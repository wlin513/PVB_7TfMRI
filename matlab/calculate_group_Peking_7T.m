clear all
close all
clc
%% set the paths
parentdir='F:\2023_Peking_DRL';
addpath(genpath([parentdir,'\code\matlab\models\']))
addpath(genpath([parentdir,'\code\matlab\utility\']))
figdir=[parentdir,'\tmp_figures\'];
%addpath(genpath('functions\'))
datadir='D:\2023_Peking_DRL_data_backup\raw_data\';
sublistfile=dir([datadir,'\s*']);
%% read in behavior and questionnaire data
n=0;
for i=1:size(sublistfile,1)
    i
    k=dir([datadir,sublistfile(i).name,'\Behaviour\*csv']);
    if ~isempty(k)
        n=n+1;
    data(n)=read_csv_Peking_7T(datadir,sublistfile(i).name);
    end
end

%%
read_questionnaires
check_beh_data_quality_Peking_7T
accuracy_include(2)=0;%exclude the first three participants whose T1 images used different settings than the rest of participants
%save([datadir,'beh_data.mat'],'data','option_include','accuracy_include')
%%
f=figure;set(gcf,'Position',[300 300 300 250]);plotcorr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques_table.RRS(option_include&accuracy_include),1,1,'pro-variance bias','RRS');saveas(f,[figdir,'RRS_pro_v.png'])
f=figure;set(gcf,'Position',[300 300 300 250]);plotcorr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques_table.SDS(option_include&accuracy_include),1,1,'pro-variance bias','SDS');saveas(f,[figdir,'SDS_pro_v.png'])
figure;plotcorr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques_table.tSTAI(option_include&accuracy_include),1,1,'pro-variance bias','trait anxiety')
f=figure;set(gcf,'Position',[300 300 300 250]);plotcorr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques_table.STAI(option_include&accuracy_include),1,1,'pro-variance bias','trait and state anxiety');saveas(f,[figdir,'STAI_pro_v.png'])
figure;plotcorr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques_table.sSTAI(option_include&accuracy_include),1,1,'pro-variance bias','state anxiety')
f=figure;set(gcf,'Position',[300 300 300 250]);plotcorr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques_table.IUS(option_include&accuracy_include),1,1,'pro-variance bias','IUS');saveas(f,[figdir,'IUS_pro_v.png'])
f=figure;set(gcf,'Position',[300 300 300 250]);plotcorr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques_table.DAS(option_include&accuracy_include),1,1,'pro-variance bias','DAS');saveas(f,[figdir,'DAS_pro_v.png'])
%%
start=0.5;
abandontn=0;
ntrials=30;
%%
tic
for i=1:size(data,2)
     disp(i) 
      choices=transpose(reshape(data(i).choice,ntrials,length(data(i).blockN)));
      %blk=find(data(i).blockN==5|data(i).blockN==6|data(i).blockN==7|data(i).blockN==8);
      blk=[find(data(i).blockN==5),find(data(i).blockN==6),find(data(i).blockN==7),find(data(i).blockN==8)];

      choice=choices(blk,1:ntrials);
      resp_made=true(size(choice)); 

  
    opt1_events=transpose(reshape(data(i).opt1_out,ntrials,length(data(i).blockN)));
    opt1_events=opt1_events(blk,1:ntrials);
    opt1_events=(opt1_events-1)/12.245+0.01;

    opt2_events=transpose(reshape(data(i).opt2_out,ntrials,length(data(i).blockN)));
    opt2_events=opt2_events(blk,1:ntrials);
    opt2_events=(opt2_events-1)/12.245+0.01;
     estimates_Bayesian_CVaR_eta_beta(i)=fit_linked_Bayesian_CVaR_eta_beta(opt1_events,opt2_events,choice,abandontn,resp_made,1,30,30,0);
     estimates_1LR1B(i)=fit_linked_1LR1B(opt1_events,opt2_events,choice,start,abandontn);
     estimates_PNPE(i)=fit_linked_PNPE(opt1_events,opt2_events,choice,start,abandontn);
     estimates_PEIRS(i)=fit_linked_PEIRS(opt1_events,opt2_events,choice,start,abandontn);
     estimates_concave_UTIL(i)=fit_linked_concave_UTIL(opt1_events,opt2_events,choice,start,abandontn,resp_made,30,30,30,0);
     estimates_convex_UTIL(i)=fit_linked_convex_UTIL(opt1_events,opt2_events,choice,start,abandontn,resp_made,30,30,30,0);
     estimates_inv_s_shape_UTIL(i)=fit_linked_inverse_s_shape_UTIL(opt1_events,opt2_events,choice,start,abandontn,resp_made,30,30,30,0);
    resp_made=resp_made(:,abandontn+1:end);

    random(i).BIC=2*-sum(sum(log(0.5*resp_made+1e-16)));%change this if there is actually no response trials
end
toc
ee.Bayesian_CVaR_eta_beta=struct2table(estimates_Bayesian_CVaR_eta_beta);
%ee.Bayesian_CVaR_eta_priorvar=struct2table(estimates_Bayesian_CVaR_eta_priorvar);
ee.rw=struct2table(estimates_1LR1B);
ee.PNPE=struct2table(estimates_PNPE);
ee.concave_UTIL=struct2table(estimates_concave_UTIL);
ee.convex_UTIL=struct2table(estimates_convex_UTIL);
ee.inverse_s_shape_UTIL=struct2table(estimates_inv_s_shape_UTIL);
ee.random=struct2table(random);
ee.PEIRS=struct2table(estimates_PEIRS);

pos_bias=ee.PNPE.mean_alpha_pos./(ee.PNPE.mean_alpha_pos+ee.PNPE.mean_alpha_neg);
pos_bias_logit=logit(pos_bias);
sub_include=option_include&accuracy_include;
clear PEIRS CVAR PNPE RW
for i=1:size(estimates_PEIRS,2)
    PEIRS(i,:)=mean(estimates_PEIRS(i).prob_ch_left,2);
    CVAR(i,:)=mean(estimates_Bayesian_CVaR_eta_beta(i).prob_ch_left,2);
    PNPE(i,:)=mean(reshape(estimates_PNPE(i).prob_ch_left,30,4),1);
    RW(i,:)=mean(reshape(estimates_1LR1B(i).prob_ch_left,30,4),1);
end
%save('model_results.mat',  '-v7.3')
%
colors=[repmat([0.68,0.85,0.92],4,1);repmat([0.415,0.686,0.902],4,1)];
f5=figure;
set(gcf,'Position',[300 300 370 250])
models={'Bayesian_CVaR_eta_beta','rw','PNPE','random','PEIRS','concave_UTIL','convex_UTIL','inverse_s_shape_UTIL'};%,'Bayesian_CVaR_eta_priorvar','PEIRS'
models_names={'Bayesian-CVaR','1lr-RW','pos-neg-RW','random','PEIRS','concave-UTIL','convex-UTIL','inverse-s-shape-UTIL'};
BICs=[];
for i=1:length(models)
BICs=[BICs;sum(ee.(models{i}).BIC(all_sub_include))];
end
barh(BICs-min(BICs),'FaceColor',colors(end,:),'EdgeColor',colors(end,:))
%title(datasetname,'FontSize',10)
ax=gca;
ax.XAxis.FontSize=5;
ax.YAxis.FontSize=8;
yticklabels(models_names)
xlabel('∆BICs','FontSize',8)
%% plot pro-v from simulations using best-fited parameter for each model


figure;bar(mean(CVAR)-0.5)
drw=mean(RW(sub_include,1:2),2)-mean(RW(sub_include,3:4),2);
dpnpe=mean(PNPE(sub_include,1:2),2)-mean(PNPE(sub_include,3:4),2);
dpeirs=mean(PEIRS(sub_include,1:2),2)-mean(PEIRS(sub_include,3:4),2);
dcvar=mean(CVAR(sub_include,1:2),2)-mean(CVAR(sub_include,3:4),2);
ddata=mean(optionchocies(sub_include,5:6),2)-mean(optionchocies(sub_include,7:8),2);
figure;bar(mean([drw,dpnpe,dpeirs,dcvar,ddata]))
hold on;
errorbar(mean([drw,dpnpe,dpeirs,dcvar,ddata]),std([drw,dpnpe,dpeirs,dcvar,ddata])/sqrt(sum(sub_include)),'LineStyle','none')
xticklabels({'RW','PNPE','PEIRS','CVAR','data'})
title('fmri data')

[h,p]=ttest(dpeirs)
[h,p]=ttest(dcvar)
[h,p]=ttest(dcvar-ddata)
[h,p]=ttest(dpeirs-ddata)
[h,p]=ttest(dpeirs-dcvar)

figure;scatter(mean(PNPE,2)-0.5,ee.PNPE.mean_alpha_pos./(ee.PNPE.mean_alpha_pos+ee.PNPE.mean_alpha_neg))
figure;scatter(mean(CVAR,2)-0.5,ee.Bayesian_CVaR_eta_beta.mean_eta)
figure;scatter(CVAR(:,4),ee.Bayesian_CVaR_eta_beta.mean_eta)
figure;scatter(log(ee.Bayesian_CVaR_eta_beta.mean_beta),ee.Bayesian_CVaR_eta_beta.mean_eta)
figure;scatter(log(ee.Bayesian_CVaR_eta_beta.mean_beta(sub_include)),dcvar)
figure;scatter(log(ee.PEIRS.mean_beta(sub_include)),dpeirs)
figure;scatter(log(ee.rw.mean_beta(sub_include)),log(ee.PEIRS.mean_beta(sub_include)))


figure;scatter(ee.Bayesian_CVaR_eta_beta.mean_eta(sub_include),CVAR(sub_include,1)-CVAR(sub_include,2))
figure;scatter(ee.Bayesian_CVaR_eta_beta.mean_eta(sub_include),CVAR(sub_include,1)-CVAR(sub_include,2))

figure;scatter(mean(optionchocies(sub_include,5:6),2),mean(optionchocies(sub_include,7:8),2))
[r,p]=corr(mean(optionchocies(sub_include,5:6),2),mean(optionchocies(sub_include,7:8),2))
%%
%save('model_results.mat',  '-v7.3')
figure;plotcorr(ques_table.SDS(option_include&accuracy_include),mean(optionchocies(option_include&accuracy_include,5:6),2),1,1,'sds','PVB')
figure;plotcorr(ques_table.SDS(option_include&accuracy_include),mean(optionchocies(option_include&accuracy_include,7:8),2),1,1,'sds','PVB')

figure;plotcorr(ques_table.STAI(option_include&accuracy_include),mean(optionchocies(option_include&accuracy_include,5:6),2),1,1,'STAI','PVB')
figure;plotcorr(ques_table.STAI(option_include&accuracy_include),mean(optionchocies(option_include&accuracy_include,7:8),2),1,1,'STAI','PVB')

figure;plotcorr(pos_bias_logit(option_include&accuracy_include),mean(optionchocies(option_include&accuracy_include,5:8),2),1,1,'pos bias lr','PVB')
figure;plotcorr(logit((ee.Bayesian_CVaR_eta_beta.mean_eta(option_include&accuracy_include)+1)/2),mean(optionchocies(option_include&accuracy_include,5:8),2),1,1,'CVaR','PVB')

f=figure;set(gcf,'Position',[300 300 300 250]);plotcorr(pos_bias_logit(option_include&accuracy_include),ques_table.SDS(option_include&accuracy_include),1,1,'pos bias lr','SDS');saveas(f,[figdir,'SDS_pos_lr.png'])
f=figure;set(gcf,'Position',[300 300 300 250]);plotcorr(logit((ee.Bayesian_CVaR_eta_beta.mean_eta(option_include&accuracy_include)+1)/2),ques_table.SDS(option_include&accuracy_include),1,1,'CVaR','SDS');saveas(f,[figdir,'SDS_CVaR.png'])

f=figure;set(gcf,'Position',[300 300 300 250]);plotcorr(pos_bias_logit(option_include&accuracy_include),ques_table.STAI(option_include&accuracy_include),1,1,'pos bias lr','STAI');saveas(f,[figdir,'STAI_pos_lr.png'])
f=figure;set(gcf,'Position',[300 300 300 250]);plotcorr(logit((ee.Bayesian_CVaR_eta_beta.mean_eta(option_include&accuracy_include)+1)/2),ques_table.STAI(option_include&accuracy_include),1,1,'CVaR','STAI');saveas(f,[figdir,'STAI_CVaR.png'])

figure;plotcorr(pos_bias_logit(option_include&accuracy_include),ques_table.RRS(option_include&accuracy_include),1,1,'pos bias lr','RRS')
figure;plotcorr(logit((ee.Bayesian_CVaR_eta_beta.mean_eta(option_include&accuracy_include)+1)/2),ques_table.RRS(option_include&accuracy_include),1,1,'CVaR','RRS')
%%
colors=[repmat([0.68,0.85,0.92],4,1);repmat([0.415,0.686,0.902],4,1)];
f5=figure;
set(gcf,'Position',[300 300 370 250])
models={'Bayesian_CVaR_eta_beta','rw','PNPE','random','PEIRS','concave_UTIL','convex_UTIL','inverse_s_shape_UTIL'};%,'Bayesian_CVaR_eta_priorvar','PEIRS'
models_names={'Bayesian-CVaR','1lr-RW','pos-neg-RW','random','PEIRS','concave-UTIL','convex-UTIL','inverse-s-shape-UTIL'};
BICs=[];
for i=1:length(models)
BICs=[BICs;sum(ee.(models{i}).BIC(option_include&accuracy_include))];
end
barh(BICs-min(BICs),'FaceColor',colors(end,:),'EdgeColor',colors(end,:))
%title(datasetname,'FontSize',10)
ax=gca;
ax.XAxis.FontSize=5;
ax.YAxis.FontSize=8;
yticklabels(models_names)
xlabel('∆BICs','FontSize',8)
exportgraphics(f5,[figdir,'delta_BICs.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f5,[figdir,'delta_BICs.png'])
