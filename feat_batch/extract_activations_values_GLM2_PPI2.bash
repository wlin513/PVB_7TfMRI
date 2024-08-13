#! /bin/bash

base_dir=/mnt/e/2023_Peking_DRL

readarray -d ' ' -t subjectlist < ${base_dir}/code/feat_batch/subject_list
echo extracting roi values for participants: ${subjectlist[@]}

PRE=pre_1

glm=GLM2
cope_name=chosen_PPE

seedname=atlas-vta_hem-bi_proba-27_resampled_thr01
#second contrast
#ncontrast=2
#contrast_names=("all_mean" "diff_mean" "equal_mean")
contrast_names=all_mean

for ncontrast in `seq 1 ${#contrast_names[@]}`; do

    for i in `seq 1 ${#subjectlist[@]}`; do 


      binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m   ${base_dir}/ROIs/binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled.nii*`
      NAcc_resampled[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/NAcc_resampled.nii*`
      NAcc_resampled_left[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/NAcc_resampled_left.nii*`
      NAcc_resampled_right[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/NAcc_resampled_right.nii*`
      activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82.nii*`
     bilateral_Hb_15[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/bilateral_Hb_15.nii*`
	 left_Hb_15[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/left_Hb_15.nii*`
	 right_Hb_15[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/right_Hb_15.nii*`
	 left_amyg[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/MNI152_left_amygdala_resampled.nii*`
	 right_amyg[$i]=`fslmeants -i  ${base_dir}/second_level/PPI_${glm}_${cope_name}_${seedname}_${PRE}/${subjectlist[i-1]}.gfeat/cope1.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/MNI152_right_amygdala_resampled.nii*`
	 bilateral_VTA[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/atlas-vta_hem-bi_proba-27_resampled_thr01.nii*`
	 left_VTA[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/atlas-vta_hem-l_proba-27_resampled_thr01.nii*`
	 right_VTA[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/atlas-vta_hem-r_proba-27_resampled_thr01.nii*`
  done
   
     echo ${binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled[@]} >${base_dir}/ROI_analysis/binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${NAcc_resampled[@]} >${base_dir}/ROI_analysis/NAcc_resampled_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${NAcc_resampled_left[@]} >${base_dir}/ROI_analysis/NAcc_resampled_left_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${NAcc_resampled_right[@]} >${base_dir}/ROI_analysis/NAcc_resampled_right_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82[@]} >${base_dir}/ROI_analysis/activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${bilateral_Hb_15[@]} >${base_dir}/ROI_analysis/bilateral_Hb_15_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
     echo ${left_Hb_15[@]} >${base_dir}/ROI_analysis/left_Hb_15_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${right_Hb_15[@]} >${base_dir}/ROI_analysis/right_Hb_15_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${left_amyg[@]} >${base_dir}/ROI_analysis/left_amyg_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${right_amyg[@]} >${base_dir}/ROI_analysis/right_amyg_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${bilateral_VTA[@]} >${base_dir}/ROI_analysis/bilateral_VTA_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
     echo ${left_VTA[@]} >${base_dir}/ROI_analysis/left_VTA_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 echo ${right_VTA[@]} >${base_dir}/ROI_analysis/right_VTA_PPI_${glm}_${cope_name}_${seedname}_${PRE}_${contrast_names[ncontrast-1]}.txt
	 

done