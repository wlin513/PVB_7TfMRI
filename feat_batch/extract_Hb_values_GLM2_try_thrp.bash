#! /bin/bash

base_dir=/mnt/f/2023_Peking_DRL

readarray -d ' ' -t subjectlist < ${base_dir}/code/feat_batch/subject_list
echo extracting roi values for participants: ${subjectlist[@]}

PRE=pre_2



#first level contrasts for GLM1
#glm=GLM1
#declare -a cope_names=("feedback_1" "win_amount" "win_mean" "loss_amount" "loss_mean" "win_vs_loss_amount" "win_vs_loss_mean" "feedback3")

#=GLM1_1
#declare -a cope_names=("feedback_1" "win_amount" "win_mean" "loss_amount" "loss_mean" "win_vs_loss_amount" "win_vs_loss_mean" "feedback2")
glm=GLM2
declare -a cope_names=("chosen_PPE" "mean_chosen_PPE" "chosen_NPE" "mean_chosen_NPE")

#second contrast
#ncontrast=2
contrast_names=("all_mean" "diff_mean" "equal_mean")
#contrast_names=all_mean
thrp=70

for ncontrast in `seq 1 ${#contrast_names[@]}`; do
  for c in `seq 1 4`;do #for c in `seq 1 ${#cope_names[@]}`;do

  for i in `seq 1 ${#subjectlist[@]}`; do 
  
   fslmaths ${base_dir}/ROI_analysis/${subjectlist[i-1]}/left_Hb_mni.nii -thrp ${thrp} ${base_dir}/ROI_analysis/${subjectlist[i-1]}/left_Hb_mni_${thrp}.nii
   fslmaths ${base_dir}/ROI_analysis/${subjectlist[i-1]}/right_Hb_mni.nii -thrp ${thrp} ${base_dir}/ROI_analysis/${subjectlist[i-1]}/right_Hb_mni_${thrp}.nii
   fslmaths ${base_dir}/ROI_analysis/${subjectlist[i-1]}/bilateral_Hb_mni.nii -thrp ${thrp} ${base_dir}/ROI_analysis/${subjectlist[i-1]}/bilateral_Hb_mni_${thrp}.nii
   lefthb[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/left_Hb_mni_${thrp}.nii*` 
   righthb[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/right_Hb_mni_${thrp}.nii*` 
   bilateralhb[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/bilateral_Hb_mni_${thrp}.nii*`
  
   # left_accumbens[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/harvardoxford-subcortical_prob_Left_Accumbens.nii*`
   # right_accumbens[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/harvardoxford-subcortical_prob_Right_Accumbens.nii*`
   # bilateral_accumbens[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/harvardoxford-subcortical_prob_Bilateral_Accumbens.nii*`
   # nacc[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/NAcc_resampled.nii*`
   # VS[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/VS_resampled.nii*`
   # left_AI[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/AI_L_sphere_resampled.nii*`
   # right_AI[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/AI_R_sphere_resampled.nii*`
   # bilateral_AI[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/AI_Bi_sphere_resampled.nii*`
   # left_Hb_10[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/left_Hb_10.nii*`
   # right_Hb_10[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/right_Hb_10.nii*`
   # bilateral_Hb_10[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/bilateral_Hb_10.nii*`
   # left_Hb_15[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/left_Hb_15.nii*`
   # right_Hb_15[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/right_Hb_15.nii*`
   # bilateral_Hb_15[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/bilateral_Hb_15.nii*`
   
   # bilateral_VTA[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/CIT168toMNI152_prob_atlas_bilat_1mm__VTA_resampled.nii*`
   # bilateral_SNr[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/CIT168toMNI152_prob_atlas_bilat_1mm__SNr_resampled.nii*`
   # bilateral_HN[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/CIT168toMNI152_prob_atlas_bilat_1mm__HN_resampled.nii*`
   # left_VTA[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/atlas-vta_hem-l_proba-27_resampled_thr01.nii*`
   # right_VTA[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/atlas-vta_hem-r_proba-27_resampled_thr01.nii*`
   
   # left_amyg[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/MNI152_left_amygdala_resampled.nii*`
   # right_amyg[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/MNI152_right_amygdala_resampled.nii*`
   
   
   # activation_right_insula[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/GLM2_pre_1_chosen_NPE_activation_right_insula_mask.nii*`
   # activation_left_VS[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/GLM2_pre_1_chosen_PPE_activation_left_VS_mask.nii*`
   # activation_left_VS_pre2[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/GLM2_pre_2_chosen_PPE_activation_left_VS_mask.nii*`
   # activation_right_VS[$i]=`fslmeants -i  ${base_dir}/second_level/${glm}_${PRE}/${subjectlist[i-1]}.gfeat/cope$c.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROIs/GLM2_pre_1_chosen_PPE_activation_right_VS_mask.nii*`
   
  done
   echo ${lefthb[@]} >${base_dir}/ROI_analysis/left_Hb_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   echo ${righthb[@]} >${base_dir}/ROI_analysis/right_Hb_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   echo ${bilateralhb[@]} >${base_dir}/ROI_analysis/bilateral_Hb_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   
   # echo ${left_accumbens[@]} >${base_dir}/ROI_analysis/left_accumbens_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${right_accumbens[@]} >${base_dir}/ROI_analysis/right_accumbens_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${bilateral_accumbens[@]} >${base_dir}/ROI_analysis/bilateral_accumbens_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt

   # echo ${nacc[@]} >${base_dir}/ROI_analysis/NAcc_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${VS[@]} >${base_dir}/ROI_analysis/VS_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${left_AI[@]} >${base_dir}/ROI_analysis/left_AI_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${right_AI[@]} >${base_dir}/ROI_analysis/right_AI_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${bilateral_AI[@]} >${base_dir}/ROI_analysis/bilateral_AI_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${left_Hb_10[@]} >${base_dir}/ROI_analysis/left_Hb_10_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${right_Hb_10[@]} >${base_dir}/ROI_analysis/right_Hb_10_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${bilateral_Hb_10[@]} >${base_dir}/ROI_analysis/bilateral_Hb_10_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${left_Hb_15[@]} >${base_dir}/ROI_analysis/left_Hb_15_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${right_Hb_15[@]} >${base_dir}/ROI_analysis/right_Hb_15_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${bilateral_Hb_15[@]} >${base_dir}/ROI_analysis/bilateral_Hb_15_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${left_VTA[@]} >${base_dir}/ROI_analysis/left_VTA_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${right_VTA[@]} >${base_dir}/ROI_analysis/right_VTA_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${bilateral_VTA[@]} >${base_dir}/ROI_analysis/bilateral_VTA_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${bilateral_SNr[@]} >${base_dir}/ROI_analysis/bilateral_SNr_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${bilateral_HN[@]} >${base_dir}/ROI_analysis/bilateral_HN_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${left_amyg[@]} >${base_dir}/ROI_analysis/left_amyg_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${right_amyg[@]} >${base_dir}/ROI_analysis/right_amyg_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   
   # echo ${activation_right_insula[@]} >${base_dir}/ROI_analysis/activation_right_insula_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${activation_left_VS[@]} >${base_dir}/ROI_analysis/activation_left_VS_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${activation_right_VS[@]} >${base_dir}/ROI_analysis/activation_right_VS_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
   # echo ${activation_left_VS_pre2[@]} >${base_dir}/ROI_analysis/activation_left_VS_pre2_${cope_names[c-1]}_${contrast_names[ncontrast-1]}.txt
  done
done