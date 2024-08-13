#! /bin/bash

subject=`echo $1`
echo ${subject}

base_dir=/mnt/f/2023_Peking_DRL

roi_dir=${base_dir}/ROI_analysis/${subject}/

declare -a blklist=("BHBL1" "BHBL2" "BHNL" "NHBL" "BHNH1" "BHNH2" "BLNL1" "BLNL2")

#seednames=("binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled" "NAcc_resampled" "NAcc_resampled_left" "NAcc_resampled_right" "activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82" "atlas-vta_hem-bi_proba-27_resampled_thr01")
seednames=("bilateral_Hb_15" "left_Hb_15" "right_Hb_15")

cp /mnt/h/2023_Peking_DRL/first_level/GLM1_pre_1/${subject}/BHBL1.feat/reg/highres2standard_warp.nii.gz  ${roi_dir}
cp /mnt/h/2023_Peking_DRL/first_level/GLM1_pre_1/${subject}/BHBL1.feat/reg/highres.nii.gz  ${roi_dir}


cd ${roi_dir}

invwarp --ref=highres.nii.gz --warp=highres2standard_warp.nii.gz --out=standard2highres_warp.nii.gz
for b in `seq 1 ${#blklist[@]}`;do
   cp /mnt/h/2023_Peking_DRL/first_level/GLM1_pre_1/${subject}/${blklist[b-1]}.feat/reg/highres2example_func.mat  ${roi_dir}/highres2example_func_${blklist[b-1]}.mat
   cp /mnt/h/2023_Peking_DRL/first_level/GLM1_pre_1/${subject}/${blklist[b-1]}.feat/reg/example_func.nii.gz  ${roi_dir}/example_func_${blklist[b-1]}.nii.gz
   for nseed in `seq 1 ${#seednames[@]}`; do
       applywarp --ref=example_func_${blklist[b-1]}.nii.gz --in=${base_dir}/ROIs/${seednames[nseed-1]}.nii.gz --warp=standard2highres_warp.nii.gz --postmat=highres2example_func_${blklist[b-1]}.mat --out=${subject}_${seednames[nseed-1]}_${blklist[b-1]} --interp=nn
   done
done