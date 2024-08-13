#! /bin/bash

cat /mnt/f/2023_Peking_DRL/code/feat_batch/subject_list_physio.txt | xargs -n 1 -P 1  /mnt/f/2023_Peking_DRL/code/feat_batch/rewrite_pnm_evlist.bash

