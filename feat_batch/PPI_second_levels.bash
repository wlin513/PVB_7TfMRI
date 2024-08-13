#! /bin/bash


echo 'Enter Subject Number'
read subject

PRE=pre_1
glm=GLM2
seedname=atlas-vta_hem-bi_proba-27_resampled_thr01
contrast=chosen_PPE


base_dir=/mnt/f/2023_Peking_DRL
firstleveldir=/mnt/e/2023_Peking_DRL
secondleveldir=/mnt/e/2023_Peking_DRL

desdir="${base_dir}/design_files/second_level"
tmpdir="${base_dir}/design_files/second_level/PPI_${glm}_${seedname}_${PRE}"

mkdir -p ${tmpdir}
designfile="${desdir}/PPI.fsf"

sed    -e s@subject@${subject}@g	\
       -e s@PRE@${PRE}@g \
	   -e s@glm@${glm}@g \
	   -e s@seedname@${seedname}@g \
	   -e s@contrast@${contrast}@g \
	   -e s@firstleveldir@${firstleveldir}@g \
	   -e s@secondleveldir@${secondleveldir}@g \
	<${designfile} >${tmpdir}/${subject}.fsf

feat ${tmpdir}/${subject}.fsf
