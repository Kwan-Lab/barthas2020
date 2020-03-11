function [ bouts ] = sucrose_getBoutData( sessionData, blocks )
% % sucrose_getBoutData %
%PURPOSE: Retrieve lick-bout data for free operant sucrose task.
%AUTHORS: AC Kwan 170608
%
%INPUT ARGUMENTS
%   sessionData:    Structure obtained with a call to sucrose_getSessionData().
%   blocks:         Structure obtained wiht a call to sucrose_getBlockData().
%   
%OUTPUT VARIABLES
%   bouts:    Structure containing fields related the lick bouts
%

%%
minLickInterval = 0.5;  %licks occuring shorter than this interval is part of a bout
lickTime = sessionData.lickTimes;
rewardTimes = sessionData.outcomeTimes;

%% go through each lick, and group them as lick bouts
bouts=[];
idx=1;  % index for current bout

for j=1:numel(lickTime)
    if j==1 %the very first lick is a special case
        bouts.startTimes(idx,1) = lickTime(j);
        bouts.numLick(idx,1) = 1;
        
    else    %beyond the first lick
        if (lickTime(j)-lickTime(j-1)) < minLickInterval    %this lick is part of a lick bout
            bouts.numLick(idx,1) = bouts.numLick(idx,1) + 1;
            
        else    %else this lick is the start of a new lick bout
            %--- first, finish gathering stats for the last lick bout
            bouts.duration(idx,1)= lickTime(j-1) - bouts.startTimes(idx,1);
            
            rewardIdx = (rewardTimes > bouts.startTimes(idx,1)) & (rewardTimes < lickTime(j-1));    %was there a reward within the last bout we just closed
            if sum(rewardIdx)==1     %if yes
                bouts.reward(idx,1) = sessionData.outcome(rewardIdx);
                bouts.rewardNum(idx,1) = 1;
                bouts.timeToReward(idx,1) = rewardTimes(rewardIdx) - bouts.startTimes(idx,1);  %reward time, relative to bout start time  
                bouts.numLickAfterReward(idx,1) = sum(lickTime>rewardTimes(rewardIdx) & lickTime<=lickTime(j-1)); %number of consummatory licks after the reward
            elseif sum(rewardIdx)>1  %sometimes lick bout can span >1 reward
                bouts.reward(idx,1) = NaN;
                bouts.rewardNum(idx,1) = sum(rewardIdx);   %use info about first reward
                temp=rewardTimes(rewardIdx) - bouts.startTimes(idx,1);
                bouts.timeToReward(idx,1) = temp(1);   
                bouts.numLickAfterReward(idx,1) = NaN;
            else                     %else lick bout did not lead to any reward
                bouts.reward(idx,1) = NaN;
                bouts.rewardNum(idx,1) = 0;
                bouts.timeToReward(idx,1) = NaN;
                bouts.numLickAfterReward(idx,1) = NaN;
            end

            %--- then, start the current lick bout
            idx = idx + 1;
            
            bouts.startTimes(idx,1) = lickTime(j);
            bouts.numLick(idx,1) = 1;
        end
    end
end

%"close" the last bout
bouts.duration(idx,1)= lickTime(end) - bouts.startTimes(idx,1);

rewardIdx = (rewardTimes > bouts.startTimes(idx,1)) & (rewardTimes < lickTime(end));    %was there a reward within the last bout we just closed
if sum(rewardIdx)==1     %if yes
    bouts.reward(idx,1) = sessionData.outcome(rewardIdx);
    bouts.rewardNum(idx,1) = 1;
    bouts.timeToReward(idx,1) = rewardTimes(rewardIdx) - bouts.startTimes(idx,1);  %reward time, relative to bout start time
    bouts.numLickAfterReward(idx,1) = sum(lickTime>rewardTimes(rewardIdx) & lickTime<=lickTime(end)); %number of consummatory licks after the reward
elseif sum(rewardIdx)>1  %sometimes lick bout can span >1 reward
    bouts.reward(idx,1) = NaN;
    bouts.rewardNum(idx,1) = sum(rewardIdx);
    temp=rewardTimes(rewardIdx) - bouts.startTimes(idx,1);
    bouts.timeToReward(idx,1) = temp(1);
    bouts.numLickAfterReward(idx,1) = NaN;
else                     %else lick bout did not lead to any reward
    bouts.reward(idx,1) = NaN;
    bouts.rewardNum(idx,1) = 0;
    bouts.timeToReward(idx,1) = NaN;
    bouts.numLickAfterReward(idx,1) = NaN;
end

%% what is the interval between bouts?

% time elapsed since end of last bout
for jj = 2:numel(bouts.startTimes)
end

% time elapsed until next bout
bouts.intervalFromLast(1) = NaN;
for jj = 1:numel(bouts.startTimes)-1
    tempInterval = bouts.startTimes(jj+1) - (bouts.startTimes(jj) + bouts.duration(jj));
    
    bouts.intervalFromLast(jj+1,1) = tempInterval;
    bouts.intervalToNext(jj,1) = tempInterval;
end
bouts.intervalToNext(jj+1,1) = NaN;

%% go through each reward, and identify the type based on block information
% using block information to do this, so we can distinguish 3%pc and 3%nc

for j=1:numel(bouts.timeToReward)
    if (bouts.rewardNum(j) > 0)   %was there a reward associated with this bout?
        tempTime = bouts.startTimes(j)+bouts.timeToReward(j);  %time of reward, the absolute value
        blockIdx = sum(tempTime > (blocks.startTime - 5.5));     %find in what block did this reward occur 
            %minus 5.5 to account for that first reward/FI5 that initiated the block
        bouts.block(j,1) = blockIdx;
        bouts.rewardType{j,1} = blocks.rewardType{blockIdx};
    else    %there was no reward
        bouts.block(j,1) = NaN;
        bouts.rewardType{j,1} = 'none';
    end
end
