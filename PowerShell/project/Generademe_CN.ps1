<#
**** Genprof,means [GenerateReadMe]'s abbreviation.
**** Programmer:Harold.Duan
**** Date:20190903
**** Reason:[GenerateProjectsFolders] Auto generate\update README.md file.
#>

function WriteContents([String]$file,[String]$cur_path,[Int]$depth,[String]$last_dir="")
{
    $depth = $depth + 1
    $cur_info = Get-ChildItem $root_path | Measure-Object
    # echo $cur_dir
    # echo $cur_info
    if ($cur_info.Count -gt 0)
    {
        Get-ChildItem $cur_path -Exclude *.ps1,*.md,.git* | ForEach-Object -Process{
            $cur_dir = $_.Name
            echo $cur_dir
            # echo $_.Directory
            # echo $_.FullName
            $tap = "  "*($depth - 1)
            if($last_dir -ne ""){
                echo "$tap+ [$cur_dir](#/$last_dir/$cur_dir)" >> $file
            }
            else{
                echo "$tap+ [$cur_dir](#/$cur_dir)" >> $file
            }
            if($_ -isnot [System.IO.FileInfo])
            {
                if($last_dir -ne ""){
                    $last_dir = "$last_dir/$cur_dir"
                }
                else{
                    $last_dir = $cur_dir
                }
                # echo $_.FullName
                # echo "fuck"
                # echo $last_dir
                # echo $depth
                WriteContents $file $_.FullName $depth $last_dir
            }
        }
    }
}

echo "Generating README..."
# Get current file
$cur_file = $MyInvocation.MyCommand.Definition
# Get current root path
$root_path = Split-Path -Parent $cur_file
$root_name =  Split-Path $root_path -Leaf
cd $root_path
echo "Removing old file..."
# Remove old README.md
if (Test-Path $root_path\README.md)
{
    del $root_path\README.md
}
# echo "Creating README..."
# New README.md
# New-Item README.md
# Write README top contents
echo "# $root_name

## 概览

+ [概览](#概览)  
+ [目录](#目录)  
+ [贡献](#贡献)  
+ [鸣谢](#鸣谢)  


## 目录
" >> $root_path/README.md
echo "Scanning folders and files..."
WriteContents "$root_path/README.md" $root_path 0 ""
# Write README bottom contents
echo "
## 贡献

<p align=`"left`">
  <a href=`"http://gogs.avatech.com.cn:8080/Harold.Duan`"><img src=`"https://secure.gravatar.com/avatar/e8a13a25f5772fa2c47552f6d354205b?d=identicon&s=287`" width=`"70`" alt=`"Harold.Duan`" /></a>
  <a href=`"http://gogs.avatech.com.cn:8080/Pancy`"><img src=`"https://secure.gravatar.com/avatar/b52772a76077449be10bdf1762402d51?d=identicon&s=287`" width=`"70`" alt=`"Pancy.Fan`" /></a>
  <a href=`"http://gogs.avatech.com.cn:8080/Aaton.Kang`"><img src=`"http://gogs.avatech.com.cn:8080/avatars/9?s=287`" width=`"70`" alt=`"Aaton.Kang`" /></a>
  <a href=`"http://gogs.avatech.com.cn:8080/Shuo.Liu`"><img src=`"https://secure.gravatar.com/avatar/d2479a28b78bcdf1f4da9b8680da127b?d=identicon&s=287`" width=`"70`" alt=`"Shuo.Liu`" /></a>
</p>

## 鸣谢

<h3 align=`"left`">
  <p align=`"left`">
    <a href=`"http://gogs.avatech.com.cn:8080/Project`"><img src=`"http://gogs.avatech.com.cn:8080/avatars/19?s=140`" width=`"70`" alt=`"Team RDC-Project`" /></a>
    <a href=`"http://gogs.avatech.com.cn:8080/Product`"><img src=`"http://gogs.avatech.com.cn:8080/avatars/20?s=140`" width=`"70`" alt=`"Team RDC-Product`" /></a>
  </p>
</h3>

***Auto generating by Generademe.***
" >> $root_path/README.md
echo "Done!"