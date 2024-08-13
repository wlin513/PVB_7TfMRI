%% 
clear all; 
clc;
%%

basedir='/media/wlin/Data2/wlin/2021_DRL_fMRI/';
datadir='/media/wlin/Data1/wlin/2021_DRL_fMRI/raw_data';
cd([basedir,'code/matlab']);
load([datadir,'/fmri_beh_data.mat'])

fmri_IDs=importdata([basedir,'code/feat_batch/subject_list_group_level']);
%%
for ss=1:size(fmri_IDs,1)
    idx(ss)=find(strcmp(ques_fmri.subnum,fmri_IDs{ss}));
end

RRS_fmri=[ones(size(fmri_IDs)),ques_fmri.RRS_total(idx)-mean(ques_fmri.RRS_total(idx))];
STAI_fmri=[ones(size(fmri_IDs)),ques_fmri.STAI_total(idx)];