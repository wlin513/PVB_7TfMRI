clear all
close all
clc
%% set the paths
parentdir='F:\2023_Peking_DRL';
addpath(genpath([parentdir,'\code\matlab\models\']))
addpath(genpath([parentdir,'\code\matlab\utility\']))
addpath(genpath('functions\'))
%figdir=[parentdir,'\tmp_figures\'];
figdir='D:\OneDrive - University College London\2023_Peking_DRL\tmp_figures\';
%
load('data.mat')
%% calculate overall scores for anxiety and depression
tt1=ques_table.SDS;
tt2=ques_table.STAI;
ques_table.zscore_AD=zscore(tt1)+zscore(tt2);
calculate_PVB
%% setting for modelfitting
start=0.5;
abandontn=0;
ntrials=30;
tic
for i=1:size(data,2)
     disp(i) 
      choices=transpose(reshape(data(i).choice,ntrials,length(data(i).blockN)));
      %blk=find(data(i).blockN==5|data(i).blockN==6|data(i).blockN==7|data(i).blockN==8);
      %blk=[find(data(i).blockN==5),find(data(i).blockN==6),find(data(i).blockN==7),find(data(i).blockN==8)];
      blk=[find(data(i).blockN==1),find(data(i).blockN==2),find(data(i).blockN==5),find(data(i).blockN==6),find(data(i).blockN==7),find(data(i).blockN==8)];

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
     %estimates_PEIRS(i)=fit_linked_PEIRS(opt1_events,opt2_events,choice,start,abandontn);
%      estimates_concave_UTIL(i)=fit_linked_concave_UTIL(opt1_events,opt2_events,choice,start,abandontn,resp_made,30,30,30,0);
%      estimates_convex_UTIL(i)=fit_linked_convex_UTIL(opt1_events,opt2_events,choice,start,abandontn,resp_made,30,30,30,0);
%      estimates_inv_s_shape_UTIL(i)=fit_linked_inverse_s_shape_UTIL(opt1_events,opt2_events,choice,start,abandontn,resp_made,30,30,30,0);
     resp_made=resp_made(:,abandontn+1:end);

    random(i).BIC=2*-sum(sum(log(0.5*resp_made+1e-16)));%change this if there is actually no response trials
end
toc
ee.Bayesian_CVaR_eta_beta=struct2table(estimates_Bayesian_CVaR_eta_beta);
ee.rw=struct2table(estimates_1LR1B);
ee.PNPE=struct2table(estimates_PNPE);
ee.concave_UTIL=struct2table(estimates_concave_UTIL);
ee.convex_UTIL=struct2table(estimates_convex_UTIL);
ee.inverse_s_shape_UTIL=struct2table(estimates_inv_s_shape_UTIL);
ee.random=struct2table(random);
ee.PEIRS=struct2table(estimates_PEIRS);

pos_bias=ee.PNPE.mean_alpha_pos./(ee.PNPE.mean_alpha_pos+ee.PNPE.mean_alpha_neg);
pos_bias_logit=logit(pos_bias);
clear PEIRS CVAR PNPE RW
for i=1:size(estimates_PEIRS,2)
    PEIRS(i,:)=mean(estimates_PEIRS(i).prob_ch_left,2);
    CVAR(i,:)=mean(estimates_Bayesian_CVaR_eta_beta(i).prob_ch_left,2);
    PNPE(i,:)=mean(reshape(estimates_PNPE(i).prob_ch_left,30,4),1);
    RW(i,:)=mean(reshape(estimates_1LR1B(i).prob_ch_left,30,4),1);
end

CVaR_model=struct2table(estimates_Bayesian_CVaR_eta_beta);
aa=ismember(CVaR_model.Properties.VariableNames,{'mean_eta','mean_beta'});
CVaR_model(:,~aa)=[];
CVaR_model.mean_eta_logit=logit((CVaR_model.mean_eta+1)/2);
CVaR_model.mean_beta_log=log(CVaR_model.mean_beta);

PNPE_model=struct2table(estimates_PNPE);
aa=ismember(PNPE_model.Properties.VariableNames,{'mean_alpha_pos','mean_alpha_neg'});
PNPE_model(:,~aa)=[];
PNPE_model.neg_bias_lrs=PNPE_model.mean_alpha_neg./(PNPE_model.mean_alpha_pos+PNPE_model.mean_alpha_neg);
PNPE_model.mean_alpha_pos_logit=logit(PNPE_model.mean_alpha_pos);
PNPE_model.mean_alpha_neg_logit=logit(PNPE_model.mean_alpha_neg);
PNPE_model.neg_bias_lrs_logit=logit(PNPE_model.neg_bias_lrs);
save('model_results_110724.mat',  '-v7.3')


%% plot correlations
col1=[0.784,0.62,0.769];
col2=[0.518,0.694,0.929];

wcol=[0.404,0.835,0.710];
lcol=[0.933,0.467,0.522];
col=[col1;col2];

f4=figure;
set(gcf,'Position',[300 300 200 250])
plotcorr(beh_results.pro_variance_bias,ques_table.zscore_AD,1,1,'pro-variance bias','anxiety-depression scores',col2);
exportgraphics(f4,[figdir,'corrplt_PVB_AD.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'corrplt_PVB_AD.png'])

f4=figure;
set(gcf,'Position',[300 300 200 250])
plotcorr(PNPE_model.neg_bias_lrs_logit,ques_table.zscore_AD,1,1,'negative bias in learning rates','anxiety-depression scores',col2);
exportgraphics(f4,[figdir,'corrplt_LR_AD.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'corrplt_LR_AD.png'])

f4=figure;
set(gcf,'Position',[300 300 200 250])
plotcorr(ROI_GLM1.bilateral_NAcc_chosen_NPE_all_mean,PNPE_model.neg_bias_lrs_logit,1,1,'Parameter Estimates for NPE','negative bias in learning rates',col2);
exportgraphics(f4,[figdir,'GLM2_corrplt_NAcc_NPE_LR.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM2_corrplt_sdHb_NAcc_NPE_LR.png'])

f4=figure;
set(gcf,'Position',[300 300 200 250])
plotcorr(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,PNPE_model.neg_bias_lrs_logit,1,1,'Hb-VTA (a.u.)','negative bias in learning rates',col2);
exportgraphics(f4,[figdir,'GLM2_PPI_corrplt_sdHb_VTA_NPE_LR.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM2_PPI_corrplt_sdHb_VTA_NPE_LR.png'])

f4=figure;
set(gcf,'Position',[300 300 200 250])
plotcorr(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,beh_results.pro_variance_bias,1,1,'Hb-VTA (a.u.)','pro-variance bias',col2);
exportgraphics(f4,[figdir,'GLM2_PPI_corrplt_sdHb_VTA_NPE_PVB.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM2_PPI_corrplt_sdHb_VTA_NPE_PVB.png'])

f4=figure;
set(gcf,'Position',[300 300 200 250])
plotcorr(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,CVaR_model.mean_eta_logit,1,1,'Hb-VTA (a.u.)','CVaR',col2);
exportgraphics(f4,[figdir,'GLM2_PPI_corrplt_sdHb_VTA_NPE_CVaR.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM2_PPI_corrplt_sdHb_VTA_NPE_CVaR.png'])
%% plot correlations %sFig1
f4=figure;
set(gcf,'Position',[300 300 300 250])
plotcorr(beh_results.pro_variance_bias,ques_table.SDS,1,1,'pro-variance bias','SDS',col2);
exportgraphics(f4,[figdir,'corrplt_PVB_SDS.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'corrplt_PVB_SDS.png'])

f4=figure;
set(gcf,'Position',[300 300 300 250])
plotcorr(beh_results.pro_variance_bias,ques_table.STAI,1,1,'pro-variance bias','STAI',col2);
exportgraphics(f4,[figdir,'corrplt_PVB_STAI.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'corrplt_PVB_STAI.png'])

f4=figure;
set(gcf,'Position',[300 300 300 250])
plotcorr(PNPE_model.neg_bias_lrs_logit,ques_table.SDS,1,1,'negative bias in learning rates','SDS',col2);
exportgraphics(f4,[figdir,'corrplt_LR_SDS.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'corrplt_LR_SDS.png'])

f4=figure;
set(gcf,'Position',[300 300 300 250])
plotcorr(PNPE_model.neg_bias_lrs_logit,ques_table.STAI,1,1,'negative bias in learning rates','STAI',col2);
exportgraphics(f4,[figdir,'corrplt_LR_STAI.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'corrplt_LR_STAI.png'])
%% plot AIC
colors=[repmat([0.68,0.85,0.92],4,1);repmat([0.415,0.686,0.902],4,1)];
f4=figure;
set(gcf,'Position',[300 300 300 350])
models={'PNPE','rw','PEIRS','Bayesian_CVaR_eta_beta'};
models_names={'2lr-RW','1lr-RW','PEIRS','Bayesian-CVaR'};
AICs=[];
for i=1:length(models)
AICs=[AICs;sum(ee.(models{i}).AIC)];
end
barh(AICs-min(AICs),'FaceColor',colors(end,:),'EdgeColor',colors(end,:))
ax=gca;
ax.XAxis.FontSize=5;
ax.YAxis.FontSize=8;
yticklabels(models_names)
xlabel('∆AICs','FontSize',8)
exportgraphics(f4,[figdir,'AICs.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'AICs.png'])
%%


figure;plotcorr(ques_table.SDS(option_include&accuracy_include),mean(optionchocies(option_include&accuracy_include,5:6),2),1,1,'sds','PVB')

[r,p]=corr(beh_results.pro_variance_bias,CVaR_model.mean_eta_logit)
[r,p]=corr(beh_results.pro_variance_bias,PNPE_model.neg_bias_lrs_logit)

[r,p]=corr(ques_table.zscore_AD,PNPE_model.neg_bias_lrs_logit)
[r,p]=corr(ques_table.zscore_AD,PNPE_model.mean_alpha_neg_logit)


[r,p]=corr(ROI_GLM1.bilateral_NAcc_chosen_NPE_all_mean,PNPE_model.neg_bias_lrs_logit)
[r,p]=corr(ROI_GLM1.bilateral_NAcc_chosen_NPE_all_mean,CVaR_model.mean_eta_logit)

[r,p]=corr(ROI_GLM1.mPFC_chosen_NPE_all_mean,PNPE_model.neg_bias_lrs_logit)
[r,p]=corr(ROI_GLM1.mPFC_chosen_NPE_all_mean,CVaR_model.mean_eta_logit)

[r,p]=corr(ROI_GLM1.bilateral_Hb_chosen_NPE_all_mean,PNPE_model.mean_alpha_neg_logit)

[r,p]=corr(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,PNPE_model.neg_bias_lrs_logit)
[r,p]=corr(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,PNPE_model.mean_alpha_neg_logit)
[r,p]=corr(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,PNPE_model.mean_alpha_pos_logit)
[r,p]=corr(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,CVaR_model.mean_eta_logit)
[r,p]=corr(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,ques_table.zscore_AD)


[r,p]=corr(ROI_PPI_GLM1_sdVTA.bilateral_NAcc_PPI_NPE_sd_VTA,PNPE_model.neg_bias_lrs_logit)
[r,p]=corr(ROI_PPI_GLM1_sdVTA.bilateral_NAcc_PPI_NPE_sd_VTA,PNPE_model.mean_alpha_neg_logit)
[r,p]=corr(ROI_PPI_GLM1_sdVTA.bilateral_NAcc_PPI_NPE_sd_VTA,PNPE_model.mean_alpha_pos_logit)

[r,p]=corr(ROI_GLM1.bilateral_Hb_loss_amount_all_mean,PNPE_model.neg_bias_lrs_logit)
[r,p]=corr(ROI_GLM1.left_Hb_loss_amount_all_mean,ques_table.zscore_AD)
[r,p]=corr(ROI_GLM1.left_Hb_loss_amount_all_mean,PNPE_model.mean_alpha_pos_logit)

[h,p,~,stat]=ttest(ROI_PPI_GLM1_sdVTA.bilateral_NAcc_PPI_NPE_sd_VTA)
[h,p,~,stat]=ttest(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb)

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
AICs=[];
for i=1:length(models)
AICs=[AICs;sum(ee.(models{i}).BIC(option_include&accuracy_include))];
end
barh(AICs-min(AICs),'FaceColor',colors(end,:),'EdgeColor',colors(end,:))
%title(datasetname,'FontSize',10)
ax=gca;
ax.XAxis.FontSize=5;
ax.YAxis.FontSize=8;
yticklabels(models_names)
xlabel('∆BICs','FontSize',8)
exportgraphics(f5,[figdir,'delta_BICs.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f5,[figdir,'delta_BICs.png'])
%% plot GLM1 activation for each ROI Fig.2
i=1;
rois={'NAcc_resampled_right',...
      'NAcc_resampled',...
      'NAcc_resampled_left',...
      'binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled',...
      'activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82',...
      'bilateral_VTA',...
      'bilateral_Hb_15',...
      'left_Hb_15',...
      'right_Hb_15'};
  roinames={'right NAcc','bilateral NAcc','left NAcc','mPFC','mPFC activation','bilateral VTA','bilateral Hb','left Hb','right Hb'};
for roi=rois
    roiname=regexprep(roinames{i},' ','_');
    % plot bargarph
    pltvars=[ROI_GLM1.([roiname,'_chosen_PPE_all_mean']),ROI_GLM1.([roiname,'_chosen_NPE_all_mean'])];
    means=mean(pltvars);
    errs=std(pltvars)/sqrt(size(pltvars,1));
    f2=figure('Position',[300 300 330 250]);
    H=bar(means,'FaceColor','flat');
    H.CData=col;
    hold on
    set(gca,'XTickLabel',{'PPE','NPE'},'FontSize',10);
    ylabel('parameter estimates (a.u.)','FontSize',10);
    hold on
    title(roinames{i},'FontSize',13);
    for pos=1:2
        dotPlot_xtr(pltvars(:,pos),pos,col(pos,:),0.05)

    end
    set(gca,'Box','off')
    el=errorbar(1:2,means,errs)
    el.LineStyle='none';
    el.Color='k';
     exportgraphics(f2,[figdir,'GLM1_barplt_',roiname,'.eps'],'BackgroundColor','none','ContentType','vector')
     saveas(f2,[figdir,'GLM1_barplt_',roiname,'.png'])
    i=i+1;
end
%% plot GLM3 activation for each ROI Fig.S5
i=1;
rois={'NAcc_resampled_right',...
      'NAcc_resampled',...
      'NAcc_resampled_left',...
      'binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled',...
      'activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82',...
      'bilateral_VTA',...
      'bilateral_Hb_15',...
      'left_Hb_15',...
      'right_Hb_15'};
  roinames={'right NAcc','bilateral NAcc','left NAcc','mPFC','mPFC activation','bilateral VTA','bilateral Hb','left Hb','right Hb'};
for roi=rois
    roiname=regexprep(roinames{i},' ','_');
    % plot bargarph
    pltvars=[ROI_GLM3.([roiname,'_win_amount_all_mean']),ROI_GLM3.([roiname,'_loss_amount_all_mean'])];
    means=mean(pltvars);
    errs=std(pltvars)/sqrt(size(pltvars,1));
    f2=figure('Position',[300 300 330 250]);
    H=bar(means,'FaceColor','flat');
    H.CData=col;
    hold on
    set(gca,'XTickLabel',{'Win','Loss'},'FontSize',10);
    ylabel('parameter estimates (a.u.)','FontSize',10);
    hold on
    title(roinames{i},'FontSize',13);
    for pos=1:2
        dotPlot_xtr(pltvars(:,pos),pos,col(pos,:),0.05)

    end
    set(gca,'Box','off')
    el=errorbar(1:2,means,errs)
    el.LineStyle='none';
    el.Color='k';
     exportgraphics(f2,[figdir,'GLM3_barplt_',roiname,'.eps'],'BackgroundColor','none','ContentType','vector')
     saveas(f2,[figdir,'GLM3_barplt_',roiname,'.png'])
    i=i+1;
end
%% corrplots for Fig S6
f4=figure;
set(gcf,'Position',[300 300 330 250])
plotcorr(ROI_GLM3.left_Hb_loss_amount_all_mean,ques_table.zscore_AD,1,1,'parameter estimates for Loss','anxiety-depression scores',col2);
exportgraphics(f4,[figdir,'corrplt_AD_left_Hb_Loss.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'corrplt_AD_left_Hb_Loss.png'])

f4=figure;
set(gcf,'Position',[300 300 330 250])
plotcorr(ROI_GLM1.bilateral_NAcc_chosen_NPE_all_mean,ques_table.zscore_AD,1,1,'parameter estimates for NPE','anxiety-depression scores',col2);
exportgraphics(f4,[figdir,'corrplt_AD_NAcc_NPE.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'corrplt_AD_NAcc_NPE.png'])

f4=figure;
set(gcf,'Position',[300 300 330 250])
plotcorr(ROI_GLM1.mPFC_chosen_NPE_all_mean,ques_table.zscore_AD,1,1,'parameter estimates for NPE','anxiety-depression scores',col2);
exportgraphics(f4,[figdir,'corrplt_AD_mPFC_NPE.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'corrplt_AD_mPFC_NPE.png'])
%% plot SEM model comparisons for Fig S7
load('R_SEM_results.mat', 'SEMresults')
f1=figure;
    set(gcf,'Position',[300 300 500 250])
colors=[103,213,181;238,119,133;200,158,196;132,177,237]/255;
b=bar(transpose(reshape(SEMresults.AIC,3,4))-min(SEMresults.AIC)+10000);
for k=1:3
b(k).FaceColor='flat';
b(k).CData=colors;
end
xticks(1:4)
xticklabels({'Hb','VTA','NAcc','mPFC'})
ylabel('\Delta AICs','FontSize',10)
exportgraphics(f1,[figdir,'SEM_results2.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f1,[figdir,'SEM_results.png'])
%%
[paths, stats]=mediation(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,ROI_GLM1.bilateral_NAcc_chosen_NPE_all_mean,PNPE_model.neg_bias_lrs_logit,'boottop','verbose','bootsamples',50000)

[paths, stats]=mediation(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,ROI_GLM1.bilateral_NAcc_chosen_NPE_all_mean,CVaR_model.mean_eta,'boottop','verbose','bootsamples',50000)


[paths, stats]=mediation(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,ques_table.zscore_AD,PNPE_model.neg_bias_lrs_logit,'boottop','verbose','bootsamples',50000)
[paths, stats]=mediation(PNPE_model.neg_bias_lrs_logit,ques_table.zscore_AD,ROI_GLM1.bilateral_NAcc_chosen_NPE_all_mean,'boottop','verbose','bootsamples',50000)




[paths, stats]=mediation(ROI_PPI_GLM1_sdbHb.bilateral_VTA_PPI_NPE_sd_bHb,ques_table.zscore_AD,ROI_GLM1.bilateral_NAcc_chosen_NPE_all_mean,'M',PNPE_model.neg_bias_lrs_logit,'boot','verbose',100000)

%%
T=[ques_table,beh_results,PNPE_model,CVaR_model,struct2table(ROI_GLM1),struct2table(ROI_GLM3),struct2table(ROI_PPI_GLM1_sdbHb),struct2table(ROI_PPI_GLM1_sdVTA)];
writetable(T,'roi_results_all.csv')