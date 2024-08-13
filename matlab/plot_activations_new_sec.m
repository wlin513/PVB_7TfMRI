load('F:\2023_Peking_DRL\code\matlab\model_results.mat')
%%
fid=fopen('F:\2023_Peking_DRL\code\feat_batch\subject_list_n49');
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
contrast_names={'BHBL', 'BHNL', 'NHBL', 'BHNH', 'BLNL'};%,'diff_mean','equal_mean'};
%contrast_names={'all_mean'};
%   rois={'activation_GLM1_pre_1_win_vs_loss_mean_rNAcc',...
%       'activation_GLM1_pre_1_win_vs_loss_mean_biNAcc',...
%       'activation_GLM1_pre_1_win_vs_loss_mean_lNAcc',...
%       'activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82'};
  rois={'NAcc_resampled_right',...
      'NAcc_resampled',...
      'NAcc_resampled_left',...
      'binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled',...
      'activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82',...
      'bilateral_VTA',...
      'left_Hb_15','right_Hb_15','bilateral_Hb_15'};
  roinames={'right NAcc','bilateral NAcc','left NAcc','mPFC','mPFC activation','bilateral VTA','left Hb','right Hb','bilateral Hb'};
  %

  n=1;
for i=rois
    for j=cope_names
        for k=contrast_names
            m=regexprep(i{1},'activation_','');
            m=regexprep(m,'cluster','');                
          %roi_table.([m,'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
          roi_table.([regexprep(roinames{n},' ','_'),'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
        end
    end
    n=n+1;
end
roi_table.option_include=option_include(fmri_sub_include);
optionchociestable=array2table(optionchocies(fmri_sub_include,:),'VariableNames',{'BHBL1','BHBL2','BHNL','NHBL','BHNH1','BHNH2','BLNL1','BLNL2'});
roi_table.pro_variance_bias=mean(optionchocies(fmri_sub_include,5:8),2);
optionchociestable.BLNL=(optionchociestable.BLNL1+optionchociestable.BLNL2)/2;
optionchociestable.BHNH=(optionchociestable.BHNH1+optionchociestable.BHNH2)/2;
optionchociestable.BHBL=(optionchociestable.BHBL1+optionchociestable.BHBL2)/2;
tt1=roi_table.SDS;
tt2=roi_table.STAI;
roi_table.zscore_AD=zscore(tt1)+zscore(tt2);


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


%% color settings
col1=[0.784,0.62,0.769];
col2=[0.518,0.694,0.929];

wcol=[0.404,0.835,0.710];
lcol=[0.933,0.467,0.522];
col=[col1;col1;col1;col2;col2];

addpath('functions\');
figdir='D:\OneDrive - University College London\2023_Peking_DRL\tmp_figures\';
%% plot some figures for GLM2
  close all; clc
i=1;
%({'NHBL','BHNL','BHBL','BHNH','BLNL'})
for roi=rois
    roiname=roinames{i}
    %pltroi=regexprep(regexprep(roi{1},'activation_',''),'cluster',''); 
    pltroi=regexprep(roinames{i},' ','_');
    % plot bargarph
     %pltvars=[roi_table.([pltroi,'_chosen_PPE_NHBL']),roi_table.([pltroi,'_chosen_PPE_BHNL']),roi_table.([pltroi,'_chosen_PPE_BHBL']),roi_table.([pltroi,'_chosen_PPE_BHNH']),roi_table.([pltroi,'_chosen_PPE_BLNL'])];
   pltvars=[roi_table.([pltroi,'_chosen_NPE_NHBL']),roi_table.([pltroi,'_chosen_NPE_BHNL']),roi_table.([pltroi,'_chosen_NPE_BHBL']),roi_table.([pltroi,'_chosen_NPE_BHNH']),roi_table.([pltroi,'_chosen_NPE_BLNL'])];
    %pltvars=[roi_table.([pltroi,'_mean_chosen_NPE_NHBL']),roi_table.([pltroi,'_mean_chosen_NPE_BHNL']),roi_table.([pltroi,'_mean_chosen_NPE_BHBL']),roi_table.([pltroi,'_mean_chosen_NPE_BHNH']),roi_table.([pltroi,'_mean_chosen_NPE_BLNL'])];
    %pltvars=[roi_table.([pltroi,'_mean_chosen_PPE_NHBL']),roi_table.([pltroi,'_mean_chosen_PPE_BHNL']),roi_table.([pltroi,'_mean_chosen_PPE_BHBL']),roi_table.([pltroi,'_mean_chosen_PPE_BHNH']),roi_table.([pltroi,'_mean_chosen_PPE_BLNL'])];

    [r,p]=corr(roi_table.SDS,pltvars(:,4));
    disp(['SDS-BHNH: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(roi_table.SDS,pltvars(:,5));
    disp(['SDS-BLNL: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])

    [r,p]=corr(roi_table.STAI,pltvars(:,4));
    disp(['STAI-BHNH: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(roi_table.STAI,pltvars(:,5));
        disp(['STAI-BLNL: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    
    [r,p]=corr(roi_table.zscore_AD,pltvars(:,4));
    disp(['AD-BHNH: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(roi_table.zscore_AD,pltvars(:,5));
    disp(['AD-BLNL: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    
    [r,p]=corr(roi_table.pro_variance_bias,pltvars(:,4));
    disp(['PVB-BHNH: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(roi_table.pro_variance_bias,pltvars(:,5));
    disp(['PVB-BLNL: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    
    [r,p]=corr(model2.mean_alpha_neg_logit,pltvars(:,4));
    disp(['Nlr-BHNH: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(model2.mean_alpha_neg_logit,pltvars(:,5));
    disp(['Nlr-BLNL: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    
    [r,p]=corr(model2.pos_bias_lrs_logit,pltvars(:,4));
    disp(['biaslr-BHNH: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(model2.pos_bias_lrs_logit,pltvars(:,5));
    disp(['biaslr-BLNL: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
%     
    means=mean(pltvars);
    errs=std(pltvars)/sqrt(size(pltvars,1));
    f2=figure('Position',[300 300 330 250]);
    H=bar(means,'FaceColor','flat');
    H.CData=col;
    hold on
    set(gca,'XTickLabel',{'NHBL','BHNL','BHBL','BHNH','BLNL'},'FontSize',10);
    ylabel('parameter estimates (a.u.)','FontSize',10);
    hold on
    title(roiname,'FontSize',13);
    for pos=1:5
        dotPlot_xtr(pltvars(:,pos),pos,col(pos,:),0.05)

    end
    set(gca,'Box','off');
    el=errorbar(1:5,means,errs);
    el.LineStyle='none';
    el.Color='k';
    %exportgraphics(f2,[figdir,'GLM2_barplt_',pltroi,'.eps'],'BackgroundColor','none','ContentType','vector')
    %saveas(f2,[figdir,'GLM2_barplt_',pltroi,'.png'])
    i=i+1;
end
%% GLM1
close all;clc
cope_names={'win_amount', 'loss_amount'};
contrast_names={'all_mean'};
n=1;
for i=rois
    for j=cope_names
        for k=contrast_names
            m=regexprep(i{1},'activation_','');
            m=regexprep(m,'cluster','');                
          %roi_table.([m,'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
          roi_table.([regexprep(roinames{n},' ','_'),'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));

        end
    end
    n=n+1;
end
i=1;
for roi=rois
    roiname=roinames{i}
    %pltroi=regexprep(regexprep(roi{1},'activation_',''),'cluster',''); 
    pltroi=regexprep(roinames{i},' ','_');
    % plot bargarph
    pltvars=[roi_table.([pltroi,'_win_amount_all_mean']),roi_table.([pltroi,'_loss_amount_all_mean'])];
    [r,p]=corr(roi_table.SDS,pltvars(:,1));
    disp(['SDS-win amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(roi_table.SDS,pltvars(:,2));
    disp(['SDS-loss amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])

    [r,p]=corr(roi_table.STAI,pltvars(:,1));
    disp(['STAI-win amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(roi_table.STAI,pltvars(:,2));
        disp(['STAI-loss amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    
    [r,p]=corr(roi_table.zscore_AD,pltvars(:,1));
    disp(['AD-win amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(roi_table.zscore_AD,pltvars(:,2));
    disp(['AD-loss amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    
    [r,p]=corr(roi_table.pro_variance_bias,pltvars(:,1));
    disp(['PVB-win amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(roi_table.pro_variance_bias,pltvars(:,2));
    disp(['PVB-loss amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    
    [r,p]=corr(model2.mean_alpha_neg_logit,pltvars(:,1));
    disp(['Nlr-win amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    [r,p]=corr(model2.mean_alpha_neg_logit,pltvars(:,2));
    disp(['Nlr-loss amount: r=',num2str(round(r,3)),' p=',num2str(round(p,3))])
    means=mean(pltvars);
    errs=std(pltvars)/sqrt(size(pltvars,1));
    f2=figure('Position',[300 300 330 250]);
    H=bar(means,'FaceColor','flat');
    H.CData=col;
    hold on
    set(gca,'XTickLabel',{'WIN','LOSS'},'FontSize',10);
    ylabel('parameter estimates (a.u.)','FontSize',10);
    hold on
    title(roiname,'FontSize',13);
    for pos=1:2
        dotPlot_xtr(pltvars(:,pos),pos,col(pos,:),0.05)

    end
    set(gca,'Box','off')
    el=errorbar(1:2,means,errs);
    el.LineStyle='none';
    el.Color='k';
    exportgraphics(f2,[figdir,'GLM1_ROI_',pltroi,'.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f2,[figdir,'GLM1_ROI_',pltroi,'.png'])
    i=i+1;
end

%%
T=[roi_table,optionchociestable,model2];
writetable(T,'roi_results_new_sec_n49.csv')

%%

contrastname='chosen_NPE_all_mean';
yname='zscore_AD'
color=lcol;
for i=1:length(rois)
    roiname=roinames{i};
    %pltroi=regexprep(regexprep(roi{1},'activation_',''),'cluster',''); 
    pltroi=regexprep(roinames{i},' ','_');

    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.([pltroi,'_',contrastname]),roi_table.(yname),1,1,['parameter estimates for ',regexprep(regexprep(contrastname,'chosen_',''),'_(\w*)_mean','')],regexprep(yname,'_',' '),color);
    title(roiname,'FontSize',13);
    exportgraphics(f4,[figdir,'GLM2_corrplt_',pltroi,'_',contrastname,'_',yname,'.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'GLM2_corrplt_',pltroi,'_',contrastname,'_',yname,'.png'])
end