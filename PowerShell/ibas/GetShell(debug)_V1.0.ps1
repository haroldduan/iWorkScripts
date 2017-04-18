<#
**** Programmer:Harold.Duan
**** Date:20161127
**** Reason:Auto get & flush the ibas(debug) shell's function packages and dlls.
**** Update Date:20170104
**** Reason:Repair the bug is that can't download the lastest version ibas shell's function packages and dlls.
**** Update Date:20170417
**** Reason:If this current day has exists new version,then down this current day's;else down the lastest version's.
#>

param([string]$WebUrl,[string]$UserName,[string]$Password,[string]$FileName,[string]$HostFilePath)
# TFS URL Address:Local Area Network "http://192.168.3.42:8866/ibas/shell/" WorldWwid Area Network "http://ibas-dev.avatech.com.cn:8866/ibas/shell/"
$WebUrl = "http://ibas-dev.avatech.com.cn:8866/ibas/shell/debug/"
# TFS User Name:avatech\harold.duan
$UserName = "avatech\avauser"
# TFS User Password:fuck!
$Password = "Aa123456"
$Global:ZipFileName

$HostFilePath = $env:ibasSourceCode + "\BusinessSystemShell\04\Release\"
$FileName = "ibas_4_shell_published_"

if($(Get-Date).Hour -gt 5)
{
    $CureentDate = Get-Date
}
else 
{
    $CureentDate = $(Get-Date).AddDays(-1)
}
$CureentDate = $CureentDate.ToString("yyyyMMdd")

function GetShell()
{
    try
    {
        #清除历史文件*************************************************************************
        if(!(Test-Path $HostFilePath)) { mkdir $HostFilePath }
        Get-ChildItem -Path $HostFilePath -Recurse | Remove-Item -Force -Recurse
        #*************************************************************************************

        #***检索新文件************************************************************************
        echo ("正在从 " + $WebUrl + "检索最新文件...")
        $HttpWebRequest = [System.Net.WebRequest]::Create($WebUrl)        
        $HttpWebRequest.Method = "GET"
        $HttpWebRequest.ContentType = "application/json; charset=UTF-8"
        $HttpWebRequest.Timeout = 1 * 60 * 1000
        $HttpWebRequest.KeepAlive = $true
        $HttpWebRequest.Credentials = New-Object System.Net.NetworkCredential($UserName, $Password)
        $WebResponse = $HttpWebRequest.GetResponse()
        $ResponseStream = $WebResponse.GetResponseStream()
        $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding
        $StreamReader =  New-Object System.IO.StreamReader($ResponseStream,$Utf8NoBomEncoding)
        $RetString = $StreamReader.ReadToEnd()
        $StreamReader.Close()
        $StreamReader.Close()
        $Index = $RetString.IndexOf("<A HREF=""/ibas/shell/debug/" + $FileName + $CureentDate)
        if ($Index -ge 0) #查询当日版本
        {
            $Index += ("<A HREF=""/ibas/shell/debug/" + $FileName + $CureentDate).Length;
            $Time = $RetString.Substring($Index, 7); 
            $ZipFileName = $FileName + $CureentDate +$Time + ".zip"
        }
        else #未查询到当日版本，则查询已发布的最新版本
        {
            $Index = $RetString.LastIndexOf($FileName)
            if ($Index -ge 0)
            {
                $Index += ($FileName).Length
                $Time = $RetString.Substring($Index, 15); 
                $ZipFileName = $FileName +$Time + ".zip"
            }
        }
        #echo ($Index)
        #echo ($Time)
        #echo ($FileName)
        #echo ($RetString)
        echo ("检索最新文件完成 [" + $ZipFileName + "]")
        #*************************************************************************************

        #下载ibas框架压缩包*******************************************************************
        if(!(Test-Path $HostFilePath)) 
        {
            mkdir $HostFilePath
        }
        echo ("正在从 " + $WebUrl + "下载文件 " + $ZipFileName + " 至本地文件夹[" + $HostFilePath + "]...")
        $WebClient = New-Object System.Net.WebClient
        $WebClient.Credentials = New-Object System.Net.NetworkCredential($UserName, $Password)
        $WebClient.DownloadFile($WebUrl + $ZipFileName,$HostFilePath + $ZipFileName)
        echo "下载完成！"
        #*************************************************************************************

        #解压压缩包***************************************************************************
        $ZipFile = ($HostFilePath + $ZipFileName)
        echo ("正在解压文件 " + $ZipFileName + " 至本地文件夹[" + $HostFilePath + "]...")
        $FolderName = $HostFilePath
        #路径
        $7zip_path = ($env:ibasTools + "\7zip")
        #参数列表
        $Arg = "x $ZipFile -o" + $FolderName + " -y -r-"
        #7-Zip命令
        $7zip = $7zip_path + "\7z.exe"
        #解压ZIP文件
        & $7zip $Arg.Split() 
        echo "解压完成！"
        #*************************************************************************************

        #删除压缩包***************************************************************************
        Remove-Item ($HostFilePath + $ZipFileName) -Force -Recurse
        #*************************************************************************************
    }
    catch
    {
        Write-Host "Caught an exception:" -ForegroundColor Red
        Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
        Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
    }
}

GetShell

