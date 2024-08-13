load('F:\2023_Peking_DRL\code\matlab\model_results.mat')
fmri_subs=importdata('F:\2023_Peking_DRL\code\feat_batch\subject_list',' ');

fid=fopen('F:\2023_Peking_DRL\code\feat_batch\subject_list');
tt=textscan(fid, '%s','Delimiter',' ');
fclose(fid)
fmri_subs=tt{1,1};
%
dt=struct2table(data);
fmri_sub_include=ismember(dt.subnum,fmri_subs);
%%
roi_table=ques_table(fmri_sub_include,:);
roi_table=removevars(roi_table,{'ques_edu','subn'});

%cope_names={'win_amount', 'win_mean', 'loss_amount', 'loss_mean'};
cope_names={'chosen_PPE','mean_chosen_PPE','chosen_NPE','mean_chosen_NPE'};
contrast_names={'all_mean','diff_mean','equal_mean'};
%contrast_names={'all_mean'};
%  rois={'left_Hb','right_Hb','bilateral_Hb','NAcc','VS','left_accumbens','right_accumbens','bilateral_accumbens',...
%      'left_Hb_10','right_Hb_10','bilateral_Hb_10','left_Hb_15','right_Hb_15','bilateral_Hb_15','left_AI','right_AI','bilateral_AI',...
%      'left_Hb','right_Hb','bilateral_Hb','left_VTA','right_VTA','bilateral_VTA','bilateral_SNr','bilateral_HN','left_amyg','right_amyg'...
%      ,'activation_right_insula','activation_ACC','activation_left_VS','activation_left_lOFC','activation_right_VS'};%GLM1
  rois={'left_Hb','right_Hb','bilateral_Hb','NAcc','VS','left_accumbens','right_accumbens','bilateral_accumbens',...
     'left_Hb_10','right_Hb_10','bilateral_Hb_10','left_Hb_15','right_Hb_15','bilateral_Hb_15','left_AI','right_AI','bilateral_AI',...
     'left_Hb','right_Hb','bilateral_Hb','left_VTA','right_VTA','bilateral_VTA','bilateral_SNr','bilateral_HN','left_amyg','right_amyg'...
     'bilateral_NAcc','left_NAcc','right_NAcc'...
     ,'activation_right_insula','activation_left_VS','activation_left_VS_pre2','activation_right_VS','activation_left_VS_neg_NPE'};%GLM2
for i=rois
    for j=cope_names
        for k=contrast_names
          roi_table.([i{1},'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
        end
    end
end
roi_table.option_include=option_include(fmri_sub_include);
optionchociestable=array2table(optionchocies(fmri_sub_include,:),'VariableNames',{'BHBL1','BHBL2','BHNL','NHBL','BHNH1','BHNH2','BLNL1','BLNL2'});
optionchociestable.pro_variance_bias=mean(optionchocies(fmri_sub_include,5:8),2);

model1=struct2table(estimates_Bayesian_CVaR_eta_beta);
aa=ismember(model1.Properties.VariableNames,{'mean_eta','mean_beta'});
model1(:,~aa)=[];
model1.mean_eta_logit=logit((model1.mean_eta+1)/2);
model1.mean_beta_log=log(model1.mean_beta);
model1(~fmri_sub_include,:)=[];

model2=struct2table(estimates_PNPE);
aa=ismember(model2.Properties.VariableNames,{'mean_alpha_pos','mean_alpha_neg'});
model2(:,~aa)=[];
model2.pos_bias_lrs=model2.mean_alpha_pos./(model2.mean_alpha_pos+model2.mean_alpha_neg);
model2.mean_alpha_pos_logit=logit(model2.mean_alpha_pos);
model2.mean_alpha_neg_logit=logit(model2.mean_alpha_neg);
model2.pos_bias_lrs_logit=logit(model2.pos_bias_lrs);
model2(~fmri_sub_include,:)=[];


tt1=roi_table.SDS;
tt2=roi_table.STAI;
zscore_AD_all=zscore(tt1)+zscore(tt2);
tt1(optionchociestable.pro_variance_bias<0.3)=[];
tt2(optionchociestable.pro_variance_bias<0.3)=[];
zscore_AD=zscore(tt1)+zscore(tt2);

T=[roi_table,optionchociestable,model1];
writetable(T,'GLM2_pre_2_roi_results.csv')
%% results to write
[r,p]=corr(roi_table.SDS(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.SDS,optionchociestable.pro_variance_bias)
[r,p]=corr(roi_table.STAI(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.STAI,optionchociestable.pro_variance_bias)
[r,p]=corr(zscore_AD_all,optionchociestable.pro_variance_bias)
[r,p]=corr(zscore_AD,optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))

[r,p]=corr(roi_table.SDS(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.SDS,optionchociestable.pro_variance_bias)
[r,p]=corr(roi_table.STAI(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.STAI,optionchociestable.pro_variance_bias)
[r,p]=corr(zscore_AD_all,logit(optionchociestable.pro_variance_bias))

[r,p]=corr(zscore_AD,sqrt(optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3)))
figure;scatter(optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3),sqrt(optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3)))


[r,p]=corr(roi_table.left_Hb_15_loss_amount_all_mean(optionchociestable.pro_variance_bias>0.3),roi_table.STAI(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_15_loss_amount_all_mean,roi_table.STAI)
[r,p]=corr(roi_table.left_Hb_15_loss_amount_all_mean,roi_table.SDS)
[r,p]=corr(roi_table.left_Hb_15_loss_amount_all_mean(optionchociestable.pro_variance_bias>0.3),zscore_AD)
[r,p]=corr(roi_table.left_Hb_15_loss_amount_all_mean,zscore_AD_all)
%% set the paths
parentdir='F:\2023_Peking_DRL';
addpath(genpath([parentdir,'\code\matlab\models\']))
addpath(genpath([parentdir,'\code\matlab\utility\']))
figdir=[parentdir,'\tmp_figures\'];
wcol=[0.702 0.847, 0.38];
lcol=[0.945,0.419,0.435];
col=[wcol;lcol];
%%
[r,p]=corr(roi_table.activation_left_VS_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
f1=figure; plotcorr(roi_table.activation_left_VS_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3),1,1,'parameter estimate to PPE - VS','PVB',wcol)
saveas(f1,[figdir,'corr_VS_PPE_PVB.png'])
[r,p]=corr(roi_table.activation_left_VS_chosen_NPE_equal_mean,optionchociestable.pro_variance_bias)
[r,p]=corr(roi_table.activation_right_VS_chosen_NPE_all_mean,optionchociestable.pro_variance_bias)

[r,p]=corr(roi_table.left_Hb_15_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))

[r,p]=corr(roi_table.bilateral_Hb_15_chosen_NPE_equal_mean,optionchociestable.pro_variance_bias)
[r,p]=corr(roi_table.bilateral_Hb_15_chosen_PPE_equal_mean,optionchociestable.pro_variance_bias)
[r,p]=corr(roi_table.bilateral_Hb_15_chosen_PPE_equal_mean,roi_table.activation_left_VS_chosen_PPE_equal_mean)
[r,p]=corr(roi_table.bilateral_Hb_15_chosen_NPE_equal_mean,roi_table.activation_left_VS_chosen_NPE_equal_mean)





[r,p]=corr(roi_table.activation_right_VS_chosen_NPE_equal_mean,optionchociestable.pro_variance_bias)
[r,p]=corr(roi_table.activation_right_VS_chosen_PPE_all_mean,optionchociestable.pro_variance_bias)

[r,p]=corr(zscore_AD_all,optionchociestable.pro_variance_bias)
[r,p]=corr(roi_table.activation_left_VS_chosen_PPE_all_mean,zscore_AD_all)


[r,p]=corr(roi_table.activation_left_VS_pre2_chosen_PPE_all_mean,optionchociestable.pro_variance_bias,'type','Spearman')
[r,p]=corr(roi_table.activation_left_VS_pre2_chosen_PPE_equal_mean,roi_table.SDS)
[r,p]=corr(roi_table.activation_left_VS_pre2_chosen_PPE_equal_mean,roi_table.tSTAI)
[r,p]=corr(roi_table.activation_left_VS_pre2_chosen_PPE_equal_mean,model2.pos_bias_lrs_logit)
[r,p]=corr(roi_table.activation_left_VS_pre2_chosen_PPE_equal_mean,optionchociestable.BiLNL)
figure;scatter(roi_table.activation_left_VS_pre2_chosen_PPE_all_mean,optionchociestable.pro_variance_bias)

[r,p]=corr(roi_table.left_Hb_chosen_NPE_all_mean,optionchociestable.pro_variance_bias)
figure;scatter(roi_table.bilateral_Hb_15_chosen_PPE_all_mean,optionchociestable.pro_variance_bias)
figure;scatter(roi_table.SDS(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))

figure;scatter(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))

[r,p]=corr(zscore_AD,optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.SDS(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.bilateral_Hb_15_chosen_PPE_all_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.activation_right_VS_chosen_NPE_all_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(zscore_AD,optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(zscore_AD,roi_table.activation_right_VS_chosen_PPE_all_mean(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.right_amyg_chosen_NPE_all_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))


[r,p]=corr(roi_table.left_Hb_15_loss_amount_equal_mean(optionchociestable.pro_variance_bias>0),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_15_loss_amount_all_mean(optionchociestable.pro_variance_bias>0.3),roi_table.STAI(optionchociestable.pro_variance_bias>0.3))
figure;scatter(roi_table.left_Hb_15_loss_amount_all_mean(optionchociestable.pro_variance_bias>0),roi_table.STAI(optionchociestable.pro_variance_bias>0))


[r,p]=corr(roi_table.activation_left_VS_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.activation_left_VS_pre2_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.activation_left_VS_neg_NPE_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.activation_left_VS_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.activation_left_VS_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),roi_table.activation_left_VS_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3))


[r,p]=corr(roi_table.bilateral_accumbens_chosen_PPE_all_mean(optionchociestable.pro_variance_bias>0.3),zscore_AD)

[r,p]=corr(roi_table.activation_left_VS_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_15_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_15_chosen_PPE_equal_mean,optionchociestable.pro_variance_bias)

%% trying
[h,p]=ttest(roi_table.left_Hb_chosen_NPE_all_mean)
[h,p]=ttest(roi_table.right_Hb_chosen_NPE_all_mean)
[h,p]=ttest(roi_table.bilateral_Hb_chosen_NPE_all_mean)
[r,p]=corr(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),zscore_AD)
[r,p]=corr(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),roi_table.SDS(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),roi_table.STAI(optionchociestable.pro_variance_bias>0.3))

[r,p]=corr(roi_table.left_Hb_15_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),roi_table.SDS(optionchociestable.pro_variance_bias>0.3))


[r,p]=corr(roi_table.left_Hb_chosen_NPE_all_mean(optionchociestable.pro_variance_bias>0.3),zscore_AD)
[r,p]=corr(roi_table.left_Hb_loss_amount_all_mean(optionchociestable.pro_variance_bias>0.3),zscore_AD)
[r,p]=corr(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),roi_table.STAI(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_chosen_NPE_all_mean(optionchociestable.pro_variance_bias>0),zscore_AD_all)
[r,p]=corr(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0),zscore_AD_all)

[r,p]=corr(roi_table.right_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.bilateral_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),logit(optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3)))
figure;scatter(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),logit(optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3)))
figure;scatter(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0),logit(optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0)))

[r,p]=corr(roi_table.left_Hb_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.left_Hb_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0))

[r,p]=corr(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0))

%%
figure;scatter(roi_table.right_Hb_15_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.4),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.4))
figure;scatter(roi_table.left_Hb_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))


[r,p]=corr(roi_table.bilateral_Hb_15_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))


[r,p]=corr(roi_table.activation_right_VS_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),roi_table.tSTAI(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.activation_left_VS_pre2_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
find(optionchociestable.pro_variance_bias>0.3)
figure;scatter(roi_table.activation_left_VS_pre2_chosen_PPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
figure;scatter(roi_table.activation_left_VS_chosen_NPE_equal_mean(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))
[r,p]=corr(roi_table.STAI(optionchociestable.pro_variance_bias>0.3),optionchociestable.pro_variance_bias(optionchociestable.pro_variance_bias>0.3))

%% try try
 [r,p]=corr(mean(optionchocies(fmri_sub_include,5:8),2),roi_table.bilateral_accumbens_chosen_PPE_all_mean-roi_table.bilateral_Hb_chosen_PPE_all_mean)
  [r,p]=corr(mean(optionchocies(fmri_sub_include,[5 6]),2),roi_table.bilateral_accumbens_chosen_PPE_all_mean-roi_table.bilateral_Hb_chosen_PPE_all_mean)
 [r,p]=corr(mean(optionchocies(fmri_sub_include,[5 6]),2),roi_table.bilateral_accumbens_chosen_PPE_all_mean)
  [r,p]=corr(mean(optionchocies(fmri_sub_include,[7 8]),2),roi_table.bilateral_Hb_chosen_PPE_all_mean)
  
 [r,p]=corr(mean(optionchocies(fmri_sub_include,5:8),2),roi_table.bilateral_accumbens_chosen_PPE_all_mean-roi_table.bilateral_Hb_chosen_NPE_all_mean)

 [r,p]=corr(mean(optionchocies(fmri_sub_include,5:8),2),roi_table.bilateral_accumbens_chosen_PPE_all_mean-roi_table.VS_chosen_PPE_all_mean)

%% plot some figures for GLM1
col1=[0.784,0.62,0.769];
col2=[0.518,0.694,0.929];

wcol=[0.404,0.835,0.710];
lcol=[0.933,0.467,0.522];
col=[col1;col2];

addpath('functions\');
figdir='F:\2023_Peking_DRL\tmp_figures\';
%
pltroi='activation_right_insula';
% plot bargarph
pltvars=[roi_table.([pltroi,'_win_mean_all_mean']),roi_table.([pltroi,'_loss_mean_all_mean']),roi_table.([pltroi,'_win_amount_all_mean']),roi_table.([pltroi,'_loss_amount_all_mean'])];
means=mean(pltvars);
means=reshape(means,2,2);
errs=std(pltvars)/sqrt(size(pltvars,1));
errs=reshape(errs,2,2);
cond={'mean','amount'};
f2=figure('Position',[300 300 330 250]);
H=bar(means);
H(1).FaceColor = col1;
H(2).FaceColor = col2;
H(1).EdgeColor = 'none';
H(2).EdgeColor = 'none';

hold on

%yticklabels()
set(gca,'XTickLabel',{'WIN','LOSS'},'FontSize',6);
ylabel('parameter estimates','FontSize',7);

legend(cond,'Location','northeast','AutoUpdate','off','FontSize',6);
legend boxoff
hold on
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);
pos=1;
for v=1:2
for c=1:2
    pos=c+0.15*(-1)^v;
    dotPlot_xtr(pltvars(:,c+(v-1)*2),pos,col(v,:),0.05)

end
end
set(gca,'Box','off')
e1=errorbar([1 2]-0.15,means(:,1),errs(:,1));
e1.LineStyle='none'
e1.Color='k';
e1=errorbar([1 2]+0.15,means(:,2),errs(:,2));
e1.LineStyle='none'
e1.Color='k';
exportgraphics(f2,[figdir,'GLM1_ROI_',pltroi,'.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f2,[figdir,'GLM1_ROI_',pltroi,'.png'])
%% plot some figures for GLM2
%
pltroi='activation_right_insula';
% plot bargarph
pltvars=[roi_table.([pltroi,'_mean_chosen_PPE_all_mean']),roi_table.([pltroi,'_mean_chosen_NPE_all_mean']),roi_table.([pltroi,'_chosen_PPE_all_mean']),roi_table.([pltroi,'_chosen_NPE_all_mean'])];
means=mean(pltvars);
means=reshape(means,2,2);
errs=std(pltvars)/sqrt(size(pltvars,1));
errs=reshape(errs,2,2);
cond={'mean','slope'};
f2=figure('Position',[300 300 330 250]);
H=bar(means);
H(1).FaceColor = col1;
H(2).FaceColor = col2;
H(1).EdgeColor = 'none';
H(2).EdgeColor = 'none';

hold on

%yticklabels()
set(gca,'XTickLabel',{'PPE','NPE'},'FontSize',6);
ylabel('parameter estimates','FontSize',7);

legend(cond,'Location','northeast','AutoUpdate','off','FontSize',6);
legend boxoff
hold on
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);
pos=1;
for v=1:2
for c=1:2
    pos=c+0.15*(-1)^v;
    dotPlot_xtr(pltvars(:,c+(v-1)*2),pos,col(v,:),0.05)

end
end
set(gca,'Box','off')
e1=errorbar([1 2]-0.15,means(:,1),errs(:,1));
e1.LineStyle='none'
e1.Color='k';
e1=errorbar([1 2]+0.15,means(:,2),errs(:,2));
e1.LineStyle='none'
e1.Color='k';
exportgraphics(f2,[figdir,'GLM2_ROI_',pltroi,'.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f2,[figdir,'GLM2_ROI_',pltroi,'.png'])
%%
pltroi='activation_right_VS';
contrastname='loss_mean_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),model2.mean_alpha_neg_logit,1,1,'PEs on loss mean','negative lrs',lcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_neglrs.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_neglrs.png'])


pltroi='activation_right_VS';
contrastname='loss_mean_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),ques_table.STAI(fmri_sub_include),1,1,'PEs on loss mean','STAI',lcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_STAI.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_STAI.png'])

pltroi='activation_right_VS';
contrastname='loss_mean_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),ques_table.SDS(fmri_sub_include),1,1,'PEs on loss mean','SDS',lcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_SDS.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_SDS.png'])

pltroi='right_Hb_10';
contrastname='loss_mean_diff_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),optionchociestable.pro_variance_bias,1,1,'PEs on loss mean for diff mean blks','provariance-bias',lcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.png'])

pltroi='left_Hb_15';
contrastname='loss_amount_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),ques_table.STAI(fmri_sub_include),1,1,'PEs on loss amount','STAI',lcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_STAI.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_STAI.png'])


pltroi='left_Hb_15';
contrastname='loss_amount_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),ques_table.SDS(fmri_sub_include),1,1,'PEs on loss amount','SDS',lcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_SDS.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_SDS.png'])  
% f4=figure;
% set(gcf,'Position',[300 300 250 250])
% plotcorr(roi_table.([pltroi,'_',contrastname]),T.mean_eta_logit,1,1,'PEs on win amount','risk aversion\leftarrow CVaR\rightarrow risk seeking',wcol);
% title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);
% exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_eta_.eps'],'BackgroundColor','none','ContentType','vector')
% saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_eta_.png'])


% f4=figure;
% set(gcf,'Position',[300 300 250 250])
% plotcorr(roi_table.([pltroi,'_',contrastname]),T.pos_bias_lrs_logit,1,1,'PEs on win amount','positive bias in lrs',wcol);
% title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);
% exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_posbias_lr_.eps'],'BackgroundColor','none','ContentType','vector')
% saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_posbias_lr_.png'])
%%
pltroi='left_Hb_10';
contrastname='win_mean_diff_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),optionchociestable.pro_variance_bias,1,1,'PEs on win mean for diff mean blks','provariance-bias',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.png'])

pltroi='right_Hb_10';
contrastname='loss_mean_diff_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),optionchociestable.pro_variance_bias,1,1,'PEs on loss mean for diff mean blks','provariance-bias',lcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.png'])

pltroi='left_Hb_10';
contrastname='loss_amount_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),ques_table.STAI(fmri_sub_include),1,1,'PEs on loss mean for all blks','STAI',lcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_STAI.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_STAI.png'])
%% GLM2
pltroi='VS';
contrastname='chosen_PPE_diff_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),ques_table.SDS(fmri_sub_include),1,1,'PEs on chosen PPE for diff mean blks','SDS',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_SDS.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_SDS.png'])

pltroi='VS';
contrastname='chosen_NPE_diff_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),ques_table.SDS(fmri_sub_include),1,1,'PEs on chosen NPE for diff mean blks','SDS',lcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_SDS.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_SDS.png'])

pltroi='left_Hb_10';
contrastname='chosen_PPE_equal_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),optionchociestable.pro_variance_bias,1,1,'PEs on win mean for equal mean blks','provariance-bias',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.png'])

pltroi='right_Hb_15';
contrastname='chosen_PPE_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),optionchociestable.pro_variance_bias,1,1,'PEs on chosen PPE','provariance-bias',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.png'])

pltroi='right_Hb_15';
contrastname='chosen_PPE_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),model2.pos_bias_lrs_logit,1,1,'PEs on chosen PPE','lr-positive-bias',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_posbiaslr.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_posbiaslr_.png'])

pltroi='right_Hb_15';
contrastname='chosen_PPE_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),model1.mean_eta_logit,1,1,'PEs on chosen PPE','CVAR',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_CVAR.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_CVAR_.png'])


pltroi='bilateral_Hb_15';
contrastname='chosen_PPE_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),optionchociestable.pro_variance_bias,1,1,'PEs on chosen PPE','provariance-bias',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.png'])

pltroi='bilateral_Hb_15';
contrastname='chosen_PPE_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),model2.pos_bias_lrs_logit,1,1,'PEs on chosen PPE','lr-positive-bias',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_posbiaslr.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_posbiaslr_.png'])

pltroi='bilateral_Hb_15';
contrastname='chosen_PPE_all_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),model1.mean_eta_logit,1,1,'PEs on chosen PPE','CVAR',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_CVAR.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_CVAR_.png'])


pltroi='bilateral_Hb_10';
contrastname='chosen_PPE_equal_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),optionchociestable.pro_variance_bias,1,1,'PEs on win mean for equal mean blks','provariance-bias',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.png'])

pltroi='left_Hb_15';
contrastname='mean_chosen_NPE_diff_mean';
f4=figure;
set(gcf,'Position',[300 300 250 250])
plotcorr(roi_table.([pltroi,'_',contrastname]),optionchociestable.pro_variance_bias,1,1,'PEs on win mean for equal mean blks','provariance-bias',wcol);
title(regexprep(pltroi,'_(\d*)',' '),'FontSize',10);

exportgraphics(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.eps'],'BackgroundColor','none','ContentType','vector')
saveas(f4,[figdir,'GLM1_ROI_',pltroi,'_',contrastname,'_pro_v_.png'])
%%
f4=figure;
set(gcf,'Position',[300 300 250 250])
pltroi='right_Hb_10';
contrastname='loss_amount_all_mean';
plotcorr(T.pos_bias_lrs_logit,roi_table.([pltroi,'_',contrastname]),0,1,'positive bias in lrs','PEs on loss amount',lcol);
hold on;
pltroi='bilateral_accumbens';
contrastname='win_amount_all_mean';
plotcorr(T.pos_bias_lrs_logit,roi_table.([pltroi,'_',contrastname]),0,1,'positive bias in lrs','PEs on loss amount',wcol);
%%
roi_table=ques_fmri(fmri_sub_include,:);
roi_table=removevars(roi_table,{'subnum_ques','left_handed','education_level','gender'});

cope_names={'chosen_PPE', 'mean_chosen_PPE', 'chosen_NPE', 'mean_chosen_NPE'};
contrast_names={'all_mean','diff_mean','equal_mean'};
rois={'left_Hb','right_Hb','bilateral_Hb','NAcc','VS','left_accumbens','right_accumbens','bilateral_accumbens',...
    'left_Hb_10','right_Hb_10','bilateral_Hb_10','left_Hb_15','right_Hb_15','bilateral_Hb_15','left_AI','right_AI','bilateral_AI'};
for i=rois
    for j=cope_names
        for k=contrast_names
          roi_table.([i{1},'_',j{1},'_',k{1}])=transpose(importdata(['E:\wlin\2021_DRL_fMRI\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
        end
    end
end
roi_table.option_include=option_include(fmri_sub_include);
optionchociestable=array2table(optionchocies(fmri_sub_include,:),'VariableNames',{'BHBL','NHNL','BHNL','NHBL','BHNH','BLNL','BiHNH','BiLNL'});
optionchociestable.pro_variance_bias=mean(optionchocies(fmri_sub_include,5:8),2);

model1=struct2table(estimates_Bayesian_CVaR_eta_beta);
aa=ismember(model1.Properties.VariableNames,{'mean_eta','mean_beta'});
model1(:,~aa)=[];
model1.mean_eta_logit=logit((model1.mean_eta+1)/2);
model1.mean_beta_log=log(model1.mean_beta);
model1(~fmri_sub_include,:)=[];

model2=struct2table(estimates_PNPE);
aa=ismember(model2.Properties.VariableNames,{'mean_alpha_pos','mean_alpha_neg'});
model2(:,~aa)=[];
model2.pos_bias_lrs=model2.mean_alpha_pos./(model2.mean_alpha_pos+model2.mean_alpha_neg);
model2.mean_alpha_pos_logit=logit(model2.mean_alpha_pos);
model2.mean_alpha_neg_logit=logit(model2.mean_alpha_neg);
model2.pos_bias_lrs_logit=logit(model2.pos_bias_lrs);
model2(~fmri_sub_include,:)=[];


T=[roi_table,optionchociestable,model1,model2];
writetable(T,'GLM_3_pre_1_roi_results.csv')