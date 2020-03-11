% simulate behavior, based on ideas from these papers
% Cools/Nakamura/Daw, Neuropsychopharmacology 2011
% Niv/Daw/Joel/Dayan, Psychopharmacology, 2007

close all;
clear all;

%% set up figure plotting
set(groot, ...
    'DefaultFigureColor', 'w', ...
    'DefaultAxesLineWidth', 2, ...
    'DefaultAxesXColor', 'k', ...
    'DefaultAxesYColor', 'k', ...
    'DefaultAxesFontUnits', 'points', ...
    'DefaultAxesFontSize', 18, ...
    'DefaultAxesFontName', 'Helvetica', ...
    'DefaultLineLineWidth', 1, ...
    'DefaultTextFontUnits', 'Points', ...
    'DefaultTextFontSize', 18, ...
    'DefaultTextFontName', 'Helvetica', ...
    'DefaultAxesBox', 'off', ...
    'DefaultAxesTickLength', [0.02 0.025]);

% set the tickdirs to go out - need this specific order
set(groot, 'DefaultAxesTickDir', 'out');
set(groot, 'DefaultAxesTickDirMode', 'manual');
set(0,'defaultfigureposition',[40 40 1200 600]);

%% simulate behavior
block=[1:60];
respRate=nan(1,numel(block));

alpha = 0.05;          %parameter for marginal utility

%median values from stress/control experiments, day-1 and 1
utilityCP = 185;  %change point for utility function
o_cost_params=[0.0143 1.2335 1.2808 1.9525];   %the slopes, corresponding to reward type, in opportunity cost

[~, respRate]=costfun([o_cost_params alpha utilityCP],respRate);

figure;
subplot(2,1,1);
plot(block,respRate(1:numel(block)),'k.-','LineWidth',3,'MarkerSize',30);
xlabel('Block');
ylabel('Response rate');
ylim([0 12]);

%% plot how these cost functions look like

costfcn_dt=0.001;
costfcn_t=[0:costfcn_dt:240];

%---energetic cost
%param1: time constant for the 1/x function;
%"latency-dependent vigor cost (Niv paper cited Staddon 2001 book)
%"inversely proportional to latency (Niv, 2007)
e_cost = 1./costfcn_t;

%---opportunity cost
%param1: slope (due to reward type)
%"rat chooses the latency with which to perform an action.. cost of this
%committment is latency*average reward rate because the rat is effectively
%forgoing this much reward by doing nothing (Niv, 2007) -- in our case, the
%near-future reward rate is entirely predictable, so just substitute with
%reward type
o_cost1 = o_cost_params(1).*costfcn_t;
o_cost3 = o_cost_params(1)*o_cost_params(3).*costfcn_t;
o_cost10 = o_cost_params(1)*o_cost_params(4).*costfcn_t;

marginal_util = @(param1,RewardNum) exp(-1*param1*RewardNum);

util = @(param1,RewardNum) -exp(-1*param1*RewardNum);

figure;

subplot(2,3,1);
plot(costfcn_t,e_cost,'k','LineWidth',3);
title('Energetic cost');
xlim([0 15]); xlabel('Response time (s)');
ylim([0 0.5]); set(gca,'YTick',[]); axis square;

subplot(2,3,2); 
plot(costfcn_t,o_cost1,'k','LineWidth',3); hold on;
plot(costfcn_t,o_cost3,'Color',[0.66 0 0.66],'LineWidth',3);
plot(costfcn_t,o_cost10,'Color',[1 0 1],'LineWidth',3);
title({'Opportunity cost'});
xlim([0 15]); xlabel('Response time (s)');
ylim([0 0.5]); set(gca,'YTick',[]); axis square; 

numReward=[0:400-round(utilityCP)];
subplot(2,3,3);
plot([1:400],[ones(1,round(utilityCP)-1) marginal_util(alpha,numReward)],'k','LineWidth',3); hold on;
plot(utilityCP*[1 1],[0 1.5],'k--','LineWidth',2);
title({'Marginal utility'});
xlim([0 300]); xlabel('Rewards earned');
ylim([0 1.5]); axis square;

%total cost
subplot(2,3,4); 

total_cost1 = e_cost+o_cost1;
[val1,idx1]=nanmin(total_cost1);
total_cost3 = e_cost+o_cost3;
[val3,idx3]=nanmin(total_cost3);
total_cost10 = e_cost+o_cost10;
[val10,idx10]=nanmin(total_cost10);

plot(costfcn_t,total_cost1,'k','LineWidth',3); hold on;
plot(costfcn_t(idx1),val1,'k.','MarkerSize',30);
plot(costfcn_t,total_cost3,'Color',[0.66 0 0.66],'LineWidth',3); 
plot(costfcn_t(idx3),val3,'.','Color',[0.66 0 0.66],'MarkerSize',30);
plot(costfcn_t,total_cost10,'Color',[1 0 1],'LineWidth',3); 
plot(costfcn_t(idx10),val10,'.','Color',[1 0 1],'MarkerSize',30);
title('Total cost');
xlim([0 15]); xlabel('Response time (s)');
ylim([0 0.5]); set(gca,'YTick',[]); axis square;

%print(gcf,'-dpng','SimFig2');
