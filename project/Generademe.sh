#!/bin/bash
# Genprof,means [GenerateReadMe]'s abbreviation.
# Programmer:Harold.Duan
# Date:20180718
# Reason:[GenerateReadMe] Auto generate\update README.md file.

echo "Generating README..."
echo "Removing old file..."
rm -rf README.md
# root_path=$(dirname "$PWD")
cur_file="README.md"
cur_date="`date +%Y-%m-%d`"
# root_name= basename `pwd`
root_path=$(cd $(dirname $0); pwd)
# echo $root_path
root_name=${root_path##*/}
# echo $root_name
echo "Writing head contents..."
cat>"${cur_file}"<<EOF
/*  
@title: Project $root_name README  
@author: harold.duan  
@date: $cur_date  
@memo: The README is the project's overview,it is generated by Generademe.  
*/  

# $root_name  

## Overview  

+ [Overview](#Overview)  
+ [Structures](#Structure) 
+ [Contributors](#Contributors)  
+ [Thanks](#Thanks) 

## Structures

\`\`\`
EOF
# echo "\n# $root_name  \n" >> $cur_file
echo "Writing project peroid contents..."
cur_dir=$(ls -l $pwd |awk '/^d/ {print $NF}')
for i in $cur_dir
do
cat>>"${cur_file}"<<EOF
+-- $root_name
    +-- $i
        +-- documents  
            +-- requirements  
            +-- dev_plannings  
            +-- dev_designs  
            +-- buglist  
            +-- handovers  
        +-- source_codes  
            +-- addons  
            +-- services  
            +-- web  
EOF
    # echo "    - [$i](#$i)" >> $cur_file
    echo "Generating project sub dic $i"
done
echo "Writing foot contents..."
cat>>"${cur_file}"<<EOF
\`\`\`

## Contributors

<p align="left">
  <a href="http://gogs.avatech.com.cn:8080/Harold.Duan"><img src="https://secure.gravatar.com/avatar/e8a13a25f5772fa2c47552f6d354205b?d=identicon&s=287" width="70" alt="Harold.Duan" /></a>
  <a href="http://gogs.avatech.com.cn:8080/Pancy"><img src="https://secure.gravatar.com/avatar/b52772a76077449be10bdf1762402d51?d=identicon&s=287" width="70" alt="Pancy.Fan" /></a>
  <a href="http://gogs.avatech.com.cn:8080/Aaton.Kang"><img src="http://gogs.avatech.com.cn:8080/avatars/9?s=287" width="70" alt="Aaton.Kang" /></a>
  <a href="http://gogs.avatech.com.cn:8080/Shuo.Liu"><img src="https://secure.gravatar.com/avatar/d2479a28b78bcdf1f4da9b8680da127b?d=identicon&s=287" width="70" alt="Shuo.Liu" /></a>
</p>

## Thanks

<h3 align="left">
  <p align="left">
    <a href="http://gogs.avatech.com.cn:8080/Project"><img src="http://gogs.avatech.com.cn:8080/avatars/19?s=140" width="70" alt="Team RDC-Project" /></a>
    <a href="http://gogs.avatech.com.cn:8080/Product"><img src="http://gogs.avatech.com.cn:8080/avatars/20?s=140" width="70" alt="Team RDC-Product" /></a>
  </p>
</h3>
EOF
echo "Done!"