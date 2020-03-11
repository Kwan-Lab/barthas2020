%% Summary plots from multiple analyses of behavioral performance
% run this after running start_beh

clearvars;
close all;

%% setup path and plotting formats

sucrose_setPathList;

setup_figprop;  %set up default figure plotting parameters

disp('Summary of behavioral data:');

%% which set of data to load?
data_subdir = fullfile(data_dir,'Randomized');
[ dirs, expData ] = expData_randomized(data_subdir);

%% collect analysis results
for i = 1:numel(expData)
    
    if isfield(expData(i),'onefolder')   %all the log files saved in one folder
        temp = sprintf('%04d',i);
        cd(fullfile(dirs.analysis,expData(i).sub_dir,temp));
    else
        cd(fullfile(dirs.analysis,expData(i).sub_dir));
    end
    
    load(['beh.mat']);
    
    suc_lick_array{i}=suc_lick;
    suc_boutconsumlick_array{i} = suc_boutconsumlick;
    
end

%% make summary plots
savebehfigpath = fullfile(dirs.summary,'figs-beh');
if ~exist(savebehfigpath,'dir')
    mkdir(savebehfigpath);
end

cd(savebehfigpath);
standard_plotparams.colors={[0 0 0],[0.66 0 0.66],[1 0 1]};  %colors associated with block type
standard_plotparams.gray=[0.7 0.7 0.7];
standard_plotparams.symbols={'o','^','d'};                             %symbols associated with block type
standard_plotparams.tlabel = strcat('Group summary, n=',int2str(numel(expData)));

%% analyze lick rate by reward type
plotparams = standard_plotparams;
plotparams.xtitle = 'Time from reinforcement (s)';
plot_sucrose_licks(suc_lick_array,plotparams);

%%
plotparams = standard_plotparams;
plotparams.xtitle = {'Consummatory licks per reward'};
plot_bout_timing(suc_boutconsumlick_array,plotparams);
print(gcf,'-dpng','bout_consumlick');    %png format
saveas(gcf, 'bout_consumlick', 'fig');

%% plays sound when done
load train;
sound(y,Fs);