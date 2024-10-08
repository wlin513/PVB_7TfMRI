#! /bin/bash

base_dir=/mnt/f/2023_Peking_DRL

readarray -d ' ' -t subjectlist < ${base_dir}/code/feat_batch/subject_list
echo extracting roi values for participants: ${subjectlist[@]}

PRE=pre_1


glm=GLM1

#second contrast
#ncontrast=2
contrast_names=("feedback_1" "win_amount" "win_mean" "loss_amount" "loss_mean" "win_vs_loss_amount" "win_vs_loss_mean" "feedback3")


declare -a blklist=("BHBL1" "BHBL2" "BHNL" "NHBL" "BHNH1" "BHNH2" "BLNL1" "BLNL2")

for ncontrast in `seq 2 5`; do

  for b in `seq 1 ${#blklist[@]}`;do

    for i in `seq 1 ${#subjectlist[@]}`; do 
	
	 left_Hb[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_left_Hb_15_${blklist[b-1]}.nii*`
	 right_Hb[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_right_Hb_15_${blklist[b-1]}.nii*`
	 bilateral_Hb[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_bilateral_Hb_15_${blklist[b-1]}.nii*`
     # left_Hb[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_left_Hb_${blklist[b-1]}.nii*`
	 # right_Hb[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_right_Hb_${blklist[b-1]}.nii*`
	 # bilateral_Hb[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_bilateral_Hb_${blklist[b-1]}.nii*`
	 # left_Hb_1[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_left_Hb_${blklist[b-1]}_0.1.nii*`
	 # right_Hb_1[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_right_Hb_${blklist[b-1]}_0.1.nii*`
	 # bilateral_Hb_1[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_bilateral_Hb_${blklist[b-1]}_0.1.nii*`
	 # left_Hb_2[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_left_Hb_${blklist[b-1]}_0.2.nii*`
	 # right_Hb_2[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_right_Hb_${blklist[b-1]}_0.2.nii*`
	 # bilateral_Hb_2[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_bilateral_Hb_${blklist[b-1]}_0.2.nii*`
	 # left_Hb_3[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_left_Hb_${blklist[b-1]}_0.3.nii*`
	 # right_Hb_3[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_right_Hb_${blklist[b-1]}_0.3.nii*`
	 # bilateral_Hb_3[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_bilateral_Hb_${blklist[b-1]}_0.3.nii*`
	 # left_Hb_4[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_left_Hb_${blklist[b-1]}_0.4.nii*`
	 # right_Hb_4[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_right_Hb_${blklist[b-1]}_0.4.nii*`
	 # bilateral_Hb_4[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_bilateral_Hb_${blklist[b-1]}_0.4.nii*`
	 # left_Hb_5[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_left_Hb_${blklist[b-1]}_0.5.nii*`
	 # right_Hb_5[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_right_Hb_${blklist[b-1]}_0.5.nii*`
	 # bilateral_Hb_5[$i]=`fslmeants -i  /mnt/h/2023_Peking_DRL/first_level/${glm}_${PRE}/${subjectlist[i-1]}/${blklist[b-1]}.feat/stats/zstat$ncontrast.nii.gz -m ${base_dir}/ROI_analysis/${subjectlist[i-1]}/${subjectlist[i-1]}_bilateral_Hb_${blklist[b-1]}_0.5.nii*`
     done
   
     echo ${left_Hb[@]} >${base_dir}/ROI_analysis/left_Hb_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${right_Hb[@]} >${base_dir}/ROI_analysis/right_Hb_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 echo ${bilateral_Hb[@]} >${base_dir}/ROI_analysis/bilateral_Hb_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${left_Hb_1[@]} >${base_dir}/ROI_analysis/left_Hb_01_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${right_Hb_1[@]} >${base_dir}/ROI_analysis/right_Hb_01_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${bilateral_Hb_1[@]} >${base_dir}/ROI_analysis/bilateral_Hb_01_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${left_Hb_2[@]} >${base_dir}/ROI_analysis/left_Hb_02_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${right_Hb_2[@]} >${base_dir}/ROI_analysis/right_Hb_02_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${bilateral_Hb_2[@]} >${base_dir}/ROI_analysis/bilateral_Hb_02_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${left_Hb_3[@]} >${base_dir}/ROI_analysis/left_Hb_03_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${right_Hb_3[@]} >${base_dir}/ROI_analysis/right_Hb_03_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${bilateral_Hb_3[@]} >${base_dir}/ROI_analysis/bilateral_Hb_03_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${left_Hb_4[@]} >${base_dir}/ROI_analysis/left_Hb_04_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${right_Hb_4[@]} >${base_dir}/ROI_analysis/right_Hb_04_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${bilateral_Hb_4[@]} >${base_dir}/ROI_analysis/bilateral_Hb_04_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${left_Hb_5[@]} >${base_dir}/ROI_analysis/left_Hb_05_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${right_Hb_5[@]} >${base_dir}/ROI_analysis/right_Hb_05_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
	 # echo ${bilateral_Hb_5[@]} >${base_dir}/ROI_analysis/bilateral_Hb_05_${blklist[b-1]}_${contrast_names[ncontrast-1]}.txt
  done
done