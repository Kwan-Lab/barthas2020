function output = groupbysubject(subject,expdate,cond,roundAcqDate)
% % groupbysubject %
%PURPOSE:   Group the data files by the subject name and their experiment
%           dates
%AUTHORS:   AC Kwan 170613
%
%INPUT ARGUMENTS
%   subject:      Cell array of subject names.
%   expdate:      Date on which experiment was performed, from Matlab's own datenum().
%   cond:         Condition (e.g., 0 for control and 1 for stressed).
%   roundAcqDate:    For the relative experiment date, round to the
%                    nearest interger, (e.g. 2, if we know iamging is done
%                    every 2 days)

%%

subjectLabel = unique([subject{:}]);
numSubject = numel(subjectLabel);

startDate = nan(numSubject,1);
subjCond = nan(numSubject,1);
subjectID = nan(size(expdate));
acqdate = nan(size(expdate));
for j = 1:numSubject
    idx = find(strcmp([subject{:}],subjectLabel(j)));   %indices of sessions belonging to this subject

    startDate(j,1) = nanmin(expdate(idx));  %earlier behavioral record for this subject
    
    temp = unique(cond(idx));  %does the subject has consistent 'condition'
    if numel(temp)==1 %yes, e.g., control vs stress, different cohorts
        subjCond(j,1) = temp;
    else              %no, e.g., muscimol vs vehicle, same cohort, different days
        subjCond(j,1) = nan;
    end
    
    %calculate experiment days relative to the date of the first experiment
    acqdate(idx) = expdate(idx) - startDate(j);     %day relative to the first experiment
    
    acqdate(idx) = floor(acqdate(idx)/roundAcqDate)*roundAcqDate;   %round to the lower multiples of roundAcqDate
    acqdate(idx) = acqdate(idx) + 1;   %the first day is day 1

    subjectID(idx) = j;     %assign numerical ID to this subject
end 

output.subjectID = subjectID;       %a numerical ID for each subject, starting from 1
output.subjectLabel = subjectLabel; %a text label for each subject
output.acqdate = acqdate;      %day of experiment, relative to first day recorded for this subject    
output.cond = cond;         %condition (e.g. 0 = vehicle; 1 = muscimol)

output.startDate = startDate;
output.subjCond = subjCond;

end


