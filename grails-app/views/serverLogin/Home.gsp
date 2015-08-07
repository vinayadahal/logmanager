<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="MainLayout"/>
    <title>Home - Log Manager</title>
</head>

<body>
<div class="alert alert-success" id='headerBtn'>

    <div id="optionsBox">
        <select name="tomcatLocation" class="form-control" style="width: 200px;float: left;" id="selectTomcat">
            <g:each in="${tomcatLocation}">
                <option value="${it.tomcat_location}">${it.tomcat_name}</option>
            </g:each>
        </select>
        <button class="btn btn-default btn_login_override" style="float: left;margin: 0px;"
                onclick="submitForm('${createLink(controller: 'serverLogin', action: 'connectServer')}')">
            Submit
        </button>
    </div>

    <div class="alert alert-danger" id='alert'>Please do not refresh the page.</div>
</div>

<div style=" " id="logArea"></div>
<script type="text/javascript">
    $(document).ready(function () {
        $.ajax({
            url: "${createLink(controller:'ServerLogin',action:'checkTailStatus')}",
            type: "get",
            cache: false,
            success: function (response) {
                if (response == "tail is on") {
                    interval = setInterval(function () {
                        readResponse();
                    }, 3000);
                } else {
                    console.log('status failed')
                }
            }
        });
    });
    function readResponse() {
        $.ajax({
            url: "${createLink(controller:'ServerLogin',action:'showInGsp')}",
            type: "get",
            cache: false,
            complete: function () {
                console.log("Read Request Complete");
            },
            success: function (response) {
                console.log(response);
                if (response !== '') {
                    $('#logArea').append("<pre>" + response + "</pre>");
                    console.log("console Log: " + response);
                    $('#logArea').scrollTop($('#logArea')[0].scrollHeight);
                }
            }
        });
    }
</script>
</body>
</html>