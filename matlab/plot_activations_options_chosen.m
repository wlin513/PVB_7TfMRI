load('F:\2023_Peking_DRL\code\matlab\model_results.mat')
%%
fid=fopen('F:\2023_Peking_DRL\code\feat_batch\subject_list');
tt=textscan(fid, '%s','Delimiter',' ');
fclose(fid);
fmri_subs_all=tt{1,1};
fid=fopen('F:\2023_Peking_DRL\code\feat_batch\subject_list_n49');
tt=textscan(fid, '%s','Delimiter',' ');
fclose(fid);
fmri_subs=tt{1,1};
%
dt=struct2table(data);
all_sub_include=ismember(dt.subnum,fmri_subs);
fmri_sub_include=ismember(fmri_subs_all,fmri_subs);
%%
roi_table=ques_table(all_sub_include,:);
roi_table=removevars(roi_table,{'ques_edu','subn'});

%cope_names={'win_amount', 'win_mean', 'loss_amount', 'loss_mean'};
cope_names={'chosen_opt1','mean_chosen_opt1','unchosen_opt1','mean_unchosen_opt1','chosen_opt2','mean_chosen_opt2','unchosen_opt2','mean_unchosen_opt2'};
contrast_names={'BHNH1','BHNH2','BLNL1','BLNL2'};
%contrast_names={'all_mean'};
%   rois={'activation_GLM1_pre_1_win_vs_loss_mean_rNAcc',...
%       'activation_GLM1_pre_1_win_vs_loss_mean_biNAcc',...
%       'activation_GLM1_pre_1_win_vs_loss_mean_lNAcc',...
%       'activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82'};
 rois={'NAcc_resampled_right',...
      'NAcc_resampled',...
      'NAcc_resampled_left',...
      'bilateral_VTA',...
      'binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled',...
      'activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82',...
      'bilateral_Hb_05',...
      'left_Hb_05',...
      'right_Hb_05'};
  roinames={'right NAcc','bilateral NAcc','left NAcc','bilateral VTA','mPFC','mPFC activation','bilateral Hb','left Hb','right Hb'};
  %%

  n=1;
for i=rois
    for j=cope_names
        for k=contrast_names
            m=regexprep(i{1},'activation_','');
            m=regexprep(m,'cluster','');                
          %roi_table.([m,'_',j{1},'_',k{1}])=transpose(importdata(['H:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
          tmp=transpose(importdata(['H:\2023_Peking_DRL\ROI_analysis\',i{1},'_',k{1},'_',j{1},'.txt']));
          roi_table.([regexprep(roinames{n},' ','_'),'_',j{1},'_',k{1}])=tmp(fmri_sub_include);
        end 
                                                     
    end
        roi_table.([regexprep(roinames{n},' ','_'),'_BH'])=mean([roi_table.([regexprep(roinames{n},' ','_'),'_chosen_opt1_BHNH1']),...
                                                                 roi_table.([regexprep(roinames{n},' ','_'),'_chosen_opt1_BHNH2'])],...
                                                                 2); 
        roi_table.([regexprep(roinames{n},' ','_'),'_NH'])=mean([roi_table.([regexprep(roinames{n},' ','_'),'_chosen_opt2_BHNH1']),...
                                                                 roi_table.([regexprep(roinames{n},' ','_'),'_chosen_opt2_BHNH2'])],...
                                                                 2);
        roi_table.([regexprep(roinames{n},' ','_'),'_BL'])=mean([roi_table.([regexprep(roinames{n},' ','_'),'_chosen_opt1_BLNL1']),...
                                                                 roi_table.([regexprep(roinames{n},' ','_'),'_chosen_opt1_BLNL2'])],...
                                                                 2);
        roi_table.([regexprep(roinames{n},' ','_'),'_NL'])=mean([roi_table.([regexprep(roinames{n},' ','_'),'_chosen_opt2_BLNL1']),...
                                                                 roi_table.([regexprep(roinames{n},' ','_'),'_chosen_opt2_BLNL2'])],...
                                                                 2); 
        roi_table.([regexprep(roinames{n},' ','_'),'_mean_BH'])=mean([roi_table.([regexprep(roinames{n},' ','_'),'_mean_chosen_opt1_BHNH1']),...
                                                                 roi_table.([regexprep(roinames{n},' ','_'),'_mean_chosen_opt1_BHNH2'])],...
                                                                 2); 
        roi_table.([regexprep(roinames{n},' ','_'),'_mean_NH'])=mean([roi_table.([regexprep(roinames{n},' ','_'),'_mean_chosen_opt2_BHNH1']),...
                                                                 roi_table.([regexprep(roinames{n},' ','_'),'_mean_chosen_opt2_BHNH2'])],...
                                                                 2);
        roi_table.([regexprep(roinames{n},' ','_'),'_mean_BL'])=mean([roi_table.([regexprep(roinames{n},' ','_'),'_mean_chosen_opt1_BLNL1']),...
                                                                 roi_table.([regexprep(roinames{n},' ','_'),'_mean_chosen_opt1_BLNL2'])],...
                                                                 2);
        roi_table.([regexprep(roinames{n},' ','_'),'_mean_NL'])=mean([roi_table.([regexprep(roinames{n},' ','_'),'_mean_chosen_opt2_BLNL1']),...
                                                                 roi_table.([regexprep(roinames{n},' ','_'),'_mean_chosen_opt2_BLNL2'])],...
                                                                 2);                                                       
   
    n=n+1;
end



roi_table.option_include=option_include(all_sub_include);
optionchociestable=array2table(optionchocies(all_sub_include,:),'VariableNames',{'BHBL1','BHBL2','BHNL','NHBL','BHNH1','BHNH2','BLNL1','BLNL2'});
roi_table.pro_variance_bias=mean(optionchocies(all_sub_include,5:8),2);
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
model1(~all_sub_include,:)=[];

model2=struct2table(estimates_PNPE);
aa=ismember(model2.Properties.VariableNames,{'mean_alpha_pos','mean_alpha_neg'});
model2(:,~aa)=[];
model2.pos_bias_lrs=model2.mean_alpha_pos./(model2.mean_alpha_pos+model2.mean_alpha_neg);
model2.mean_alpha_pos_logit=logit(model2.mean_alpha_pos);
model2.mean_alpha_neg_logit=logit(model2.mean_alpha_neg);
model2.pos_bias_lrs_logit=logit(model2.pos_bias_lrs);
model2(~all_sub_include,:)=[];


%% color settings
col1=[0.784,0.62,0.769];
col2=[0.518,0.694,0.929];

wcol=[0.404,0.835,0.710];
lcol=[0.933,0.467,0.522];
col=[col1;col1;col2;col2];

addpath('functions\');
figdir='D:\OneDrive - University College London\2023_Peking_DRL\tmp_figures\';
%% plot some figures for GLM2
 %close all; 
i=1;
%({'NHBL','BHNL','BHBL','BHNH','BLNL'})
rois={'NAcc_resampled_right',...
      'NAcc_resampled',...
      'NAcc_resampled_left',...
      'bilateral_VTA',...
      'binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled',...
      'activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82',...
      'bilateral_Hb_05',...
      'left_Hb_05',...
      'right_Hb_05'};
  roinames={'right NAcc','bilateral NAcc','left NAcc','bilateral VTA','mPFC','mPFC activation','bilateral Hb','left Hb','right Hb'};


for roi=rois
    roiname=roinames{i}
    %pltroi=regexprep(regexprep(roi{1},'activation_',''),'cluster',''); 
    pltroi=regexprep(roinames{i},' ','_');
    % plot bargarph
     %pltvars=[roi_table.([pltroi,'_mean_BH']),roi_table.([pltroi,'_mean_BL']),roi_table.([pltroi,'_mean_NH']),roi_table.([pltroi,'_mean_NL'])];
    pltvars=[roi_table.([pltroi,'_BH']),roi_table.([pltroi,'_BL']),roi_table.([pltroi,'_NH']),roi_table.([pltroi,'_NL'])];

    
    means=mean(pltvars);
    errs=std(pltvars)/sqrt(size(pltvars,1));
    f2=figure('Position',[300 300 330 250]);
    H=bar(means,'FaceColor','flat');
    H.CData=col;
    hold on
    set(gca,'XTickLabel',{'BH','BL','NH','NL'},'FontSize',10);
    ylabel('parameter estimates (a.u.)','FontSize',10);
    hold on
    title(roiname,'FontSize',13);
    for pos=1:4
        dotPlot_xtr(pltvars(:,pos),pos,col(pos,:),0.05)

    end
    set(gca,'Box','off')
    el=errorbar(1:4,means,errs);
    el.LineStyle='none';
    el.Color='k';
    exportgraphics(f2,[figdir,'GLM4_ROI_',pltroi,'.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f2,[figdir,'GLM4_ROI_',pltroi,'.png'])
    i=i+1;
end

%%
T=[roi_table,optionchociestable,model2];
writetable(T,'roi_results_options_ifchosen_n49.csv')

%%

contrastname='opt1_NPE_all_mean';
yname='zscore_AD'
color=lcol;
for i=1:length(rois)
    roiname=roinames{i};
    %pltroi=regexprep(regexprep(roi{1},'activation_',''),'cluster',''); 
    pltroi=regexprep(roinames{i},' ','_');

    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.([pltroi,'_',contrastname]),roi_table.(yname),1,1,['parameter estimates for ',regexprep(regexprep(contrastname,'opt1_',''),'_(\w*)_mean','')],regexprep(yname,'_',' '),color);
    title(roiname,'FontSize',13);
    exportgraphics(f4,[figdir,'GLM2_corrplt_',pltroi,'_',contrastname,'_',yname,'.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'GLM2_corrplt_',pltroi,'_',contrastname,'_',yname,'.png'])
end