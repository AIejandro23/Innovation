/* Formatted on 04/04/2019 11:28:10 (QP5 v5.336) */
SELECT reservas.resecodi
           AS CodigoReserva,
       reservas.resefechaini
           AS FechaEntrada,
       (reservas.resefechafin - reservas.resefechaini)
           AS Noches,
       volcp.cripto.decript (reservas.resenomcli)
           AS NombreCliente,
       volcp.cripto.decript (reservas.reseapellidos)
           AS ApellidoCliente,
       volcp.cripto.decript (reservas.reseemail)
           AS EmailCliente,
       reservas.resenumhab
           AS NumeroHabitaciones,
       reservashabitacion.rehadesc
           AS NombreHabitacion,
       (reservas.resenumadultos + reservas.resenumnins)
           AS TotalPax,
       mercado.mercdesc
           AS NombreMercado,
       estadoreserva.esredesc
           AS EstadoReserva,
           entidad.enticomenom
           AS Agencia
  FROM volcp.reservas
       INNER JOIN volgc.mercado ON mercado.merccodi = reservas.merccodi
       INNER JOIN volcp.reservashabitacion
           ON reservas.resecodi = reservashabitacion.resecodi
       INNER JOIN volcp.estadoreserva
           ON reservas.esrecodi = estadoreserva.esrecodi
       LEFT JOIN volcp.entidad ON reservas.agencodi = entidad.enticodi
 WHERE reservas.resefecha BETWEEN '10/04/2017' AND '11/04/2017'
       AND reservas.sogecodi = 1
       AND reservas.centcodi = 3
       AND mercado.mercficticio = 0
       AND estadoreserva.esrevisibilidad = 0;
       
