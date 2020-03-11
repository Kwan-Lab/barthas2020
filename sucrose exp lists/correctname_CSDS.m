function [subject_mod, expdate_mod] = correctname_CSDS(subject,expdate)
% % correctname_CSDS %
%PURPOSE:   Manually correct naming inconsistencies
%AUTHORS:   AC Kwan 170613
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

%subjects 1_10 and 4_10 are both named 10, need to separate baesd on
%date of experiment
batch1 = (expdate >= datenum(2016,8,18)) & (expdate <= datenum(2016,9,15));
%batch1 = (expdate >= datenum(2016,8,25)) & (expdate <= datenum(2016,9,15));
batch3 = (expdate >= datenum(2016,11,30)) & (expdate <= datenum(2016,12,22));
batch4 = (expdate >= datenum(2017,3,7)) & (expdate <= datenum(2017,3,29));
batch5 = (expdate >= datenum(2017,4,25)) & (expdate <= datenum(2017,5,9));

for k=1:13
    labelIdx = strcmp([subject{:}],int2str(k));
    
    idx = find(batch1 & labelIdx);
    for l = 1:numel(idx)
        subject_mod{idx(l)} = {['1_' int2str(k)]};
    end
    idx = find(batch3 & labelIdx);
    for l = 1:numel(idx)
        subject_mod{idx(l)} = {['3_' int2str(k)]};
    end
    idx = find(batch4 & labelIdx);
    for l = 1:numel(idx)
        subject_mod{idx(l)} = {['4_' int2str(k)]};  %4- is 4_1
    end
    idx = find(batch5 & labelIdx);
    for l = 1:numel(idx)
        subject_mod{idx(l)} = {['5_' int2str(k)]};
    end
end

%correction #1, "9*9" should be subject 696
idx = find(strcmp([subject_mod{:}],'9*9'));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'696'};
end
%correction #2, "5_17" should be subject 5_16 on post-stress day 1
idx = find(strcmp([subject_mod{:}],'5_17'));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'5_16'};
end
%correction #3, "1_2" should be subject 1_4 on stress day 5
idx = find(strcmp([subject_mod{:}],'1_2'));
for k = 1:numel(idx)
    if expdate(idx(k)) == datenum(2016,8,31);
        subject_mod{idx(k)} = {'1_4'};
    end
end

end