#/bin/bash
fileName=$1

ffmpeg -i 01_witcher_the_last_wish.mp3 -af "silencedetect=noise=-20dB:d=2,ametadata=mode=print:file=silence.txt" -f null -

cat silence.txt|grep -v frame|tr '=' '\n'|grep [0-9]|awk '{ printf "%s,", $1 } NR%3==0{ print "" }' | awk -F, '$3>4.0 {print $1,$2}'| awk 'BEGIN{start=0.0;i=0;}{printf "%04d,%s,%s\n" ,i,start,$1;start=$2;i++;}' > silence

for line in `cat silence`
do
    number=`echo $line|cut -d "," -f1`
    start=`echo $line|cut -d "," -f2`
    end=`echo $line|cut -d "," -f3`
    ffmpeg -i $fileName -ss "$start" -to "$end" "$number_$fileName"
done
