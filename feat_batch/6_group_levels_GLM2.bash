#! /bin/bash


ques='pro_v'
PRE=pre_2
glm=GLM2
declare -a contrastlist=("chosen_PPE" "chosen_NPE" "unchosen_PPE" "unchosen_NPE")
declare -a copenums=("1" "3" "5" "7")

base_dir=/media/sf_2023_Peking_DRL
desdir="${base_dir}/design_files/group_level/"
tmpdir="${base_dir}/design_files/group_level/${ques}/${glm}_${PRE}"
mkdir -p ${tmpdir}
designfile="${desdir}/${ques}.fsf"

#for i in `seq 0 3` ; do
i=3
echo ${contrastlist[$i]}
copen=cope${copenums[$i]}

sed    -e s@glm@${glm}@g \
       -e s@PRE@${PRE}@g \
       -e s@ques@${ques}@g \
       -e s@contrastname@${contrastlist[$i]}@g \
       -e s@copen@${copen}@g \
	<${designfile} >${tmpdir}/${contrastlist[$i]}.fsf

feat ${tmpdir}/${contrastlist[$i]}.fsf
#done
