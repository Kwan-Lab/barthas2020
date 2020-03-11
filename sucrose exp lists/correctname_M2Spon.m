function [subject_mod, expdate_mod] = correctname_M2Spon(subject,expdate)
% % correctname_M2Spon %
%PURPOSE:   Manually correct naming inconsistencies
%AUTHORS:   AC Kwan 190306
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

%correction, "*-" should be subject *
idx = find(strncmp([subject_mod{:}],'1-',2));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'1'};
end
idx = find(strncmp([subject_mod{:}],'4-',2));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'4'};
end
idx = find(strncmp([subject_mod{:}],'5-',2));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'5'};
end
idx = find(strncmp([subject_mod{:}],'9-',2));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'9'};
end
idx = find(strncmp([subject_mod{:}],'10-',3));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'10'};
end
idx = find(strncmp([subject_mod{:}],'11-',3));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'11'};
end

idx = find(strncmp([subject_mod{:}],'82-',3));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'82'};
end
idx = find(strncmp([subject_mod{:}],'83-',3));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'83'};
end
idx = find(strncmp([subject_mod{:}],'84-',3));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'84'};
end
idx = find(strncmp([subject_mod{:}],'85-',3));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'85'};
end
idx = find(strncmp([subject_mod{:}],'88-',3));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'88'};
end

%2018/11/18 file says animal 8, but it should be animal 4
%first, there is no animal 8
%second, stress and control animals were done on alternate days so this
%must be the group of animal 1,4,5
idx = find(strncmp([subject_mod{:}],'8-',2));
for k = 1:numel(idx)
    subject_mod{idx(k)} = {'4'};
end

%correction, the baseline day for 84 on 2018/05/07 was unavailable, so
%using 2018/05/05, but that should not shift the stress days
idx = find(strcmp([subject_mod{:}],'84'));
for k = 1:numel(idx)
    if expdate(idx(k)) == datenum(2018,5,5)
        expdate_mod(idx(k)) = datenum(2018,5,7);
    end
end


end