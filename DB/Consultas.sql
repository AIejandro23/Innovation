/* Formatted on 04/04/2019 11:45:26 (QP5 v5.336) */
  -- Total de reservas y sus importes

WITH
    totalReservas
    AS
        (  SELECT mercado.merccodi                AS idMercado,
                  mercado.mercdesc                AS NombreMercado,
                  COUNT (*)                       AS TotalReservas,
                  SUM (reservas.reseimptotal)     AS ImporteReservas
             FROM volcp.reservas, volgc.mercado, volcp.estadoreserva
            WHERE     volgc.mercado.merccodi = volcp.reservas.merccodi
                  AND volcp.estadoreserva.esrecodi = volcp.reservas.esrecodi
                  AND reservas.sogecodi = 1
                  AND mercado.mercficticio = 0
                  AND estadoreserva.esrevisibilidad = 0
         GROUP BY mercado.merccodi, mercado.mercdesc),
    -- Total de reservas canceladas y sus importes
    CANCELADOS
    AS
        (  SELECT mercado.merccodi                AS idMercado,
                  COUNT (*)                       AS ReservasCanceladas,
                  SUM (reservas.reseimptotal)     AS ImporteCanceladas
             FROM volcp.reservas, volgc.mercado, volcp.estadoreserva
            WHERE     volgc.mercado.merccodi = volcp.reservas.merccodi
                  AND volcp.estadoreserva.esrecodi = volcp.reservas.esrecodi
                  AND reservas.sogecodi = 1
                  AND mercado.mercficticio = 0
                  AND estadoreserva.esrevisibilidad = 0
                  AND reservas.esrecodi IN (2,
                                            7,
                                            9,
                                            14,
                                            16)
         GROUP BY mercado.merccodi),
    -- Media de noches, adultos por habitacion y niños por habitacion
    MEDIA
    AS
        (  SELECT reservas.merccodi
                      AS CodigoMercado,
                    SUM (reservas.resefechafin - reservas.resefechaini)
                  / COUNT (reservas.resefechafin - reservas.resefechaini)
                      AS MediaNoches,
                    SUM (reservas.resenumadultos)
                  / COUNT (reservas.resenumhab)
                      AS MediaAdultos,
                  SUM (reservas.resenumnins) / COUNT (reservas.resenumhab)
                      AS MediaNiños
             FROM volcp.reservas
                  INNER JOIN volgc.mercado
                      ON reservas.merccodi = mercado.merccodi
                  INNER JOIN volcp.estadoreserva
                      ON estadoreserva.esrecodi = reservas.esrecodi
            WHERE     reservas.sogecodi = 1
                  AND mercado.mercficticio = 0
                  AND estadoreserva.esrevisibilidad = 0
         GROUP BY reservas.merccodi),
    -- Hotel con mas reservas
    HOTEL
    AS
        (  SELECT reservas.merccodi                  AS MercCodi,
                  STATS_MODE (reservas.centcodi)     AS CodigoHotel
             FROM volcp.reservas
                  INNER JOIN volgc.mercado
                      ON reservas.merccodi = mercado.merccodi
                  INNER JOIN volcp.estadoreserva
                      ON estadoreserva.esrecodi = reservas.esrecodi
                  INNER JOIN volgc.centros
                      ON reservas.centcodi = centros.centcodi
            WHERE     reservas.sogecodi = 1
                  AND mercado.mercficticio = 0
                  AND estadoreserva.esrevisibilidad = 0
         GROUP BY reservas.merccodi)
SELECT tr.NombreMercado,
       tr.TotalReservas,
       tr.ImporteReservas,
       ca.ReservasCanceladas,
       ca.ImporteCanceladas,
       me.MediaNoches,
       me.MediaAdultos,
       me.MediaNiños,
       centros.centnom     AS HotelMasReservado
  FROM totalReservas  tr
       INNER JOIN CANCELADOS ca ON tr.idMercado = ca.idMercado
       INNER JOIN MEDIA me ON tr.idMercado = me.codigoMercado
       INNER JOIN HOTEL ho ON tr.idMercado = ho.MercCodi
       INNER JOIN VOLGC.centros ON ho.CodigoHotel = centros.centcodi;
