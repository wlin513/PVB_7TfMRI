#! /bin/bash

subject=`echo $1`
echo ${subject}

base_dir=/mnt/h/2023_Peking_DRL
PRE=pre_1
declare -a blklist=("BHBL1" "BHBL2" "BHNL" "NHBL" "BHNH1" "BHNH2" "BLNL1" "BLNL2")

seedname=binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled
seedir=${base_dir}/ROIs

PPIdir="${base_dir}/PPI/${seedname}"
desdir="${PPIdir}/${subject}/time_courses/${PRE}"
mkdir -p ${desdir}
mkdir -p ${PPIdir}/${subject}/ROI_mask

cp ${seedir}/${seedname}.nii* ${PPIdir}

for i in `seq 0 7` ; do

predir="${base_dir}/preprocessing/${PRE}/${subject}/${blklist[$i]}.feat"
cp ${base_dir}/ROI_analysis/${subject}/${subject}_${seedname}_${blklist[$i]}.nii.gz ${PPIdir}/${subject}/ROI_mask/

fslmeants -i  ${predir}/filtered_func_data.nii.gz -o ${desdir}/${blklist[$i]}.txt -m ${base_dir}/ROI_analysis/${subject}/${subject}_${seedname}_${blklist[$i]}.nii.gz
done
