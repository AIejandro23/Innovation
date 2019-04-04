/* Formatted on 04/04/2019 11:28:10 (QP5 v5.336) */
SELECT reservas.resecodi
           AS CodigoReserva,
       reservas.resefechaini
           AS FechaEntrada,
       (reservas.resefechafin - reservas.resefechaini)
           AS Noches,
       volcp.cripto.decript (reservas.resenomcli)
           AS NombreCliente,
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
       agencia.agennom
           AS Agencia
  FROM volcp.reservas
       INNER JOIN volgc.mercado ON mercado.merccodi = reservas.merccodi
       INNER JOIN volcp.reservashabitacion
           ON reservas.resecodi = reservashabitacion.resecodi
       INNER JOIN volcp.estadoreserva
           ON reservas.esrecodi = estadoreserva.esrecodi
       INNER JOIN volcp.agencia ON reservas.agencodi = agencia.agencodi
 WHERE     reservas.resefecha BETWEEN '10/04/2017' AND '11/04/2017'
       AND reservas.sogecodi = 1
       AND reservas.centcodi = 3;