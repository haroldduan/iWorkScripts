<#
**** Genprof,means [GenerateProjectsFolders]'s abbreviation.
**** Programmer:Harold.Duan
**** Date:20180607
**** Reason:[GenerateProjectsFolders] Auto generate project's folders.
#>


function CreateSubFolders([string]$root_path,[string[]]$sub_folders)
{
    <#echo $root_path#>
    cd $root_path
    foreach($item in $sub_folders)
    {
        mkdir $item
        echo "Folder [$item] is created!"
    }
}

function Read-InputBoxDialog([string]$Message, [string]$WindowTitle, [string]$DefaultText)
{
    Add-Type -AssemblyName Microsoft.VisualBasic
    return [Microsoft.VisualBasic.Interaction]::InputBox($Message, $WindowTitle, $DefaultText)
}

function CreateFoldersStructure([string]$root_path,[string]$root_name)
{
    CreateSubFolders $root_path $root_name
    $current_path = "$root_path\$root_name"
    echo "This current folder's path :[$current_path]!"
    echo "Creating the project's folder..."
    $folders_1st_level = "1.需求说明","2.设计文档","3.数据库相关","4.项目源代码","5.开发主计划","6.客户往来资料","7.交付客户内容","8.开发工作单","9.问题处理记录","10.项目验收和稽核"
    CreateSubFolders $current_path $folders_1st_level
    $father_path = "$current_path\1.需求说明"
    $folders_2nd_level = "开发需求解读(工作任务书,调研文档..)","客户提供资料","商务文档"
    CreateSubFolders $father_path $folders_2nd_level
    $father_path = "$current_path\3.数据库相关"
    $folders_2nd_level = "客户帐套","数据库设计文档"
    CreateSubFolders $father_path $folders_2nd_level
    $father_path = "$current_path\4.项目源代码"
    $folders_2nd_level = "Addon","ibas","Integration"
    CreateSubFolders $father_path $folders_2nd_level
    $father_path = "$current_path\7.交付客户内容"
    $folders_2nd_level = "项目安装必备","用户操作手册"
    CreateSubFolders $father_path $folders_2nd_level
}

try
{
    $folder_name = Read-InputBoxDialog "Please input the projects folder's name..." "Folders Naming" "一期"
    echo "You input folders name is $folder_name!"
    $folder_path = Split-Path -Parent $MyInvocation.MyCommand.Definition
    CreateFoldersStructure $folder_path $folder_name
}
catch
{
    Write-Host "Caught an exception:" -ForegroundColor Red
    Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
    Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
}
