function task = read_csv_Peking_7T(datadir,sub)
%read the csv data files generated by prolific and output the information
%
datafile=dir([datadir,sub,'\Behaviour\*csv']);
data=[];
for i=1:size(datafile,1)
dt=readtable([datafile(i).folder,'\',datafile(i).name]);
dt=dt(1:end-mod(size(dt,1),30),:);
try
    dt.text_2_started=[];
    dt.text_2_stopped=[];
end
data=[data;dt];
end

task.subnum=sub;
task.choice=2-data.choice(~isnan(data.choice));%1for chosing opt1 0for chosing opt2
task.opt1pos=data.opt1pos(~isnan(data.opt1pos));
task.total_money=data.total_money(~isnan(data.total_money));
task.trialN=data.trials_thisTrialN(~isnan(data.trials_thisTrialN));
task.trial_idx=data.trials_thisIndex(~isnan(data.trials_thisIndex));
task.correctopt=data.correctopt(~isnan(data.correctopt));
task.correct=data.correct(~isnan(data.correct));
task.str_opt1_out=data.opt1_out(~cellfun('isempty',data.opt1_out));
task.str_opt2_out=data.opt2_out(~cellfun('isempty',data.opt2_out));
task.str_blockN=data.blockn(~cellfun('isempty',data.blockn));
task.chosenside=(data.feedback_pos(~isnan(data.feedback_pos))+90)/180;%90 for left -90 for right → 1 for left 0 for right
task.date=data.date{1};
task.rt=data.key_resp_choice_rt(~isnan(data.key_resp_choice_rt));

task.resp=data.key_resp_choice_keys(~isnan(data.key_resp_choice_keys));
task.order=data.order(~isnan(data.order));
task.diff=data.diff(~isnan(data.diff));
task.TR_choice=data.TR_choice(~isnan(data.TR_choice));
task.TR_monitor=data.TR_monitor(~isnan(data.TR_monitor));
task.TR_feedback1=data.TR_feedback1(~isnan(data.TR_feedback1));
task.TR_feedback2=data.TR_feedback2(~isnan(data.TR_feedback2));
task.TR_ITI=data.TR_ITI(~isnan(data.TR_ITI));

for j=1:size(task.str_opt1_out,1)
    tmp=extractAfter(extractBefore(task.str_opt1_out{j},'.png'),'pictures/');
    task.opt1_out(j,1)=str2num((tmp(1:end-1)));
    tmp=extractAfter(extractBefore(task.str_opt2_out{j},'.png'),'pictures/');
    task.opt2_out(j,1)=str2num((tmp(1:end-1)));
end

for j=1:size(task.str_blockN,1)
    if contains(task.str_blockN{j},'_myopia')
        bb(j)=str2num(extractAfter(extractBefore(task.str_blockN{j},'_myopia.csv'),'blocklist/block'));
    else
        bb(j)=str2num(extractAfter(extractBefore(task.str_blockN{j},'.csv'),'blocklist/block'));        
    end 
    task.blockN=unique(bb,'stable');
end

end

