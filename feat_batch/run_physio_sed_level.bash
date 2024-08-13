#! /bin/bash

# script to generate physiological regressors


subject=`echo $1`
echo ${subject}
#echo 'Enter Subject Number'
#read subject

base_dir=/media/sf_2023_Peking_DRL
physio_dir="${base_dir}/physio/"
declare -a blklist=("BHBL1" "BHBL2" "BHNL" "NHBL" "BHNH1" "BHNH2" "BLNL1" "BLNL2")

for i in `seq 0 7` ; do

${physio_dir}${subject}/${blklist[$i]}/${subject}_${blklist[$i]}_run_second_lev.txt
done


