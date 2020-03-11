function [ dirs, expData ] = expData_sucralose(data_dir)
% % expData_randomized %
%
%PURPOSE: Create data structure for behavioral log files
%       sucralose (0, 0.23mM, 1.0mM) instead of sucrose
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
dirs.analysis = fullfile(data_dir,'analysis');
dirs.summary = fullfile(data_dir,'summary');

l = 1;
subdir{l}='day26'; l=l+1;
subdir{l}='day27'; l=l+1;
subdir{l}='day29'; l=l+1;
subdir{l}='day30'; l=l+1;

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