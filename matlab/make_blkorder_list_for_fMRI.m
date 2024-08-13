%% 
clear all;
clc;
%%

%getfolders;

basedir='F:\2023_Peking_DRL\';
datadir='F:\2023_Peking_DRL\raw_data\';
cd('F:\2023_Peking_DRL\code\matlab');

%% read in behavior and questionnaire data
load([datadir,'beh_data.mat'])
blkslist=[];
for i=1:size(data,2)
       sub_names{i,1}=data(i).subnum;
       blkslist=[blkslist;data(i).blockN];
end

%make or update the block order list file for the fmri analyses
blkslist(:,9)=nan;
T=array2table(blkslist,"RowNames",sub_names);
writetable(T,[basedir,'code\feat_batch\blkorderlist.txt'],'WriteRowNames',true,'Encoding','UTF-8','WriteVariableNames',false,'Delimiter',' ')
writetable(T,[basedir,'code\matlab\pnm\blkorderlist.txt'],'WriteRowNames',true,'Encoding','UTF-8','WriteVariableNames',false,'Delimiter',' ')