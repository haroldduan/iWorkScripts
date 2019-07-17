#!/bin/bash
# Genprof,means [GenerateProjectsFolders]'s abbreviation.
# Programmer:Harold.Duan
# Date:20180607
# Reason:[GenerateProjectsFolders] Auto generate project's folders.

read -p "Enter the project's period,like p1,p2,p3... > " period
echo "Current project period is $period..."
echo "Generating the project folders..."
mkdir $period
root_path=$(cd `dirname $0`; pwd)$pwd
# echo $root_path
cd $period
period_path=$(cd `dirname $0`; pwd)$pwd
# echo $period_path
echo "Generating the documents and source_codes folders..."
mkdir "documents" "source_codes"
cd documents
echo "Generating documents sub folders..."
mkdir "buglist" "dev_designs" "dev_plannings" "handovers" "requirements"
cd ../source_codes
mkdir "addons" "services" "web"
echo "Generating source_codes sub folders..."
echo "Done!"