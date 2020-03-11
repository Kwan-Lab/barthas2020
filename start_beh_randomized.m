%% Analyze behavioral performance of self-paced sucrose drinking task
% special case: randomized rewards

clearvars;
close all;

tic;    %set clock to estimate how long this takes

%% setup path and plotting formats

sucrose_setPathList;

setup_figprop;  %set up default figure plotting parameters

%% which set of data to load?
data_subdir = fullfile(data_dir,'Randomized');
[ dirs, expData ] = expData_randomized(data_subdir);

%% process data files
for i = 1:numel(expData)
        
    disp(['--- Processing file ' int2str(i) '/' int2str(numel(expData)) '.']);
    disp([expData(i).sub_dir ' - ' expData(i).logfile]);
    
    % setup/create subdirectories to save analysis and figures
    if isfield(expData(i),'onefolder')   %all the log files saved in one folder
        temp = sprintf('%04d',i);
        savematpath = fullfile(dirs.analysis,expData(i).sub_dir,temp);
        savebehfigpath = fullfile(dirs.analysis,expData(i).sub_dir,temp,'figs-beh');
    else
        savematpath = fullfile(dirs.analysis,expData(i).sub_dir);
        savebehfigpath = fullfile(dirs.analysis,expData(i).sub_dir,'figs-beh');
    end
    
    if ~exist(savematpath,'dir')
        mkdir(savematpath);
    end
    if ~exist(savebehfigpath,'dir')
        mkdir(savebehfigpath);
    end
    
    % parse the presentation log file
    [ logData ] = parseLogfile( fullfile(dirs.data,expData(i).sub_dir), expData(i).logfile );
    
    % break the parsed data into trials (each trial is a lick bout)
    [ sessionData ] = sucrose_getSessionData( logData );
    
    % identify the reward blocks
    [ blocks ] = sucrose_getBlockData( sessionData );
    
    % identify the lick bouts
    [ bouts ] = sucrose_getBoutData ( sessionData, blocks );
    
    % save the analysis so can summarize the population results later
    temp = sprintf('%03d',i);   %add number to distinguish between beh.mat, allows for multiple log files stored in same folder
    save(fullfile(savematpath,'beh.mat'),...
        'logData','sessionData','bouts','blocks');
    
    %% setup analysis and plotting parameters
    cd(savebehfigpath);
    
    % all the analysis breaks down situation by reward blocks
    sepType={3 4 5};
    
    % standard plotting parameters that are common to all figures
    standard_plotparams.colors={[0 0 0],[0.66 0 0.66],[1 0 1]};  %colors associated with block type
    standard_plotparams.gray=[0.7 0.7 0.7];
    standard_plotparams.symbols={'o','^','d'};                             %symbols associated with block type
    standard_plotparams.tlabel=strcat('Subject=',char(logData.subject),', Time=',char(logData.dateTime(1)),'-',char(logData.dateTime(2)));
        
    %% summarize performance
    
    % analyze lick density by reward type
    plotparams = standard_plotparams;
    plotparams.edges=[-10:0.2:10]';   % params.edges to plot the lick rate histogram
    plotparams.trigTime = bouts.startTimes + bouts.timeToReward;
    plotparams.xtitle = 'Time from reinforcement (s)';
    suc_lick=sucrose_licks(sessionData,bouts.reward,sepType,plotparams.trigTime,plotparams.edges);
    plot_sucrose_licks(suc_lick,plotparams);
            
    %% analyze number of motivational vs consummatory licks
    % (number of licks before and after reward in a bout)
    % do not include bout if it spans more than 1 reward)
    
    plotparams = standard_plotparams;
    plotparams.edges = [0:1:40]';   %edges to plot the lick number histogram
    plotparams.xtitle = {'Number of consummatory licks';'[from reinforcement to end of bout]'};
    suc_boutconsumlick=bout_timing(bouts.numLickAfterReward,bouts.reward,sepType,plotparams);
    if ~exist('suppressFigs','var')
        plot_bout_timing(suc_boutconsumlick,plotparams);
    end
    
    % save the analysis so can summarize the population results later
    save(fullfile(savematpath,'beh.mat'),...
        'suc_lick','suc_boutconsumlick');
        
    close all;
    clearvars -except i dirs expData expParam suppressFigs m;
end

% plays sound when done
load train;
sound(y,Fs);

toc