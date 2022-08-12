<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Welcome.aspx.cs" Inherits="Welcome" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Auto - Summarization Hindi & English</title>
    <script src="SailSupport/js/jquery.min.js"></script>
    <script src="SailSupport/js/bootstrap.min.js"></script>
    <link href="SailSupport/css/bootstrap.min.css" rel="stylesheet" />
    <script type="text/javascript">
        function CngSrc(PName)
        {
            $("#IframeMainPage").hide(500).attr('src', PName);
            $("#IframeMainPage").show(500);
            //setTimeout(function () {
                
            //}, 2000);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <br />
        <br />
        <div class="container-fluid">
            <div class="jumbotron">
              <h1 class="display-4 text-center">Auto - Summarization Hindi & English</h1>
              <hr class="my-4"/>
              <p class="lead text-center">
                <a class="btn btn-primary btn-lg" href="#" role="button" onclick="CngSrc('GetSummEn.aspx');">English</a>
                  <a class="btn btn-primary btn-lg" href="#" role="button" onclick="CngSrc('GetSumm.aspx');">Hindi</a>
              </p>
                <iframe id="IframeMainPage" src="GetSummEn.aspx" style="position:relative; top:10%; bottom:0px;left:20px; right:0px; width: 98%; border: none; margin:0; padding:10px; overflow: hidden; z-index:999999; height: 700px;"></iframe>
            </div>
        </div>
    </form>
</body>
</html>
