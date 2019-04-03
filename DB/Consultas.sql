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
        GROUP BY mercado.merccodi)
SELECT tr.NombreMercado,tr.TotalReservas,tr.ImporteReservas, ca.ReservasCanceladas, ca.ImporteCanceladas FROM totalReservas tr INNER JOIN CANCELADOS ca ON tr.idMercado = ca.idMercado;


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
        
-- Media de noches 

   select (reservas.resefechafin - reservas.resefechaini)  FROM volcp.reservas, volgc.mercado, volcp.estadoreserva
    WHERE volgc.mercado.merccodi = volcp.reservas.merccodi
         AND volcp.estadoreserva.esrecodi = volcp.reservas.esrecodi
         AND reservas.sogecodi = 1
         AND mercado.mercficticio = 0
         AND estadoreserva.esrevisibilidad = 0
        GROUP BY reservas.merccodi;
        
        select (reservas.resefechafin - reservas.resefechaini) from volcp.reservas;