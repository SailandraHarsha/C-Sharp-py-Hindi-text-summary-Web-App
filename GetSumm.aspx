<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetSumm.aspx.cs" Inherits="GetSumm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Hindi Summarizer</title>
    <link href="SailSupport/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="SailSupport/css/my_style.css" rel="stylesheet"/>
    <link href="SailSupport/css/sticky-footer-navbar.css" rel="stylesheet"/>
    <script type="text/javascript">

        function ClearContent()
        {
            var DotSen = $.trim($("#input").val()).split(".");
            var HinSen = $.trim($("#input").val()).split("।");
            if (DotSen.length > HinSen.length) {
                var NewHinSen = $.trim($("#input").val()).replace(/\./g, '।').replace(/\t/g, '');
                $("#input").val(NewHinSen);
            }
            GetSumm();
        }

        function GetSumm()
        {
            var text =$("#input").val().trim();
            var num_sent = $("#num_sent").val().trim();
            if (text != "" && num_sent != "") {
                try {
                    $.ajax({
                        type: "POST",
                        url: "GetSumm.aspx/GetSummHin",
                        data: JSON.stringify({
                            HinText: text,
                            SumPer: num_sent
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSuccOperationJQ,
                        failure: function (response) {
                            alert(response.d);
                        }
                    });
                }
                catch (ex) { }
            }
            else { alert("Please Enter Required Details");}
        }

        function OnSuccOperationJQ(response) {
            if (response.d != "") {
                if (response.d.indexOf("Error") >= 0) {
                    $.notify(response.d, { className: "error", position: "top center" });
                }
                else {

                    try {
                        $.ajax({
                            type: "POST",
                            url: "GetSumm.aspx/GetFinalSummHin",
                            data: JSON.stringify({
                                OutFile: response.d
                            }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                $("#output").hide(200);
                                $("#output").html('<div class="jumbotron"><p>' + response.d + '<p></div>').show(200);
                            },
                            failure: function (response) {
                                alert(response.d);
                            }
                        });
                    }
                    catch (ex) { }
                    //BootstrapDialog.show({
                    //    message: response.d,
                    //    buttons: [{
                    //        label: 'OK',
                    //        action: function (dialogItself) {
                    //            dialogItself.close();
                    //            FillAllPost('Inward_Outward_Office');
                    //        }
                    //    }]
                    //});
                }
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
          <div class="row" style="max-width:90em; margin:auto">
            <br/><br/>
            <div class="col-xs-12">
              <textarea id="input" class="form-control" placeholder="Input text to be summarized. (Hindi)" rows="12"></textarea>
              <br/>

              <div style="align:center; margin:auto">
                <div class="input-group">
                  <input id="num_sent" type="text" class="form-control" placeholder="Summary percentage"/>
                  <span class="input-group-btn">
                    <button class="btn btn-default" type="button" onclick="ClearContent();">
                      <span class="glyphicon glyphicon-flash" aria-hidden="true"></span>&nbsp;
                      Summarize
                    </button>
                  </span>
                </div>
              </div>

              <br/><br/>

              <div id="output">
                <div class="jumbotron">
                  <p>Summary output</p>
                </div>
              </div>

            </div>
          </div>
        </div>
        <footer class="footer">
          <div class="container" align="center">
            <p class="text-muted">
            <span class="glyphicon glyphicon-copyright-mark" aria-hidden="true"></span>
            2018-2019 Sailandra Harsha
            </p>
          </div>
        </footer>
        <script src="SailSupport/js/jquery.min.js"></script>
        <script src="SailSupport/js/bootstrap.min.js"></script>
        <script src="SailSupport/js/notify.js"></script>
    </form>
<!-- Wait Modal Start here
$('#myPleaseWait').modal('show');
$('#myPleaseWait').modal('hide');
-->
<div class="modal fade bs-example-modal-sm" id="myPleaseWait" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">
                    <span class="glyphicon glyphicon-time"></span>Please Wait
                </h4>
            </div>
            <div class="modal-body">
                <div class="progress">
                    <div class="progress-bar progress-bar-info progress-bar-striped active" style="width: 100%">Fetching Data</div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--Wait Modal ends Here -->
</body>
</html>
