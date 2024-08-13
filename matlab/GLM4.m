%% 
 clear all; 
 clc;
%%

basedir='F:\2023_Peking_DRL\';
datadir=[basedir,'raw_data'];
cd([basedir,'code/matlab']);
%load([datadir,'\beh_data.mat'])
load([basedir,'code/matlab/model_results.mat'])
%% read in behavior and questionnaire data
tn=30;
blkname={'BHNH1','BHNH2','BLNL1','BLNL2'};
%%
        
is=0;
for ss=1:size(data,2)
    %%   
    include=option_include&accuracy_include;
    if include(ss)==1
            is=is+1; 
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
                        
            opt1_PEs=opt1_out-opt1_EVs;
            opt2_PEs=opt2_out-opt2_EVs;
            
            choice_value_diff=opt1_EVs-opt2_EVs;
            choice_value_diff(~chosen)=opt2_EVs(~chosen)-opt1_EVs(~chosen); %opt1 not chosen
            
            opt1_TR=data(ss).TR_feedback1;
            opt1_TR(~order)=data(ss).TR_feedback2(~order);
            
            opt2_TR=data(ss).TR_feedback2;
            opt2_TR(~order)=data(ss).TR_feedback1(~order);
            
            for i=1:length(blkname)                
                %%
                %outcome
                bb=data(ss).blockN==i+4;
                aa=repmat(bb,[tn,1]);
                blkidx=reshape(aa,[size(aa,1)*size(aa,2),1]);

                %when opt_a/opt1 has a positive prediction errors and
                %chosen
                opt1_chosen(i).onset=opt1_TR(blkidx&chosen);
                opt1_chosen(i).value=opt1_PEs(blkidx&chosen);
                opt1_chosen(i).value=opt1_chosen(i).value-mean(opt1_chosen(i).value);
                opt1_chosen(i).dur=zeros(size(opt1_chosen(i).onset));

                mean_opt1_chosen(i).onset=opt1_chosen(i).onset;
                mean_opt1_chosen(i).value=ones(size(opt1_chosen(i).onset));
                mean_opt1_chosen(i).dur=zeros(size(opt1_chosen(i).onset));

               
                
                %when opt_a not chosen
                opt1_unchosen(i).onset=opt1_TR(blkidx&~chosen);
                opt1_unchosen(i).value=opt1_PEs(blkidx&~chosen);
                opt1_unchosen(i).value=opt1_unchosen(i).value-mean(opt1_unchosen(i).value);
                opt1_unchosen(i).dur=zeros(size(opt1_unchosen(i).onset));

                mean_opt1_unchosen(i).onset=opt1_unchosen(i).onset;
                mean_opt1_unchosen(i).value=ones(size(opt1_unchosen(i).onset));
                mean_opt1_unchosen(i).dur=zeros(size(opt1_unchosen(i).onset));


                %when opt_b  chosen
                opt2_chosen(i).onset=opt2_TR(blkidx&~chosen);
                opt2_chosen(i).value=opt2_PEs(blkidx&~chosen);
                opt2_chosen(i).value=opt2_chosen(i).value-mean(opt2_chosen(i).value);
                opt2_chosen(i).dur=zeros(size(opt2_chosen(i).onset));

                mean_opt2_chosen(i).onset=opt2_chosen(i).onset;
                mean_opt2_chosen(i).value=ones(size(opt2_chosen(i).onset));
                mean_opt2_chosen(i).dur=zeros(size(opt2_chosen(i).onset));

                
                %when opt_b  not chosen
                opt2_unchosen(i).onset=opt2_TR(blkidx&chosen);
                opt2_unchosen(i).value=opt2_PEs(blkidx&chosen);
                opt2_unchosen(i).value=opt2_unchosen(i).value-mean(opt2_unchosen(i).value);
                opt2_unchosen(i).dur=zeros(size(opt2_unchosen(i).onset));

                mean_opt2_unchosen(i).onset=opt2_unchosen(i).onset;
                mean_opt2_unchosen(i).value=ones(size(opt2_unchosen(i).onset));
                mean_opt2_unchosen(i).dur=zeros(size(opt2_unchosen(i).onset));  
                
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

                vdiff(i).onset=data(ss).TR_choice(blkidx);
                vdiff(i).value=choice_value_diff(blkidx);
                vdiff(i).value=vdiff(i).value-mean(vdiff(i).value);
                vdiff(i).dur=zeros(size(vdiff(i).onset));
                


      


     %   write txt files for each regressor
          mkdir([basedir,'EVfiles/GLM4/',data(ss).subnum]);
          warning('off', 'MATLAB:MKDIR:DirectoryExists');  
                %@choice
                resptmp=[resp(i).onset resp(i).dur resp(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/1_response_',blkname{i},'.txt'],'resptmp','-ascii');

                vdifftmp=[vdiff(i).onset vdiff(i).dur vdiff(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/2_value_diff_',blkname{i},'.txt'],'vdifftmp','-ascii');

                ch_consttmp=[ch_const(i).onset ch_const(i).dur ch_const(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/3_ch_const_',blkname{i},'.txt'],'ch_consttmp','-ascii');
                %@outcome
                opt1_chosen_tmp=[opt1_chosen(i).onset opt1_chosen(i).dur opt1_chosen(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/4_opt1_chosen',blkname{i},'.txt'],'opt1_chosen_tmp','-ascii');

                mean_opt1_chosen_tmp=[mean_opt1_chosen(i).onset mean_opt1_chosen(i).dur mean_opt1_chosen(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/5_mean_opt1_chosen',blkname{i},'.txt'],'mean_opt1_chosen_tmp','-ascii');
                
                opt1_unchosen_tmp=[opt1_unchosen(i).onset opt1_unchosen(i).dur opt1_unchosen(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/6_opt1_unchosen',blkname{i},'.txt'],'opt1_unchosen_tmp','-ascii');

                mean_opt1_unchosen_tmp=[mean_opt1_unchosen(i).onset mean_opt1_unchosen(i).dur mean_opt1_unchosen(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/7_mean_opt1_unchosen',blkname{i},'.txt'],'mean_opt1_unchosen_tmp','-ascii');

               
                opt2_chosen_tmp=[opt2_chosen(i).onset opt2_chosen(i).dur opt2_chosen(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/8_opt2_chosen',blkname{i},'.txt'],'opt2_chosen_tmp','-ascii');

                mean_opt2_chosen_tmp=[mean_opt2_chosen(i).onset mean_opt2_chosen(i).dur mean_opt2_chosen(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/9_mean_opt2_chosen',blkname{i},'.txt'],'mean_opt2_chosen_tmp','-ascii');
                
                opt2_unchosen_tmp=[opt2_unchosen(i).onset opt2_unchosen(i).dur opt2_unchosen(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/10_opt2_unchosen',blkname{i},'.txt'],'opt2_unchosen_tmp','-ascii');

                mean_opt2_unchosen_tmp=[mean_opt2_unchosen(i).onset mean_opt2_unchosen(i).dur mean_opt2_unchosen(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/11_mean_opt2_unchosen',blkname{i},'.txt'],'mean_opt2_unchosen_tmp','-ascii');

                
                fdb3tmp=[fdb3(i).onset fdb3(i).dur fdb3(i).value];
                save([basedir,'EVfiles/GLM4/',data(ss).subnum,'/12_feedback3_',blkname{i},'.txt'],'fdb3tmp','-ascii');


        % Make the hrf and plot the corr matrix
        names_regressor={'Response','value diff','Choice constant',...
            'opt1 chosen','mean opt1 chosen',...
            'opt1 unchosen','mean opt1 unchosen',...
            'opt2 chosen','mean opt2 chosen',...
            'opt2 unchosen','mean opt2 unchosen',...
            'feedback3'};

             endtime=data(ss).TR_ITI(blkidx);
             endtime=endtime(end);
             tmpR=cal_design_matrix(endtime,resp(i),vdiff(i),ch_const(i),...
                 opt1_chosen(i),mean_opt1_chosen(i),...
                 opt1_unchosen(i),mean_opt1_unchosen(i),...
                 opt2_chosen(i),mean_opt2_chosen(i),...
                 opt2_unchosen(i),mean_opt2_unchosen(i),...
                 fdb3(i));
             R(is,i,:,:)=tmpR;
             if sum(sum(isnan(tmpR)))~=0
                 display([strrep(data(ss).subnum,'_',' '),' ',strrep(blkname{i},'_',' '),'has no regressor for :',names_regressor{sum(isnan(tmpR))==length(names_regressor)}])
             end

            f1=figure;
            imagesc(tmpR);
            colorbar;

            title([strrep(blkname{i},'_',' '),': ',data(ss).subnum]);

            set(gca,'Xtick',1:length(names_regressor),'XTickLabel',[ ])
            set(gca,'Ytick',1:length(names_regressor),'YTickLabel',[ ])
            for t=1:length(names_regressor)
                text(0,t+1,names_regressor{t});
                text(t-0.4,length(names_regressor),names_regressor{t});
            end
            H=findobj(gca,'Type','text');
            set(H,'Rotation',60); % tilt

            saveas(f1,[basedir,'EVfiles/GLM4/',data(ss).subnum,'/designmatrix_',blkname{i},'.png'])
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
    
    saveas(f2,[basedir,'EVfiles/GLM4/max_designmatrix_',blkname{i},'.png'])
end