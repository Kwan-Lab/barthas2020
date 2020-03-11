function [subject_mod, expdate_mod] = correctname_M2_CSDS_water(subject,expdate)
% % correctname_M2_CSDS_water %
%PURPOSE:   Manually correct naming inconsistencies
%AUTHORS:   AC Kwan 171116
%
%INPUT ARGUMENTS
%   subject:    Subject label associated with each experiment.
%   expdate:    Experiment's date associated with each experiment.
%
%OUTPUT ARGUMENTS
%   subject_mod:    Subject label associated with each experiment.
%   expdate_mod:    Experiment's date associated with each experiment.
%

%%

subject_mod = subject;
expdate_mod = expdate;

%some times the subject names are inputted by experimenter inconsistently
%at beginning of training session, leading to different subject names in
%the log files for the same animal

% baseline group are technically done on 6/1/2017, one day prior to
% beginning of stress; going to pretend that they were done in 5/31/2017, 
% to facilitate analysis 
baseline_group = (expdate_mod == datenum(2017,6,1));
idx = find(baseline_group);

for k=1:sum(baseline_group)
    expdate_mod(idx(k)) = datenum(2017,5,31);    
end


end