#! /bin/bash


PRE=pre_2
glm=GLM2
ques=tSTAI
seedname=bilateral_Hb_15
contrast=chosen_PPE

base_dir=/mnt/f/2023_Peking_DRL
desdir="${base_dir}/design_files/group_level/"
tmpdir="${base_dir}/design_files/group_level/PPIs/${ques}/${glm}_${PRE}_${seedname}"
mkdir -p ${tmpdir}
designfile="${desdir}/PPI_${ques}.fsf"

sed    -e s@glm@${glm}@g \
       -e s@PRE@${PRE}@g \
       -e s@ques@${ques}@g \
       -e s@contrast@${contrast}@g \
	   -e s@seedname@${seedname}@g \
	<${designfile} >${tmpdir}/${contrast}.fsf

feat ${tmpdir}/${contrast}.fsf

