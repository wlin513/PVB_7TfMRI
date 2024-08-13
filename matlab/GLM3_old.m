%% 
clear all; 
clc;
%%

basedir='E:\wlin\2021_DRL_fMRI\';
datadir=[basedir,'raw_data'];
cd([basedir,'code/matlab']);
load([datadir,'/fmri_beh_data.mat'])
%% read in behavior and questionnaire data
tn=30;
blkname={'BHBL';'NHNL';'BHNL';'NHBL';'BHNH';'BLNL';'BiHNH';'BiLNL'};
%%
for ss=1:size(task,2)
        chosen=task(ss).choice==1;
        order=task(ss).order==2;%original order code:order=1:opt2 shown first;order=2:opt1 shown first.here true for opt1 first.
        fd1_chosen=chosen&order|~chosen&~order;
        fd2_chosen=~chosen&order|chosen&~order;
        aa=[fd1_chosen,fd2_chosen];
        fdb_chosen=reshape(aa',[size(aa,1)*size(aa,2),1]);
        aa=[task(ss).TR_feedback1,task(ss).TR_feedback2];
        fdb_TR=reshape(aa',[size(aa,1)*size(aa,2),1]);
        fd1_value=task(ss).opt1_out;
        fd1_value(~order)=task(ss).opt2_out(~order);
        fd2_value=task(ss).opt2_out;
        fd2_value(~order)=task(ss).opt1_out(~order);
        aa=[fd1_value,fd2_value];
        fdb_value=reshape(aa',[size(aa,1)*size(aa,2),1]);
    %@outcome  
    for i=1:length(blkname)
        bb=task(ss).blockN==i*2;
        aa=repmat(bb,[tn,1]);
        blkidx=reshape(aa,[size(aa,1)*size(aa,2),1]);
        aa=repmat(bb,[tn*2,1]);
        blkidx2=reshape(aa,[size(aa,1)*size(aa,2),1]);
        if i==5||i==7
            refpoint=8;
        end
        if i==6||i==8
            refpoint=6;
        end
        if i<5
            refpoint=7;
        end
            
        %where cards>refpoint were chosen
        chosen_PPE(i).onset=fdb_TR(blkidx2&fdb_chosen&fdb_value>refpoint);
        chosen_PPE(i).value=fdb_value(blkidx2&fdb_chosen&fdb_value>refpoint);
        chosen_PPE(i).value=chosen_PPE(i).value-mean(chosen_PPE(i).value);
        chosen_PPE(i).dur=zeros(size(chosen_PPE(i).onset));

        mean_chosen_PPE(i).onset=chosen_PPE(i).onset;
        mean_chosen_PPE(i).value=ones(size(chosen_PPE(i).onset));
        mean_chosen_PPE(i).dur=zeros(size(chosen_PPE(i).onset));

        %where cards<refpoint were chosen
        chosen_NPE(i).onset=fdb_TR(blkidx2&fdb_chosen&fdb_value<refpoint);
        chosen_NPE(i).value=fdb_value(blkidx2&fdb_chosen&fdb_value<refpoint);
        chosen_NPE(i).value=-chosen_NPE(i).value-mean(-chosen_NPE(i).value);
        chosen_NPE(i).dur=zeros(size(chosen_NPE(i).onset));

        mean_chosen_NPE(i).onset=chosen_NPE(i).onset;
        mean_chosen_NPE(i).value=ones(size(chosen_NPE(i).onset));
        mean_chosen_NPE(i).dur=zeros(size(chosen_NPE(i).onset));

            
        %where cards>refpoint were not chosen
        unchosen_PPE(i).onset=fdb_TR(blkidx2&~fdb_chosen&fdb_value>refpoint);
        unchosen_PPE(i).value=fdb_value(blkidx2&~fdb_chosen&fdb_value>refpoint);
        unchosen_PPE(i).value=unchosen_PPE(i).value-mean(unchosen_PPE(i).value);
        unchosen_PPE(i).dur=zeros(size(unchosen_PPE(i).onset));

        mean_unchosen_PPE(i).onset=unchosen_PPE(i).onset;
        mean_unchosen_PPE(i).value=ones(size(unchosen_PPE(i).onset));
        mean_unchosen_PPE(i).dur=zeros(size(unchosen_PPE(i).onset));

        %where cards<refpoint were not chosen
        unchosen_NPE(i).onset=fdb_TR(blkidx2&~fdb_chosen&fdb_value<refpoint);
        unchosen_NPE(i).value=fdb_value(blkidx2&~fdb_chosen&fdb_value<refpoint);
        unchosen_NPE(i).value=-unchosen_NPE(i).value-mean(-unchosen_NPE(i).value);
        unchosen_NPE(i).dur=zeros(size(unchosen_NPE(i).onset));

        mean_unchosen_NPE(i).onset=unchosen_NPE(i).onset;
        mean_unchosen_NPE(i).value=ones(size(unchosen_NPE(i).onset));
        mean_unchosen_NPE(i).dur=zeros(size(unchosen_NPE(i).onset));

        %where cards=refpoint
        mean_seven(i).onset=fdb_TR(blkidx2&fdb_value==refpoint);
        mean_seven(i).value=ones(size(mean_seven(i).onset));
        mean_seven(i).dur=zeros(size(mean_seven(i).onset));
      
    %calculate the choice present duration(the rule is if the participant responds within 1s the choice will be presentted for 1s, if they don't
    %response within 5s, a ramdom choice will be made for them, RT for this trial will nan)
%     choicedur=ones(length(data.trialnum),1);
% 
%     for i=1:length(choicedur)
%         if isnan(data.RT(i))
%             choicedur(i)=5;
%         else
%             if data.RT(i)>1
%             choicedur(i)=data.RT(i);
%             end
%         end
%     end
 
    %% @choice onset
    %regressor 1: the response(-1 for left; 1 for right; leave out the trial in which the participants didn't respond; then demean)

        resp(i).onset=task(ss).TR_choice(blkidx);
        resp(i).value=(task(ss).resp(blkidx)-1.5)*2;
        resp(i).value=resp(i).value-mean(resp(i).value);
        resp(i).dur=zeros(size(resp(i).onset));
    
    
    %regressor 2: the reaction time (demean)
    
        RT(i).onset=task(ss).TR_choice(blkidx);
        RT(i).value=task(ss).rt(blkidx);
        RT(i).value=RT(i).value-mean(RT(i).value);
        RT(i).dur=resp(i).dur;
        
   

        ch_const(i).onset=task(ss).TR_choice(blkidx);
        ch_const(i).value=ones(size(ch_const(i).onset));
        ch_const(i).dur=zeros(size(ch_const(i).onset));
 
%% write txt files for each regressor
  mkdir([basedir,'EVfiles/GLM3/',task(ss).subnum]);
  warning('off', 'MATLAB:MKDIR:DirectoryExists');  
        %@choice
        resptmp=[resp(i).onset resp(i).dur resp(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/1_response_',blkname{i},'.txt'],'resptmp','-ascii');

        RTtmp=[RT(i).onset RT(i).dur RT(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/2_reactiontime_',blkname{i},'.txt'],'RTtmp','-ascii');
        
        mean_seventmp=[mean_seven(i).onset mean_seven(i).dur mean_seven(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/3_mean_seven_',blkname{i},'.txt'],'mean_seventmp','-ascii');    
        
        ch_consttmp=[ch_const(i).onset ch_const(i).dur ch_const(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/4_ch_const_',blkname{i},'.txt'],'ch_consttmp','-ascii');
        %@outcome
        chosen_PPEtmp=[chosen_PPE(i).onset chosen_PPE(i).dur chosen_PPE(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/5_chosen_PPE_',blkname{i},'.txt'],'chosen_PPEtmp','-ascii');

        mean_chosen_PPEtmp=[mean_chosen_PPE(i).onset mean_chosen_PPE(i).dur mean_chosen_PPE(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/6_mean_chosen_PPE_',blkname{i},'.txt'],'mean_chosen_PPEtmp','-ascii');

        chosen_NPEtmp=[chosen_NPE(i).onset chosen_NPE(i).dur chosen_NPE(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/7_chosen_NPE_',blkname{i},'.txt'],'chosen_NPEtmp','-ascii');    

        mean_chosen_NPEtmp=[mean_chosen_NPE(i).onset mean_chosen_NPE(i).dur mean_chosen_NPE(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/8_mean_chosen_NPE_',blkname{i},'.txt'],'mean_chosen_NPEtmp','-ascii');   

        unchosen_PPEtmp=[unchosen_PPE(i).onset unchosen_PPE(i).dur unchosen_PPE(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/9_unchosen_PPE_',blkname{i},'.txt'],'unchosen_PPEtmp','-ascii');

        mean_unchosen_PPEtmp=[mean_unchosen_PPE(i).onset mean_unchosen_PPE(i).dur mean_unchosen_PPE(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/10_mean_unchosen_PPE_',blkname{i},'.txt'],'mean_unchosen_PPEtmp','-ascii');

        unchosen_NPEtmp=[unchosen_NPE(i).onset unchosen_NPE(i).dur unchosen_NPE(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/11_unchosen_NPE_',blkname{i},'.txt'],'unchosen_NPEtmp','-ascii');    

        mean_unchosen_NPEtmp=[mean_unchosen_NPE(i).onset mean_unchosen_NPE(i).dur mean_unchosen_NPE(i).value];
        save([basedir,'EVfiles/GLM3/',task(ss).subnum,'/12_mean_unchosen_NPE_',blkname{i},'.txt'],'mean_unchosen_NPEtmp','-ascii');   



   
%% Make the hrf and plot the corr matrix
names_regressor={'Response','Reaction time','sevens','Choice constant',...
    'chosen PPE','mean chosen PPE','chosen NPE','mean chosen NPE',...
    'unchosen PPE','mean unchosen PPE','unchosen NPE','mean unchosen NPE'};

     endtime=task(ss).TR_ITI(tn*i,1);
     tmpR=cal_design_matrix(endtime,resp(i),RT(i),mean_seven(i),ch_const(i),...
         chosen_PPE(i),mean_chosen_PPE(i),chosen_NPE(i),mean_chosen_NPE(i),...
         unchosen_PPE(i),mean_unchosen_PPE(i),unchosen_NPE(i),mean_unchosen_NPE(i));
     if sum(sum(isnan(tmpR)))>0       
         display(['check the design: ',task(ss).subnum,' block: ',blkname{i}])
     end
     R(ss,i,:,:)=tmpR;
    
    f1=figure;
    imagesc(tmpR);
    colorbar;

    title(strrep(blkname{i},'_',' '));

    set(gca,'Xtick',1:length(names_regressor),'XTickLabel',[ ])
    set(gca,'Ytick',1:length(names_regressor),'YTickLabel',[ ])
    for t=1:length(names_regressor)
        text(0,t+1,names_regressor{t});
        text(t-0.4,length(names_regressor),names_regressor{t});
    end
    H=findobj(gca,'Type','text');
    set(H,'Rotation',60); % tilt

    saveas(f1,[basedir,'EVfiles/GLM3/',task(ss).subnum,'/designmatrix_',blkname{i},'.png'])

    end
end
%% plot maximum corr coef design across participants
for i=1:length(blkname)
    RR=R(:,:,:,:);
    RR(RR==1)=0;
    RRabs=abs(RR);
    maxRabs=max(RRabs,[],1);
    maxRori=max(RR,[],1);
    NegCinx=(maxRabs-maxRori);
    maxR=maxRabs;
    maxR(NegCinx>0)=-maxR(NegCinx>0);
    
    
    f2=figure;
    tmpR=maxR(:,i,:,:);
    tmpR(tmpR==0)=1;
    imagesc(squeeze(tmpR));
    colorbar;
    
    title(strrep(blkname{i},'_',' '));
    
    set(gca,'Xtick',1:7,'XTickLabel',[ ])
    set(gca,'Ytick',1:7,'YTickLabel',[ ])
    
    for t=1:length(names_regressor)
    text(0,t+1,names_regressor{t});
    text(t-0.4,length(names_regressor)+1,names_regressor{t});
    end
    H=findobj(gca,'Type','text');
    set(H,'Rotation',60); % tilt
    
    saveas(f2,[basedir,'EVfiles/GLM3/max_designmatrix_',blkname{i},'.png'])
end