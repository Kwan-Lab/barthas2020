function [ sessionData ] = sucrose_getSessionData( logData )
% % getSessionData %
%PURPOSE: Retrieve session data for free operant sucrose task.
%AUTHORS: AC Kwan 170608
%
%INPUT ARGUMENTS
%   logdata:    Structure obtained with a call to parseLogfile().
%   interpulse_present: true, if reward delivered over two pulses
%                       sent to the pneumatic valve, separated by 100 ms.
%
%OUTPUT VARIABLES
%   sessionData:    Structure containing these fields:
%                   {subject, dateTime, nTrials, lickTimes, ...}.

%%

[ STIM, RESP, OUTCOME, EVENT ] = sucrose_getPresentationCodes();

%COPY FROM LOGDATA
sessionData.subject = logData.subject;
sessionData.dateTime = logData.dateTime;

%SESSION DATA <<logData.header: 'Subject' 'Trial' 'Event Type' 'Code' 'Time'>>
TYPE = logData.values{3}; %Intersectional approach necessary, because values 2,3 were reused;
CODE = logData.values{4}; %change in future Presentation scripts: with unique codes, only CODE would be needed to parse the logfile...

% What are the event codes in this log files? 
% unique(CODE(strcmp(TYPE,'Nothing')))   %do not consider RESPONSE or MANUAL

% Set up the time axis, and identify lick times
%time_0 = logData.values{5}(find(CODE==EVENT.IMAGETRIGGER,1,'first'));
time_0 = logData.values{5}(1);     %relative to the beginning of logfile
time = logData.values{5}-time_0;   %time starts at first instance of startExpt
time = double(time)/10000;         %time as double in seconds
sessionData.timeLastEvent = time(end);   %time of the last event logged

sessionData.lickTimes = time(strcmp(TYPE,'Response') & (CODE==RESP.LEFT | CODE==RESP.RIGHT));    %lick times

% When and what outcomes?
outcomeCodes = cell2mat(struct2cell(OUTCOME)); %outcome-associated codes as vector
sessionData.outcome =  CODE(strcmp(TYPE,'Nothing') & ismember(CODE,outcomeCodes));
sessionData.outcomeTimes = time(strcmp(TYPE,'Nothing') & ismember(CODE,outcomeCodes));

%% When are the blocks?
% wait blocks? (the blocks in between the 60-s timed blocks, waiting for first FR10 completion)
% reward blocks? (the 60-s timed blocks)

%7/27/2015 changed Presentation scenario file, now there is event_code==99 signaling sending imaging triggers
if sum(CODE==EVENT.IMAGETRIGGER) > 0
    newScenarioFile=true;
else
    newScenarioFile=false;
end

if (newScenarioFile)
    % How many imaging triggers? (free operant task, here one trigger = an imaging file)
    sessionData.nTriggers = sum(CODE==EVENT.IMAGETRIGGER);
    sessionData.triggerTimes = time(strcmp(TYPE,'Nothing') & CODE==EVENT.IMAGETRIGGER);
       
    % each block begins after an image trigger
    trigIdx = find(strcmp(TYPE,'Nothing') & CODE==EVENT.IMAGETRIGGER);
    for j=1:numel(trigIdx)
        
        eventIdx = trigIdx(j) + 1;  %the next event after the imaging trigger
        
        done = 0;
        while (~done)
            
            % look for the next event to tell us what block it is
            if strcmp(TYPE(eventIdx),'Nothing') && ...
                    ((CODE(eventIdx) == EVENT.STARTWATER) || (CODE(eventIdx) == EVENT.STARTSMALL) || (CODE(eventIdx) == EVENT.STARTLARGE)) || ...
                    ((CODE(eventIdx) == EVENT.WAITWATER) || (CODE(eventIdx) == EVENT.WAITSMALL) || (CODE(eventIdx) == EVENT.WAITLARGE))
                sessionData.block(j,1) = CODE(eventIdx);
                sessionData.blockTimes(j,1) = time(eventIdx);
                
                done = 1;   %block is identified
            else
                eventIdx = eventIdx + 1; %advance index (in case there is a lick response immediately after imaging trigger event
            end
        end
    end
else
    %go through event code one by one to look for block begins
    disp('Note: old version of log file with no imagetrigger event.');
    
    %run-length encoding for event codes (i.e., ignore codes associated with lick responses)
    eventIdx = strcmp(TYPE,'Nothing');
    eventTime = time(eventIdx);
    eventCode = CODE(eventIdx);
    
    x=eventCode';
    len = diff([ 0 find(x(1:end-1) ~= x(2:end)) length(x) ]);
    val = x([ find(x(1:end-1) ~= x(2:end)) length(x) ]);
    
    sessionData.blockTimes = [];
    sessionData.block = [];
    for k=1:numel(val)-2
        %if a wait-block event is followed by a start event, then this is a new 60-s block!
        if val(k)==EVENT.WAITWATER || val(k)==EVENT.WAITSMALL || val(k)==EVENT.WAITLARGE
            %find start time of the wait block
            if k>1
                waitBlockTime = eventTime(sum(len(1:k-1)));
            else
                waitBlockTime = eventTime(1);               %the very first wait-block
            end
            %find start time of the start block
            startBlockTime = eventTime(sum(len(1:k+1)))+5;  %60-s countdown for block begins at end of FI5
            %if the wait block is >60 second, then there were multiple
            %image triggers within that long wait block.. split it up
%             if (startBlockTime - waitBlockTime) > 60
%                 nTrig = ceil((startBlockTime - waitBlockTime) / 60);
%             end
%             waitBlockTime = waitBlockTime + 60*[0:(nTrig - 1)]';
            
            %find identity of the wait and start block (what kind of reinforcements for this block?)
            if val(k+2)==EVENT.STARTWATER
                waitEventCode = EVENT.WAITWATER; startEventCode = EVENT.STARTWATER;
            elseif val(k+2)==EVENT.STARTSMALL
                waitEventCode = EVENT.WAITSMALL; startEventCode = EVENT.STARTSMALL;
            elseif val(k+2)==EVENT.STARTLARGE
                waitEventCode = EVENT.WAITLARGE; startEventCode = EVENT.STARTLARGE;
            else
                error('ERROR: Problem in detecting the wait/start block times.');
            end
            
            %add wait blocks to the list of blocks
            sessionData.blockTimes = [sessionData.blockTimes; waitBlockTime];
            sessionData.block = [sessionData.block; waitEventCode*ones(numel(waitBlockTime),1)];
            %add start blocks to the list of blocks
            sessionData.blockTimes = [sessionData.blockTimes; startBlockTime];
            sessionData.block = [sessionData.block; startEventCode];
            
        end
    end
    
    % How many triggers? (free operant task, here one trigger = an imaging file)
    sessionData.triggerTimes = sessionData.blockTimes - 0.1;  %the image trigger is 100 ms long
    sessionData.nTriggers = numel(sessionData.triggerTimes);
    
end

end

