%% Make simple plots of fluorescence data (no need to save anything)
% run this after running start_beh and start_dff_compute

clearvars;
close all;

tic;    %set clock to estimate how long this takes

%% setup path and plotting formats

sucrose_setPathList;

setup_figprop;  %set up default figure plotting parameters

%% which set of data to load?
m=22;

switch m
    case 21  % Load the data set from CSDS + imaging of spontaneous activity (stress)
        data_subdir = fullfile(data_dir,'M2spon_CSDS');
        [ dirs, expData ] = expData_M2spon_stress(data_subdir);
    case 22  % Load the data set from CSDS + imaging of spontaneous activity (control)
        data_subdir = fullfile(data_dir,'M2spon_CSDS');
        [ dirs, expData ] = expData_M2spon_control(data_subdir);

end

%% process data files
for i = 1:numel(expData)
    disp(['Processing file ' int2str(i) ' out of ' int2str(numel(expData)) '.']);
    
    % setup/create subdirectories to save analysis and figures
    if isfield(expData(i),'onefolder')   %all the log files saved in one folder
        temp = sprintf('%04d',i);
        savematpath = fullfile(dirs.analysis,expData(i).sub_dir,temp);
        savefluofigpath = fullfile(dirs.analysis,expData(i).sub_dir,temp,'figs-fluo');
    else
        savematpath = fullfile(dirs.analysis,expData(i).sub_dir);
        savefluofigpath = fullfile(dirs.analysis,expData(i).sub_dir,'figs-fluo');
    end
    
    % load the saved behavioral analysis (from start_beh.m)
    % load the saved dF/F (from start_dff_compute.m)
    cd(savematpath);
    load('dff.mat');
    
    cd(savefluofigpath);
    
    %% Plot dF/F of all the cells
    if ~isfield(cells,'dFF')
        cells.dFF = [];
        cells.t = NaN;
    end
    
    plotparams.filelabel = 'dFF';
    plot_allCells( cells, [], plotparams);
    
    %% Spike inference with the peeling algorithm
    
    %use the peeling algorithm to infer firing rate
    %load the parameters used for peeling algorithm
    cd(fullfile(code_dir,'common functions','LHPeeling'));
    load('S.mat');
    cd(savefluofigpath);
    
    cells_peeled.t = cells.t;
    cells_peeled.sessionDur=cells.t(end)-cells.t(1);                   %duration of the analysis period
    for j = 1:numel(cells.dFF)
        disp(['Applying peeling algorithm on cell #' int2str(j)]);
        dFFPrePeeled = cells.dFF{j}' * 100;   %in unit of percent, and row vectors
        [spikeInfer,dFFInfer,~] = doPeel(dFFPrePeeled,cells.frameRate,S);
        cells_peeled.spikeTimesInfer{j} = spikeInfer{:};       %times of the spikes inferred
        cells_peeled.spikeRateInfer{j} = numel(spikeInfer{:})/cells_peeled.sessionDur;  %event rate inferred (in Hz)
        cells_peeled.dFFInfer{j} = dFFInfer{:} / 100;          %deconvolved then reconvolved dF/F, /100 to match unit of dF/F
        clear spikeInfer dFFInfer;
        
        % calculate transient amplitude as a measure of whether the measurement
        % was physiological. ROI with actual cell would have large transients, whereas
        % ROI with no cell would fluctuate around median so much smallertransients
        cells_peeled.prctile{j} = [prctile(cells.dFF{j},5) prctile(cells.dFF{j},50) prctile(cells.dFF{j},95)];
    
    end
    
    plotparams.filelabel = 'dFFInfer';
    plot_allCells( cells_peeled, [], plotparams);
    
    save(fullfile(savematpath,'dff_peeled.mat'),'cells_peeled');
    
    %%
    clearvars -except i dirs expData code_dir;
    close all;
end

% plays sound when done
load train;
sound(y,Fs);

toc