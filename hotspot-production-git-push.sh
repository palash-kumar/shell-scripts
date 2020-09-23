#!/bin/bash 

# variables

#hotspot-0.0.1-SNAPSHOT
echo "Copy From Source : "
read cpFrom
#"copy-test-dir" #"hotspot-production"
cpTo="hotspot-production"

echo "Do you want to Push to GIT? Type Yes/y to agree."
read git

echo "Do you want to Push to Server as ZIP? Type Yes/y to agree."
read serverPush

echo "\n========== Scanning for Source ==========\n"
cpfromloc=$(find /mnt -type d -name $cpFrom)
echo "COPY FROM : $cpfromloc"

cpfromloc=$(echo "$cpfromloc")
ls "$cpfromloc/"
echo "=> cpfromloc : $cpfromloc"

echo "\n========== Scanning for Destination ==========\n"
echo "cpTo : $cpTo"
echo "Copy TO : "
var=$(find /mnt -type d -name $cpTo)
echo "Var : $var"
cpToLoc=$(echo "$var")
echo "cpToLoc : $cpToLoc"

echo "\n========== Directories List ==========\n"
echo "Copy from : $cpfromloc"
echo "Copy to : $cpToLoc"
echo "Directories at Source Location : "
ls "$cpfromloc"

ls "$cpToLoc"

echo "\n========== File Copy Initiated ==========\n"
for FILE in `ls "$cpfromloc"`
do
    echo "IN FOR"
    echo $FILE
    ls $FILE
    cp -uR "$cpfromloc/$FILE" "$cpToLoc"
done
sleep 3
echo "\n========== File Copy Completed ==========\n"
cd "$cpToLoc"

if [[ ${git,,} == "yes" || ${git,,} == "y" ]]
then
    echo "\n========== Initiating GIT Commit ==========\n"
    ## Git commands works
    cd "$cpToLoc" && shift && git add "$cpToLoc/."
    echo "ENTER COMMIT MESSAGE"
    read commitmsg

    #cd "$cpToLoc" && shift && git commit -m "$commitmsg"
    git commit -m "$commitmsg"
    #cd "$cpToLoc" && shift &&  
    git branch

    #cd "$cpToLoc" && shift && 
    git push
    echo "\n========== GIT Update completed ==========\n"
fi

#echo "\n========== Transfering Files to local server ==========\n"

if [[ ${serverPush,,} == "yes" || ${serverPush,,} == "y" ]]
then
    cd ..
    ls -l
    #echo "please Enter a file name"
    zipName="$cpTo-20092020.zip"
    echo $zipName
    zip -r "$zipName" "$cpTo"

    sleep 3

    echo "Server Username : "
    read u
    # 114.31.10.244 hotspot-0.0.1-SNAPSHOT
    echo "Server IP : "
    read ipa
    echo scp -r -P 5566 "$cpToLoc/" $u@$ipa:/home/maestro/$cpTo
    scp -r -P 5566 "$zipName" $u@$ipa:/home/maestro/

    #SUDO commands
    ssh -t -p 5566 $u@$ipa "sudo cd /home/maestro/; echo 'Apache Tomcat is shutting down'; sudo /usr/apache-tomcat-8.5.27/bin/shutdown.sh; sleep 5;  sudo unzip $zipName; sleep 2; sudo cp hotspot-production-020920/WEB-INF/classes/application.properties hotspot-production/WEB-INF/classes/;sudo /usr/apache-tomcat-8.5.27/bin/startup.sh "
fi