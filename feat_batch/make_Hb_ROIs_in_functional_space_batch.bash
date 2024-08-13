#! /bin/bash

subject=`echo $1`
echo ${subject}

base_dir=/mnt/f/2023_Peking_DRL

roi_dir=${base_dir}/ROI_analysis/${subject}/

declare -a blklist=("BHBL1" "BHBL2" "BHNL" "NHBL" "BHNH1" "BHNH2" "BLNL1" "BLNL2")
declare -a thrs=("0.1" "0.2" "0.3" "0.4" "0.5" )

cd ${roi_dir}

for b in `seq 1 ${#blklist[@]}`;do


    flirt -in left_Hb.nii -ref example_func_${blklist[b-1]}.nii.gz  -applyxfm -init highres2example_func_${blklist[b-1]}.mat -o ${subject}_left_Hb_${blklist[b-1]}	
	flirt -in right_Hb.nii -ref example_func_${blklist[b-1]}.nii.gz  -applyxfm -init highres2example_func_${blklist[b-1]}.mat -o ${subject}_right_Hb_${blklist[b-1]}
	flirt -in bilateral_Hb.nii.gz -ref example_func_${blklist[b-1]}.nii.gz  -applyxfm -init highres2example_func_${blklist[b-1]}.mat -o ${subject}_bilateral_Hb_${blklist[b-1]}
    for t in `seq 1 ${#thrs[@]}`;do
	     fslmaths ${subject}_left_Hb_${blklist[b-1]}.nii.gz -thr ${thrs[t-1]} ${subject}_left_Hb_${blklist[b-1]}_${thrs[t-1]} 
		 fslmaths ${subject}_right_Hb_${blklist[b-1]}.nii.gz -thr ${thrs[t-1]} ${subject}_right_Hb_${blklist[b-1]}_${thrs[t-1]} 
		 fslmaths ${subject}_bilateral_Hb_${blklist[b-1]}.nii.gz -thr ${thrs[t-1]} ${subject}_bilateral_Hb_${blklist[b-1]}_${thrs[t-1]} 
	done
done