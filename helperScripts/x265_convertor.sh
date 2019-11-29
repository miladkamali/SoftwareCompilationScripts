#!/bin/bash
op_type=$1
IFS=$(echo -en "\n\b")

function clean_file_names {
    IFS=$(echo -en "\n\b")
    for file in `cat $1`
    do
	if [ -f $file ]
	then
	    edited_file_name=`echo $file|awk 'BEGIN{FS=".";output="";}{if(NF>2){output=$1;for(i=2;i<=NF-1;i++){if(length($i)>0){output=output"_"$i;}}output=output"."$(NF);print output;}else{print $0;}}'`
	    edited_file_name=`echo $edited_file_name|tr -s ' ' ' '|sed -e 's/ /_/g'`
	    edited_file_name=`echo $edited_file_name|tr -s  '_' '_'`

	    #sed -e 's/\./_/g' -e 's/ /-/g' -e 's/\(.*\)_/\1./'
	    if [ "$file" != "$edited_file_name" ]
	    then
		mv "$file" "$edited_file_name"
	    fi
#	    echo "$file" "\t \t" "$edited_file_name"
	fi
    done

}

function clean_file_names_recursively {
    clean_dile_names ./
    for directory in `ls -l |grep "^d"|cut -d' ' -f9-`
    do
	cd $directory
	clean_dile_names ./
	clean_file_names_recursively
    done
}


function findVideoFilesInDirectoryRecursively {
    find $1 -type f -name *mp4 -o -name *flv -o -name *avi -o -name *webm -o -name *mov;
}

rm convert_list
findVideoFilesInDirectoryRecursively ./ >>convert_list
clean_file_names ./convert_list>>convert_list2
rm convert_list
mv convert_list2 convert_list

for i in `cat convert_list`
do
    name=`echo $i|cut -d '.' -f2`
    name="$name-crf28.mkv"
    echo $name-x265-crf26.mkv
    #input_duration=`ffprobe $i -show_format|grep duration|cut -d '=' -f2`
    #input_duration=`mediainfo --Inform="General;%Duration%" $i`
        echo $i
    ffmpeg -i $i -vcodec libx265 -crf 30 -preset slow  -c:a aac -strict experimental -b:a 192k .$name
    #output_duration=`ffprobe $name -show_format|grep duration|cut -d '=' -f2`
    #output_duration=`mediainfo --Inform="General;%Duration%" $name`
    #echo "$input_duration == $output_duration"
    #if [ $input_duration == $output_duration ]
    #then
    #   rm $i
    #fi
done
rm convert_list


