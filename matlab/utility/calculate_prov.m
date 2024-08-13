function [optionchocies,sub_include]=calculate_prov(data,ntrials)
    for i=1:size(data,2)
        %probabilities of choosing the same shape for each block
        tmp_optionchocies=transpose(reshape(data(i).choice,ntrials,length(data(i).blockN)));
        k=1;
        for j=data(i).blockN
        opt1chocies(i,j,:)=tmp_optionchocies(k,:);
        k=k+1;
        end
        %probabilities of choosing the same side for each block
        tmp_sidechocies=mean(reshape(data(i).chosenside,ntrials,length(data(i).blockN),1));
        k=1;
        for j=data(i).blockN
        sidechocies(i,j)=tmp_sidechocies(k);
        k=k+1;
        end
        %accuracies for each block
        tmp_optionchocies=transpose(reshape(data(i).choice,ntrials,length(data(i).blockN)));
        tmp_correctopt=2-transpose(reshape(data(i).correctopt,ntrials,length(data(i).blockN)));
        tmp_accuracies=tmp_correctopt==tmp_optionchocies;
        tmp_accuracies=double(tmp_accuracies);
        tmp_accuracies(tmp_correctopt==-1)=0.5;
        k=1;
        for j=data(i).blockN
        accuracy(i,j,:)=tmp_accuracies(k,:);
        k=k+1;
        end
        %rt for each block
        tmp_rt=transpose(reshape(data(i).rt,ntrials,length(data(i).blockN)));
        k=1;
        for j=data(i).blockN
        rt(i,j,:)=tmp_rt(k,:);
        k=k+1;
        end
    end

    optionchocies=squeeze(mean(opt1chocies,3));
    tmp=(optionchocies==1|optionchocies==0);
    option_include=sum(tmp(:,5:8),2)==0;
    accuracies=mean(accuracy,3);
    accuracy_include=mean(accuracies(:,1:4),2)>0.6;
    sub_include=option_include&accuracy_include;
end
