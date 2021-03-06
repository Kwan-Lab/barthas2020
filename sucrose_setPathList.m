% % sucrose_setPathList %
%
%PURPOSE: To set up the paths to run the code.
%AUTHORS: AC Kwan, 170505.
%

data_dir = '/Users/alexkwan/Desktop/ongoing data analysis/barthas2020/';
code_dir = '/Users/alexkwan/Desktop/ongoing data analysis/barthas2020/matlab sucrose';

% add the paths needed for this code
path_list = {...
    code_dir;...
    fullfile(code_dir,'common functions');...
    fullfile(code_dir,'common functions','beeswarm');...
    fullfile(code_dir,'common functions','cbrewer');...
    fullfile(code_dir,'common functions','LHPeeling');...
    fullfile(code_dir,'common functions','LHPeeling','etc');...
    fullfile(code_dir,'sucrose exp lists');...
    fullfile(code_dir,'sucrose behavior');...
    fullfile(code_dir,'sucrose fluo');...
    };
addpath(path_list{:});