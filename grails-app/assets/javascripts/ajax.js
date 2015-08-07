$(document).ready(function () {
    $("#logArea").hide();
});

function submitForm(url) {
    console.log(url);
    var dataString = "location=" + $("#selectTomcat").val();
    $.ajax({
        url: url,
        data: dataString,
        type: 'GET',
        cache: false,
        success: function (response) {
            $('#optionsBox').html('');
            $('#optionsBox').html(response);
        },
        failure: function (response) {
            console.log(response);
        }
    });
}