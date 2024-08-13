clear all
clc
pnmdir='F:\2023_Peking_DRL\physio\';
sublist=dir([pnmdir,'sub*']);
blklist={'BHBL1','BHBL2','BHNL','NHBL','BHNH1','BHNH2','BLNL1','BLNL2'};
%read evlist file
for i=1:length(sublist)
     disp(sublist(i).name)
     for b=1:8
        %filename=[sublist(i).name,'_',blklist{b},'_run_second_lev'];
        filename=[sublist(i).name,'_',blklist{b},'_pnm_evlist'];
        fileID=fopen([pnmdir,sublist(i).name,'\',blklist{b},'\',filename,'.txt'],'r');
        %A=fscanf(fileID,'%s %s');
        A=table;
        tline=fgetl(fileID);
        l=0;
        while ischar(tline)
            l=l+1;
            a=convertCharsToStrings(tline);
            %disp(a)
            aa=regexprep(a,'/mnt/f/2023_Peking_DRL/','/mnt/f/2023_Peking_DRL/')
            %aa=regexprep(aa,'"','')
            %disp(aa)
            A{l,1}=aa;
            tline=fgetl(fileID);
        end
        fclose(fileID);
        writetable(A,[pnmdir,sublist(i).name,'\',blklist{b},'\',filename],'WriteVariableNames',0,'QuoteStrings',0);   
     end
end