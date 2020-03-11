%% Summary plots from multiple analyses of behavioral performance
% run this after running start_beh

clearvars;
close all;

%% setup path and plotting formats

sucrose_setPathList;

setup_figprop;  %set up default figure plotting parameters

disp('Summary of behavioral data:');

%% which set of data to load?
m=4;

switch m
    case 4  % Load the data set from CSDS (only baseline days from both control and stress data)
        data_subdir = fullfile(data_dir,'CSDS');
        [ dirs, expData ] = expData_CSDS_baseline(data_subdir);
        suppressFigs = true; %do not plot anything (only save the analysis results)
        
    case 11  % Load the data set, replace sucrose with sucralose
        data_subdir = fullfile(data_dir,'Sucralose');
        [ dirs, expData ] = expData_sucralose(data_subdir);
        suppressFigs = true; %do not plot anything (only save the analysis results)
        
end

%% collect analysis results
for i = 1:numel(expData)
    
    if isfield(expData(i),'onefolder')   %all the log files saved in one folder
        temp = sprintf('%04d',i);
        cd(fullfile(dirs.analysis,expData(i).sub_dir,temp));
    else
        cd(fullfile(dirs.analysis,expData(i).sub_dir));
    end
    
    load(['beh.mat']);
    
    subject{i}=sessionData.subject;
    beh_block_array{i}=beh_block;
    suc_stat_array{i}=suc_stat;
    suc_lick_array{i}=suc_lick;
    suc_boutconsumlick_array{i} = suc_boutconsumlick;
    
end

%% make summary plots
savebehfigpath = fullfile(dirs.summary,'figs-beh');
if ~exist(savebehfigpath,'dir')
    mkdir(savebehfigpath);
end

cd(savebehfigpath);
standard_plotparams.colors={[0 0 0],[0.33 0 0.33],[0.66 0 0.66],[1 0 1]};  %colors associated with block type
standard_plotparams.gray=[0.7 0.7 0.7];
standard_plotparams.symbols={'o','v','^','d'};                             %symbols associated with block type
standard_plotparams.tlabel = strcat('Group summary, n=',int2str(numel(expData)));

%% analyze performance by reward type

% plot number of actions by block
plotparams=standard_plotparams;
plotparams.nBlock = 60;   %plot up to the 60th block
plotparams.fitModel = false;
plot_sucrose_blocks(beh_block_array,plotparams);

%% summarize performance
plot_sucrose_stats(suc_stat_array,standard_plotparams);

%% analyze lick rate by reward type
plotparams = standard_plotparams;
plotparams.xtitle = 'Time from reinforcement (s)';
plot_sucrose_licks(suc_lick_array,plotparams);

%% analyze consummatory licks
plotparams.xtitle = {'Consummatory licks per reward'};
plot_bout_timing(suc_boutconsumlick_array,plotparams);
print(gcf,'-dpng','bout_consumlick');    %png format
saveas(gcf, 'bout_consumlick', 'fig');

%% plays sound when done
load train;
sound(y,Fs);