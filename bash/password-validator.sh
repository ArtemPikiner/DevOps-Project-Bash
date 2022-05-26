#!/bin/bash

###### Collors ######
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)
RESULT=''
###################################################
# function to check that a password has been entered
function EmptyStringCheck {
    if [[ -z ${PASS} ]];
    then 
        echo "${green}Enter your password:"
        read PASS

        if [[ -z ${PASS} ]];
        then
            EmptyStringCheck
        fi
    fi
}
#########################################################
# function to check that the password is at least 10 characters
function PasswordCheckMore10Characters {
    if [ ${#PASS} -lt 10 ];
    then
        RESULT='Password less than 10'
    else 
        RESULT=''
    fi
}
########################################################
#function to check that the password contains numbers
function PasswordCheckNumbers
{
    if [[ $PASS =~ ([0-9]+) ]];
    then
        RESULT=''
    elif [[ -z ${RESULT} ]];
    then
         RESULT="Password must contain numbers"
    else
        RESULT="${RESULT} and Password must contain numbers"
    
    fi
}
###############################################################
#function to check that the password contains capital case letters
function PasswordCheckCapitalLetters {
    str=`echo -n $PASS | grep '[A-Z]'`
    if [ -z "$str" ]; then
        if [[ -z ${RESULT} ]];
        then
            RESULT="Password must contain capital case letters"
        else
            RESULT="${RESULT} and Password must contain capital case letters"
        fi
    fi
   
}
#############################################################
#function to check that the password contains lower case letters
function PasswordCheckLowerLetters {
    str=`echo -n $PASS | grep '[a-z]'`
    if [ -z "$str" ]; then
        if [[ -z ${RESULT} ]];
        then
            RESULT="Password must contain lower case letters"
        else
            RESULT="${RESULT} and Password must contain lower case letters"
        fi
    fi
   
}
#################################################################
# function output to terminal
function Output {
    if [[ -z ${RESULT} ]];
     then
        echo "${green}Congratulations the password is strong"
        exit 0
    else
        echo "${red}$RESULT"
        exit 1
    fi
}
#############################################################
# function read password from file
function ReadPasswordFromFile {
        PASS=$(cat $pathFile)
        echo $PASS
        PasswordCheckMore10Characters
        PasswordCheckNumbers
        PasswordCheckLowerLetters
        PasswordCheckCapitalLetters
        Output
}
##############################################################
# Check that the file exists at the given path
function checkFileExist {
    if [ -f "$pathFile" ];
    then
        ReadPasswordFromFile
    else
        echo "${red}File at the specifiend path does not exist"
        command='./password-validator.sh -f'
        eval $command
    fi
    
}
#############################################################
#Check that the path to the file is entered
function checkPathFileInput {
    if [[ -z ${pathFile} ]];
    then 
        echo "${green}Enter your file.txt path:"
        read pathFile

        if [[ -z ${pathFile} ]];
        then
            checkPathFileInput
        else
            checkFileExist
        fi
    else
        checkFileExist
   
    fi

}

#################################################
# main script
while getopts "f" opt
do 
case $opt in
f)  pathFile=$2
    checkPathFileInput
    
    ;;
?) echo "${red}Option does not exist"
   exit 1
 ;;
esac
done

PASS=$1
EmptyStringCheck 
PasswordCheckMore10Characters
PasswordCheckNumbers
PasswordCheckLowerLetters
PasswordCheckCapitalLetters
Output


