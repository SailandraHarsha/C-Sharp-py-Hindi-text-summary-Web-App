<%@ Page Language="C#" AutoEventWireup="true" CodeFile="string-similarity.aspx.cs" Inherits="string_similarity" %>

<!DOCTYPE html>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Find similarity</title>
    <link href="SailSupport/css/bootstrap.min.css" rel="stylesheet" />
    <link href="SailSupport/css/my_style.css" rel="stylesheet" />
    <link href="SailSupport/css/sticky-footer-navbar.css" rel="stylesheet" />
    <script src="SailSupport/js/string-similarity.min.js"></script>
    <script type="text/javascript">
        function checksimilarity() {
            //var similarity = stringSimilarity.compareTwoStrings('healed', 'sealed');

            var AllQns = [];
            $.each($("#input").val().split("\n"), function () {
                if ($.trim(this) != "")
                    AllQns.push($.trim(this));
            });
            var Result = [];
            for (var i = 0; i < AllQns.length; i++) {
                var PrimaryQ = AllQns[i];
                var CheckArray = AllQns.filter((value, index) => i !== index);
                var matches = stringSimilarity.findBestMatch(PrimaryQ, CheckArray);
                if ($("#txtnum_per").val().trim() != "") {
                    if (parseFloat((matches.bestMatch.rating * 100).toFixed(2)) >= parseFloat($("#txtnum_per").val())) {
                        Result.push({
                            ORGQ: PrimaryQ,
                            ORGQNo: (i + 1),
                            BestMatch: (matches.bestMatch.rating * 100).toFixed(2),
                            BestMatchQ: matches.bestMatch.target,
                            BestMatchQNo: i <= matches.bestMatchIndex ? (matches.bestMatchIndex + 2) : (matches.bestMatchIndex + 1)
                        });
                    }
                }
                else {
                    Result.push({
                        ORGQ: PrimaryQ,
                        ORGQNo: (i + 1),
                        BestMatch: (matches.bestMatch.rating * 100).toFixed(2),
                        BestMatchQ: matches.bestMatch.target,
                        BestMatchQNo: i <= matches.bestMatchIndex ? (matches.bestMatchIndex + 2) : (matches.bestMatchIndex + 1)
                    });
                }

            }
            var BodyHtml = "";
            $.each(Result, function (index, value) {
                BodyHtml += "<tr>" +
                    "<td>" + value.ORGQNo + "</td>" +
                    "<td>" + value.ORGQ + "</td>" +
                    "<td>" + value.BestMatch + "</td>" +
                    "<td>" + value.BestMatchQNo + "</td>" +
                    "<td>" + value.BestMatchQ + "</td>" +
                    "</tr>";
            });
            $("#divOutputBody").html(BodyHtml);
            debugger;
            //var matches = stringSimilarity.findBestMatch('healed', ['edward', 'sealed', 'theatre']);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row" style="max-width: 90em; margin: auto">
                <br />
                <br />
                <div class="col-xs-12">
                    <textarea id="input" class="form-control" placeholder="Input text to be check for similarity. (English)" rows="12">
What is it?
Who is the second largest u?
What does and has with the Gulf of Mexico to the southeast?
Who has a coastline with the Gulf of Mexico to the southeast?
Where is Houston the most populous city and the fourth largest in the U?
Where is Houston the most populous city in Texas and the fourth largest?
What is Houston in Texas and the fourth largest in the U?
Who is the most populous city in Texas and the fourth largest in the U?
Where is while San Antonio the second-most populous in the state and seventh largest?
What is while San Antonio second-most populous in the state and seventh largest in the U?
Who is the second-most populous in the state and seventh largest in the U?
Who is popularly associated with the U?
Who is desert?
What did Spain was to claim and control the area of Texas?
Who was the first european country to claim and control the area of Texas?
What France held?
Who held a short-lived colony?
Who joined the union as the 28th state?
When set the state 's annexation off a chain of events that led to the Mexican–american War?
Whose a chain of events that led to the Mexican–american War in 1846?
Who set off a chain of events that led to the Mexican–american War in 1846?
What did Texas declared from the U?
Who declared its secession from the U?
What did and officially joined states of America on March 2 of the same year?
Who officially joined the Confederate states of America on March 2 of the same year?
What did Texas entered of economic stagnation?
Who entered a long period of economic stagnation?
Who grew to be major industries as the cattle industry became less lucrative?
Who became less lucrative?
What Texas developed and high tech industry in the mid-20th century?
Who developed a diversified economy and high tech industry in the mid-20th century?
Who is second on the list of the most Fortune 500 companies with 54?
What has Texas led?
Who has led the U?
Who has the second-highest gross state product?
What would it be largest economy in the world?
Who would be the 10th largest economy in the world?
                    </textarea>
                    <br />

                    <div style="align: center; margin: auto">
                        <div class="input-group">
                            <input id="txtnum_per" type="text" class="form-control" placeholder="Min % (number)" />
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="button" onclick="checksimilarity();">
                                    <span class="glyphicon glyphicon-flash" aria-hidden="true"></span>&nbsp;
                  Check
                                </button>
                            </span>
                        </div>
                    </div>

                    <br />
                    <br />

                    <div class="container">
                        <h2>Similarity Summary</h2>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Q No</th>
                                    <th>Org Q</th>
                                    <th>Best Match %</th>
                                    <th>Best Match Q No</th>
                                    <th>Best Match Q</th>
                                </tr>
                            </thead>
                            <tbody id="divOutputBody">
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <script src="SailSupport/js/jquery.min.js"></script>
        <script src="SailSupport/js/bootstrap.min.js"></script>
    </form>
</body>
</html>

