#! /bin/bash

cat /mnt/f/2023_Peking_DRL/code/feat_batch/subject_list2 | xargs -n 1 -P 4  /mnt/f/2023_Peking_DRL/code/feat_batch/5_second_levels_batch
