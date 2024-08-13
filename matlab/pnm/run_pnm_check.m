clear all
clc
pnmdir='/media/sf_2023_Peking_DRL/physio/';
sublist=dir([pnmdir,'sub*']);
blklist={'BHBL1','BHBL2','BHNL','NHBL','BHNH1','BHNH2','BLNL1','BLNL2'};%
%% experiment and physio data information
%for i=1:size(sublist,1)
    i=57;
    display(sublist(i).name)
    for b=1:8        
        check_pnm(pnmdir,sublist(i).name,blklist{b});
        uiwait;
    end
%end