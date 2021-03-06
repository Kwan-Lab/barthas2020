function plot_sucrose_licks(input,plotparams)
% % plot_sucrose_licks %
%PURPOSE:   Plot lick rates for different bout type
%AUTHORS:   AC Kwan 170609
%
%INPUT ARGUMENTS
%   input:        Structure generated by sucrose_licks().
%   plotparams:   Parameters to do with how to plot
%       tlabel:       Text to put as title of the plot
%       colors:       Colors assocaited with the reinforcement types

%%
if numel(input)>1  %more than 1 data set, plot mean+-sem
    sepType=input{1}.sepType;
    edges=input{1}.edges;
    for j=1:numel(input)
        lickRateByType(:,:,j)=input{j}.lickRateByType;
    end
    
    lickRateByType = nanmean(lickRateByType,3); %average across subjects
else        %plot the 1 data set
    sepType=input.sepType;
    edges=input.edges;
    lickRateByType=input.lickRateByType;
    lickTimesByType=input.lickTimesByType;
end

%% calculate mean and sem
nType = numel(sepType);
edges = edges(1:end-1)+nanmean(diff(edges))/2;   %plot using the center of the histogram bins

%% plot
figure;

subplot(2,2,1); hold on;
for j=1:nType
    plot(edges,lickRateByType(:,j),'-','Linewidth',3,'Color',plotparams.colors{j});
end
if ischar(sepType{j})
    legend(sepType);
    legend('boxoff');
end
plot([0 0],[0 12],'k--','LineWidth',2);
ylabel('Lick density (Hz)');
axis([edges(1) edges(end) 0 12]);
xlabel(plotparams.xtitle);
title(plotparams.tlabel,'interpreter','none');

if numel(input)==1  %if the input comes from 1 data set, then plot example lick rasters from this session
    
    numTrialToPlot = 10;  %how many example rows of lick raster to plot for each reward type
    
    subplot(2,5,[4 5]); hold on;
    for j=1:nType
        trialnum = 1;
        randTrial = randperm(numel(lickTimesByType{j}.trial)); %randomly order the trial
        for k=1:numel(randTrial)
            if trialnum <= numTrialToPlot   %plot up the limit number of trials
                if ~isempty(lickTimesByType{j}.trial{randTrial(k)}) %only plot if there is some licks in this trial
                    y = (j-1)*numTrialToPlot + trialnum;
                    plot([lickTimesByType{j}.trial{randTrial(k)} lickTimesByType{j}.trial{randTrial(k)}]',y+[-0.4 0.4],'-','LineWidth',2,'Color',plotparams.colors{j});
                    trialnum = trialnum + 1;
                end
            end
        end
    end
    plot([0 0],[0 numTrialToPlot*nType+0.5],'k--','LineWidth',2);
    xlim([edges(1) edges(end)]);
    ylim([0 numTrialToPlot*nType+0.5]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])

    subplot(4,5,[14 15]); hold on;
    for j=1:nType
        plot(edges,lickRateByType(:,j),'-','Linewidth',3,'Color',plotparams.colors{j});
    end
    plot([0 0],[0 10],'k--','LineWidth',2);
    ylabel('Lick density (Hz)');
    axis([edges(1) edges(end) 0 10]);
    xlabel(plotparams.xtitle);

end

print(gcf,'-dpng',['lickrates-' plotparams.xtitle]);    %png format
saveas(gcf, ['lickrates-' plotparams.xtitle], 'fig');

end


