%% checking behavior data quality
%online
%b1_bhbl;
%b3_nhnl;
%b5_bhnl;
%b7_nhbl;
%b9_bhnh;
%b11_blnl;
%b13_bihnh;
%b15_bilnl;

for i=1:size(data,2)
    %probabilities of choosing the same shape for each block
    tmp_optionchocies=transpose(reshape(data(i).choice,30,length(data(i).blockN)));
    k=1;
    for j=(data(i).blockN+1)/2
    opt1chocies(i,j,:)=tmp_optionchocies(k,:);
    k=k+1;
    end
    %probabilities of choosing the same side for each block
    tmp_sidechocies=mean(reshape(data(i).chosenside,30,length(data(i).blockN),1));
    k=1;
    for j=(data(i).blockN+1)/2
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
    for j=(data(i).blockN+1)/2
    accuracy(i,j,:)=tmp_accuracies(k,:);
    k=k+1;
    end
       %rt for each block
    tmp_rt=transpose(reshape(data(i).rt,30,length(data(i).blockN)));
    k=1;
    for j=(data(i).blockN+1)/2
    rt(i,j,:)=tmp_rt(k,:);
    k=k+1;
    end
end

optionchocies=squeeze(mean(opt1chocies,3));

f=figure;
bar(mean(optionchocies,1));
err=std(optionchocies)/sqrt(size(data,2));
hold on
er=errorbar(mean(optionchocies,1),err);
er.LineStyle='none';
ylabel('precentages of choosing option A');
%xticks([1:8])
xticklabels({'BHBL','NHNL','BHNL','NHBL','BHNH','BLNL','BiHNH','BiLNL'});
%saveas(f,'perc_ch_optA_beijing_online.png')
beh_results=array2table(optionchocies,'VariableNames',{'BHBL','NHNL','BHNL','NHBL','BHNH','BLNL','BiHNH','BiLNL'});
beh_results.pro_variance_bias=mean(optionchocies(:,5:8),2);