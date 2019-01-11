#!/bin/bash

# Get directory and install files.
project_dir="$( cd "$(dirname "$0")" ; pwd -P )"
apt_install_file=${project_dir}/apt.install
pip_install_file=${project_dir}/pip.install
return_value=""

echo "Project directory: $project_dir"
echo "Apt install file directory: $apt_install_file"
echo "Pip install file directory: $pip_install_file"


function user_confirmation () {
    # Display passed prompt and get user input.
    # Return true on "yes" or false otherwise.
    echo "$1 [ yes | no ]"
    read user_input
    if [ "$user_input" = "yes" ] || [ "$user_input" = "y" ] || [ "$user_input" = "YES" ] || [ "$user_input" = "Y" ]
    then
        return_value=true
    else
        return_value=false
    fi
}


function read_file_lines () {
    # Loop through all lines in file. Echo to console.
    while read line
    do
        echo " ${line}"
    done < "$1"
}


function main () {
    # Make sure we are root.
    if [ "$USER" != "root" ]
    then
        echo ""
        echo "Please run script as sudo user. Terminating script."
        exit 0
    else
        echo ""
        echo "Note: This script will install system packages."
        echo "      To cancel, hit ctrl+c now. Otherwise hit enter to start."
        read user_input
    fi

    # Install apt-get packages.
    apt-get update
    apt-get install $(read_file_lines ${apt_install_file}) -y
    echo ""
    user_confirmation "Did everything install correctly?"
    if [ "$return_value" = false ]
    then
        echo ""
        echo "Please correct errors and run script again."
        echo "Terminating script."
        exit 0
    else
        echo ""
    fi
    return_value=""

    # Install pip packages.
    python -m pip install $(read_file_lines ${pip_install_file})
    echo ""
    user_confirmation "Everything install correctly?"
    if [ "$return_value" = false ]
    then
        echo ""
        echo "Please correct errors and run script again."
        echo "Terminating script."
        exit 0
    else
        echo ""
    fi

    # Success. Exit script.
    echo "Installation has finished."
    exit 0
}

main
