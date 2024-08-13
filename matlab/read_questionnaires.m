%read questionnaire excel file
%datadir='F:\2023_Peking_DRL\raw_data\';
quesfile=dir([datadir,'*问卷.xlsx']);

qfile=[quesfile.folder,'\',quesfile.name];
rawques=readtable(qfile);


RRS_symp_idx=[1,2,3,4,6,8,9,14,17,18,19,22];
RRS_brooding_idx=[5,10,13,15,16];
RRS_reflec_idx=[7,11,12,20,21];

a=1:40;
das_d1_idx=[3,8,15,17,18];
das_d2_idx=[16,31,32,39,40];
das_d3_idx=[1,11,14,20,23];
das_d4_idx=[5,13,25,30,36];
das_d5_idx=[19,27,33,34,35];
das_d6_idx=[7,24,26,28,38];
das_d7_idx=[4,9,10,21,22];
das_d8_idx=[2,6,12,29,37];

ss=find(strcmp(table2cell(rawques(1,:)),'dRL项目前筛(0)'))+1;%anchor to the start of the questionnaire section
for i=1:size(data,2)
    sn=find(rawques.Sub==str2double(regexp(data(i).subnum,'\d+','match')));
    ques(i).subname=data(i).subnum;
ques(i).subn=rawques.Sub(sn);
%RRS
tmp=table2array(rawques(sn,ss:ss+21));
if length(unique(tmp))==1
    ques_include.RRS(i,1)=0;
else
    ques_include.RRS(i,1)=1;
end    

ques(i).RRS=sum(table2array(rawques(sn,ss:ss+21)));
ques(i).RRS_symp=sum(table2array(rawques(sn,RRS_symp_idx+ss-1)));
ques(i).RRS_brooding=sum(table2array(rawques(sn,RRS_brooding_idx+ss-1)));
ques(i).RRS_reflec=sum(table2array(rawques(sn,RRS_reflec_idx+ss-1)));

%STAI
  
ques(i).tSTAI=sum(table2array(rawques(sn,ss+22:ss+41)));
ques(i).sSTAI=sum(table2array(rawques(sn,ss+42:ss+61)));
ques(i).STAI=ques(i).tSTAI+ques(i).sSTAI;

%SDS
ques(i).SDS_raw=sum(table2array(rawques(sn,ss+62:ss+81)));
ques(i).SDS=ques(i).SDS_raw*1.25;

%IUS
ques(i).IUS=sum(table2array(rawques(sn,ss+82:ss+93)));

%DAS
 
ques(i).DAS=sum(table2array(rawques(sn,ss+94:ss+133)));



ques(i).gender=strcmp(rawques.Info_Q9{sn},'性别女，认同女')+1;%1 for male 2 for female
if strcmp(rawques.Info_Q9{sn},'性别女，认同男')|| strcmp(rawques.Info_Q9{sn},'性别男，认同女')
    display(['check gender: sub',num2str(rawques.Sub(sn))])
    ques(i).gender=strcmp(rawques.Info_Q9{sn},'性别女，认同男')+1;%bio sex
end
%data(i).ques_place=rawques.Info_Q2{i};
ques(i).ques_edu=rawques.Info_Q5{sn};
%subinfo(i).lefthanded=strcmp(rawques.Info_Q7{i},'是');
%subinfo(i).phonenumber=num2str(rawques.Info_Q10(i));
%subinfo(i).completed_online_time=rawques.Time(i);

%ques.subinfo(i).SDS=ques.SDS.total(i,1);
%ques.subinfo(i).data_performance=mean(accuracies(i,1:4),2);
%ques.subinfo(i).data_performance_easiest=accuracies(i,2);
end


% %% plot correlation matrix
% queslist=[ques.SDS.total,ques.DAS.total,ques.RRS.total,ques.IUS.total,ques.STAI.total];
% varnames={'SDS','DAS','RRS','IUS','STAI'};
% corrplot(queslist,'varNames',varnames)
 
%%
ques_table=struct2table(ques);
figure;histogram(ques_table.RRS)
title('RRS(22-88)')
figure;histogram(ques_table.tSTAI)
title('tSTAI(20-80)')
figure;histogram(ques_table.sSTAI)
title('sSTAI(20-80)')
figure;histogram(ques_table.SDS)
title('SDS(25-100)')
figure;histogram(ques_table.IUS)
title('IUS(27-135)')
figure;histogram(ques_table.DAS)
title('DAS')