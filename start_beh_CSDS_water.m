%% Summary plots from many analyses of behavioral performance
% run this after running start_beh

clearvars;
close all;

%% setup path and plotting formats

sucrose_setPathList;

setup_figprop;  %set up default figure plotting parameters

disp('Summary of CSDS - water only:');

%% load data

j = 1;
for k=1:1
    switch k
        case 1  %load stress
            disp('----- loading stressed -----');
            data_subdir = fullfile(data_dir,'CSDS_water');
            [ dirs, expData ] = expData_CSDS_water(data_subdir);
    end
    
    for i = 1:numel(expData)
        disp(['Loading file ' int2str(i) '/' int2str(numel(expData)) '.']);

        if isfield(expData(i),'onefolder')   %all the log files saved in one folder
            temp = sprintf('%04d',i);
            cd(fullfile(dirs.analysis,expData(i).sub_dir,temp));
        else
            cd(fullfile(dirs.analysis,expData(i).sub_dir));
        end
        load('beh.mat');
        
        fileinfo(j) = expData(i);
        cond(j) = k;    %0 = control; 1 = muscimol
        subject{j}=sessionData.subject;
        expdate(j)=datenum(sessionData.dateTime{1},'mm/dd/yyyy');
        beh_block_array{j} = beh_block;
        block_fit_array{j} = block_fit;
        stat_array{j} = suc_stat;
        j = j + 1;  %advance counter
        
        clearvars -except i j k data_dir dirs expData ...
            fileinfo cond subject expdate beh_block_array block_fit_array stat_array;
    end
end

%% make summary plots
savebehfigpath = fullfile(dirs.summary,'figs-beh');
savematpath = fullfile(dirs.summary,'figs-beh');
if ~exist(savebehfigpath,'dir')
    mkdir(savebehfigpath);
end

cd(savebehfigpath);

%% group by subject
%manual adjustments of subject name (sometimes when experimenter use wrong capitalization or
%another variation to name the subject)
[subject_mod, expdate_mod] = correctname_M2_CSDS_water(subject, expdate);

%organize the experiment information for each subject
roundAcqDate = 2;  %rounding up the day # of the imaging session
subj_info = groupbysubject(subject_mod,expdate_mod,cond,roundAcqDate);
subj_info.condlabel = {'Control','Stressed'};

%diagnostic plot to see what subject/date data we have
batchSize=20; %plot in batches of subjects
plot_subjectday(subj_info, subj_info.acqdate, batchSize);

%% plot number of fixed-ratio actions completed as function of days
standard_days_params = [];
standard_days_params.stressDays = [2 11];
standard_days_params.daysForBarPlot = {[1 3],[7 9 11],[13 15]}; %day 1/3 of stress, day 7/9 of stress, day 11/13
standard_days_params.barlabels = {'Day -1/1','Day 5/7/9','Day 11/13'};
standard_days_params.stress_shade=[1 0.9 0.9];   %color for shaded area denoting chronic stress period
standard_days_params.maxDay = 16; % only plot data up to this day (because beyond this date, do not have as much data)

params = standard_days_params;
params.ybaseline = 201;
params.yrange1 = [0 400];
params.yrange2 = [0 500];
params.ytitle = {'Rewards earned'};
params.linelabels = {'All'};

% plot total number of fixed-ratio actions completed
temp=cell2mat(stat_array);  
plot_days_stats([temp.nFRActions]',subj_info,params);
print(gcf,'-dpng','days_actions');    %png format
saveas(gcf, 'days_actions', 'fig');

%% plot by block
standard_plotparams.colors={[0 0 0],[0 0 0],[0 0 0],[0 0 0]};       %colors associated with block type
standard_plotparams.gray=[0.7 0.7 0.7];
standard_plotparams.symbols={'o','o','o','o'};   %symbols associated with block type

plotparams = standard_plotparams;
plotparams.nBlock = 60;
plotparams.fitModel = false;  %population average smoothes out the sharp drops seen in individuals (problematic in a way similar to averaging learning rates)

mask = (subj_info.acqdate == 1);
plotparams.tlabel=['Stressed subjects on day -1 (n=' int2str(sum(mask)) '); water only'];
plot_water_blocks(beh_block_array(mask),plotparams,'-stressedDayBaseline');

mask = (subj_info.acqdate == 11);
plotparams.tlabel=['Stressed subjects on day 9 (n=' int2str(sum(mask)) '); water only'];
block_fit{11} = plot_water_blocks(beh_block_array(mask),plotparams,'-stressedDay9');

save(fullfile(savematpath,'beh.mat'),'block_fit');

%% plot model fitting summary

params = standard_days_params;
params.daysForBarPlot = {[1 3],[7 9 11],[13 15]}; %day 1/3 of stress, day 7/9 of stress, day 15/17
params.barlabels = {'Day-1/1','Day5/7/9','Day11/13'};

temp=cell2mat(block_fit_array);  
temp=[temp.xparFit];

params.ybaseline = -1;
params.yrange1 = [0 500];
params.yrange2 = [0 500];
params.ytitle = 'R_0, reward change-point';
params.linelabels = {'All'};
plot_days_stats(temp(6,:)',subj_info,params);  %plot all block types
print(gcf,'-dpng','days_fitRewardCP');    %png format
saveas(gcf, 'days_fitRewardCP', 'fig');

params.ybaseline = 1;
params.yrange1 = [0 5.2];
params.yrange2 = [0.5 3];
params.ytitle = 'c, opportunity cost coefficient';
params.linelabels = {'3% nc','3% pc','10%'};
plot_days_stats(temp(2:4,:)',subj_info,params);  %plot all block types
print(gcf,'-dpng','days_fitc10');    %png format
saveas(gcf, 'days_fitc10', 'fig');

%% plot model fitting summary

params = standard_days_params;
params.daysForBarPlot = {[1 3],[7 9 11],[13 15]}; %day 1/3 of stress, day 7/9 of stress, day 15/17
params.barlabels = {'Day-1/1','Day5/7/9','Day11/13'};

temp=cell2mat(block_fit_array);  
temp=[temp.xparFit];

%median = 0.7733
disp(['Grand median for the alpha parameter = ' num2str(nanmedian(temp(5,:)))]); 

%% plays sound when done
load train;
sound(y,Fs);