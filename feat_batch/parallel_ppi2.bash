#! /bin/bash

cat /mnt/f/2023_Peking_DRL/code/feat_batch/subject_list_final.txt | xargs -n 1 -P 2  /mnt/f/2023_Peking_DRL/code/feat_batch/PPI_second_levels_batch.bash

