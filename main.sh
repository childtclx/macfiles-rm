#! /bin/bash

function mac_files_del() {
    # because of hidden file included "." and "..", they are bad variable name
    filelist=`ls -a $1`
    for file in $filelist
    do
        if [[ "$file" != "." &&  "$file" != ".." ]];
        then
            if [ -d $1/$file ];
            then
                mac_files_del $1/$file
            elif [[ $file =~ ".DS_Store" ]] || [[ $file = "Thumbs.db" ]];
            then
                rm -rf $1/$file
                # print path that is deleted
                echo $1/$file
            fi
        fi
    done
}

function mac_files_move() {
    filelist=`ls -a $1`
    for file in $filelist
    do
        if [[ "$file" != "." &&  "$file" != ".." ]];
        then
            if [ -d $1/$file ];
            then
                mac_files_del $1/$file $2
            elif [[ $file =~ ".DS_Store" ]] || [[ $file = "Thumbs.db" ]];
            then
                move_path_add=${1#*$dname}
                mkdir -p $2/$move_path_add
                mv $1/$file $2/$move_path_add
            fi
        fi
    done
}

echo "Please enter a folder to delete:"
read name
name=${name#*\'}
name=${name%\'*}
# if delete, please commit the following 3 lines
# dname=$(dirname "$name")
# mkdir -p $dname/mac_files_recover
# move_path=$dname/mac_files_recover

echo "------ Begin Handling Mac files ------"
# mac_files_move $name $move_path
mac_files_del $name
echo "-------------- In the end --------------"
