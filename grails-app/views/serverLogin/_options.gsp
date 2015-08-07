<a href="javascript:void(0);" id="showLog">
    <button class="btn btn-default btn_login_override">
        <i class="glyphicon glyphicon-eye-open"></i> View Log
    </button>
</a>
<a href="javascript:void(0);" id="clearLog">
    <button class="btn btn-default btn_login_override">
        <i class="glyphicon glyphicon-trash"></i> Clear Log
    </button>
</a>
<a href="javascript:void(0);" id="hideLog">
    <button class="btn btn-default btn_login_override">
        <i class="glyphicon glyphicon-remove"></i> Disconnect
    </button>
</a>
<script>
    $(document).ready(function () {
        var interval;
        $("#logArea").hide();
        $("#showLog").click(function () {
            $("#logArea").show();
            $.ajax({
                url: "${createLink(controller:'ServerLogin',action:'GetLog')}",
                type: "get",
                cache: false,
                complete: function () {
                    console.log("get log request complete");
                },
                success: function () {
                    console.log("success triggered for getlog");
                    interval = setInterval(function () {
                        readResponse();
                    }, 3000);
                },
                failure: function () {
                    console.log('failure triggered for getlog');
                }
            });
        });
        $("#hideLog").click(function () {
            $.ajax({
                url: "${createLink(controller:'ServerLogin',action:'disconnectServer')}",
                type: "get",
                cache: false,
                complete: function () {
                    console.log("Disconnection complete");
                    window.clearInterval(interval);
                },
                success: function (response) {
                    console.log(response)
                }
            });
            $("#logArea").hide();
        });
        $("#clearLog").click(function () {
            $("#logArea").html('');
        });
    });
</script>