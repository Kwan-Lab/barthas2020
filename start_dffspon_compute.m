%% Analyze fluorescence data -- compute dF/F
% for spontaneous activity, no task

clearvars;
close all;

tic;    %set clock to estimate how long this takes

%% setup path and plotting formats

sucrose_setPathList;

setup_figprop;  %set up default figure plotting parameters

%% which set of data to load?
m=21;

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
    %% setup/create subdirectories to save analysis and figures
    disp(['Processing file ' int2str(i) ' out of ' int2str(numel(expData)) '.']);
    disp(expData(i).sub_dir);

    if isfield(expData(i),'onefolder')   %all the log files saved in one folder
        temp = sprintf('%04d',i);     %then create subfolder with names based on the file orders
        savematpath = fullfile(dirs.analysis,expData(i).sub_dir,temp);
        savefluofigpath = fullfile(dirs.analysis,expData(i).sub_dir,temp,'figs-fluo');
    else                              %otherwise, one directory = one data set, create subfolder using the same directory name
        savematpath = fullfile(dirs.analysis,expData(i).sub_dir);
        savefluofigpath = fullfile(dirs.analysis,expData(i).sub_dir,'figs-fluo');
    end
    if ~exist(savefluofigpath,'dir')
        mkdir(savefluofigpath);
    end
    
    % load the fluorescence data extracted using cellROI, calculate dF/F
    cd(fullfile(dirs.data,expData(i).sub_dir));
    
%    stackInfo = load('stackinfo.mat');
    stackInfo.frameRate = 29.795; %frame rate is the only metric used for analyzing spontaneous activity, so no need to load the entire stackinfo.mat

    % calculate the dF/F
    neuropilSubtractFactor = 0;  %neuropil subtraction
    
    cd(fullfile(dirs.data,expData(i).sub_dir));
    [ cells ] = calc_dFFspon( stackInfo, neuropilSubtractFactor );
    
    if isfield(cells,'bw')
        for k = 1:numel(cells.bw)
            temp=regionprops(cells.bw{k},'centroid');
            cells.centroid{k} = temp.Centroid;
        end
    end
        
    % save the dF/F so don't have to re-compute every time
    save(fullfile(savematpath,'dff.mat'),...
        'cells');
    
    clearvars -except i dirs expData;
end

% plays sound when done
load train;
sound(y,Fs);

toc