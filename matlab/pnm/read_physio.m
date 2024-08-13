clear all
clc
datadir='F:\2023_Peking_DRL\raw_data\';
pnmdir='F:\2023_Peking_DRL\physio\';
sublist=dir([datadir,'s*']);
%% experiment and physio data information
blklist={'BHBL1','BHBL2','BHNL','NHBL','BHNH1','BHNH2','BLNL1','BLNL2'};
nscanlist=readtable('volnums.txt');
blkorderlist=readtable('blkorderlist.txt');
hr_fs=400;
resp_fs=50;
puls_fs=200;
%% filter settings
resp_lp=1;
hr_lp=2;
puls_lp=2;
%%
%sub_04 only have physio data for the task and ECG file for the final blk
%lost due to recording errors.
%sub_58 don't have the pulse data, because he/she was too thin to record
%the pulse signal

for i=4:size(sublist,1)
    %%
    sublist(i).name
    physiodatadir=[datadir,sublist(i).name,'\Physio\'];
    ecgfiles=dir([physiodatadir,'Physio*_ECG*']);
    respfiles=dir([physiodatadir,'Physio*_RESP*']);
    infofiles=dir([physiodatadir,'Physio*_Info*']);
    pulsfiles=dir([physiodatadir,'Physio*_PULS*']);
    inscanlist=find(strcmp(table2array(nscanlist(:,1)),sublist(i).name));
    iblklist=find(strcmp(table2array(blkorderlist(:,1)),sublist(i).name));
    mkdir([pnmdir,sublist(i).name])    
    for b=1:8
        mkdir([pnmdir,sublist(i).name,'\',blklist{table2array(blkorderlist(iblklist,b+1))}])   
        nscan=table2array(nscanlist(inscanlist,table2array(blkorderlist(iblklist,b+1))+1));
        usepulse=strcmp(sublist(i).name,'sub_04')|strcmp(sublist(i).name,'sub_06')|strcmp(sublist(i).name,'sub_46')|strcmp(sublist(i).name,'sub_65');%use PULS only when ECG not available
        ECGn='ECG3';
        if strcmp(sublist(i).name,'sub_06')|strcmp(sublist(i).name,'sub_29')|strcmp(sublist(i).name,'sub_30')|strcmp(sublist(i).name,'sub_44')|strcmp(sublist(i).name,'sub_61')
            ECGn='ECG4';
        end
        if strcmp(sublist(i).name,'sub_13')|strcmp(sublist(i).name,'sub_14')|strcmp(sublist(i).name,'sub_24')|strcmp(sublist(i).name,'sub_53')
            ECGn='ECG2';
        end
        if strcmp(sublist(i).name,'sub_04')
            bn=b;
        else
            bn=1+b;
        end
        %ECGn='ECG1';
        %read physio info files
        dtinfo=readtable([physiodatadir,infofiles(bn).name],'VariableNamingRule','preserve');
        dtinfo(:,ismissing(dtinfo(5,:)))=[];
        %endscans(i,b,:)=[dtinfo.VOLUME(end-2),nscan]; 
        
        
        %read resp files
        dtresp=readtable([physiodatadir,respfiles(bn).name],'VariableNamingRule','preserve');
        dtresp(:,ismissing(dtresp(5,:)))=[];
        resp=table2array(dtresp(strcmp(table2array(dtresp(:,2)),'RESP'),[1 3]));        
        %read pulse files
        if usepulse
            dtpuls=readtable([physiodatadir,pulsfiles(bn).name],'VariableNamingRule','preserve');       
            dtpuls(:,ismissing(dtpuls(5,:)))=[];
            puls=table2array(dtpuls(strcmp(table2array(dtpuls(:,2)),'PULS'),[1 3]));
        else
            %read ecg files, here I only used ecg3 data because across all
            %participants ECG3 data seemed most clean after applying filtering
            dtecg=readtable([physiodatadir,ecgfiles(bn).name],'VariableNamingRule','preserve');
            dtecg(:,ismissing(dtecg(5,:)))=[];
            ecg=table2array(dtecg(strcmp(table2array(dtecg(:,2)),ECGn),[1 3]));
        end
        %% replace NANs in the data with 10th precentile (just to avoid have nans for filter and low enough to be recognised as wave peaks)           
         if ~usepulse&&sum(isnan(ecg(:,2)))>0
             ecg(isnan(ecg(:,2)),2)=prctile(ecg(:,2),10);
             display(['NANs found in ECG ',sublist(i).name,' block ',num2str(b)])
         end
         if sum(isnan(resp(:,2)))>0
             resp(isnan(resp(:,2)),2)=prctile(resp(:,2),10);
             display(['NANs found in RESP ',sublist(i).name,' block ',num2str(b)])
         end
         if usepulse&&sum(isnan(puls(:,2)))>0
             puls(isnan(puls(:,2)),2)=prctile(puls(:,2),10);
             display(['NANs found in PULS',sublist(i).name,' block ',num2str(b)])
         end
         %% apply filters
         % filter respiratory data
         [bb,aa]=butter(1,resp_lp/(resp_fs/2),'low');   
         fresp=filtfilt(bb,aa,resp(:,2)); 
         if usepulse
             % filter pulse data
             [bb,aa]=butter(1,puls_lp/(puls_fs/2),'low');
             fpuls=filtfilt(bb,aa,puls(:,2));
         else
             % filter cardiac data
             [bb,aa]=butter(1,hr_lp/(hr_fs/2),'low');
             fecg=filtfilt(bb,aa,ecg(:,2));
         end
         % plots to compared different physio signals
         figure;
         subplot(3,1,1)
         plot(ecg(2001:10000,2));hold on;plot(fecg(2001:10000),'LineWidth',2);title('ECG')
         subplot(3,1,2)
         plot(resp(251:1250,2));hold on;plot(fresp(251:1250),'LineWidth',2);title('RESP')
%          subplot(3,1,3)
%          plot(puls(1001:5000,2));hold on;plot(fpuls(1001:5000),'LineWidth',2);title('PULS')
         % plots to compare the different ECG signals(used to choose the best ECG channel)
%          figure;
%          subplot(5,1,1)
%          fecg=filtfilt(bb,aa,ecg1(:,2));
%          plot(ecg1(2001:10000,2));hold on;plot(fecg(2001:10000),'LineWidth',2);title('ECG1')
%          subplot(5,1,2)
%          fecg=filtfilt(bb,aa,ecg2(:,2));
%          plot(ecg3(2001:10000,2));hold on;plot(fecg(2001:10000),'LineWidth',2);title('ECG2')
%          subplot(5,1,3)
%          plot(puls(1001:5000,2));hold on;plot(fpuls(1001:5000),'LineWidth',2);title('PULS')
%          subplot(5,1,4)
%          fecg=filtfilt(bb,aa,ecg3(:,2));
%          plot(ecg3(2001:10000,2));hold on;plot(fecg(2001:10000),'LineWidth',2);title('ECG3')
%          subplot(5,1,5)
%          fecg=filtfilt(bb,aa,ecg4(:,2));
%          plot(ecg4(2001:10000,2));hold on;plot(fecg(2001:10000),'LineWidth',2);title('ECG4')
%          sgtitle(regexprep(sublist(i).name,'_','-'))


         %% tidy up the data and add scanner triggers       
         scan_start_time=dtinfo.ACQ_START_TICS(1);       
         if dtinfo.VOLUME(end-2)==nscan %in the physio info file volume number was counted from zero
             idx=find(diff(dtinfo.VOLUME==nscan)==1);
             scan_end_time=dtinfo.ACQ_START_TICS(idx+1)-1;
             timetags=unique(dtinfo.ACQ_START_TICS(1:idx));
         else
             idx=find(diff(dtinfo.VOLUME==nscan-1)==1);
             scan_end_time=dtinfo.ACQ_START_TICS(idx+1)+550-1;
             timetags=unique(dtinfo.ACQ_START_TICS(1:idx));
             timetags=[timetags;timetags(end-24:end)+550];
         end
         
         physio(:,1)=scan_start_time:scan_end_time;
         if size(physio,1)~=nscan*1.375*400
             display(['physio data length not matching nscan: ',sublist(i).name,' block ',num2str(b)])
         end
         physio(:,2)=ismember(physio(:,1),timetags);%mark scan trigger per slice
         physio(:,3:4)=nan;%3for RESP 4for ECG/PULS
         %RESP
         idx1=ismember(resp(:,1),physio(:,1));
         idx2=ismember(physio(:,1),resp(:,1));
         physio(idx2,3)=fresp(idx1);
       
         %interplolate nans
         nanx=isnan(physio(:,3));
         t=1:size(physio,1);
         physio(nanx,3)=interp1(t(~nanx),physio(~nanx,3),t(nanx));
         idx=find(diff(isnan(physio(:,3)))~=0);

         if length(idx)==2
             physio(1:idx(1),3)=physio(idx(1)+1,3);
             physio(idx(2)+1:end,3)=physio(idx(2),3);
         else
             if length(idx)==1
                if physio(idx,1)<median(physio(:,1))
                   physio(1:idx,3)=physio(idx+1,3); 
                else
                   physio(idx+1:end,3)=physio(idx,3);
                end
             end
          end
         
         
         %ECG or PULS
         if usepulse
             try
             idx1=ismember(puls(:,1),physio(:,1));
             idx2=ismember(physio(:,1),puls(:,1));
             physio(idx2,4)=fpuls(idx1);
             catch ME
                 for k=1:size(physio,1)                     
                     idx=find(puls(:,1)==physio(k,1));
                     if ~isempty(idx)
                         physio(k,4)=fpuls(idx(1));
                     end
                 end
             end
             %interplolate nans
             nanx=isnan(physio(:,4));
             t=1:size(physio,1);
             physio(nanx,4)=interp1(t(~nanx),physio(~nanx,4),t(nanx));
             idx=find(diff(isnan(physio(:,4)))~=0);

             if length(idx)==2
                 physio(1:idx(1),4)=physio(idx(1)+1,4);
                 physio(idx(2)+1:end,4)=physio(idx(2),4);
             else
                 if length(idx)==1
                     if physio(idx,1)<median(physio(:,1))
                        physio(1:idx,4)=physio(idx+1,4); 
                     else
                         physio(idx+1:end,4)=physio(idx,4);
                     end
                 end
             end
         else
             try
             idx1=ismember(ecg(:,1),physio(:,1));
             idx2=ismember(physio(:,1),ecg(:,1));
             physio(idx2,4)=fecg(idx1);
             catch ME
                 for k=1:size(physio,1)                     
                     idx=find(ecg(:,1)==physio(k,1));
                     if ~isempty(idx)
                         physio(k,4)=fecg(idx(1));
                     end
                 end
             end
             
             %interplolate nans
             nanx=isnan(physio(:,4));
             t=1:size(physio,1);
             physio(nanx,4)=interp1(t(~nanx),physio(~nanx,4),t(nanx));
             idx=find(diff(isnan(physio(:,4)))~=0);

             if length(idx)==2
                 physio(1:idx(1),4)=physio(idx(1)+1,4);
                 physio(idx(2)+1:end,4)=physio(idx(2),4);
             else
                 if length(idx)==1
                     if physio(idx,1)<median(physio(:,1))
                        physio(1:idx,4)=physio(idx+1,4); 
                     else
                         physio(idx+1:end,4)=physio(idx,4);
                     end
                 end
             end
         end
        

        % figure;subplot(3,1,1);plot(physio(end-5000:end,3));subplot(3,1,2);plot(physio(end-5000:end,4));subplot(3,1,3);plot(physio(end-5000:end,2));
         
        %write 
           tmp=physio(:,2:4);
           clear physio
           save([pnmdir,sublist(i).name,'\',blklist{table2array(blkorderlist(iblklist,b+1))},'\',sublist(i).name,'_',blklist{table2array(blkorderlist(iblklist,b+1))},'_physio.txt'],'tmp','-ascii');      
    end
end
