<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetSummEn.aspx.cs" Inherits="GetSummEn" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>English summarizer</title>
    <link href="SailSupport/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="SailSupport/css/my_style.css" rel="stylesheet"/>
    <link href="SailSupport/css/sticky-footer-navbar.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
    <div class="container">
      <div class="row" style="max-width:90em; margin:auto">
        <br/><br/>
        <div class="col-xs-12">
          <textarea id="input" class="form-control" placeholder="Input text to be summarized. (English)" rows="12"></textarea>
          <br/>

          <div style="align:center; margin:auto">
            <div class="input-group">
              <input id="num_sent" type="text" class="form-control" placeholder="Summary length (the number of sentences)"/>
              <span class="input-group-btn">
                <button class="btn btn-default" type="button" onclick="summarize();">
                  <span class="glyphicon glyphicon-flash" aria-hidden="true"></span>&nbsp;
                  Summarize
                </button>
              </span>
            </div>
          </div>

          <br/><br/>

          <div id="output">
            <div class="jumbotron">
              <p>Summary output<p>
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
    <script src="SailSupport/js/pagerank.js"></script>
    <script src="SailSupport/js/lexrank.js"></script>
    <script src="SailSupport/js/summarize_en.js"></script>
    </form>
</body>
</html>
