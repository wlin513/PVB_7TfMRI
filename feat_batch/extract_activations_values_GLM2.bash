#! /bin/bash

base_dir=/mnt/f/2023_Peking_DRL

readarray -d ' ' -t subjectlist < ${base_dir}/code/feat_batch/subject_list
echo extracting roi values for participants: ${subjectlist[@]}

PRE=pre_1



#first level contrasts for GLM1
#glm=GLM1
#declare -a cope_names=("feedback_1" "win_amount" "win_mean" "loss_amount" "loss_mean" "win_vs_loss_amount" "win_vs_loss_mean" "feedback3")

#=GLM1_1
#declare -a cope_names=("feedback_1" "win_amount" "win_mean" "loss_amount" "loss_mean" "win_vs_loss_amount" "win_vs_loss_mean" "feedback2")
glm=GLM2
declare -a cope_names=("chosen_PPE" "mean_chosen_PPE" "chosen_NPE" "mean_chosen_NPE")

#second contrast
#ncontrast=2
#contrast_names=("all_mean" "diff_mean" "equal_mean")
contrast_names=all_mean

for ncontrast in `seq 1 ${#contrast_names[@]}`; do
  for c in `seq 1 4`;do #for c in `seq 1 ${#cope_names[@]}`;do

  for i in `seq 1 ${#subjectlist[@]}`; do 


     activation_NPE_zscoreAD_n49_cluster2dot8_mPFC[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_NPE_zscoreAD_n49_cluster2dot8_mPFC.nii*`
     activation_NPE_zscoreAD_n49_SVC_cluster2dot5_NAcc[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_NPE_zscoreAD_n49_SVC_cluster2dot5_NAcc.nii*`
     activation_NPE_pro_v_n49_SVC_cluster2dot5_NAcc[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_NPE_pro_v_n49_SVC_cluster2dot5_NAcc.nii*`
     activation_NPE_pro_v_n49_cluster2dot3_mPFC[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_NPE_pro_v_n49_cluster2dot3_mPFC.nii*`
     activation_PPE_pro_v_n49_cluster2dot3_NAccANDputamen[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_PPE_pro_v_n49_cluster2dot3_NAccANDputamen.nii*`
     activation_PPE_pro_v_n49_cluster2dot3_mPFC[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_PPE_pro_v_n49_cluster2dot3_mPFC.nii*`
     bilateral_VTA[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/atlas-vta_hem-bi_proba-27_resampled_thr01.nii*`
     activation_NPE_n49_cluster3dot1_lamyg[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_NPE_n49_cluster3dot1_lamyg.nii*`
     activation_NPE_n49_cluster3dot1_lNAcc[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_NPE_n49_cluster3dot1_lNAcc.nii*`
     activation_NPE_n49_cluster3dot1_mPFC[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_NPE_n49_cluster3dot1_mPFC.nii*`
     activation_NPE_n49_cluster3dot1_rAI[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_NPE_n49_cluster3dot1_rAI.nii*`
     activation_PPE_n49_cluster3dot1_bi_NAcc[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/activation_PPE_n49_cluster3dot1_bi_NAcc.nii*`

  done
   
     echo ${activation_NPE_zscoreAD_n49_cluster2dot8_mPFC[@]} >${base_dir}/ROI_analysis/activation_NPE_zscoreAD_n49_cluster2dot8_mPFC_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_NPE_zscoreAD_n49_SVC_cluster2dot5_NAcc[@]} >${base_dir}/ROI_analysis/activation_NPE_zscoreAD_n49_SVC_cluster2dot5_NAcc_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_NPE_pro_v_n49_SVC_cluster2dot5_NAcc[@]} >${base_dir}/ROI_analysis/activation_NPE_pro_v_n49_SVC_cluster2dot5_NAcc_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_NPE_pro_v_n49_cluster2dot3_mPFC[@]} >${base_dir}/ROI_analysis/activation_NPE_pro_v_n49_cluster2dot3_mPFC_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_PPE_pro_v_n49_cluster2dot3_NAccANDputamen[@]} >${base_dir}/ROI_analysis/activation_PPE_pro_v_n49_cluster2dot3_NAccANDputamen_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_PPE_pro_v_n49_cluster2dot3_mPFC[@]} >${base_dir}/ROI_analysis/activation_PPE_pro_v_n49_cluster2dot3_mPFC_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${bilateral_VTA[@]} >${base_dir}/ROI_analysis/bilateral_VTA_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_NPE_n49_cluster3dot1_lamyg[@]} >${base_dir}/ROI_analysis/activation_NPE_n49_cluster3dot1_lamyg_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_NPE_n49_cluster3dot1_lNAcc[@]} >${base_dir}/ROI_analysis/activation_NPE_n49_cluster3dot1_lNAcc_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_NPE_n49_cluster3dot1_mPFC[@]} >${base_dir}/ROI_analysis/activation_NPE_n49_cluster3dot1_mPFC_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_NPE_n49_cluster3dot1_rAI[@]} >${base_dir}/ROI_analysis/activation_NPE_n49_cluster3dot1_rAI_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${activation_PPE_n49_cluster3dot1_bi_NAcc[@]} >${base_dir}/ROI_analysis/activation_PPE_n49_cluster3dot1_bi_NAcc_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt

  done
done