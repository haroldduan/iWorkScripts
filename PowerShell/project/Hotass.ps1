<#
**** Hotass,means [HostAssistant]'s abbreviation.
**** Programmer:Harold.Duan
**** Date:20181108
**** Reason:[HostAssistant] Host file's assistant,smart choose and change.
#>

$sys_path = "$env:windir\System32\drivers\etc"
$asses = New-Object -TypeName System.Collections.ArrayList
function GetAsses([string]$path)
{
   echo "Load all asses..."
   # echo $path
   # $asses = Dir $path | Where-Object{$_.Name -clike "*ass*"}
   # $asses = Get-ChildItem $path\ -Include *ass*
   # $asses = [System.IO.Directory]::GetFiles($path, "*ass*")
   # $asses = Get-ChildItem $path | ?{$_.psiscontainer -eq $false}
   Get-ChildItem $path | ForEach-Object -Process{
      if ($_ -is [System.IO.FileInfo] -and $_.Name.ToLower().Contains("ass")){
          # echo $_.Name
          $asses.Add($_.Name) 
      }
   }
   echo "Load asses succeed!`r`n"
}

function Read-InputBoxDialog([string]$Message, [string]$WindowTitle, [string]$DefaultText)
{
    Add-Type -AssemblyName Microsoft.VisualBasic
    return [Microsoft.VisualBasic.Interaction]::InputBox($Message, $WindowTitle, $DefaultText)
}

function ChooseAss()
{
   $msg = ""
   $choosed = ""
   # echo $asses
   # echo $asses.Count
   if($asses.Count -ge 1)
   {
      $title = "Ass Choice"
      $notice = "Please choose the ass,example:`r`nn -> [n].ass_XXXXX ...`r`n`r`n"
      foreach($a in $asses){$notice += "* [" + $asses.IndexOf($a).ToString() + "].$a `n"}
      $choosed = Read-InputBoxDialog $notice $title 0
      #echo $choosed
      if ($choosed){
        $ass = $asses[$choosed]
        #echo $ass
        echo "You choosed ass is [$choosed].$ass!" 
        echo "Overwrite local system current hosts...`r`n[$cur_path\asses\$ass] -> [$sys_path\hosts]`r`n"
        #Start-Process powershell -Verb runAs
        #Copy-Item $cur_path\asses\$ass $sys_path\$ass
        Copy-Item $cur_path\asses\$ass $sys_path\hosts
        #ipconfig /flushdns | Out-Null
        ipconfig /flushdns
      }
      else{ echo "Ass choosing is failed!" }
   }
   else{ echo "Scan asses failed!" }
}

try
{
    $cur_path = Split-Path -Parent $MyInvocation.MyCommand.Definition
    #echo $cur_path
    GetAsses "$cur_path\asses"
    ChooseAss
}
catch
{
    Write-Host "Caught an exception:" -ForegroundColor Red
    Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
    Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
}