%% 
clear all; 
clc;
%%

basedir='F:\2023_Peking_DRL\';
datadir=[basedir,'raw_data'];
cd([basedir,'code/matlab']);
load([datadir,'\beh_data.mat'])
%% read in behavior and questionnaire data
tn=30;
blkname={'BHBL1','BHBL2','BHNL','NHBL','BHNH1','BHNH2','BLNL1','BLNL2'};
%%
is=0;
for ss=1:size(data,2)
    %@outcome  
    include=option_include&accuracy_include;
    if include(ss)==1
        is=is+1;
        for i=1:length(blkname)
            bb=data(ss).blockN==i;
            aa=repmat(bb,[tn,1]);
            blkidx=reshape(aa,[size(aa,1)*size(aa,2),1]);
            %feedback1
            fdb1(i).onset=data(ss).TR_feedback1(blkidx);
            fdb1(i).value=ones(size(fdb1(i).onset));
            fdb1(i).dur=zeros(size(fdb1(i).onset));

            %feedback2
            fdb2_wintrials(i).onset=data(ss).TR_feedback2(data(ss).correct==1&blkidx);
            fdb2_wintrials(i).value=data(ss).diff(data(ss).correct==1&blkidx);
            fdb2_wintrials(i).value=fdb2_wintrials(i).value-mean(fdb2_wintrials(i).value);
            fdb2_wintrials(i).dur=zeros(size(fdb2_wintrials(i).onset));

            fdb2_wintrials_mean(i).value=ones(size(fdb2_wintrials(i).onset));
            fdb2_wintrials_mean(i).onset=fdb2_wintrials(i).onset;
            fdb2_wintrials_mean(i).dur=fdb2_wintrials(i).dur;


            fdb2_losstrials(i).onset=data(ss).TR_feedback2(data(ss).correct==0&blkidx);
            fdb2_losstrials(i).value=data(ss).diff(data(ss).correct==0&blkidx);
            fdb2_losstrials(i).value=fdb2_losstrials(i).value-mean(fdb2_losstrials(i).value);
            fdb2_losstrials(i).dur=zeros(size(fdb2_losstrials(i).onset));

            fdb2_losstrials_mean(i).value=ones(size(fdb2_losstrials(i).onset));
            fdb2_losstrials_mean(i).onset=fdb2_losstrials(i).onset;
            fdb2_losstrials_mean(i).dur=fdb2_losstrials(i).dur;

            fdb2_drawtrials(i).onset=data(ss).TR_feedback2(data(ss).correct==0.5&blkidx);
            fdb2_drawtrials(i).value=ones(size(fdb2_drawtrials(i).onset));
            fdb2_drawtrials(i).dur=zeros(size(fdb2_drawtrials(i).onset));
            
            fdb3(i).onset=data(ss).TR_ITI(blkidx)-1;%fdb3 were presented for 1s
            fdb3(i).value=ones(size(fdb3(i).onset));
            fdb3(i).dur=zeros(size(fdb3(i).onset));
            
            



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

            resp(i).onset=data(ss).TR_choice(blkidx);
            resp(i).value=(data(ss).resp(blkidx)-1.5)*2;
            resp(i).value=resp(i).value-mean(resp(i).value);
            resp(i).dur=zeros(size(resp(i).onset));


        %regressor 2: the reaction time (demean)

            RT(i).onset=data(ss).TR_choice(blkidx);
            RT(i).value=data(ss).rt(blkidx);
            RT(i).value=RT(i).value-mean(RT(i).value);
            RT(i).dur=resp(i).dur;



    %regressior 3: trial-by-trial decision(1 for switch, -1 for stay (leave out the first choice in each block, and those choice not made))\

            storeswi=ones(length(data(ss).choice),1)*nan;
            storeswi(2:end,1)=data(ss).choice(2:end)-data(ss).choice(1:end-1);
            storeswi(storeswi~=0&~isnan(storeswi))=1;
            storeswi(storeswi==0)=-1;
            storeswi(1:tn:240)=nan;


            ifswitch(i).onset=data(ss).TR_choice(~isnan(storeswi)&blkidx);
            ifswitch(i).value=storeswi(~isnan(storeswi)&blkidx);
            ifswitch(i).dur=zeros(size(ifswitch(i).onset));


            %demean
            ifswitch(i).value=ifswitch(i).value-mean(ifswitch(i).value);


            ch_const(i).onset=data(ss).TR_choice(blkidx);
            ch_const(i).value=ones(size(ch_const(i).onset));
            ch_const(i).dur=zeros(size(ch_const(i).onset));

    %% write txt files for each regressor
      mkdir([basedir,'EVfiles/GLM1/',data(ss).subnum]);
      warning('off', 'MATLAB:MKDIR:DirectoryExists');  
            %@choice
            resptmp=[resp(i).onset resp(i).dur resp(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/1_response_',blkname{i},'.txt'],'resptmp','-ascii');

            RTtmp=[RT(i).onset RT(i).dur RT(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/2_reactiontime_',blkname{i},'.txt'],'RTtmp','-ascii');

            ch_consttmp=[ch_const(i).onset ch_const(i).dur ch_const(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/3_ch_const_',blkname{i},'.txt'],'ch_consttmp','-ascii');
            %@outcome
            fdb1tmp=[fdb1(i).onset fdb1(i).dur fdb1(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/4_feedback1_',blkname{i},'.txt'],'fdb1tmp','-ascii');

            fdb2_wintrialstmp=[fdb2_wintrials(i).onset fdb2_wintrials(i).dur fdb2_wintrials(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/5_win_mag_',blkname{i},'.txt'],'fdb2_wintrialstmp','-ascii');    

            fdb2_wintrials_meantmp=[fdb2_wintrials_mean(i).onset fdb2_wintrials_mean(i).dur fdb2_wintrials_mean(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/6_win_mean_',blkname{i},'.txt'],'fdb2_wintrials_meantmp','-ascii');   

            fdb2_losstrialstmp=[fdb2_losstrials(i).onset fdb2_losstrials(i).dur fdb2_losstrials(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/7_loss_mag_',blkname{i},'.txt'],'fdb2_losstrialstmp','-ascii');    

            fdb2_losstrials_meantmp=[fdb2_losstrials_mean(i).onset fdb2_losstrials_mean(i).dur fdb2_losstrials_mean(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/8_loss_mean_',blkname{i},'.txt'],'fdb2_losstrials_meantmp','-ascii');  

            fdb2_drawtrials_meantmp=[fdb2_drawtrials(i).onset fdb2_drawtrials(i).dur fdb2_drawtrials(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/9_draws_',blkname{i},'.txt'],'fdb2_drawtrials_meantmp','-ascii'); 
            
            fdb3tmp=[fdb3(i).onset fdb3(i).dur fdb3(i).value];
            save([basedir,'EVfiles/GLM1/',data(ss).subnum,'/10_feedback3_',blkname{i},'.txt'],'fdb3tmp','-ascii');

    %% Make the hrf and plot the corr matrix
    names_regressor={'Response','Reaction time','Choice constant','feedback1','win trials magnitude','win trials mean','loss trials magnitude', 'loss trial mean','draws','feedback3'};

         endtime=data(ss).TR_ITI(tn*i,1);
         tmpR=cal_design_matrix(endtime,resp(i),RT(i),ch_const(i),fdb1(i),fdb2_wintrials(i),fdb2_wintrials_mean(i),fdb2_losstrials(i),fdb2_losstrials_mean(i),fdb2_drawtrials(i),fdb3(i));
         R(is,i,:,:)=tmpR;

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

        saveas(f1,[basedir,'EVfiles/GLM1/',data(ss).subnum,'/designmatrix_',blkname{i},'.png'])
          end

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

        saveas(f2,[basedir,'EVfiles/GLM1/max_designmatrix_',blkname{i},'.png'])
    end
