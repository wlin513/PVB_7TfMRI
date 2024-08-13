#! /bin/bash
subject=`echo $1`
echo ${subject}

PRE=pre_1
glm=GLM4

base_dir=/mnt/h/2023_Peking_DRL

declare -a blklist=("BHNH1" "BHNH2" "BLNL1" "BLNL2")

for i in `seq 0 3` ; do
    mkdir -p ${base_dir}/RSA_analysis/${glm}_${PRE}/${subject}/${blklist[$i]}
	
	applywarp --ref=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/highres.nii.gz --in=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/stats/cope1.nii.gz --out=${base_dir}/RSA_analysis/${glm}_${PRE}/${subject}/${blklist[$i]}/cope1_2highres.nii.gz --warp=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/example_func2highres_warp.nii.gz
	
	applywarp --ref=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/highres.nii.gz --in=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/stats/cope2.nii.gz --out=${base_dir}/RSA_analysis/${glm}_${PRE}/${subject}/${blklist[$i]}/cope2_2highres.nii.gz --warp=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/example_func2highres_warp.nii.gz
	
	applywarp --ref=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/highres.nii.gz --in=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/stats/cope5.nii.gz --out=${base_dir}/RSA_analysis/${glm}_${PRE}/${subject}/${blklist[$i]}/cope5_2highres.nii.gz --warp=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/example_func2highres_warp.nii.gz
	
	applywarp --ref=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/highres.nii.gz --in=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/stats/cope6.nii.gz --out=${base_dir}/RSA_analysis/${glm}_${PRE}/${subject}/${blklist[$i]}/cope6_2highres.nii.gz --warp=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/example_func2highres_warp.nii.gz
	
	applywarp --ref=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/highres.nii.gz --in=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/stats/res4d.nii.gz --out=${base_dir}/RSA_analysis/${glm}_${PRE}/${subject}/${blklist[$i]}/res4d_2highres.nii.gz --warp=${base_dir}/first_level/${glm}_${PRE}/${subject}/${blklist[$i]}.feat/reg/example_func2highres_warp.nii.gz
done