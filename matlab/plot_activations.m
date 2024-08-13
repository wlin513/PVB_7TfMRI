load('F:\2023_Peking_DRL\code\matlab\model_results.mat')

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
contrast_names={'all_mean','diff_mean','equal_mean'};
%contrast_names={'all_mean'};
%  rois={'left_Hb','right_Hb','bilateral_Hb','NAcc','VS','left_accumbens','right_accumbens','bilateral_accumbens',...
%      'left_Hb_10','right_Hb_10','bilateral_Hb_10','left_Hb_15','right_Hb_15','bilateral_Hb_15','left_AI','right_AI','bilateral_AI',...
%      'left_Hb','right_Hb','bilateral_Hb','left_VTA','right_VTA','bilateral_VTA','bilateral_SNr','bilateral_HN','left_amyg','right_amyg'...
%      ,'activation_right_insula','activation_ACC','activation_left_VS','activation_left_lOFC','activation_right_VS'};%GLM1
  rois={'activation_NPE_zscoreAD_n49_cluster2dot8_mPFC',...
      'activation_NPE_zscoreAD_n49_SVC_cluster2dot5_NAcc',...
      'activation_NPE_pro_v_n49_SVC_cluster2dot5_NAcc',...
      'activation_NPE_pro_v_n49_cluster2dot3_mPFC',...
      'activation_PPE_pro_v_n49_cluster2dot3_NAccANDputamen',...
      'activation_PPE_pro_v_n49_cluster2dot3_mPFC',...
     'bilateral_VTA',...
     'left_Hb_15','right_Hb_15','bilateral_Hb_15',...
     'activation_NPE_n49_cluster3dot1_lamyg',...
     'activation_NPE_n49_cluster3dot1_lNAcc',...
     'activation_NPE_n49_cluster3dot1_mPFC',...
     'activation_NPE_n49_cluster3dot1_rAI',...
     'activation_PPE_n49_cluster3dot1_bi_NAcc'};%GLM2
for i=rois
    for j=cope_names
        for k=contrast_names
            m=regexprep(i{1},'activation_','');
            m=regexprep(m,'cluster','');                
          roi_table.([m,'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
        end
    end
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

T=[roi_table,optionchociestable,model2];
writetable(T,'GLM2_pre_1_roi_results_new.csv')
%% color settings
col1=[0.784,0.62,0.769];
col2=[0.518,0.694,0.929];

wcol=[0.404,0.835,0.710];
lcol=[0.933,0.467,0.522];
col=[col1;col2];

addpath('functions\');
figdir='D:\OneDrive - University College London\2023_Peking_DRL\tmp_figures\';
%% plot behaviour figures
colors=[repmat([0.68,0.85,0.92],3,1);repmat([0.415,0.686,0.902],2,1)];
colors_dot=[repmat([0.415,0.686,0.902],3,1);repmat([0.68,0.85,0.92],2,1)];
% different-mean blocks
f1=figure;
set(gcf,'Position',[300 300 270 230])
vartoplt=[optionchociestable.BHNL,optionchociestable.NHBL,optionchociestable.BHBL];
for i=1:3
b=bar(i,mean(vartoplt(:,i)));

set(b,'FaceColor',colors(i,:),'EdgeColor',colors(i,:),'BarWidth',0.8)
 hold on
     dotPlot_xtr(vartoplt(:,i),i,colors_dot(i,:),0.05)
end
ylabel('P(high|different-mean)','FontSize',10);
xticks([1:3])
xticklabels({'BHNL','NHBL','BHBL'});
ax=gca;
ax.XAxis.FontSize=9;
ax.YAxis.FontSize=8;
hold on
err=std(vartoplt)/sqrt(size(vartoplt,1));
er=errorbar(mean(vartoplt),err,'Color','black');
er.LineStyle='none';
hold on
fplot(@(x) 0.5+0*x,[-0.2 4.2],'--','Color','k')
exportgraphics(f1,[figdir,'bar_perf_diff_block.eps'],'BackgroundColor','none','ContentType','vector')
exportgraphics(f1,[figdir,'bar_perf_diff_block.png'],'BackgroundColor','none','Resolution',300)
% same-mean blocks
f1=figure;
set(gcf,'Position',[300 300 215 230])
vartoplt=[optionchociestable.BHNH,optionchociestable.BLNL];
for i=1:2
b=bar(i,mean(vartoplt(:,i)));

set(b,'FaceColor',colors(i,:),'EdgeColor',colors(i,:),'BarWidth',0.8)
 hold on
     dotPlot_xtr(vartoplt(:,i),i,colors_dot(i,:),0.05)
end
ylabel('P(broad|same-mean)','FontSize',10);
xticks([1:2])
xticklabels({'BHNH','BLNL'});
ax=gca;
ax.XAxis.FontSize=9;
ax.YAxis.FontSize=8;
hold on
err=std(vartoplt)/sqrt(size(vartoplt,1));
er=errorbar(mean(vartoplt),err,'Color','black');
er.LineStyle='none';
hold on
fplot(@(x) 0.5+0*x,[-0.2 3.2],'--','Color','k')
exportgraphics(f1,[figdir,'bar_perf_same_block.eps'],'BackgroundColor','none','ContentType','vector')
exportgraphics(f1,[figdir,'bar_perf_same_block.png'],'BackgroundColor','none','Resolution',300)
%corrplts
    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.pro_variance_bias,roi_table.SDS,1,1,'pro-variance bias','SDS',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_PVB_SDS.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_PVB_SDS.png'])
    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.pro_variance_bias,roi_table.STAI,1,1,'pro-variance bias','STAI',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_PVB_STAI.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_PVB_STAI.png'])
    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.pro_variance_bias,roi_table.DAS,1,1,'pro-variance bias','DAS',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_PVB_DAS.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_PVB_DAS.png'])
    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.pro_variance_bias,roi_table.IUS,1,1,'pro-variance bias','IUS',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_PVB_IUS.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_PVB_IUS.png'])
      f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.pro_variance_bias,roi_table.RRS,1,1,'pro-variance bias','RRS',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_PVB_RRS.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_PVB_RRS.png'])

    
   f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.pro_variance_bias,roi_table.zscore_AD,1,1,'pro-variance bias','anxiety-depression scores',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_PVB_zscoreAD.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_PVB_zscoreAD.png'])
    
    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(model2.pos_bias_lrs_logit,roi_table.zscore_AD,1,1,'learning rates bias','anxiety-depression scores',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_LRbias_zscoreAD.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_LRbias_zscoreAD.png'])
    
    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(model2.pos_bias_lrs_logit,roi_table.STAI,1,1,'learning rates bias','STAI',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_LRbias_STAI.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_LRbias_STAI.png'])
    
       f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(model2.pos_bias_lrs_logit,roi_table.SDS,1,1,'learning rates bias','SDS',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_LRbias_SDS.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_LRbias_SDS.png'])
    
    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(model2.mean_alpha_neg_logit,roi_table.zscore_AD,1,1,'negative learning rates','anxiety-depression scores',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_negLR_zscoreAD.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_negLR_zscoreAD.png'])
    
        f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(model2.mean_alpha_pos_logit,roi_table.zscore_AD,1,1,'positive learning rates','anxiety-depression scores',colors(5,:));
    exportgraphics(f4,[figdir,'corrplt_posLR_zscoreAD.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'corrplt_posLR_zscoreAD.png'])
%% plot some figures for GLM2
rois={'activation_NPE_zscoreAD_n49_cluster2dot8_mPFC',...
      'activation_NPE_zscoreAD_n49_SVC_cluster2dot5_NAcc',...
      'activation_NPE_pro_v_n49_SVC_cluster2dot5_NAcc',...
      'activation_NPE_pro_v_n49_cluster2dot3_mPFC',...
      'activation_PPE_pro_v_n49_cluster2dot3_NAccANDputamen',...
      'activation_PPE_pro_v_n49_cluster2dot3_mPFC',...
     'bilateral_VTA',...
     'left_Hb_15','right_Hb_15','bilateral_Hb_15'};
roinames={'mPFC','NAcc','NAcc','mPFC','VS(inc. NAcc)','mPFC','bilateral VTA','left Hb','right Hb','bilateral Hb'};
i=1;
for roi=rois
    roiname=roinames{i};
    pltroi=regexprep(regexprep(roi{1},'activation_',''),'cluster',''); 
    % plot bargarph
    pltvars=[roi_table.([pltroi,'_chosen_PPE_all_mean']),roi_table.([pltroi,'_chosen_NPE_all_mean'])];
    means=mean(pltvars);
    errs=std(pltvars)/sqrt(size(pltvars,1));
    f2=figure('Position',[300 300 330 250]);
    H=bar(means,'FaceColor','flat');
    H.CData=col;
    hold on
    set(gca,'XTickLabel',{'PPE','NPE'},'FontSize',10);
    ylabel('parameter estimates (a.u.)','FontSize',10);
    hold on
    title(roiname,'FontSize',13);
    for pos=1:2
        dotPlot_xtr(pltvars(:,pos),pos,col(pos,:),0.05)

    end
    set(gca,'Box','off')
    el=errorbar(1:2,means,errs)
    el.LineStyle='none';
    el.Color='k';
%     exportgraphics(f2,[figdir,'GLM2_barplt_',pltroi,'.eps'],'BackgroundColor','none','ContentType','vector')
%     saveas(f2,[figdir,'GLM2_barplt_',pltroi,'.png'])
    i=i+1;
end
%%
rois={'activation_NPE_zscoreAD_n49_cluster2dot8_mPFC',...
      'activation_NPE_zscoreAD_n49_SVC_cluster2dot5_NAcc',...
      'activation_NPE_pro_v_n49_SVC_cluster2dot5_NAcc',...
      'activation_NPE_pro_v_n49_cluster2dot3_mPFC',...
      'activation_PPE_pro_v_n49_cluster2dot3_NAccANDputamen',...
      'activation_PPE_pro_v_n49_cluster2dot3_mPFC'};
contrastnames={'chosen_NPE_all_mean','chosen_NPE_all_mean','chosen_NPE_all_mean','chosen_NPE_all_mean','chosen_PPE_equal_mean','chosen_PPE_equal_mean'};
roinames={'mPFC','NAcc','NAcc','mPFC','VS (inc. NAcc)','mPFC'};
ynames={'zscore_AD','zscore_AD','pro_variance_bias','pro_variance_bias','pro_variance_bias','pro_variance_bias'}
colors=[lcol;lcol;lcol;lcol;wcol;wcol];
for i=1:length(rois)
    pltroi=regexprep(regexprep(rois{i},'activation_',''),'cluster',''); 
    contrastname=contrastnames{i};
    roiname=roinames{i};
    yname=ynames{i};
    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.([pltroi,'_',contrastname]),roi_table.(yname),1,1,['parameter estimates for ',regexprep(regexprep(contrastname,'chosen_',''),'_(\w*)_mean','')],regexprep(yname,'_',' '),colors(i,:));
    title(roiname,'FontSize',13);
    exportgraphics(f4,[figdir,'GLM2_corrplt_',pltroi,'_',contrastname,'_',yname,'.eps'],'BackgroundColor','none','ContentType','vector')
    saveas(f4,[figdir,'GLM2_corrplt_',pltroi,'_',contrastname,'_',yname,'.png'])
end
%%
roi_table=ques_table(fmri_sub_include,:);
roi_table=removevars(roi_table,{'ques_edu','subn'});

cope_names={'win_amount', 'loss_amount'};
contrast_names={'all_mean'};
rois={'activation_loss_amount_n49_cluster3dot1_lmPFC',...
      'activation_loss_amount_n49_cluster3dot1_biNAcc',...
      'activation_loss_amount_n49_cluster3dot1_rAI',...
      'activation_win_amount_n49_cluster3dot1_biCaudate',...
      'activation_win_amount_n49_cluster3dot1_biAI',...
      'activation_win_amount_n49_cluster3dot1_OFC',...
     'activation_win_amount_n49_cluster3dot1_DLPFC',...
     'activation_win_amount_n49_cluster3dot1_mPFC'...
     'left_Hb_15','right_Hb_15','bilateral_Hb_15'};
for i=rois
    for j=cope_names
        for k=contrast_names
            m=regexprep(i{1},'activation_','');
            m=regexprep(m,'cluster','');                
          roi_table.([m,'_',j{1},'_',k{1}])=transpose(importdata(['F:\2023_Peking_DRL\ROI_analysis\',i{1},'_',j{1},'_',k{1},'.txt']));
        end
    end
end
%% color settings
col1=[0.784,0.62,0.769];
col2=[0.518,0.694,0.929];

wcol=[0.404,0.835,0.710];
lcol=[0.933,0.467,0.522];
col=[col1;col2];

addpath('functions\');
figdir='F:\2023_Peking_DRL\tmp_figures\';
%% plot some figures for GLM1
roinames={'left mPFC','bilateral NAcc','right anterior insula','bilateral VS (inc. NAcc)','bilateral anterior insula','OFC','DLPFC','mPFC','left Hb','right Hb','bilateral Hb'};
i=1;
for roi=rois
    roiname=roinames{i};
    pltroi=regexprep(regexprep(roi{1},'activation_',''),'cluster',''); 
    % plot bargarph
    pltvars=[roi_table.([pltroi,'_win_amount_all_mean']),roi_table.([pltroi,'_loss_amount_all_mean'])];
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
    el=errorbar(1:2,means,errs)
    el.LineStyle='none';
    el.Color='k';
    %exportgraphics(f2,[figdir,'GLM1_ROI_',pltroi,'.eps'],'BackgroundColor','none','ContentType','vector')
    %saveas(f2,[figdir,'GLM1_ROI_',pltroi,'.png'])
    i=i+1;
end
%%
contrastnames={'win_amount', 'loss_amount'};
ynames={'zscore_AD','zscore_AD','pro_variance_bias','pro_variance_bias','pro_variance_bias','pro_variance_bias'}
colors=[lcol;lcol;lcol;lcol;wcol;wcol];
for i=1:length(rois)
    pltroi=regexprep(regexprep(rois{i},'activation_',''),'cluster',''); 
    contrastname=contrastnames{i};
    roiname=roinames{i};
    yname=ynames{i};
    f4=figure;
    set(gcf,'Position',[300 300 250 250])
    plotcorr(roi_table.([pltroi,'_',contrastname]),roi_table.(yname),1,1,['parameter estimates for ',regexprep(regexprep(contrastname,'chosen_',''),'_(\w*)_mean','')],regexprep(yname,'_',' '),colors(i,:));
    title(roiname,'FontSize',13);
    %exportgraphics(f4,[figdir,'GLM2_corrplt_',pltroi,'_',contrastname,'_',yname,'.eps'],'BackgroundColor','none','ContentType','vector')
    %saveas(f4,[figdir,'GLM2_corrplt_',pltroi,'_',contrastname,'_',yname,'.png'])
end
