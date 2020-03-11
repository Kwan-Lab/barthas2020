function [ dirs, expData, expParam ] = expData_M2_CSDS_stress_water(data_dir)
% % expData_M2_CSDS_stress_water %
%
%PURPOSE: Create data structure for imaging tiff files and behavioral log files
%AUTHORS: AC Kwan, 171107.
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
subdir{l}=fullfile('Stress','-1 Baseline'); l=l+1;
subdir{l}=fullfile('Stress','1 Social Defeat Day 1'); l=l+1;
subdir{l}=fullfile('Stress','3 Social Defeat Day 3'); l=l+1;
subdir{l}=fullfile('Stress','5 Social Defeat Day 5'); l=l+1;
subdir{l}=fullfile('Stress','7 Social Defeat Day 7'); l=l+1;
subdir{l}=fullfile('Stress','9 Social Defeat Day 9'); l=l+1;
subdir{l}=fullfile('Stress','12 Post-Stress Day 2'); l=l+1;
subdir{l}=fullfile('Stress','14 Post-Stress Day 4'); l=l+1;
subdir{l}=fullfile('Stress','16 Post-Stress Day 6'); l=l+1;
subdir{l}=fullfile('Stress','18 Post-Stress Day 8'); l=l+1;
subdir{l}=fullfile('Stress','25 Post-Stress Day 15'); l=l+1;

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