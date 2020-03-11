function [ dirs, expData ] = expData_M2spon_control(data_dir)
% % expData_M2spon_control %
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

i=1;
        expData(i).sub_dir = fullfile('Control','-1 Baseline','9_20181109');
        expData(i).logfile = '9-20181109-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','-1 Baseline','10_20181109');
        expData(i).logfile = '10-20181109-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','-1 Baseline','11_20181109');
        expData(i).logfile = '11-20181109-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','-1 Baseline','88_20180508');
        expData(i).logfile = '88-20180508-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Control','1 Control Day 1','9_20181111');
        expData(i).logfile = '9-20181111-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','1 Control Day 1','10_20181111');
        expData(i).logfile = '10-20181111-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','1 Control Day 1','11_20181111');
        expData(i).logfile = '11-20181111-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','1 Control Day 1','88_20180510');
        expData(i).logfile = '88-20180510-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Control','3 Control Day 3','9_20181113');
        expData(i).logfile = '9-20181113-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','3 Control Day 3','10_20181113');
        expData(i).logfile = '10-20181113-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','3 Control Day 3','11_20181113');
        expData(i).logfile = '11-20181113-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','3 Control Day 3','88_20180512');
        expData(i).logfile = '88-20180512-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Control','5 Control Day 5','9_20181115');
        expData(i).logfile = '9-20181115-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','5 Control Day 5','10_20181115');
        expData(i).logfile = '10-20181115-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','5 Control Day 5','11_20181115');
        expData(i).logfile = '11-20181115-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','5 Control Day 5','88_20180514');
        expData(i).logfile = '88-20180514-phase1_sucroseblock_FR10FI5_lickport.log';
        
i=i+1;
        expData(i).sub_dir = fullfile('Control','7 Control Day 7','9_20181117');
        expData(i).logfile = '9-20181117-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','7 Control Day 7','10_20181117');
        expData(i).logfile = '10-20181117-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','7 Control Day 7','11_20181117');
        expData(i).logfile = '11-20181117-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Control','9 Control Day 9','9_20181119');
        expData(i).logfile = '9-20181119-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','9 Control Day 9','10_20181119');
        expData(i).logfile = '10-20181119-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','9 Control Day 9','11_20181119');
        expData(i).logfile = '11-20181119-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','9 Control Day 9','88_20180518');
        expData(i).logfile = '88-20180518-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Control','11 Post Day 1','9_20181121');
        expData(i).logfile = '9-20181121-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','11 Post Day 1','10_20181121');
        expData(i).logfile = '10-20181121-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','11 Post Day 1','11_20181121');
        expData(i).logfile = '11-20181121-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','11 Post Day 1','88_20180520');
        expData(i).logfile = '88-20180520-phase1_sucroseblock_FR10FI5_lickport.log';
        
i=i+1;
        expData(i).sub_dir = fullfile('Control','13 Post Day 3','9_20181123');
        expData(i).logfile = '9-20181123-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','13 Post Day 3','10_20181123');
        expData(i).logfile = '10-20181123-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','13 Post Day 3','11_20181123');
        expData(i).logfile = '11-20181123-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Control','13 Post Day 3','88_20180522');
        expData(i).logfile = '88-20180522-phase1_sucroseblock_FR10FI5_lickport.log';