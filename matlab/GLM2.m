%% 
clear all; 
clc;
%%

basedir='F:\2023_Peking_DRL\';
datadir=[basedir,'raw_data'];
cd([basedir,'code/matlab']);
load([basedir,'code/matlab/model_results_6blks.mat'])
%% read in behavior and questionnaire data
tn=30;
blkname={'BHBL1','BHBL2','BHNL','NHBL','BHNH1','BHNH2','BLNL1','BLNL2'};
%%
        
is=0;
for ss=1:size(data,2)
    %%   

            chosen=data(ss).choice==1;
            order=data(ss).order==2;%original order code:order=1:opt2 shown first;order=2:opt1 shown first.here true for opt1 first.
            %% calculate EVs for each option for each participant
            poslr=ee.PNPE.mean_alpha_pos(ss);
            neglr=ee.PNPE.mean_alpha_neg(ss);
            opt1_out=data(ss).opt1_out;
            opt2_out=data(ss).opt2_out;
            opt1_EVs=zeros(size(opt1_out));
            opt2_EVs=zeros(size(opt2_out));
            for i=1:length(opt1_out)
                if mod(i,tn)==1
                    opt1_EVs(i)=7;
                    opt2_EVs(i)=7;
                else
                    if opt1_out(i-1)>opt1_EVs(i-1)
                        opt1_EVs(i)=opt1_EVs(i-1)+poslr*(opt1_out(i-1)-opt1_EVs(i-1));                    
                    else
                        opt1_EVs(i)=opt1_EVs(i-1)+neglr*(opt1_out(i-1)-opt1_EVs(i-1));
                    end
                    if opt2_out(i-1)>opt2_EVs(i-1)
                        opt2_EVs(i)=opt2_EVs(i-1)+poslr*(opt2_out(i-1)-opt2_EVs(i-1));                    
                    else
                        opt2_EVs(i)=opt2_EVs(i-1)+neglr*(opt2_out(i-1)-opt2_EVs(i-1));
                    end
                end
            end
            
            fd1_chosen=chosen&order|~chosen&~order;%option1 were present first and chosen or option2were present first and not chosen
            fd2_chosen=~chosen&order|chosen&~order;
            aa=[fd1_chosen,fd2_chosen];
            fdb_chosen=reshape(aa',[size(aa,1)*size(aa,2),1]);
            aa=[data(ss).TR_feedback1,data(ss).TR_feedback2];
            fdb_TR=reshape(aa',[size(aa,1)*size(aa,2),1]);
            opt1_PEs=opt1_out-opt1_EVs;
            opt2_PEs=opt2_out-opt2_EVs;
            fd1_PEs=opt1_PEs;
            fd1_PEs(~order)=opt2_PEs(~order);
            fd2_PEs=opt2_PEs;
            fd2_PEs(~order)=opt1_PEs(~order);
            aa=[fd1_PEs,fd2_PEs];
            fdb_PEs=reshape(aa',[size(aa,1)*size(aa,2),1]);
            
            
            for i=1:length(blkname)                
                %%
                %outcome
                bb=data(ss).blockN==i;
                aa=repmat(bb,[tn,1]);
                blkidx=reshape(aa,[size(aa,1)*size(aa,2),1]);
                aa=repmat(bb,[tn*2,1]);
                blkidx2=reshape(aa,[size(aa,1)*size(aa,2),1]);

                refpoint=0;

                %where cards>refpoint were chosen
                chosen_PPE(i).onset=fdb_TR(blkidx2&fdb_chosen&fdb_PEs>refpoint);
                chosen_PPE(i).value=fdb_PEs(blkidx2&fdb_chosen&fdb_PEs>refpoint);
                chosen_PPE(i).value=chosen_PPE(i).value-mean(chosen_PPE(i).value);
                chosen_PPE(i).dur=zeros(size(chosen_PPE(i).onset));

                mean_chosen_PPE(i).onset=chosen_PPE(i).onset;
                mean_chosen_PPE(i).value=ones(size(chosen_PPE(i).onset));
                mean_chosen_PPE(i).dur=zeros(size(chosen_PPE(i).onset));

                %where cards<refpoint were chosen (higher more negtive)
                chosen_NPE(i).onset=fdb_TR(blkidx2&fdb_chosen&fdb_PEs<refpoint);
                chosen_NPE(i).value=fdb_PEs(blkidx2&fdb_chosen&fdb_PEs<refpoint);
                chosen_NPE(i).value=-chosen_NPE(i).value-mean(-chosen_NPE(i).value);
                chosen_NPE(i).dur=zeros(size(chosen_NPE(i).onset));

                mean_chosen_NPE(i).onset=chosen_NPE(i).onset;
                mean_chosen_NPE(i).value=ones(size(chosen_NPE(i).onset));
                mean_chosen_NPE(i).dur=zeros(size(chosen_NPE(i).onset));


                %where cards>refpoint were not chosen
                unchosen_PPE(i).onset=fdb_TR(blkidx2&~fdb_chosen&fdb_PEs>refpoint);
                unchosen_PPE(i).value=fdb_PEs(blkidx2&~fdb_chosen&fdb_PEs>refpoint);
                unchosen_PPE(i).value=unchosen_PPE(i).value-mean(unchosen_PPE(i).value);
                unchosen_PPE(i).dur=zeros(size(unchosen_PPE(i).onset));

                mean_unchosen_PPE(i).onset=unchosen_PPE(i).onset;
                mean_unchosen_PPE(i).value=ones(size(unchosen_PPE(i).onset));
                mean_unchosen_PPE(i).dur=zeros(size(unchosen_PPE(i).onset));

                %where cards<refpoint were not chosen
                unchosen_NPE(i).onset=fdb_TR(blkidx2&~fdb_chosen&fdb_PEs<refpoint);
                unchosen_NPE(i).value=fdb_PEs(blkidx2&~fdb_chosen&fdb_PEs<refpoint);
                unchosen_NPE(i).value=-unchosen_NPE(i).value-mean(-unchosen_NPE(i).value);
                unchosen_NPE(i).dur=zeros(size(unchosen_NPE(i).onset));

                mean_unchosen_NPE(i).onset=unchosen_NPE(i).onset;
                mean_unchosen_NPE(i).value=ones(size(unchosen_NPE(i).onset));
                mean_unchosen_NPE(i).dur=zeros(size(unchosen_NPE(i).onset));
                
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

            % @choice onset
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



      
                ch_const(i).onset=data(ss).TR_choice(blkidx);
                ch_const(i).value=ones(size(ch_const(i).onset));
                ch_const(i).dur=zeros(size(ch_const(i).onset));

        % write txt files for each regressor
          mkdir([basedir,'EVfiles/GLM2_3/',data(ss).subnum]);
          warning('off', 'MATLAB:MKDIR:DirectoryExists');  
                %@choice
                resptmp=[resp(i).onset resp(i).dur resp(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/1_response_',blkname{i},'.txt'],'resptmp','-ascii');

                RTtmp=[RT(i).onset RT(i).dur RT(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/2_reactiontime_',blkname{i},'.txt'],'RTtmp','-ascii');

                ch_consttmp=[ch_const(i).onset ch_const(i).dur ch_const(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/3_ch_const_',blkname{i},'.txt'],'ch_consttmp','-ascii');
                %@outcome
                chosen_PPEtmp=[chosen_PPE(i).onset chosen_PPE(i).dur chosen_PPE(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/4_chosen_PPE_',blkname{i},'.txt'],'chosen_PPEtmp','-ascii');

                mean_chosen_PPEtmp=[mean_chosen_PPE(i).onset mean_chosen_PPE(i).dur mean_chosen_PPE(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/5_mean_chosen_PPE_',blkname{i},'.txt'],'mean_chosen_PPEtmp','-ascii');

                chosen_NPEtmp=[chosen_NPE(i).onset chosen_NPE(i).dur chosen_NPE(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/6_chosen_NPE',blkname{i},'.txt'],'chosen_NPEtmp','-ascii');    

                mean_chosen_NPEtmp=[mean_chosen_NPE(i).onset mean_chosen_NPE(i).dur mean_chosen_NPE(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/7_mean_chosen_NPE',blkname{i},'.txt'],'mean_chosen_NPEtmp','-ascii');   

                unchosen_PPEtmp=[unchosen_PPE(i).onset unchosen_PPE(i).dur unchosen_PPE(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/8_unchosen_PPE_',blkname{i},'.txt'],'unchosen_PPEtmp','-ascii');

                mean_unchosen_PPEtmp=[mean_unchosen_PPE(i).onset mean_unchosen_PPE(i).dur mean_unchosen_PPE(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/9_mean_unchosen_PPE_',blkname{i},'.txt'],'mean_unchosen_PPEtmp','-ascii');

                unchosen_NPEtmp=[unchosen_NPE(i).onset unchosen_NPE(i).dur unchosen_NPE(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/10_unchosen_NPE',blkname{i},'.txt'],'unchosen_NPEtmp','-ascii');    

                mean_unchosen_NPEtmp=[mean_unchosen_NPE(i).onset mean_unchosen_NPE(i).dur mean_unchosen_NPE(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/11_mean_unchosen_NPE',blkname{i},'.txt'],'mean_unchosen_NPEtmp','-ascii');   
                
                fdb3tmp=[fdb3(i).onset fdb3(i).dur fdb3(i).value];
                save([basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/12_feedback3_',blkname{i},'.txt'],'fdb3tmp','-ascii');


        % Make the hrf and plot the corr matrix
        names_regressor={'Response','Reaction time','Choice constant',...
            'chosen PPE','mean chosen PPE','chosen NPE','mean chosen NPE',...
            'unchosen PPE','mean unchosen PPE','unchosen NPE','mean unchosen NPE','feedback3'};

             endtime=data(ss).TR_ITI(tn*i,1);
             tmpR=cal_design_matrix(endtime,resp(i),RT(i),ch_const(i),...
                 chosen_PPE(i),mean_chosen_PPE(i),chosen_NPE(i),mean_chosen_NPE(i),...
                 unchosen_PPE(i),mean_unchosen_PPE(i),unchosen_NPE(i),mean_unchosen_NPE(i),fdb3(i));
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

            saveas(f1,[basedir,'EVfiles/GLM2_3/',data(ss).subnum,'/designmatrix_',blkname{i},'.png'])
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
    
    saveas(f2,[basedir,'EVfiles/GLM2_3/max_designmatrix_',blkname{i},'.png'])
end