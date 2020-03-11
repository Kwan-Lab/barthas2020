function [ dirs, expData ] = expData_CSDS_control(data_dir)
% % expData_CSDS_control %
%
%PURPOSE: Create data structure for imaging tiff files and behavioral log files
%AUTHORS: AC Kwan, 170505.
%
%INPUT ARGUMENTS
%   data_dir:    The base directory to which the raw data are stored.  
%
%OUTPUT VARIABLES
%   dirs:        The subfolder structure within data_dir to work with
%   expData:     Info regarding each experiment

dirs.data = fullfile(data_dir,'data');
dirs.analysis = fullfile(data_dir,'analysis');
dirs.summary = fullfile(data_dir,'summary');

l = 1;
subdir{l}=fullfile('Control','-1 Baseline'); l=l+1;
subdir{l}=fullfile('Control','1 Control Day 1'); l=l+1;
subdir{l}=fullfile('Control','3 Control Day 3'); l=l+1;
subdir{l}=fullfile('Control','5 Control Day 5'); l=l+1;
subdir{l}=fullfile('Control','7 Control Day 7'); l=l+1;
subdir{l}=fullfile('Control','9 Control Day 9'); l=l+1;
subdir{l}=fullfile('Control','11 Post Day 1'); l=l+1;
subdir{l}=fullfile('Control','13 Post Day 3'); l=l+1;
subdir{l}=fullfile('Control','18 Post Day 8'); l=l+1;
 
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