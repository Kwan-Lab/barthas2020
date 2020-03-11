function [ dirs, expData ] = expData_randomized(data_dir)
% % expData_randomized %
%
%PURPOSE: Create data structure for behavioral log files
%       randomized rewards
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

i=1;
        expData(i).sub_dir = '286_20151118';
        expData(i).logfile = '286-florent_randomblock.log';
i=i+1;
        expData(i).sub_dir = '286_20151124';
        expData(i).logfile = '286-florent_randomblock.log';  
i=i+1;
        expData(i).sub_dir = '286_20151127';
        expData(i).logfile = '286-florent_randomblock.log';
i=i+1;
        expData(i).sub_dir = '286_20151129';
        expData(i).logfile = '286-florent_randomblock.log';
i=i+1;
        expData(i).sub_dir = '286_20151201';
        expData(i).logfile = '286-florent_randomblock.log';
i=i+1;
        expData(i).sub_dir = '286_20151204';
        expData(i).logfile = '286-florent_randomblock.log';
        
i=i+1;
        expData(i).sub_dir = '287_20151118';
        expData(i).logfile = '287-florent_randomblock.log';
i=i+1;
        expData(i).sub_dir = '287_20151124';
        expData(i).logfile = '287-florent_randomblock.log';
i=i+1;
        expData(i).sub_dir = '287_20151127';
        expData(i).logfile = '287-florent_randomblock.log'; 
i=i+1;
        expData(i).sub_dir = '287_20151129';
        expData(i).logfile = '287-florent_randomblock.log'; 
i=i+1;
        expData(i).sub_dir = '287_20151201';
        expData(i).logfile = '287-florent_randomblock.log';  
i=i+1;
        expData(i).sub_dir = '287_20151204';
        expData(i).logfile = '287-florent_randomblock.log';        
i=i+1;
        expData(i).sub_dir = '287_20151206';
        expData(i).logfile = '287-florent_randomblock.log';
i=i+1;
        expData(i).sub_dir = '287_20151208';
        expData(i).logfile = '287-florent_randomblock.log';  