using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IronPython.Hosting;
using System.Diagnostics;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Text;
using System.Security;
using Microsoft.Scripting.Hosting;
using System.Net;
using System.Runtime.Serialization.Json;

public partial class GetSumm : System.Web.UI.Page
{
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetSummHin(string HinText, string SumPer)
    {
        string RetMsg = "Error: Try again";
        
        var fileCount = (from file in Directory.EnumerateFiles(HttpContext.Current.Server.MapPath("HinTemp") + "//ORG//", "*.txt", SearchOption.AllDirectories) select file).Count();
        string FName = fileCount.ToString() +".txt";
        string FilePath = HttpContext.Current.Server.MapPath("HinTemp") + "//ORG//" + FName;
        try
        {
            if (File.Exists(FilePath))
            {
                //File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp")+"//Log.txt", "OLD Deleted" + Environment.NewLine);
                File.Delete(FilePath);
            }
            using (FileStream fs = File.Create(FilePath))
            {
                File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "ORG TXT Write Start" + Environment.NewLine);
                Byte[] txt = new UTF8Encoding(true).GetBytes(HinText);
                fs.Write(txt, 0, txt.Length);
                File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "ORG TXT Write Done" + Environment.NewLine);
                RetMsg = "Processing... please wait.";
                File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", RetMsg + Environment.NewLine);
            }
        }
        catch (Exception ex)
        {
            RetMsg = "Error: " + ex.Message;
        }

        if (RetMsg == "Processing... please wait.")
        {
            //if (GetActSumm(FName.Replace(".txt", ""), SumPer) == "OK\r\n") // Call python script via command prompt
            if (GetActSummWeb(FName.Replace(".txt", ""), SumPer) == "Success") // call python service to get result
            {
                return "OUT_" + FName.Replace(".txt", "") + "_" + SumPer + ".txt";
            }
            else
            {
                return "Error: Try Again";
            }
        }
        return "Please Wait";
    }

    public static string GetActSummWeb(string ActFile, string SumPer)
    {
        ////python textSummerizerFinal_WebS.py 8112 --> via .dat file
        string RetMsg = "";
        string ActFilePath = HttpContext.Current.Server.MapPath("HinTemp") + "\\ORG\\" + ActFile + ".txt";
        string StopWordFile = HttpContext.Current.Server.MapPath("SailHindPy") + "\\stopwords.txt";
        int SummPer = Convert.ToInt32(SumPer);
        string OutFile = HttpContext.Current.Server.MapPath("HinTemp") + "\\SUMM\\OUT_" + ActFile + "_" + SummPer.ToString() + ".txt";


        var request = (HttpWebRequest)WebRequest.Create("http://10.208.37.158:8112/get_Hi");
        request.ContentType = "application/json";
        request.Method = "POST";

        using (var streamWriter = new StreamWriter(request.GetRequestStream()))
        {
            string json = new JavaScriptSerializer().Serialize(new
            {
                ActFilePath = ActFilePath,
                StopWordFile = StopWordFile,
                SummPer= SummPer,
                OutFile= OutFile
            });

            streamWriter.Write(json);
        }

        var response = (HttpWebResponse)request.GetResponse();
        using (var streamReader = new StreamReader(response.GetResponseStream()))
        {
            RetMsg = streamReader.ReadToEnd();
        }
        return RetMsg;







        //var request = WebRequest.Create("http://10.208.37.158:8112/get_Hi");
        //request.Method = "POST";
        //var data = string.Format('ActFilePath:"{0}"&StopWordFile:"{1}"&SummPer:"{2}"&OutFile:"{3}"', ActFilePath, StopWordFile, SummPer, OutFile);
        //using (var writer = new StreamWriter(request.GetRequestStream()))
        //{
        //    writer.WriteLine(data);
        //}
        //string response = request.GetResponse().ToString();
        //return response;
    }


    public static string GetActSumm(string ActFile, string SumPer)
    {
        string myString = "";
        try
        {
            string python = @"C:\Users\Administrator.HARSHA\Anaconda3\python.exe";
            string myPythonApp = HttpContext.Current.Server.MapPath("SailHindPy") + "\\textSummerizerFinal.py";

            string ActFilePath = HttpContext.Current.Server.MapPath("HinTemp") + "\\ORG\\" + ActFile + ".txt";
            string StopWordFile = HttpContext.Current.Server.MapPath("SailHindPy") + "\\stopwords.txt";
            int SummPer = Convert.ToInt32(SumPer);
            string OutFile = HttpContext.Current.Server.MapPath("HinTemp") + "\\SUMM\\OUT_" + ActFile + "_" + SummPer.ToString() + ".txt";

            ProcessStartInfo myProcessStartInfo = new ProcessStartInfo(python);
            myProcessStartInfo.UseShellExecute = false;
            myProcessStartInfo.Verb = "runas";
            myProcessStartInfo.RedirectStandardOutput = true;
            myProcessStartInfo.RedirectStandardInput = true;
            myProcessStartInfo.RedirectStandardError = true;
            myProcessStartInfo.Arguments = myPythonApp + " " + ActFilePath + " " + StopWordFile + " " + SummPer + " " + OutFile;



            //////////SecureString passWord = new SecureString();
            //////////foreach (char c in "S@ilandra~!@".ToCharArray())
            //////////    passWord.AppendChar(c);

            //////////ProcessStartInfo myProcessStartInfo = new ProcessStartInfo
            //////////{
            //////////    FileName = @"C:\Users\Administrator.HARSHA\Anaconda3\python.exe",
            //////////    UserName = "Administrator",
            //////////    Domain = "",
            //////////    Password = passWord,
            //////////    UseShellExecute = false,
            //////////    RedirectStandardOutput = true,
            //////////    RedirectStandardError = true,
            //////////    Arguments = myPythonApp + " " + ActFilePath + " " + StopWordFile + " " + SummPer + " " + OutFile
            //////////};
            //////////Process myProcess = Process.Start(myProcessStartInfo);

            Process myProcess = new Process();
            myProcess.StartInfo = myProcessStartInfo;
            myProcess.StartInfo.Verb = "runas";
            File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "Calling Python script with arguments " + ActFilePath + "," + StopWordFile + "," + SummPer + "," + OutFile + Environment.NewLine);
            File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "Ready to start Process" + Environment.NewLine);
            myProcess.Start();
            File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "Process Started" + Environment.NewLine);
            StreamReader myStreamReader = myProcess.StandardOutput;
            myProcess.WaitForExit();
            myString = myStreamReader.ReadToEnd();
            myProcess.Close();
            File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "Process Completed" + Environment.NewLine);

        }
        catch (Exception ex)
        {
            File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", ex.Message.ToString() + Environment.NewLine);
        }
        return myString;


        ////////// Get the full file path
        ////////string strFilePath = HttpContext.Current.Server.MapPath("SailHindPy") + "\\textSummerizerFinal.py";

        ////////// Create the ProcessInfo object
        ////////System.Diagnostics.ProcessStartInfo psi = new System.Diagnostics.ProcessStartInfo("cmd.exe");
        ////////psi.UseShellExecute = false;
        ////////psi.RedirectStandardOutput = true;
        ////////psi.RedirectStandardInput = true;
        ////////psi.RedirectStandardError = true;
        ////////psi.Verb = "runas";
        ////////psi.WorkingDirectory = HttpContext.Current.Server.MapPath("SailHindPy");
        ////////System.Diagnostics.Process proc = System.Diagnostics.Process.Start(psi);
        ////////System.IO.StreamReader sOut = proc.StandardOutput;
        ////////System.IO.StreamWriter sIn = proc.StandardInput;
        ////////sIn.WriteLine(" python G:\\VSVN\\HindiSummSail\\SailHindPy\\textSummerizerFinal.py G:\\VSVN\\HindiSummSail\\HinTemp\\ORG\\12.txt G:\\VSVN\\HindiSummSail\\SailHindPy\\stopwords.txt 20 G:\\VSVN\\HindiSummSail\\HinTemp\\SUMM\\OUT_12_20.txt");
        ////////// Exit CMD.EXE
        ////////string stEchoFmt = "# {0} run successfully. Exiting";
        //////////sIn.WriteLine(String.Format(stEchoFmt, strFilePath));
        ////////sIn.WriteLine("EXIT");
        ////////// Close the process
        ////////proc.Close();
        ////////// Read the sOut to a string.
        ////////string results = sOut.ReadToEnd().Trim();
        ////////// Close the io Streams;
        ////////sIn.Close();
        ////////sOut.Close();
        ////////// Write out the results.
        ////////return "OK\r\n";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetFinalSummHin(string OutFile)
    {
        string RetMsg = "Error: Try again";

        string OutFilePath = HttpContext.Current.Server.MapPath("HinTemp") + "\\SUMM\\" + OutFile;
        if (File.Exists(OutFilePath))
        {
            File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "File Read Start" + Environment.NewLine);
            var encoding = Encoding.UTF8;
            var file = new FileInfo(OutFilePath);
            RetMsg = File.ReadAllText(file.FullName, encoding);
        }
        string DelInFile = OutFile.Split('_')[1] + ".txt";
        //File.Delete(HttpContext.Current.Server.MapPath("HinTemp") + "\\ORG\\" + OutFile.Split('_')[1] + ".txt");
        //File.Delete(OutFilePath);
        return RetMsg;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        //File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "Start" + Environment.NewLine);
        //SecureString passWord = new SecureString();
        //foreach (char c in "S@ilandra~!@".ToCharArray())
        //    passWord.AppendChar(c);
        //File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "Password Convert" + Environment.NewLine);
        //ProcessStartInfo info = new ProcessStartInfo
        //{
        //    FileName = @"C:\Users\Administrator.HARSHA\Anaconda3\python.exe",
        //    UserName = "Administrator",
        //    Domain = "",
        //    Password = passWord,
        //    UseShellExecute = false,
        //    RedirectStandardOutput = true,
        //    RedirectStandardError = true
        //};
        //File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "START" + Environment.NewLine);
        //Process process = Process.Start(info);
        //File.AppendAllText(HttpContext.Current.Server.MapPath("HinTemp") + "//Log.txt", "END" + Environment.NewLine);
        
    }
}