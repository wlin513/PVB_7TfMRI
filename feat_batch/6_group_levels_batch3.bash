#! /bin/bash


ques='tSTAI'
PRE=pre_1
glm=GLM1
declare -a contrastlist=("win_amount" "win_mean" "loss_amount" "loss_mean")
declare -a copenums=("2" "3" "4" "5")

base_dir=/media/sf_2023_Peking_DRL
desdir="${base_dir}/design_files/group_level/"
tmpdir="${base_dir}/design_files/group_level/${ques}/${glm}_${PRE}"
mkdir -p ${tmpdir}
designfile="${desdir}/${ques}.fsf"

for i in `seq 0 3` ; do
#i=3
echo ${contrastlist[$i]}
copen=cope${copenums[$i]}

sed    -e s@glm@${glm}@g \
       -e s@PRE@${PRE}@g \
       -e s@ques@${ques}@g \
       -e s@contrastname@${contrastlist[$i]}@g \
       -e s@copen@${copen}@g \
	<${designfile} >${tmpdir}/${contrastlist[$i]}.fsf

feat ${tmpdir}/${contrastlist[$i]}.fsf
done
