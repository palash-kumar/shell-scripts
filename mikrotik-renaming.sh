#!/bin/bash 

echo "Please Select a replace option"
echo "1. Replace TITLE"
echo "2. Replace URL"
echo "3. Replace Both 1 & 2"
read selected

#Replacing the title
if [ $selected -eq 1 ]
then
    echo "Enter the TITLE : "
    read title

    sed 's/<title>[^>]\+<\/title>/<title>'"$title"'<\/title>/g' -i hs-maXim/login.html #>> hs-maXim/replaced_login.html

fi

# Replacing the URL
if [ $selected -eq 2 ]
then
    echo "Enter the text you would like to replace: "
    read search

    echo "Enter Text you would like to replace with: "
    read replace

    sed 's#\([^/]*[^/]*'"$search"'[^/]*\)[^/]*/#'"$replace"'/#g' -i hs-maXim/login.html #>> hs-maXim/replaced_login.html

fi

# Replacing Both Title and URL
if [ $selected -eq 3 ]
then

    #Title
    echo "Enter the TITLE : "
    read title

    sed 's/<title>[^>]\+<\/title>/<title>'"$title"'<\/title>/g' -i hs-maXim/login.html #>> hs-maXim/replaced_login.html

    #URL
    echo "Enter the text you would like to replace: "
    read search

    echo "Enter Text you would like to replace with: "
    read replace

    sed 's#\([^/]*[^/]*'"$search"'[^/]*\)[^/]*/#'"$replace"'/#g' -i hs-maXim/login.html #>> hs-maXim/replaced_login.html

fi



ls hs-maXim


echo "Replace operation ended"

#echo 'I think "https://demo.maestro.com.bd/hotspot" is my favorite' | 
#    sed 's~https://demo.maestro.com.bd/hotspot~https://test.maestro.com.bd/hotspot~g'