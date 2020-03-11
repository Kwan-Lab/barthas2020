function [ STIM, RESP, OUTCOME, EVENT ] = sucrose_getPresentationCodes()
% % sucrose_getPresentationCodes %
%PURPOSE: To read and parse Presentation logfile for further analysis.
%AUTHORS: AC Kwan, 170608.
%
%OUTPUT VARIABLES
%   STIM:     fields containing stimulus-related eventCode defined in Presentation
%   RESP:     fields containing response-related eventCode defined in Presentation
%   OUTCOME:  fields containing outcome-related eventCode defined in Presentation
%   EVENT:    fields containing other event-related eventCode defined in Presentation

STIM=[];   %No stimulus

RESP.LEFT=2;
RESP.RIGHT=3;

OUTCOME.WATER=3;        % water, 0% sucrose
OUTCOME.SMALLREWARD=4;  % small reward, 3% sucrose
OUTCOME.LARGEREWARD=5;  % large reward, 10% sucrose

EVENT.STARTWATER=0;     
EVENT.STARTSMALL=1;    
EVENT.STARTLARGE=2;    
EVENT.STARTSMALL_NEGCON=6;  % 3%, but negative contrast (i.e., block follows a 10% block)    

EVENT.WAITWATER=7;      % waiting for 1st reward before starting 60s
EVENT.WAITSMALL=8;     
EVENT.WAITLARGE=9;     
EVENT.IMAGETRIGGER=99;  % sending a trigger to start imaging

end

