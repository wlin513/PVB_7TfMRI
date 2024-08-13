#! /bin/bash

base_dir=/mnt/h/2023_Peking_DRL

readarray -d ' ' -t subjectlist < ${base_dir}/code/feat_batch/subject_list
echo extracting roi values for participants: ${subjectlist[@]}

PRE=pre_1


glm=GLM4

#second contrast
#ncontrast=2
contrast_names=("chosen_opt1" "mean_chosen_opt1" "unchosen_opt1" "mean_unchosen_opt1" "chosen_opt2" "mean_chosen_opt2" "unchosen_opt2" "mean_unchosen_opt2")


declare -a blklist=("BHNH1" "BHNH2" "BLNL1" "BLNL2")

for ncontrast in `seq 1 ${#contrast_names[@]}`; do
  for b in `seq 1 ${#blklist[@]}`;do

    for i in `seq 1 ${#subjectlist[@]}`; do 

     # binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled[$i]=`fslmeants -i  ${base_dir}/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled_${blklist[b-1]}.nii*`
     # NAcc_resampled[$i]=`fslmeants -i  ${base_dir}/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_NAcc_resampled_${blklist[b-1]}.nii*`
     # NAcc_resampled_left[$i]=`fslmeants -i  ${base_dir}/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_NAcc_resampled_left_${blklist[b-1]}.nii*`
     # NAcc_resampled_right[$i]=`fslmeants -i  ${base_dir}/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_NAcc_resampled_right_${blklist[b-1]}.nii*`
     # activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82[$i]=`fslmeants -i  ${base_dir}/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82_${blklist[b-1]}.nii*`
	 # left_Hb[$i]=`fslmeants -i  ${base_dir}/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_left_Hb_${blklist[b-1]}.nii*`
	 # right_Hb[$i]=`fslmeants -i  ${base_dir}/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_right_Hb_${blklist[b-1]}.nii*`
	 # bilateral_Hb[$i]=`fslmeants -i  ${base_dir}/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_bilateral_Hb_${blklist[b-1]}.nii*`
	  bilateral_VTA[$i]=`fslmeants -i  ${base_dir}/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_atlas-vta_hem-bi_proba-27_resampled_thr01_${blklist[b-1]}.nii*`

  done
   
     # echo ${binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled[@]} >${base_dir}/ROI_analysis/binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${NAcc_resampled[@]} >${base_dir}/ROI_analysis/NAcc_resampled_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${NAcc_resampled_left[@]} >${base_dir}/ROI_analysis/NAcc_resampled_left_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${NAcc_resampled_right[@]} >${base_dir}/ROI_analysis/NAcc_resampled_right_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82[@]} >${base_dir}/ROI_analysis/activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
     # echo ${left_Hb[@]} >${base_dir}/ROI_analysis/left_Hb_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${right_Hb[@]} >${base_dir}/ROI_analysis/right_Hb_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${bilateral_Hb[@]} >${base_dir}/ROI_analysis/bilateral_Hb_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${bilateral_VTA[@]} >${base_dir}/ROI_analysis/bilateral_VTA_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
  done
done