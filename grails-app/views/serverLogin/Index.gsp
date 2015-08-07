<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="MainLayout"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login to server</title>
</head>

<body>

<div class="panel panel-primary panel_login">
    <div class="panel-heading headings">
        <h4 class="panel-title">Login - Log Viewer</h4>
    </div>

    <div class="panel-body input_wrap">
        <g:form method="POST" url="[action: 'home', controller: 'ServerLogin']">
            <div class="inner-addon left-addon">
                <input type="text" class="form-control form_override" name="username" placeholder="Username"/>
                <i class="glyphicon glyphicon-user"></i>
            </div>

            <div class="inner-addon left-addon">
                <input type="password" class="form-control form_override" name="password" placeholder="Password"/>
                <i class="glyphicon glyphicon-lock"></i>
            </div>

            <div class="inner-addon left-addon">
                <select name="ip" class="form-control form_override" style="padding-left:25px; ">
                    <g:each in="${ipaddr}">
                        <option value="${it.ip}">${it.server_name}</option>
                    </g:each>
                </select>
                <i class="glyphicon glyphicon-globe"></i>
            </div>
            <input type="hidden" class="form-control form_override" value="22" name="port" placeholder="Port"/>
            <button type="submit" class="btn btn-default btn_login_override">Login</button>
        </g:form>
    </div>
</div>
</body>
</html>
