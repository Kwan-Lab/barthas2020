function output=sucrose_stats(blocks,sepType)
% % sucrose_stats %
%PURPOSE:   Analyze behavioral performance in the free-operant sucrose-consumption task
%AUTHORS:   AC Kwan 170609
%
%INPUT ARGUMENTS
%   blocks:     Structure generated by sucrose_getBlockData().
%   sepType:    Separator [1 x #type], e.g. blocks.rewardType
%
% To plot the output, use plot_sucrose_stats().
% To plot compare output between 2 conditions, use plot_copmare_sucrose_stats().

%%
output.typeLabel = sepType;
nType = numel(output.typeLabel);   %number of reinforcement types

%% total number of completed fixed-ratio actions
output.nFRActions = sum(blocks.reward);

%% number of completed fixed-ratio actions per reward type
for j = 1:nType
    idx=strcmp(blocks.rewardType,output.typeLabel(j));
    output.nFRActionsbyType(j,1) = sum(blocks.reward(idx));
end