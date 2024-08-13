#! /bin/bash


subject=`echo $1`
echo ${subject}

PRE=pre_1
glm=GLM2

seedname=left_Hb_15
contrastname=chosen_NPE
base_dir=/mnt/f/2023_Peking_DRL

declare -a blklist=("BHBL1" "BHBL2" "BHNL" "NHBL" "BHNH1" "BHNH2" "BLNL1" "BLNL2")

mkdir -p ${base_dir}/design_files/first_level/${glm}_${PRE}/${subject}
desdir="${base_dir}/design_files/PPIs/${seedname}/GLM2/${contrastname}"
tmpdir="${base_dir}/design_files/PPIs/${seedname}/GLM2/${contrastname}/${subject}"
mkdir -p ${tmpdir}

designfile="${desdir}/design.fsf"
mkdir -p ${base_dir}/first_level/PPI_${seedname}_${glm}_${contrastname}_${PRE}/${subject}


for i in `seq 2 7` ; do

cp -r /mnt/e/2023_Peking_DRL/preprocessing/${PRE}/${subject}/${blklist[$i]}.feat ${base_dir}/first_level/PPI_${seedname}_${glm}_${contrastname}_${PRE}/${subject}

epidir="${base_dir}/funcimgs/${subject}/${blklist[$i]}/task_func/"
refdir="${base_dir}/funcimgs/${subject}/${blklist[$i]}/highres_func/"

epi_image=`ls ${epidir}*.nii.gz`
ref_image=`ls ${refdir}*.nii.gz`


nvols=`fslnvols ${epi_image}`
tot_vox_num=`fslstats ${epi_image} -v | awk '{print $1}'`

tmp=`estnoise ${epi_image} 0.8511 32.73 -1`
index=0
for a in $tmp;do 
  out[index]=$a; 
  index+=1;
done
noiselevel=${out[0]}
tempsmooth=${out[1]}

sed -e s@subject@${subject}@g	\
	-e s@nvols@${nvols}@	\
	-e s@totvoxnum@${tot_vox_num}@ \
       -e s@noiselevel@${noiselevel}@	\
       -e s@tempsmooth@${tempsmooth}@	\
	-e s@blockname@${blklist[$i]}@g \
	-e s@ref_image@${ref_image}@g \
       -e s@glm@${glm}@g \
       -e s@PRE@${PRE}@g \
	   -e s@seedname@${seedname}@g \
	   -e s@contrastname@${contrastname}@g \
	<${designfile} >${tmpdir}/${blklist[$i]}.fsf

feat ${tmpdir}/${blklist[$i]}.fsf

done