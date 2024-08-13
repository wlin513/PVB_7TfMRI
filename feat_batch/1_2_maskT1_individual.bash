#! /bin/bash

base_dir=/mnt/f/2023_Peking_DRL
echo 'Enter Subject Number'
read subject

fslmaths ${base_dir}/T1/${subject}/T1_bias_corr_smooth_20.anat/T1_biascorr_brain.nii.gz -mas ${base_dir}/T1/${subject}/T1_mask.nii.gz ${base_dir}/T1/${subject}/T1_bias_corr_smooth_20.anat/T1_biascorr_brain_masked.nii.gz
robustfov -i ${base_dir}/T1/${subject}/T1_bias_corr_smooth_20.anat/T1_biascorr_brain_masked.nii.gz -r ${base_dir}/T1/${subject}/T1_brain.nii.gz
robustfov -i ${base_dir}/T1/${subject}/T1_bias_corr_smooth_20.anat/T1_biascorr.nii.gz -r ${base_dir}/T1/${subject}/T1.nii.gz
