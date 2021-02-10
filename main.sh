#! /bin/bash

function mac_files_del() {
    ls -a "$1" \
    | while read file;
    do
        # because of hidden file included "." and "..", they are bad variable name
        if [[ "$file" != "." &&  "$file" != ".." ]];
        then
            if [[ -d "$1/$file" ]];
            then
                if [[ "$file" = "__MACOSX" ]];
                then
                    rm -rf "$1/$file"
                    echo "$1/$file"
                else
                    mac_files_del "$1/$file"
                fi
            elif [[ "$file" = "._*" ]] || [[ "$file" =~ ".DS_Store" ]] || [[ "$file" = "Thumbs.db" ]];
            then
                rm -rf "$1/$file"
                # print path that is deleted
                echo "$1/$file"
            fi
        fi
    done
}

function mac_files_move() {
    ls -a "$1" \
    | while read file;
    do
        if [[ "$file" != "." &&  "$file" != ".." ]];
        then
            if [[ -d "$1/$file" ]];
            then
                if [[ "$file" = "__MACOSX" ]];
                then
                    mkdir -p "$move_path${1#*$dname}"
                    mv "$1/$file" "$move_path${1#*$dname}"
                else
                    mac_files_move "$1/$file"
                fi
            elif [[ "$file" = "._*" ]] || [[ "$file" =~ ".DS_Store" ]] || [[ "$file" = "Thumbs.db" ]];
            then
                # first to mkdir dir
                mkdir -p "$move_path${1#*$dname}"
                mv "$1/$file" "$move_path${1#*$dname}"
            fi
        fi
    done
}

echo "Please enter a folder to delete:"
read name
# remove the start and end char("'") of path by regex
name="${name#*\'}"
name="${name%\'*}"
# if delete, please commit the following 3 lines
# dname=$(dirname "$name")
# mkdir -p "$dname/mac_files_recover"
# move_path="$dname/mac_files_recover"

echo "------ Begin Handling Mac files ------"
# mac_files_move "$name"
mac_files_del "$name"
echo "-------------- In the end --------------"
