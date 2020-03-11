function [ dirs, expData ] = expData_M2spon_stress(data_dir)
% % expData_M2spon_stress %
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
%   expParam:    Settings specific to this experiment

dirs.data = fullfile(data_dir,'data');
dirs.analysis = fullfile(data_dir,'analysis');
dirs.summary = fullfile(data_dir,'summary');

i=1;
        expData(i).sub_dir = fullfile('Stress','-1 Baseline','1_20181108');
        expData(i).logfile = '1-20181108-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','-1 Baseline','4_20181108');
        expData(i).logfile = '4-20181108-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','-1 Baseline','5_20181108');
        expData(i).logfile = '5-20181108-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','-1 Baseline','82_20180507');
        expData(i).logfile = '82-20180507-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','-1 Baseline','83_20180507');
        expData(i).logfile = '83-20180507-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','-1 Baseline','84_20180505');
        expData(i).logfile = '84-20180505-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','-1 Baseline','85_20180507');
        expData(i).logfile = '85-20180507-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Stress','1 Social Defeat Day 1','1_20181110');
        expData(i).logfile = '1-20181110-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','1 Social Defeat Day 1','4_20181110');
        expData(i).logfile = '4-20181110-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','1 Social Defeat Day 1','5_20181110');
        expData(i).logfile = '5-20181110-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','1 Social Defeat Day 1','82_20180509');
        expData(i).logfile = '82-20180509-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','1 Social Defeat Day 1','83_20180509');
        expData(i).logfile = '83-20180509-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','1 Social Defeat Day 1','84_20180509');
        expData(i).logfile = '84-20180509-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','1 Social Defeat Day 1','85_20180509');
        expData(i).logfile = '85-20180509-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Stress','3 Social Defeat Day 3','1_20181112');
        expData(i).logfile = '1-20181112-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','3 Social Defeat Day 3','4_20181112');
        expData(i).logfile = '4-20181112-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','3 Social Defeat Day 3','5_20181112');
        expData(i).logfile = '5-20181112-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','3 Social Defeat Day 3','82_20180511');
        expData(i).logfile = '82-20180511-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','3 Social Defeat Day 3','83_20180511');
        expData(i).logfile = '83-20180511-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','3 Social Defeat Day 3','84_20180511');
        expData(i).logfile = '84-20180511-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','3 Social Defeat Day 3','85_20180511');
        expData(i).logfile = '85-20180511-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Stress','5 Social Defeat Day 5','1_20181114');
        expData(i).logfile = '1-20181114-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','5 Social Defeat Day 5','4_20181114');
        expData(i).logfile = '4-20181114-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','5 Social Defeat Day 5','5_20181114');
        expData(i).logfile = '5-20181114-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','5 Social Defeat Day 5','82_20180513');
        expData(i).logfile = '82-20180513-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','5 Social Defeat Day 5','83_20180513');
        expData(i).logfile = '83-20180513-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','5 Social Defeat Day 5','84_20180513');
        expData(i).logfile = '84-20180513-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','5 Social Defeat Day 5','85_20180513');
        expData(i).logfile = '85-20180513-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Stress','7 Social Defeat Day 7','1_20181116');
        expData(i).logfile = '1-20181116-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','7 Social Defeat Day 7','4_20181116');
        expData(i).logfile = '4-20181116-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','7 Social Defeat Day 7','5_20181116');
        expData(i).logfile = '5-20181116-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Stress','9 Social Defeat Day 9','1_20181118');
        expData(i).logfile = '1-20181118-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','9 Social Defeat Day 9','4_20181118');
        expData(i).logfile = '4-20181118-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','9 Social Defeat Day 9','5_20181118');
        expData(i).logfile = '5-20181118-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','9 Social Defeat Day 9','82_20180517');
        expData(i).logfile = '82-20180517-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','9 Social Defeat Day 9','83_20180517');
        expData(i).logfile = '83-20180517-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','9 Social Defeat Day 9','84_20180517');
        expData(i).logfile = '84-20180517-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','9 Social Defeat Day 9','85_20180517');
        expData(i).logfile = '85-20180517-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Stress','11 Post-Stress Day 1','1_20181120');
        expData(i).logfile = '1-20181120-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','11 Post-Stress Day 1','4_20181120');
        expData(i).logfile = '4-20181120-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','11 Post-Stress Day 1','5_20181120');
        expData(i).logfile = '5-20181120-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','11 Post-Stress Day 1','82_20180519');
        expData(i).logfile = '82-20180519-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','11 Post-Stress Day 1','83_20180519');
        expData(i).logfile = '83-20180519-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','11 Post-Stress Day 1','84_20180519');
        expData(i).logfile = '84-20180519-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','11 Post-Stress Day 1','85_20180519');
        expData(i).logfile = '85-20180519-phase1_sucroseblock_FR10FI5_lickport.log';

i=i+1;
        expData(i).sub_dir = fullfile('Stress','13 Post-Stress Day 3','1_20181122');
        expData(i).logfile = '1-20181122-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','13 Post-Stress Day 3','4_20181122');
        expData(i).logfile = '4-20181122-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','13 Post-Stress Day 3','5_20181122');
        expData(i).logfile = '5-20181122-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','13 Post-Stress Day 3','82_20180525');
        expData(i).logfile = '82-20180525-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','13 Post-Stress Day 3','83_20180525');
        expData(i).logfile = '83-20180525-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','13 Post-Stress Day 3','84_20180525');
        expData(i).logfile = '84-20180525-phase1_sucroseblock_FR10FI5_lickport.log';
i=i+1;
        expData(i).sub_dir = fullfile('Stress','13 Post-Stress Day 3','85_20180525');
        expData(i).logfile = '85-20180525-phase1_sucroseblock_FR10FI5_lickport.log';
        