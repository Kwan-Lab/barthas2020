%% Analyze behavioral performance of self-paced sucrose drinking task

clearvars;
close all;

tic;    %set clock to estimate how long this takes

%% setup path and plotting formats

sucrose_setPathList;

setup_figprop;  %set up default figure plotting parameters

%% which set of data to load?

m=1;

switch m        
    case 1  % Load the data set from CSDS (stress)
        data_subdir = fullfile(data_dir,'CSDS');
        [ dirs, expData ] = expData_CSDS_stress(data_subdir);
        suppressFigs = true; %do not plot anything (only save the analysis results)
    case 2  % Load the data set from CSDS (control)
        data_subdir = fullfile(data_dir,'CSDS');
        [ dirs, expData ] = expData_CSDS_control(data_subdir);
        suppressFigs = true; %do not plot anything (only save the analysis results)
        
    case 4  % Load the data set from CSDS (only baseline days from both control and stress data)
        data_subdir = fullfile(data_dir,'CSDS');
        [ dirs, expData ] = expData_CSDS_baseline(data_subdir);
        suppressFigs = true; %do not plot anything (only save the analysis results)
        
    case 5  % Load the data set from CSDS (stress, only water solution)
        data_subdir = fullfile(data_dir,'CSDS_water');
        [ dirs, expData ] = expData_CSDS_water(data_subdir);
        suppressFigs = true; %do not plot anything (only save the analysis results)
                
    case 11  % Load the data set, replace sucrose with sucralose
        data_subdir = fullfile(data_dir,'Sucralose');
        [ dirs, expData ] = expData_sucralose(data_subdir);
        suppressFigs = true; %do not plot anything (only save the analysis results)

    case 21  % Load the data set from CSDS + imaging of spontaneous activity (stress)
        data_subdir = fullfile(data_dir,'M2spon_CSDS');
        [ dirs, expData ] = expData_M2spon_stress(data_subdir);
        suppressFigs = true; %do not plot anything (only save the analysis results)
    case 22  % Load the data set from CSDS + imaging of spontaneous activity (control)
        data_subdir = fullfile(data_dir,'M2spon_CSDS');
        [ dirs, expData ] = expData_M2spon_control(data_subdir);
        suppressFigs = true; %do not plot anything (only save the analysis results)

end

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
    sepType={'0%','3% nc','3% pc','10%'};
    
    % standard plotting parameters that are common to all figures
    standard_plotparams.colors={[0 0 0],[0.33 0 0.33],[0.66 0 0.66],[1 0 1]};  %colors associated with block type
    standard_plotparams.gray=[0.7 0.7 0.7];
    standard_plotparams.symbols={'o','v','^','d'};                             %symbols associated with block type
    standard_plotparams.tlabel=strcat('Subject=',char(logData.subject),', Time=',char(logData.dateTime(1)),'-',char(logData.dateTime(2)));
    
    %% analyze the basics of the behavior
    
    % plot behavior in raw format
    % plotparams = standard_plotparams;
    % plotparams.time_range = [-8 60];  %for each block, plot from -8 s to 60 s after onset of block
    % plotparams.batchSize = 60;        %plot in batches of blocks
    % plot_sucrose_beh_vert(sessionData,blocks,plotparams);
    
    % analyze licking behavior
    plotparams = standard_plotparams;
    suc_sessionTime = plot_sucrose_beh_horz(sessionData,blocks,plotparams);
    
    % save the analysis so can summarize the population results later
    save(fullfile(savematpath,'beh.mat'),...
        'suc_sessionTime','-append');
    
    %% stop further analysis if animal did not perform enough blocks
    
    % if animal performed less than 4 blocks, not meaningful to characterize
    % sucrose preference, and other performance metrics
    if numel(blocks.reward)<4
        disp('ERROR -- Animals completed less than 4 blocks, and did not sample all the reinforcement types.');
        continue;
    end
    
    %% analyze performance by reward type
    
    % plot number of actions by block
    plotparams = standard_plotparams;
    plotparams.nBlock = 60;   %plot up to the 60th block
    plotparams.fitModel = true;   %fit to opportunity cost model?
    beh_block = sucrose_blocks(blocks,sepType);
    
    if m==19 %water-only experiment
        plotparams.colors={[0 0 0],[0 0 0],[0 0 0],[0 0 0]};       %colors associated with block type
        plotparams.gray=[0.7 0.7 0.7];
        plotparams.symbols={'o','o','o','o'};   %symbols associated with block type
        plotparams.fitModel = true;
        block_fit = plot_water_blocks(beh_block,plotparams);
    elseif m==11 || m==12 %stress/control behavior
        plotparams.fitModel = true;
        block_fit = plot_sucrose_blocks(beh_block,plotparams);
    else
        block_fit = plot_sucrose_blocks(beh_block,plotparams);
    end
    
    %% summarize performance
    plotparams = standard_plotparams;
    suc_stat=sucrose_stats(blocks,sepType);
    % plot_sucrose_stats(suc_stat,plotparams);
    
    % analyze lick density by reward type
    plotparams = standard_plotparams;
    plotparams.edges=[-10:0.2:10]';   % params.edges to plot the lick rate histogram
    plotparams.trigTime = bouts.startTimes + bouts.timeToReward;
    plotparams.xtitle = 'Time from reinforcement (s)';
    suc_lick=sucrose_licks(sessionData,bouts.rewardType,sepType,plotparams.trigTime,plotparams.edges);
    if ~exist('suppressFigs','var')
        plot_sucrose_licks(suc_lick,plotparams);
    end
    
    save(fullfile(savematpath,'beh.mat'),...
        'beh_block','block_fit','suc_stat','suc_lick','-append');
    
    %% analyze number of motivational vs consummatory licks
    % (number of licks before and after reward in a bout)
    % do not include bout if it spans more than 1 reward)
    
    plotparams = standard_plotparams;
    plotparams.edges = [0:1:40]';   %edges to plot the lick number histogram
    plotparams.xtitle = {'Number of consummatory licks';'[from reinforcement to end of bout]'};
    suc_boutconsumlick=bout_timing(bouts.numLickAfterReward,bouts.rewardType,sepType,plotparams);
    if ~exist('suppressFigs','var')
        plot_bout_timing(suc_boutconsumlick,plotparams);
    end
    
    % save the analysis so can summarize the population results later
    save(fullfile(savematpath,'beh.mat'),...
        'suc_boutconsumlick','-append');
        
    close all;
    clearvars -except i dirs expData expParam suppressFigs m;
end

% plays sound when done
load train;
sound(y,Fs);

toc