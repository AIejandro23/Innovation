
    var uri = "api/products";

    $(document).ready(function () {
        //Mediante peticion ajax pedimos todos los productos del api mediante un GET.
        $.getJSON(uri).done(function (data) {
            $.each(data, function (key, item) {
                console.log(item);
                $('<li>', { text: formatItem(item) }).appendTo($('#products'));
            });
        });
    });

    // Funcion para formatear el json que recibimos por AJAX
    function formatItem(item) {
        return item.Name + " " + item.Price + "€";
}

    function find() {
        var id = $("#prodId").val();

        $.getJSON(uri + "/" + id).done(function (data) {
            $('#product').text(formatItem(data));
            // Parametros en la funcion fail para que especifique en logs el tipo de error.
        }).fail(function (jqXHR,textStatus,err) {
            $('#product').text("Producto no encontrado");
            console.log("Error: " + err)
    });
}