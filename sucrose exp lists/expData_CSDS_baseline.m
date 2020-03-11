function [ dirs, expData, expParam ] = expData_CSDS_baseline(data_dir)
% % expData_CSDS_baseline %
%
%PURPOSE: Create data structure for imaging tiff files and behavioral log files
%       baseline days for both the stress and control cohorts
%AUTHORS: AC Kwan, 170505.
%
%INPUT ARGUMENTS
%   data_dir:    The base directory to which the raw data are stored.  
%
%OUTPUT VARIABLES
%   dirs:        The subfolder structure within data_dir to work with
%   expData:     Info regarding each experiment
%   expParam:    Settings specific to this experiment

dirs.data = fullfile(data_dir,'data');
dirs.analysis = fullfile(data_dir,'analysis_baseline');
dirs.summary = fullfile(data_dir,'summary_baseline');

l = 1;
subdir{l}='Baseline';

expData=[];
i=1;
 
for k=1:numel(subdir)
    cd(fullfile(dirs.data,subdir{k}));  % go to the data directory
    flist=rdir(fullfile('**','*.log'));      % find list of files with .log extension, including subfolders
    for j=1:numel(flist)
        if flist(j).isdir==0    %if it is not a folder
            expData(i).sub_dir = subdir{k};
            expData(i).logfile = flist(j).name;
            expData(i).onefolder = true;    %many .log files are located in one folder
            i=i+1;
        end
    end  
end