#! /bin/bash

base_dir=/mnt/f/2023_Peking_DRL

rm ${base_dir}/code/matlab/pnm/volnums.txt

readarray -t subjectlist < ${base_dir}/code/feat_batch/subject_list
echo get volume num for participants: ${subjectlist[@]}

declare -a blklist=("BHBL1" "BHBL2" "BHNL" "NHBL" "BHNH1" "BHNH2" "BLNL1" "BLNL2")

  for i in `seq 1 ${#subjectlist[@]}`; do 
    volns[0]=${subjectlist[i-1]}
  for j in `seq 0 7` ; do
  epidir="${base_dir}/funcimgs/${subjectlist[i-1]}/${blklist[$j]}/task_func/"
  epi_image=`ls ${epidir}*.nii.gz`

  volns[$[j+1]]=`fslnvols ${epi_image}`
  done
    echo ${volns[@]} >>${base_dir}/code/matlab/pnm/volnums.txt
  done

