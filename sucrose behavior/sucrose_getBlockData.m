function [ blocks ] = sucrose_getBlockData( sessionData )
% % sucrose_getBlockData % %
%PURPOSE: Retrieve block data specific to the free operant sucrose task.
%AUTHORS: AC Kwan 170608
%
%INPUT ARGUMENTS
%   sessionData:    Structure generated by calling sucrose_getSessionData().
%
%OUTPUT VARIABLES
%   blocks:         Structure with information regarding each block
%

%CODES FROM NBS PRESENTATION
[STIM, RESP, OUTCOME, EVENT] = sucrose_getPresentationCodes();

%% identify each block
idx = 1;
for i=1:numel(sessionData.block)
    if sessionData.block(i) == EVENT.STARTWATER
        blocks.startTime(idx,1) = sessionData.blockTimes(i);
        blocks.rewardType(idx,1) = {'0%'};
        idx = idx + 1;
    
    elseif sessionData.block(i) == EVENT.STARTSMALL
        if strcmp(blocks.rewardType(idx-1),'10%');
            blocks.startTime(idx,1) = sessionData.blockTimes(i);
            blocks.rewardType(idx,1) = {'3% nc'};
        else
            blocks.startTime(idx,1) = sessionData.blockTimes(i);
            blocks.rewardType(idx,1) = {'3% pc'};
        end
        idx = idx + 1;
        
    elseif sessionData.block(i) == EVENT.STARTLARGE
        blocks.startTime(idx,1) = sessionData.blockTimes(i);
        blocks.rewardType(idx,1) = {'10%'}; 
        idx = idx + 1;
        
    end
end

%% number of rewards per block

% Animals have to make one FR10, then when the ensuing FI5 ends, the 60-s block begins.
% so always at least one reward per block type
x=sessionData.outcome';
len = diff([ 0 find(x(1:end-1) ~= x(2:end)) length(x) ]);
val = x([ find(x(1:end-1) ~= x(2:end)) length(x) ]);

blocks.reward=len';
blocks.rewardCode=val';

%% Check consistency among the extracted trial values
if numel(blocks.rewardType) ~= numel(blocks.reward)
    disp('ERROR in sucrose_getBlockData: check #1');
end