function plot_days_fluo_cellbycell( t, dFF, inferRate, ampl, day, tlabel)
% % plot_allCells %
%PURPOSE:   Plot dF/F for all the cells in one imaging session
%AUTHORS:   MJ Siniscalchi 170105
%           modified by AC Kwan 170515
%
%INPUT ARGUMENTS
%   t:     array containing time
%   dFF:   cell array containing the dF/F traces
%   inferRate:  cell array containing inferred spike rate
%   ampl:  cell array containing amplitude of dF/F
%   day:   corresponding acquisition day for the cell array elements
%   tlabel:     text to put as the title

%% Display parameters
spacing = 1.5*nanmax(dFF{1});     

nDay = numel(day);

%%

figure; 

%Plot dF/F traces for each day
subplot(1,5,[1:2]); hold on;

y1 = spacing*0.5;
y2 = -[spacing*(nDay+0.5)]; %Day idx negated so day 1 is on top

legstring=[];
for i = 1:numel(day)
    %the last data point may include an invalid value, so do not plot that
    h(i)=plot(t{i}(1:end-1),dFF{i}(1:end-1) - spacing*(i),'k','LineWidth',1);
    legstring{i}=['Day ' int2str(day(i))];
end
ylabel('dF/F'); 
xlabel('Time (s)');
%legend(h,legstring);
title(tlabel);
ylim([y2 y1]);
xlim([0 300]);

%Plot infer rate across days
subplot(5,5,[4 5]); hold on;
plot(day-2,inferRate,'k.-','MarkerSize',30);
xlabel('Day'); 
ylabel('Inferred event (Hz)');
xlim([-2 12]);
ylim([0 1.1*nanmax(inferRate)]);
%set(gca,'Ydir','reverse');
%view([-90 -90]);

%Plot amplitude of dF/F across days
subplot(5,5,[14 15]); hold on;
plot(day-2,ampl,'k.-','MarkerSize',30);
xlabel('Day'); 
ylabel('Amplitude of dF/F');
xlim([-2 12]);
%set(gca,'Ydir','reverse');
%view([-90 -90]);
