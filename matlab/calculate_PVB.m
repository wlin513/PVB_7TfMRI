%% checking behavior data quality
%fMRI block lists
%b1_bhbl;
%b2_bhbl;
%b3_bhnl;
%b4_nhbl;
%b5_bhnh;
%b6_bhnh;
%b7_blnl;
%b8_blnl;
for i=1:size(data,2)
    %probabilities of choosing the same shape for each block
    tmp_optionchocies=transpose(reshape(data(i).choice,30,length(data(i).blockN)));
    k=1;
    for j=data(i).blockN
    opt1chocies(i,j,:)=tmp_optionchocies(k,:);
    k=k+1;
    end
    %probabilities of choosing the same side for each block
    tmp_sidechocies=mean(reshape(data(i).chosenside,30,length(data(i).blockN),1));
    k=1;
    for j=data(i).blockN
    sidechocies(i,j)=tmp_sidechocies(k);
    k=k+1;
    end
    %accuracies for each block
    tmp_optionchocies=transpose(reshape(data(i).choice,30,length(data(i).blockN)));
    tmp_correctopt=2-transpose(reshape(data(i).correctopt,30,length(data(i).blockN)));
    tmp_accuracies=tmp_correctopt==tmp_optionchocies;
    tmp_accuracies=double(tmp_accuracies);
    tmp_accuracies(tmp_correctopt==-1)=0.5;
    k=1;
    for j=data(i).blockN
    accuracy(i,j,:)=tmp_accuracies(k,:);
    k=k+1;
    end
    %rt for each block
    tmp_rt=transpose(reshape(data(i).rt,30,length(data(i).blockN)));
    k=1;
    for j=data(i).blockN
    rt(i,j,:)=tmp_rt(k,:);
    k=k+1;
    end
end
%calculating win stay and loss switch probilities and over-all switch
%probabilities
tmp1=accuracy(:,:,1:29);
tmpc2=opt1chocies(:,:,2:30);
tmpc1=opt1chocies(:,:,1:29);
tmp_ws=tmp1==1&tmpc2==tmpc1;
tmp_ls=tmp1==0&tmpc2~=tmpc1;
winstayprob=sum(tmp_ws,3)./sum(accuracy,3);
lossswitchprob=sum(tmp_ls,3)./sum(~accuracy,3);
wsls=winstayprob-lossswitchprob;
switchprobs=tmpc2~=tmpc1;
switchprobabilities=mean(switchprobs,2);
%
optionchocies=squeeze(mean(opt1chocies,3));
beh_results=array2table(optionchocies,'VariableNames',{'BHBL1','BHBL2','BHNL','NHBL','BHNH1','BHNH2','BLNL1','BLNL2'});
beh_results.pro_variance_bias=mean(optionchocies(:,5:8),2);
beh_results.BLNL=(beh_results.BLNL1+beh_results.BLNL2)/2;
beh_results.BHNH=(beh_results.BHNH1+beh_results.BHNH2)/2;
beh_results.BHBL=(beh_results.BHBL1+beh_results.BHBL2)/2;
