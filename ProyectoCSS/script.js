var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

    console.log("JQuery cargado.");
    var actual = new Date();
    var year = actual.getFullYear();
    var month = actual.getMonth();
    var i = 0

$(document).ready(function () {
    mostrarCalendario(actual.getFullYear(),actual.getMonth()+1);
    $(".textoOculto").hide();
    // Bucle para averiguar en que mes nos encontramos.
    for (i; i < 12; i++) {
        if (i == month) {
            $("#calendarTitle").text(months[i] + " " + year);
            break;
        }
    }
    
    /** ABRIR Y CERRAR EMAILS */
    $("#primero").click(function(){
        if($("#email1").hasClass("hide")){
            $("#primero").text("keyboard_arrow_down");
            $("#email1").removeClass("hide");
            $("#email2").addClass("hide");
            $("#email3").addClass("hide");
            $("#email4").addClass("hide");

        }else{
            $("#email1").addClass("hide");
            $("#primero").text("chevron_right");

        }
    });

    $("#segundo").click(function(){
        if($("#email2").hasClass("hide")){
            $("#segundo").text("keyboard_arrow_down");
            $("#email2").removeClass("hide");
            $("#email1").addClass("hide");
            $("#email3").addClass("hide");
            $("#email4").addClass("hide");
        }else{
            $("#email2").addClass("hide");
            $("#segundo").text("chevron_right");

        }
    });

    $("#tercero").click(function(){
        if($("#email3").hasClass("hide")){
            $("#tercero").text("keyboard_arrow_down");
            $("#email3").removeClass("hide");
            $("#email2").addClass("hide");
            $("#email1").addClass("hide");
            $("#email4").addClass("hide");
        }else{
            $("#tercero").text("chevron_right");
            $("#email3").addClass("hide");
        }
    });
    $("#cuarto").click(function(){
        if($("#email4").hasClass("hide")){
            $("#cuarto").text("keyboard_arrow_down");
            $("#email4").removeClass("hide");
            $("#email2").addClass("hide");
            $("#email3").addClass("hide");
            $("#email1").addClass("hide");
        }else{
            $("#cuarto").text("chevron_right");
            $("#email4").addClass("hide");
        }
    });
    
    /** BORRAR EMAILS */
    $("#delFirst").click(function(){
        $("#correos1").remove();
    });
    $("#delSecond").click(function(){
        $("#correos2").remove();
     });
    $("#delThird").click(function(){
        $("#correos3").remove();
    });
    $("#delFourth").click(function(){
        $("#correos4").remove();
    });
});


function deleteEmail(){
    $(".email1").click(function(){
        $(".email1").hide();
    })
    $(".email2").click(function(){
        $(".email2").hide();
    })
}
var calendario = false;
function deleteCalendar(){
    if(calendario == false){
        $("#cancel").text("keyboard_arrow_down");
        $(".cuerpo").hide();
        calendario = true;
    }else{
        $("#cancel").text("clear");
        $(".cuerpo").show();
        calendario = false;
    }

}

/** Pruebas calendario */

var actual=new Date();
function mostrarCalendario(year,month)
{
	var now=new Date(year,month-1,1);
	var last=new Date(year,month,0);
	var primerDiaSemana=(now.getDay()==0)?7:now.getDay();
	var ultimoDiaMes=last.getDate();
	var dia=0;
	var resultado="<tr>";
	var diaActual=0;
 
	var last_cell=primerDiaSemana+ultimoDiaMes;
 
	// hacemos un bucle hasta 42, que es el máximo de valores que puede
	// haber... 6 columnas de 7 dias
	for(var i=1;i<=42;i++)
	{
		if(i==primerDiaSemana)
		{
			// determinamos en que dia empieza
			dia=1;
		}
		if(i<primerDiaSemana || i>=last_cell)
		{
			// celda vacia
			resultado+="<td>&nbsp;</td>";
		}else{
			// mostramos el dia
			if(dia==actual.getDate() && month==actual.getMonth()+1 && year==actual.getFullYear())
				resultado+="<td class='hoy'>"+dia+"</td>";
			else
				resultado+="<td>"+dia+"</td>";
			dia++;
		}
		if(i%7==0)
		{
			if(dia>ultimoDiaMes)
				break;
			resultado+="</tr><tr>\n";
		}
	}
	resultado+="</tr>";
 
    var meses = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
 
	// Calculamos el siguiente mes y año
	nextMonth=month+1;
	nextYear=year;
	if(month+1>12)
	{
		nextMonth=1;
		nextYear=year+1;
	}
 
	// Calculamos el anterior mes y año
	prevMonth=month-1;
	prevYear=year;
	if(month-1<1)
	{
		prevMonth=12;
		prevYear=year-1;
	}
    document.getElementById("tituloRight").getElementsByTagName("h3")[0].innerHTML="<div>"+meses[month-1]+"  "+year+"<a style='float:left' onclick='mostrarCalendario("+prevYear+","+prevMonth+")'>&lt;</a> <a style='float:right' onclick='mostrarCalendario("+nextYear+","+nextMonth+")'>&gt;</a></div>";
	document.getElementById("calendar").getElementsByTagName("tbody")[0].innerHTML=resultado;
}
 
