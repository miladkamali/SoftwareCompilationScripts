#!/bin/bash
op_type=$1
IFS=$(echo -en "\n\b")

function clean_file_names {
    IFS=$(echo -en "\n\b")
    for file in `ls`
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


if [ $op_type=="" ]
then
    rm convert_list
    clean_file_names
    ls|grep \.mp4 >> convert_list
    ls|grep \.flv >> convert_list
    ls|grep \.m4v >> convert_list
    ls|grep \.avi >>convert_list
    ls|grep \.wma >>convert_list
    ls|grep \.wmv >>convert_list
    ls|grep \.webm >>convert_list
    ls|grep \.mov >>convert_list
    for i in `cat convert_list`
    do
	name=`echo $i|cut -d '.' -f1`
	name="$name-crf28.mkv"
	echo $name-x265-crf26.mkv
#input_duration=`ffprobe $i -show_format|grep duration|cut -d '=' -f2`
	input_duration=`mediainfo --Inform="General;%Duration%" $i`
	ffmpeg -i $i -vcodec libx265 -crf 28 -preset fast  -c:a aac -strict experimental -b:a 192k $name
#output_duration=`ffprobe $name -show_format|grep duration|cut -d '=' -f2`
	output_duration=`mediainfo --Inform="General;%Duration%" $name`
	echo "$input_duration == $output_duration"
#if [ $input_duration == $output_duration ]
#then
#	rm $i
#fi
    done
    rm convert_list
fi
