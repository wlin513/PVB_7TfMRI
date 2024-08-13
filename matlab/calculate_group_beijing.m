%% 
clear all;
clc;
%%
addpath('models\PNPE')
addpath('models\1LR1b')
addpath('models\SI_model')
addpath('models\DRL')
addpath('models\CVaR')
addpath('models\DRL_LR')
addpath('utility\')
addpath('models\PEIRS\')
%cd('D:\2021_DistRL\code');
getfolders;
datadir=[datadir,'beijing_online\'];
%% read in behavior and questionnaire data
sublistfile=dir([datadir,'PsychoPy\*.csv']);
for i=1:size(sublistfile,1)
    i
    dfile=[sublistfile(i).folder,'\',sublistfile(i).name];
    data(i)=read_csv_beijing_online(dfile);
end


%%
check_beh_data_quality_beijing_online
read_questionnaires_beijing_online
%anomymize and save the data
data=rmfield(data,{'subname','ques_subname','ques_edu','ques_IP'});
save([datadir,'data_beijing_online.mat'],'data','side_include','optionchocies','option_include','ques_include','accuracy_include')
save('D:\OneDrive - University College London\2021_DistRL\analyses_beijing_beh_data\data\experiment\data_beijing_online.mat','data','side_include','optionchocies','option_include','ques_include','accuracy_include')
%load('D:\OneDrive - University College London\2021_DistRL\analyses_beijing_beh_data\data\experiment\data_beijing_online.mat','data','side_include','optionchocies','option_include','ques_include','accuracy_include')

task_include=accuracy_include&option_include;

data=data(task_include);
ques_table=struct2table(data);
save('data_online.mat','data','ques_table','beh_results')
%%
%online
%b1_bhbl;
%b3_nhnl;
%b5_bhnl;
%b7_nhbl;
%b9_bhnh;
%b11_blnl;
%b13_bihnh;
%b15_bilnl;
%fMRI
%b2_bhbl;
%b4_nhnl;
%b6_bhnl;
%b8_nhbl;
%b10_bhnh;
%b12_blnl;
%b14_bihnh;
%b16_bilnl;
%load([datadir,'data_v2.mat'])
start=0.5;
abandontn=5;
%nneuro=100;
%
for i=1:size(task,2)
    disp(i)
    tic
    choices=transpose(reshape(task(i).choice,30,8));
    blk=find(task(i).blockN==9|task(i).blockN==11|task(i).blockN==13|task(i).blockN==15);%blk=true(1,size(choices,1));%
    choice=choices(blk,1:30);

    opt1_events=transpose(reshape(task(i).opt1_out,30,8));
    opt1_events=opt1_events(blk,1:30);
    opt1_events=(opt1_events-1)/12;

    opt2_events=transpose(reshape(task(i).opt2_out,30,8));
    opt2_events=opt2_events(blk,1:30);
    opt2_events=(opt2_events-1)/12;
    
    %try
    %
    %catch
    %    continue
    %end
    
    %estimates_DRL(i)=fit_linked_distRL(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_CVaR(i)=fit_linked_CVaR(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_PNPE(i)=fit_linked_PNPE(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_1LR1B(i)=fit_linked_1LR1B(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_SI(i)=fit_linked_selective_integration(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_fixbias(i)=fit_linked_distRL_fixbias(opt1_events,opt2_events,choice,start,abandontn,100);
    %estimates_DRL_LR(i)=fit_linked_distRL_LR_singleVar(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_DRL_LR_2v(i)=fit_linked_distRL_LR_twoVars(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_CVaR_variation(i)=fit_linked_CVaR_variation(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_CVaR_variation_LR(i)=fit_linked_CVaR_variation_LR(opt1_events,opt2_events,choice,start,abandontn)
    %estimates_CVaR_LR(i)=fit_linked_CVaR_LR(opt1_events,opt2_events,choice,start,abandontn)
    %estimates_CVaR_LR_fix_lrs_map(i)=fit_linked_CVaR_LR_fix_lrs_map(opt1_events,opt2_events,choice,start,abandontn)
    %estimates_CVaR_LR_varing_start(i)=fit_linked_CVaR_LR_varing_start(opt1_events,opt2_events,choice,start,abandontn)
    %estimates_PEIRS(i)=fit_linked_PEIRS(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_PEIRS_fix_s0(i)=fit_linked_PEIRS_fix_s0(opt1_events,opt2_events,choice,start,0,abandontn);
    estimates_PEIRS_fix_s0_bias(i)=fit_linked_PEIRS_fix_s0_bias(opt1_events,opt2_events,choice,start,0,abandontn);
    %estimates_PEICVaR(i)=fit_linked_PEICVaR(opt1_events,opt2_events,choice,start,abandontn);
    %estimates_PEI_bias_CVaR(i)=fit_linked_PEI_bias_CVaR(opt1_events,opt2_events,choice,start,abandontn);
    toc
end
save('model_results_beijing_online_PEIRS_fix_s0_bias_060922.mat',  '-v7.3')
%%


for i=1:size(estimates_DRL,2)
    pos_bias_DRL(i,1)= estimates_DRL(i).mean_pos_bias;
    base_lrs_DRL(i,1)= estimates_DRL(i).mean_base_alpha;
    vars_DRL(i,1)=estimates_DRL(i).mean_vars;
end
for i=1:size(estimates_DRL_LR,2)
    pos_bias_DRL_LR(i,1)= estimates_DRL_LR(i).pos_bias;
    base_lrs_DRL_LR(i,1)= estimates_DRL_LR(i).baselrs;
    vars_DRL_LR(i,1)=estimates_DRL_LR(i).mean_vars;
    pos_alpha_DRL_LR(i,1)= estimates_DRL_LR(i).mean_pos_alpha;
    neg_alpha_DRL_LR(i,1)= estimates_DRL_LR(i).mean_neg_alpha;
end
% for i=1:size(estimates_fixbias2,2)
%     base_lrs_fixbias(i,1)= estimates_fixbias(i).mean_base_alpha;
%     vars_fixbias2(i,1)=estimates_fixbias2(i).mean_vars;
% end

% histogram(vars_fixbias)
% scatter(vars_fixbias.^2,log(RW_betas(1:45)))
% figure;scatter(base_lrs_fixbias,RW_lrs(1:45))

for i=1:size(estimates_PNPE,2)
    pos_lrs(i,1)= estimates_PNPE(i).mean_alpha_pos;
    neg_lrs(i,1)= estimates_PNPE(i).mean_alpha_neg;
    betas(i,1)=estimates_PNPE(i).mean_beta;
end
pos_bias_PNPE=pos_lrs./(pos_lrs+neg_lrs);
for i=1:size(estimates_1LR1B,2)
    RW_lrs(i,1)= estimates_1LR1B(i).mean_alpha;
    RW_betas(i,1)=estimates_1LR1B(i).mean_beta;
end
for i=1:size(estimates_SI,2)
    leaks(i,1)= estimates_SI(i).mean_leak;
    lapses(i,1)=estimates_SI(i).mean_lapse;
    ws(i,1)=estimates_SI(i).mean_w;
    noises(i,1)=estimates_SI(i).mean_noise;
end
% for i=1:size(estimates_CVaR,2)
%     eta(i,1)= estimates_CVaR(i).mean_eta;
%     CVaR_betas(i,1)=estimates_CVaR(i).mean_beta;
% end

for i=1:size(estimates_CVaR_variation,2)
    vars_CVaR_variation(i,1)= estimates_CVaR_variation(i).mean_vars;
    eta_variation(i,1)= estimates_CVaR_variation(i).mean_eta;
    CVaR_betas_variation(i,1)=estimates_CVaR_variation(i).mean_beta;
end


for i=1:size(estimates_CVaR_LR,2)
    eta_LR(i,1)= estimates_CVaR_LR(i).mean_eta;
    CVaR_LR(i,1)=estimates_CVaR_LR(i).mean_beta;
    CVaR_alphas_LR(i,1)=estimates_CVaR_LR(i).mean_base_alpha;
end

for i=1:size(estimates_PEIRS,2)
    PEIRS_alphaQ(i,1)= estimates_PEIRS(i).mean_alphaQ;
    PEIRS_alphaS(i,1)=estimates_PEIRS(i).mean_alphaS;
    PEIRS_omega(i,1)=estimates_PEIRS(i).mean_omega;
    PEIRS_beta(i,1)=estimates_PEIRS(i).mean_beta;
    PEIRS_spread(i,1)=estimates_PEIRS(i).mean_spread;
end

for i=1:size(estimates_PEIRS_fix_s0,2)
    PEIRS_fix_s0_alphaQ(i,1)= estimates_PEIRS_fix_s0(i).mean_alphaQ;
    PEIRS_fix_s0_alphaS(i,1)=estimates_PEIRS_fix_s0(i).mean_alphaS;
    PEIRS_fix_s0_omega(i,1)=estimates_PEIRS_fix_s0(i).mean_omega;
    PEIRS_fix_s0_beta(i,1)=estimates_PEIRS_fix_s0(i).mean_beta;
end
for i=1:size(estimates_PEIRS_fix_s0_bias,2)
    PEIRS_fix_s0_bias_alphaQ(i,1)= estimates_PEIRS_fix_s0_bias(i).mean_alphaQ;
    PEIRS_fix_s0_bias_alphaS(i,1)=estimates_PEIRS_fix_s0_bias(i).mean_alphaS;
    PEIRS_fix_s0_bias_omega(i,1)=estimates_PEIRS_fix_s0_bias(i).mean_omega;
    PEIRS_fix_s0_bias_beta(i,1)=estimates_PEIRS_fix_s0_bias(i).mean_beta;
    PEIRS_fix_s0_bias_phi(i,1)=estimates_PEIRS_fix_s0_bias(i).mean_phi;
end
for i=1:size(estimates_PEICVaR,2)
    omega_PEICVaR(i,1)= estimates_PEICVaR(i).mean_omega;
    beta_PEICVaR(i,1)=estimates_PEICVaR(i).mean_beta;
    alphas_PEICVaR(i,1)=estimates_PEICVaR(i).mean_base_alpha;
end


%% corr ques and model estimates
%plot risk-seeking for both-high and both-low
figure;scatter(mean(optionchocies(task_include,[5,7]),2),mean(optionchocies(task_include,[6,8]),2));hold on;fplot(@(x) x,[0 1])
ylabel('P-risky|both low');xlabel('P-risky|both high');
%scatter(optionchocies(:,5),optionchocies(:,6));hold on;fplot(@(x) x,[0 1])
[r,p]=corr(mean(optionchocies(task_include,[5,7]),2),mean(optionchocies(task_include,[6,8]),2))
%
ques=struct2table(data);

figure;plotcorr(ques.DAS(task_include),mean(optionchocies(task_include,5:8),2),1,1,'DAS','provariance-bias','b');



figure;scatter(mean(optionchocies(task_include,[5 7]),2),ques.RRS(task_include))
[r,p]=corr(mean(optionchocies(task_include,[5 7]),2),ques.RRS(task_include))

figure;scatter(mean(optionchocies(task_include,[5 7]),2),ques.STAI(task_include))
[r,p]=corr(mean(optionchocies(task_include,[5 7]),2),ques.STAI(task_include))

figure;scatter(mean(optionchocies(task_include,[5 7]),2),ques.SDS(task_include))
[r,p]=corr(mean(optionchocies(task_include,[5 7]),2),ques.SDS(task_include))

ADzscores=zscore(ques.STAI(task_include))+zscore(ques.STAI(task_include))
%
figure;scatter(pos_bias_PNPE(task_include),ques.RRS.total(task_include))
[r,p]=corr(pos_bias_PNPE(task_include),ques.RRS.total(task_include))
%
figure;scatter(pos_bias_DRL_LR(task_include),ques.RRS.total(task_include))
[r,p]=corr(pos_bias_DRL_LR(task_include),ques.RRS.total(task_include))
%
figure;scatter(omega_PEICVaR(task_include),ques.RRS.total(task_include))
[r,p]=corr(omega_PEICVaR(task_include),ques.RRS.total(task_include))
%
figure;scatter(PEIRS_fix_s0_bias_phi,ques.RRS.total)
[r,p]=corr(PEIRS_fix_s0_bias_phi,ques.RRS.total)
%
figure;scatter(PEIRS_fix_s0_bias_omega,PEIRS_fix_s0_omega)
[r,p]=corr(PEIRS_fix_s0_bias_phi,(mean(optionchocies(task_include,5:8),2)))
%
figure;scatter(PEIRS_fix_s0_bias_omega,(mean(optionchocies(task_include,5:8),2)))
[r,p]=corr(PEIRS_fix_s0_bias_omega,(mean(optionchocies(task_include,5:8),2)))

figure;scatter(PEIRS_fix_s0_bias_phi,(mean(optionchocies(task_include,5:8),2)))
[r,p]=corr(PEIRS_fix_s0_bias_phi,(mean(optionchocies(task_include,5:8),2)))
%
figure;scatter(ques.STAI.total(task_include),ques.SDS.total(task_include))
[r,p]=corr(ques.STAI.total(task_include),ques.SDS.total(task_include))
%
figure;scatter(mean(optionchocies(:,1:8),2),ques.RRS.total)
[r,p]=corr(mean(optionchocies(:,1:8),2),ques.RRS.total)
%
figure;scatter(eta_LR,ques.IUS.total)
[r,p]=corr(eta_LR,ques.IUS.total)

figure;scatter(mean(optionchocies(:,[5 7]),2),ques.RRS.total)
[r,p]=corr(mean(optionchocies(:,[5 7]),2),ques.RRS.total)

figure;scatter(mean(optionchocies(:,[6 8]),2),ques.RRS.total)
[r,p]=corr(mean(optionchocies(:,[6 8]),2),ques.RRS.total)

figure;scatter(mean(optionchocies(:,[5 7]),2)./(mean(optionchocies(:,[5 7]),2)+mean(optionchocies(:,[6 8]),2)),ques.RRS.total)
[r,p]=corr((mean(optionchocies(:,[5 7]),2)-mean(optionchocies(:,[6 8]),2))./(mean(optionchocies(:,[5 7]),2)+mean(optionchocies(:,[6 8]),2)),ques.RRS.total)

figure;scatter(mean(optionchocies(option_include&accuracy_include,5:8),2),ques.RRS(option_include&accuracy_include))
l=lsline
[r,p]=corr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques.RRS(option_include&accuracy_include))

figure;scatter(mean(optionchocies(option_include&accuracy_include,[6 8]),2),ques.RRS(option_include&accuracy_include))
l=lsline
[r,p]=corr(mean(optionchocies(option_include&accuracy_include,[6 8]),2),ques.RRS(option_include&accuracy_include))

figure;scatter(optionchocies(option_include&accuracy_include,5),ques.RRS(option_include&accuracy_include))
l=lsline
[r,p]=corr(optionchocies(option_include&accuracy_include,5),ques.RRS(option_include&accuracy_include))

figure;scatter(mean(optionchocies(option_include&accuracy_include,5:8),2),ques.SDS(option_include&accuracy_include))
[r,p]=corr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques.SDS(option_include&accuracy_include))

figure;scatter(mean(optionchocies(option_include&accuracy_include,5:8),2),ques.DAS(option_include&accuracy_include))
[r,p]=corr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques.DAS(option_include&accuracy_include))

figure;scatter(mean(optionchocies(option_include&accuracy_include,5:8),2),ques.IUS(option_include&accuracy_include))
[r,p]=corr(mean(optionchocies(option_include&accuracy_include,5:8),2),ques.IUS(option_include&accuracy_include))

figure;scatter(optionchocies(:,8),ques.RRS.total)
[r,p]=corr(optionchocies(:,8),ques.RRS.total)
%
figure;scatter(pos_bias_PNPE(task_include),ques.RRS.total(task_include))
[r,p]=corr(pos_bias_PNPE(task_include),ques.RRS.total(task_include))
%
figure;scatter(mean(optionchocies(task_include,5:8),2),ques.RRS.total(task_include))
[r,p]=corr(mean(optionchocies(task_include,5:8),2),ques.RRS.total(task_include))
%
figure;scatter(optionchocies(task_include,3)-optionchocies(task_include,4),ques.RRS.total(task_include))
[r,p]=corr(mean(optionchocies(task_include,5:8),2),ques.RRS.total(task_include))
%
figure;scatter(optionchocies(task_include,3),optionchocies(task_include,4))

ax=eta_LR;
ay=mean(optionchocies(:,[6 8]),2);
figure;scatter(ax(task_include),ay(task_include))
[r,p]=corr(ax(task_include),ay(task_include))

%
figure;scatter(eta_LR(task_include),ques.SDS.total(task_include))
[r,p]=corr(eta_LR(task_include),ques.SDS.total(task_include))
%
figure;scatter(ques.SDS.total,ques.STAI.total)
figure;scatter(ques.SDS.total,ques.RRS.total)
[r,p]=corr(ques.SDS.total,ques.RRS.total)
figure;scatter(optionchocies(task_include,6),ques.IUS.total(task_include))
[r,p]=corr(optionchocies(task_include,6),ques.IUS.total(task_include))
figure;scatter(ques.RRS.total,ques.IUS.total)
ques_all=[ques.RRS.total,ques.STAI.total,ques.SDS.total,ques.IUS.total,ques.DAS.total];
var_names={'RRS','STAI','SDS','IUS','DAS'};
figure;imagesc(corr(ques_all(task_include,:)));colorbar
figure;imagesc(corr(ques_all));colorbar

xticks(1:size(ques_all,2))
xticklabels(var_names)
yticks(1:size(ques_all,2))
yticklabels(var_names)


tmp=[pos_bias_PNPE(task_include),ques_all(task_include,:)];%mean(optionchocies(task_include,[6 8]),2)
var_names2=['pro-v-both-high',var_names];
[r,p]=corr(tmp)
figure;imagesc(corr(tmp));colorbar
xticks(1:size(tmp,2))
xticklabels(var_names2)
yticks(1:size(tmp,2))
yticklabels(var_names2)

clear a b aa bb
a=mean(squeeze(mean(opt1chocies(task_include,[5,7],:))));
b=mean(squeeze(mean(opt1chocies(task_include,[6,8],:))));
a=squeeze(mean(opt1chocies(task_include,5,:)));
b=squeeze(mean(opt1chocies(task_include,6,:)));

wind=5;
for i=1:length(a)/wind
    aa(i)=mean(a(i:i+wind-1));
    bb(i)=mean(b(i:i+wind-1));
end
figure;plot(aa);hold on;plot(bb)
%% compare BICs
%load('PNPE_model_results_aban5_s94_vmax1_start05.mat')
task_include=option_include&side_include;
task_include=side_include;
task_include=true(size(task,2),1);
for i=1:size(task,2)
    BICs_PNPE(i)=estimates_PNPE(i).BIC;
    %BICs_DRL(i)=estimates_uni_vars(i).BIC;
    %BICs_DRL(i)=estimates_DRL(i).BIC;
    BICs_DRL_LR(i)=estimates_DRL_LR(i).BIC;
    %BICs_DRL_LR_2v(i)=estimates_DRL_LR_2v(i).BIC;
    BICs_1LR1B(i)=estimates_1LR1B(i).BIC;
    BICs_SI(i)=estimates_SI(i).BIC;
    %BICs_CVaR(i)=estimates_CVaR(i).BIC;
    %BICs_CVaR_variation(i)=estimates_CVaR_variation(i).BIC;
    %BICs_CVaR_variation_LR(i)=estimates_CVaR_variation_LR(i).BIC;
    BICs_CVaR_LR(i)=estimates_CVaR_LR(i).BIC;
    %BICs_CVaR_LR2(i)=estimates_CVaR_LR2(i).BIC;
    %BICs_CVaR_LR_varing_start(i)=estimates_CVaR_LR_varing_start(i).BIC;
    %BICs_PEIRS(i)=estimates_PEIRS(i).BIC;
    BICs_PEIRS_fix_s0(i)=estimates_PEIRS_fix_s0(i).BIC;
    BICs_PEIRS_fix_s0_bias(i)=estimates_PEIRS_fix_s0_bias(i).BIC;
   %BICs_PEICVaR(i)=estimates_PEICVaR(i).BIC;
   %BICs_CVaR_LR_fix_lrs_map(i)=estimates_CVaR_LR_fix_lrs_map(i).BIC;
end
b=figure;
model_names={'PNPE','1LR','SI','DRL-LR','CVaR-LR','PEIRS-fix-s0','PEIRS-fix-s0-bias'};
BICs=[BICs_PNPE(task_include)',BICs_1LR1B(task_include)',BICs_SI(task_include)',...
    BICs_DRL_LR(task_include)',...
    BICs_CVaR_LR(task_include)',...
    BICs_PEIRS_fix_s0(task_include)',...
    BICs_PEIRS_fix_s0_bias(task_include)'];
[~,idx]=sort(mean(BICs));
sorted_BICs=BICs(:,idx);
delta_sorted_BICs=sorted_BICs-sorted_BICs(:,1);
delta_sorted_mBICs=mean(delta_sorted_BICs);
bar(delta_sorted_mBICs)
xticklabels(model_names(idx))
saveas(b,[figdir,'BICs.png'])
[h,p]=ttest(BICs_SI(task_include),BICs_PEICVaR(task_include))
figure;scatter(BICs_DRL(task_include),BICs_SI(task_include))
hold on;fplot(@(x) x,[0,300])

aa=BICs_DRL-BICs_1LR1B;
figure;scatter(pos_bias_DRL(task_include),aa(task_include))
figure;scatter(abs(pos_bias_PNPE(task_include)-0.5),aa(task_include)')
[r,p]=corr(abs(pos_bias_PNPE(task_include)-0.5),aa(task_include)')


outl=true(size(task,2),size(task,1));
outl(find(BICs_DRL>5000))=false;
figure;s=scatter(BICs_DRL,BICs)
hold on; fplot(@(x) x,[40 240])
figure;scatter(BICs_DRL(task_include&outl)-BICs_PNPE(task_include&outl),logit(base_lrs(task_include&outl)))
figure;scatter(BICs_DRL(task_include&outl)-BICs_PNPE(task_include&outl),log(betas(task_include&outl)))
figure;scatter(BICs_DRL(task_include&outl)-BICs_PNPE(task_include&outl),log(vars(task_include&outl)))
figure;scatter(betas(task_include),vars(task_include))
figure;scatter(pos_bias_DRL(task_include&outl),pos_bias(task_include&outl))
figure;scatter(vars_DRL(task_include),vars(task_include))

fplot(@(x) log(x),[0 2])
outl2=true(size(task,2),size(task,1));
outl2(find(BICs_DRL-BICs_PNPE>70))=false;
median(BICs_DRL)
%% compare AICs
%load('PNPE_model_results_aban5_s94_vmax1_start05.mat')
task_include=option_include&side_include&accuracy_include;
for i=1:size(task,2)
    AICs_PNPE(i)=estimates_PNPE(i).AIC;
    %AICs_DRL(i)=estimates_uni_vars(i).AIC;
    %AICs_DRL(i)=estimates_DRL(i).AIC;
    %AICs_DRL_LR(i)=estimates_DRL_LR(i).AIC;
    %AICs_DRL_LR_2v(i)=estimates_DRL_LR_2v(i).AIC;
    AICs_1LR1B(i)=estimates_1LR1B(i).AIC;
    AICs_SI(i)=estimates_SI(i).AIC;
    %AICs_CVaR(i)=estimates_CVaR(i).AIC;
    %AICs_CVaR_variation(i)=estimates_CVaR_variation(i).AIC;
    %AICs_CVaR_variation_LR(i)=estimates_CVaR_variation_LR(i).AIC;
    AICs_CVaR_LR(i)=estimates_CVaR_LR(i).AIC;
    %AICs_CVaR_LR_varing_start(i)=estimates_CVaR_LR_varing_start(i).AIC;
    %AICs_PEIRS(i)=estimates_PEIRS(i).AIC;
    AICs_PEIRS_fix_s0(i)=estimates_PEIRS_fix_s0(i).AIC;
    AICs_PEICVaR(i)=estimates_PEICVaR(i).AIC;
end
b=figure;
model_names={'PNPE','1LR','SI','CVaR-LR','PEIRS-fix-s0','PEICVaR'};
AICs=[AICs_PNPE(task_include)',AICs_1LR1B(task_include)',AICs_SI(task_include)',...
    AICs_CVaR_LR(task_include)',...
    AICs_PEIRS_fix_s0(task_include)',...
    AICs_PEICVaR(task_include)'];
[~,idx]=sort(mean(AICs));
sorted_AICs=AICs(:,idx);
delta_sorted_AICs=sorted_AICs-sorted_AICs(:,1);
delta_sorted_mAICs=mean(delta_sorted_AICs);
std_AICs=std(delta_sorted_AICs)./sqrt(sum(task_include));
bar(delta_sorted_mAICs)
hold on
er=errorbar(delta_sorted_mAICs,...
    std_AICs)
er.LineStyle='none'
xticklabels(model_names(idx))
saveas(b,[figdir,'AICs.png'])
[h,p]=ttest(AICs_DRL(task_include),AICs_SI(task_include))
figure;scatter(AICs_DRL(task_include),AICs_SI(task_include))
hold on;fplot(@(x) x,[0,300])