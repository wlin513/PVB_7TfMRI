#! /bin/bash

subject=`echo $1`
echo ${subject}


base_dir=/mnt/f/2023_Peking_DRL
roi_dir=${base_dir}/ROI_analysis/${subject}
mkdir -p ${roi_dir}

cp ${base_dir}/T1/${subject}/left_Hb.nii* ${roi_dir}/left_Hb.nii
cp ${base_dir}/T1/${subject}/right_Hb.nii* ${roi_dir}/right_Hb.nii

fslmaths ${roi_dir}/left_Hb.nii -add ${roi_dir}/right_Hb.nii ${roi_dir}/bilateral_Hb.nii

applywarp -i ${roi_dir}/left_Hb.nii -o ${roi_dir}/left_Hb_mni.nii -r ${base_dir}/first_level/GLM1_pre_1/${subject}/BHBL1.feat/reg/standard.nii.gz -w ${base_dir}/first_level/GLM1_pre_1/${subject}/BHBL1.feat/reg/highres2standard_warp.nii.gz
applywarp -i ${roi_dir}/right_Hb.nii -o ${roi_dir}/right_Hb_mni.nii -r ${base_dir}/first_level/GLM1_pre_1/${subject}/BHBL1.feat/reg/standard.nii.gz -w ${base_dir}/first_level/GLM1_pre_1/${subject}/BHBL1.feat/reg/highres2standard_warp.nii.gz
applywarp -i ${roi_dir}/bilateral_Hb.nii -o ${roi_dir}/bilateral_Hb_mni.nii -r ${base_dir}/first_level/GLM1_pre_1/${subject}/BHBL1.feat/reg/standard.nii.gz -w ${base_dir}/first_level/GLM1_pre_1/${subject}/BHBL1.feat/reg/highres2standard_warp.nii.gz

#fslmeants -i ../stats/zstat2.nii.gz -o meants_left_Hb_FOV.txt -m left_Hb_FOV.nii.gz