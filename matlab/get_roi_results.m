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

    rois={'NAcc_resampled_right',...
      'NAcc_resampled',...
      'NAcc_resampled_left',...
      'binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled',...
      'activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82',...
      'bilateral_Hb_15',...
      'left_Hb_15',...
      'right_Hb_15'
      };
  roinames={'right NAcc','bilateral NAcc','left NAcc','mPFC','mPFC activation','bilateral Hb','left Hb','right Hb'};
  %
  ROI_PPI_GLM2_sdVTA=struct();
  n=1;
for i=rois
            m=regexprep(i{1},'activation_','');
            m=regexprep(m,'cluster','');                
          %roi_table.([m,'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
          
          tmp=transpose(importdata(['E:\2023_Peking_DRL\ROI_analysis\',i{1},'_PPI_GLM2_chosen_PPE_atlas-vta_hem-bi_proba-27_resampled_thr01_pre_1_all_mean.txt']));        
          ROI_PPI_GLM2_sdVTA.([regexprep(roinames{n},' ','_'),'_PPI_PPE_sd_VTA'])=tmp(fmri_sub_include);
          tmp=transpose(importdata(['E:\2023_Peking_DRL\ROI_analysis\',i{1},'_PPI_GLM2_chosen_NPE_atlas-vta_hem-bi_proba-27_resampled_thr01_pre_1_all_mean.txt']));
          ROI_PPI_GLM2_sdVTA.([regexprep(roinames{n},' ','_'),'_PPI_NPE_sd_VTA'])=tmp(fmri_sub_include);
        
    n=n+1;
end
%%
rois={'NAcc_resampled_right',...
      'NAcc_resampled',...
      'NAcc_resampled_left',...
      'binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled',...
      'activation_GLM1_pre_1_win_vs_loss_mean_mPFC_82',...
      'bilateral_VTA'
      };
  roinames={'right NAcc','bilateral NAcc','left NAcc','mPFC','mPFC activation','bilateral VTA'};
  %
  ROI_PPI_GLM2_sdbHb=struct();
  n=1;
for i=rois
            m=regexprep(i{1},'activation_','');
            m=regexprep(m,'cluster','');                
          %roi_table.([m,'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
          
          tmp=transpose(importdata(['E:\2023_Peking_DRL\ROI_analysis\',i{1},'_PPI_GLM2_chosen_PPE_bilateral_Hb_15_pre_1_all_mean.txt']));        
          ROI_PPI_GLM2_sdbHb.([regexprep(roinames{n},' ','_'),'_PPI_PPE_sd_bHb'])=tmp(fmri_sub_include);
          tmp=transpose(importdata(['E:\2023_Peking_DRL\ROI_analysis\',i{1},'_PPI_GLM2_chosen_NPE_bilateral_Hb_15_pre_1_all_mean.txt']));
          ROI_PPI_GLM2_sdbHb.([regexprep(roinames{n},' ','_'),'_PPI_NPE_sd_bHb'])=tmp(fmri_sub_include);
        
    n=n+1;
end

%% GLM2 results
%cope_names={'win_amount', 'win_mean', 'loss_amount', 'loss_mean'};
cope_names={'chosen_PPE','chosen_NPE'};
contrast_names={'all_mean'};
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
  %

  n=1;
for i=rois
    for j=cope_names
        for k=contrast_names
            m=regexprep(i{1},'activation_','');
            m=regexprep(m,'cluster','');                
          %roi_table.([m,'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
          tmp=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
          ROI_GLM2_2.([regexprep(roinames{n},' ','_'),'_',j{1},'_',k{1}])=tmp;
        end
    end
    n=n+1;
end
T=[ROI_GLM2,optionchociestable,model2];
writetable(T,'roi_results_GLM2_2_Pre1.csv')
%% GLM1 results
cope_names={'win_amount', 'loss_amount'};
%cope_names={'chosen_PPE','chosen_NPE'};
contrast_names={'all_mean'};
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
  %

  n=1;
for i=rois
    for j=cope_names
        for k=contrast_names
            m=regexprep(i{1},'activation_','');
            m=regexprep(m,'cluster','');                
          %roi_table.([m,'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
          tmp=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
          ROI_GLM1.([regexprep(roinames{n},' ','_'),'_',j{1},'_',k{1}])=tmp(fmri_sub_include);
        end
    end
    n=n+1;
end



%save('data.mat','ROI_GLM1','ROI_GLM2','ROI_PPI_GLM2_sdbHb','ROI_PPI_GLM2_sdVTA','data','beh_results','ques_table')
%% color settings


addpath('functions\');
figdir='D:\OneDrive - University College London\2023_Peking_DRL\tmp_figures\';
%% plot some figures for GLM2 PPI 
  close all; clc
i=1;
for roi=roinames
    %pltroi=regexprep(regexprep(roi{1},'activation_',''),'cluster',''); 
    pltroi=regexprep(roi{1},' ','_');
    % plot bargarph
    pltvars=[ROI_PPI_GLM2_sdVTA.([pltroi,'_PPI_PPE_sd_VTA']),ROI_PPI_GLM2_sdVTA.([pltroi,'_PPI_NPE_sd_VTA'])];

    
    
    means=mean(pltvars);
    errs=std(pltvars)/sqrt(size(pltvars,1));
    f2=figure('Position',[300 300 330 250]);
    H=bar(means,'FaceColor','flat');
    H.CData=col;
    hold on
    set(gca,'XTickLabel',{'PPE','NPE'},'FontSize',10);
    ylabel('parameter estimates (a.u.)','FontSize',10);
    hold on
    title(roi{1},'FontSize',13);
    for pos=1:2
        dotPlot_xtr(pltvars(:,pos),pos,col(pos,:),0.05)

    end
    set(gca,'Box','off');
    el=errorbar(1:2,means,errs);
    el.LineStyle='none';
    el.Color='k';
%     exportgraphics(f2,[figdir,'GLM2_PPI_barplt_sd_VTA_',pltroi,'.eps'],'BackgroundColor','none','ContentType','vector')
%     saveas(f2,[figdir,'GLM2_PPI_barplt_sd_VTA_',pltroi,'.png'])
    i=i+1;
end

%%
T=[ROI_PPI_GLM2_sdVTA,optionchociestable,model2];
writetable(T,'roi_results_PPI_VTA_Pre1.csv')

%%

