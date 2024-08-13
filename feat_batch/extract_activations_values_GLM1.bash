#! /bin/bash

base_dir=/mnt/f/2023_Peking_DRL

readarray -d ' ' -t subjectlist < ${base_dir}/code/feat_batch/subject_list_n49
echo extracting roi values for participants: ${subjectlist[@]}

PRE=pre_1



#first level contrasts for GLM1
glm=GLM1
declare -a cope_names=("feedback_1" "win_amount" "win_mean" "loss_amount" "loss_mean" "win_vs_loss_amount" "win_vs_loss_mean" "feedback3")

#second contrast
contrast_names=all_mean

for ncontrast in `seq 1 ${#contrast_names[@]}`; do
  for c in `seq 2 4`;do #for c in `seq 1 ${#cope_names[@]}`;do

  for i in `seq 1 ${#subjectlist[@]}`; do 


     activation_loss_amount_n49_cluster3dot1_lmPFC[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_loss_amount_n49_cluster3dot1_lmPFC.nii*`
     activation_loss_amount_n49_cluster3dot1_biNAcc[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_loss_amount_n49_cluster3dot1_biNAcc.nii*`
     activation_loss_amount_n49_cluster3dot1_rAI[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_loss_amount_n49_cluster3dot1_rAI.nii*`
     activation_win_amount_n49_cluster3dot1_biCaudate[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_win_amount_n49_cluster3dot1_biCaudate.nii*`
     activation_win_amount_n49_cluster3dot1_biAI[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_win_amount_n49_cluster3dot1_biAI.nii*`
     activation_win_amount_n49_cluster3dot1_OFC[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_win_amount_n49_cluster3dot1_OFC.nii*`
     activation_win_amount_n49_cluster3dot1_DLPFC[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_win_amount_n49_cluster3dot1_DLPFC.nii*`
     activation_win_amount_n49_cluster3dot1_mPFC[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_win_amount_n49_cluster3dot1_mPFC.nii*`

  done
   
     echo ${activation_loss_amount_n49_cluster3dot1_lmPFC[@]} >${base_dir}/ROI_analysis/activation_loss_amount_n49_cluster3dot1_lmPFC_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_loss_amount_n49_cluster3dot1_biNAcc[@]} >${base_dir}/ROI_analysis/activation_loss_amount_n49_cluster3dot1_biNAcc_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_loss_amount_n49_cluster3dot1_rAI[@]} >${base_dir}/ROI_analysis/activation_loss_amount_n49_cluster3dot1_rAI_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_win_amount_n49_cluster3dot1_biCaudate[@]} >${base_dir}/ROI_analysis/activation_win_amount_n49_cluster3dot1_biCaudate_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_win_amount_n49_cluster3dot1_biAI[@]} >${base_dir}/ROI_analysis/activation_win_amount_n49_cluster3dot1_biAI_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_win_amount_n49_cluster3dot1_OFC[@]} >${base_dir}/ROI_analysis/activation_win_amount_n49_cluster3dot1_OFC_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_win_amount_n49_cluster3dot1_DLPFC[@]} >${base_dir}/ROI_analysis/activation_win_amount_n49_cluster3dot1_DLPFC_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_win_amount_n49_cluster3dot1_mPFC[@]} >${base_dir}/ROI_analysis/activation_win_amount_n49_cluster3dot1_mPFC_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt

  done
done