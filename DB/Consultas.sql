/* Formatted on 03/04/2019 16:08:30 (QP5 v5.336) */
  -- MAIN QUERY --
  WITH totalReservas as (
  SELECT mercado.merccodi as idMercado,mercado.mercdesc as NombreMercado,
         COUNT (*) AS TotalReservas, sum(reservas.reseimptotal) as ImporteReservas
    FROM volcp.reservas, volgc.mercado, volcp.estadoreserva
   WHERE volgc.mercado.merccodi = volcp.reservas.merccodi
         AND volcp.estadoreserva.esrecodi = volcp.reservas.esrecodi
         AND reservas.sogecodi = 1
         AND mercado.mercficticio = 0
         AND estadoreserva.esrevisibilidad = 0
GROUP BY mercado.merccodi, mercado.mercdesc) , 
    CANCELADOS as 
    (select mercado.merccodi as idMercado, count(*) as ReservasCanceladas, sum(reservas.reseimptotal) as ImporteCanceladas FROM volcp.reservas, volgc.mercado, volcp.estadoreserva
    WHERE volgc.mercado.merccodi = volcp.reservas.merccodi
         AND volcp.estadoreserva.esrecodi = volcp.reservas.esrecodi
         AND reservas.sogecodi = 1
         AND mercado.mercficticio = 0
         AND estadoreserva.esrevisibilidad = 0
         AND reservas.esrecodi
        IN(2,7,9,14,16)
        GROUP BY mercado.merccodi),
    MEDIA AS
    (select reservas.merccodi as CodigoMercado,sum(reservas.resefechafin - reservas.resefechaini) / count(reservas.resefechafin - reservas.resefechaini) as MediaNoches, 
   sum(reservas.resenumadultos) / count(reservas.resenumadultos) as MediaAdultos, sum(reservas.resenumnins) / count(reservas.resenumnins) as MediaNiños
   FROM volcp.reservas 
    INNER JOIN volgc.mercado ON reservas.merccodi = mercado.merccodi
    INNER JOIN volcp.estadoreserva ON estadoreserva.esrecodi = reservas.esrecodi
    WHERE 
        reservas.sogecodi = 1
    AND mercado.mercficticio = 0
    AND estadoreserva.esrevisibilidad = 0
    GROUP BY reservas.merccodi),
    HOTEL AS (SELECT reservas.merccodi as MercCodi ,STATS_MODE(reservas.centcodi) as CodigoHotel from volcp.reservas 
        INNER JOIN volgc.mercado ON reservas.merccodi = mercado.merccodi
        INNER JOIN volcp.estadoreserva ON estadoreserva.esrecodi = reservas.esrecodi
        INNER JOIN volgc.centros ON reservas.centcodi = centros.centcodi
    WHERE reservas.sogecodi = 1
        AND mercado.mercficticio = 0
        AND estadoreserva.esrevisibilidad = 0
    GROUP BY reservas.merccodi)
SELECT tr.NombreMercado,tr.TotalReservas,tr.ImporteReservas, ca.ReservasCanceladas, ca.ImporteCanceladas , me.MediaNoches, me.MediaAdultos,me.MediaNiños, ho.CodigoHotel
FROM totalReservas tr 
    INNER JOIN CANCELADOS ca ON tr.idMercado = ca.idMercado
    INNER JOIN MEDIA me ON tr.idMercado = me.codigoMercado
    INNER JOIN HOTEL ho ON tr.idMercado = ho.MercCodi;

-- Total de reservas y su importe
SELECT mercado.mercdesc,
         COUNT (*) AS TotalReservas, sum(reservas.reseimptotal) as Importe
    FROM volcp.reservas, volgc.mercado, volcp.estadoreserva
   WHERE volgc.mercado.merccodi = volcp.reservas.merccodi
         AND volcp.estadoreserva.esrecodi = volcp.reservas.esrecodi
         AND reservas.sogecodi = 1
         AND mercado.mercficticio = 0
         AND estadoreserva.esrevisibilidad = 0
GROUP BY reservas.merccodi, mercado.mercdesc;

-- Total de reservas canceladas y su importe
    select count(*) as ReservasCanceladas, sum(reservas.reseimptotal) as ImporteCanceladas FROM volcp.reservas, volgc.mercado, volcp.estadoreserva
    WHERE volgc.mercado.merccodi = volcp.reservas.merccodi
         AND volcp.estadoreserva.esrecodi = volcp.reservas.esrecodi
         AND reservas.sogecodi = 1
         AND mercado.mercficticio = 0
         AND estadoreserva.esrevisibilidad = 0
         AND reservas.esrecodi
        IN(2,7,9,14,16)
        GROUP BY reservas.merccodi;
        
-- Media de noches, adultos por habitacion y niños por habitacion

   select reservas.merccodi as CodigoMercado,sum(reservas.resefechafin - reservas.resefechaini) / count(reservas.resefechafin - reservas.resefechaini) as MediaNoches, 
   sum(reservas.resenumadultos) / count(reservas.resenumadultos) as MediaAdultos, sum(reservas.resenumnins) / count(reservas.resenumnins) as MediaNiños
   FROM volcp.reservas 
    INNER JOIN volgc.mercado ON reservas.merccodi = mercado.merccodi
    INNER JOIN volcp.estadoreserva ON estadoreserva.esrecodi = reservas.esrecodi
    WHERE 
        reservas.sogecodi = 1
    AND mercado.mercficticio = 0
    AND estadoreserva.esrevisibilidad = 0
    GROUP BY reservas.merccodi;

    
-- Hotel con mas reservas
    SELECT reservas.merccodi as MercCodi ,STATS_MODE(reservas.centcodi) as CodigoHotel from volcp.reservas 
        INNER JOIN volgc.mercado ON reservas.merccodi = mercado.merccodi
        INNER JOIN volcp.estadoreserva ON estadoreserva.esrecodi = reservas.esrecodi
        INNER JOIN volgc.centros ON reservas.centcodi = centros.centcodi
    WHERE reservas.sogecodi = 1
        AND mercado.mercficticio = 0
        AND estadoreserva.esrevisibilidad = 0
    GROUP BY reservas.merccodi;
    
 

   