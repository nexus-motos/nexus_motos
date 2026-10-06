$(document).ready(function () {
    let tabla = $('#tablaHistorial').DataTable({
        dom: 'Bfrtip',
        buttons: ['excelHtml5', 'csvHtml5', 'pdfHtml5'],
        responsive: true,
        language: { url: '//cdn.datatables.net/plug-ins/1.10.25/i18n/Spanish.json' },
        data: [],
        columns: [
            { data: 'fecha_inicio' },
            {
                data: 'fecha_fin',
                render: function (data) {
                    return data === 'Vigente'
                        ? '<span style="color:green;font-weight:bold;">Vigente</span>'
                        : data;
                }
            },
            { data: 'costo', className: 'text-end' },
            { data: 'margen', className: 'text-end' },
            { data: 'precio_venta', className: 'text-end' },
            { data: 'stock', className: 'text-end' }
        ],
        order: [], // Desactivar orden inicial
        searching: false, // Quitar el buscador
        ordering: false,  // Quitar el ordenamiento por columnas
        rowCallback: function (row, data, index) {
            if (data.separador) {
                // Reemplaza completamente la fila con el separador
                $(row).html(`<td colspan="6" style="background-color:#f2f2f2;font-weight:bold">${data.producto}</td>`);
            }
        },
        createdRow: function (row, data, dataIndex) {
            if (data.separador) {
                $(row).addClass('separador');
            }
        }
    });

    $('#btnBuscar').on('click', function () {
        const fecha_inicio = $('#fecha_inicio').val();
        const fecha_fin = $('#fecha_fin').val();
        const producto_id = $('#producto_id').val();

        $('#spinner').removeClass("d-none");
        $('#btnBuscar').prop("disabled", true);

        $.ajax({
            url: '/buscar_historial_precios/',
            type: 'POST',
            headers: { "X-CSRFToken": $('input[name="csrfmiddlewaretoken"]').val() },
            data: { fecha_inicio, fecha_fin, producto_id },
            success: function (res) {
                tabla.clear().rows.add(res.datos).draw();
            },
            error: function (err) {
                alert('Ocurrió un error al buscar.');
                console.log(err);
            }
        })
        .always(function () {
            $('#spinner').addClass("d-none");
            $('#btnBuscar').prop("disabled", false);
        });
    });
});
