#! /usr/bin/env bash

main() {
    echo -e "Hello $USER!"

    while true; do
        menu

        read option

        case $option in
            0)     
                echo -e "\nFarewell!"
                break 
                ;;
            1)     
                os_info 
                ;;
            2)     
                user_info
                ;;
            3)     
                file_dir_ops
                ;;
            4)     
                executable_ops
                ;;
            *)     
                echo "Invalid option!" 
                ;;
        esac
    done
}

file_dir_ops() {
    while true; do
        echo -e "\nThe list of files and directories:"

        local array=($(ls))
        
        list_file_and_dirs "${array[@]}"
        
        file_menu
        read input

        if [ $input -eq 0 ]; then
            break
        elif [ $input = 'up' ]; then
            up_cmd
        elif contains $input "${array[@]}"; then
            file_dir_cmd "$input"
        else
            echo -e "Invalid input!\n"
        fi
    done
}

executable_ops() {
    echo "Enter an executable name:"

    read executable_name
    executable=$(which $executable_name)

    if [ $executable ]; then
        echo "Located in: $executable"
        echo "Enter arguments:"
        read arguments
        $executable $arguments
    else
        echo "The executable with that name does not exist!"
    fi
}

list_file_and_dirs() {
    local arr=("$@")
    for item in "${arr[@]}"; do
        local type=$(get_type "$item")
        echo "${type} ${item}"
    done
}

file_dir_cmd() {
    local type=$(get_type "$1")
    case $type in
        'F')
            file_opt_cmd "$1"
            ;;
        'D')     
            cd $1
            ;;
    esac
}

file_opt_cmd() {
    while true; do
        file_opt_menu

        file_name=$1
        read file_option

        case $file_option in
            0)
                break 
                ;;
            1)     
                rm $file_name
                echo "${file_name} has been deleted."
                break
                ;;
            2)     
                echo "Enter the new file name: "
                read new_file_name
                mv $file_name $new_file_name
                echo "${file_name} has been renamed as ${new_file_name}"
                break
                ;;
            3)     
                chmod 666 $file_name
                echo "Permissions have been updated."
                ls -l $file_name
                break
                ;;
            4)     
                chmod 664 $file_name
                echo "Permissions have been updated."
                ls -l $file_name
                break
                ;;
            *)     
                continue 
                ;;
        esac
    done
}

contains() {
    to_find=$1
    shift   
    local arr=("$@")

    for item in "${arr[@]}"; do
        if [[ $to_find == "$item" ]]; then
            return 0
        fi
    done

    return 1
}

get_type() {    
    if [[ -f "$1" ]]; then
        echo "F"
    elif [[ -d "$1" ]]; then
        echo "D"
    fi
}

up_cmd() {
    cd ..
}

not_implemented() {
    echo "Not implemented!"
}

os_info() {
    uname -no
}

user_info() {
    whoami
}

menu() {
    echo ""
    echo "------------------------------"
    echo "| Hyper Commander            |"
    echo "| 0: Exit                    |"
    echo "| 1: OS info                 |"
    echo "| 2: User info               |"
    echo "| 3: File and Dir operations |"
    echo "| 4: Find Executables        |"
    echo "------------------------------"
}

file_menu() {
    echo ""
    echo "---------------------------------------------------"
    echo "| 0 Main menu | 'up' To parent | 'name' To select |"
    echo "---------------------------------------------------"
}

file_opt_menu() {
    echo ""
    echo "---------------------------------------------------------------------"
    echo "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
    echo "---------------------------------------------------------------------"
}

main
