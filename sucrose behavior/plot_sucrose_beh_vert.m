function plot_sucrose_beh_vert(sessionData,blocks,plotparams)
% % plot_sucrose_beh_vert %
%PURPOSE:   Plot free-operant sucrose task performance, vertical view
%AUTHORS:   AC Kwan 170608
%
%INPUT ARGUMENTS
%   sessionData:  Structure generated by sucrose_getSessionData().
%   blocks:       Structure generated by sucrose_getBlockData().
%   plotparams:   Parameters to do with how to plot
%       tlabel:       Text to put as title of the plot
%       time_range:   Time in seconds to plot, e.g., [-2 6], around the cue
%       batchSize:    Split into multiple figures if too many blocks

nBlocks=numel(blocks.startTime);   %number of blocks animal performed
numBatch=ceil(nBlocks/plotparams.batchSize);  %number of figures needed given the batch size

[ ~, ~, OUTCOME, ~ ] = sucrose_getPresentationCodes();

%search for events, include those even slightly outside the plotting range
%plot then restrict the x-axis to get final figure
search_range = [plotparams.time_range(1)-10 plotparams.time_range(2)+10]; 

for l=1:numBatch
    figure; hold on;
    title({plotparams.tlabel;'{\color[rgb]{0.7,0.7,0.7}0%} / {\color[rgb]{0.5,0,0.5}3%} / {\color[rgb]{1,0,1}10%} / {\color{black}Lick}'});

    block1=(l-1)*plotparams.batchSize+1;
    block2=block1+plotparams.batchSize-1;
    if block2>nBlocks
        block2=nBlocks;
    end
    
    for j=block1:block2
        %time of the block onset (start of 60 s with the same type of reinforcement)
        refTime=blocks.startTime(j);
        
        %draw the outcome
        eventTime = sessionData.outcomeTimes - refTime;
        eventType = sessionData.outcome( (eventTime > search_range(1)) & (eventTime < search_range(2))); 
        eventTime = eventTime( (eventTime > search_range(1)) & (eventTime < search_range(2))); 
        eventDur=5;
        for k = 1:numel(eventTime)
            switch eventType(k)
                case OUTCOME.WATER
                    color=[0.7 0.7 0.7];
                case OUTCOME.SMALLREWARD
                    color=[0.5 0 0.5];
                case OUTCOME.LARGEREWARD
                    color=[1 0 1];
            end
            
            p=fill([eventTime(k) eventTime(k)+eventDur eventTime(k)+eventDur eventTime(k)],[j-0.5 j-0.5 j+0.5 j+0.5],color);
            set(p,'Edgecolor',color);
        end
        
        %draw licks
        lickTime = sessionData.lickTimes' - refTime;
        lickTime = lickTime( (lickTime > search_range(1)) & (lickTime < search_range(2))); 
        plot([lickTime; lickTime],j+[-0.5*ones(size(lickTime)); 0.5*ones(size(lickTime))],'k','LineWidth',1);
        
        %draw optostim
        optoStimTime = sessionData.optoTimes(sessionData.optoLaserOn == 1)' - refTime;
        optoStimTime = optoStimTime( (optoStimTime > search_range(1)) & (optoStimTime < search_range(2))); 
        plot([optoStimTime; optoStimTime],j+[-0.5*ones(size(optoStimTime)); 0.5*ones(size(optoStimTime))],'b','LineWidth',3);
        %draw optostim
        optoBlankTime = sessionData.optoTimes(sessionData.optoLaserOn == 0)' - refTime;
        optoBlankTime = optoBlankTime( (optoBlankTime > search_range(1)) & (optoBlankTime < search_range(2))); 
        plot([optoBlankTime; optoBlankTime],j+[-0.5*ones(size(optoBlankTime)); 0.5*ones(size(optoBlankTime))],'r','LineWidth',3);
        
    end
    
    xlim([plotparams.time_range(1),plotparams.time_range(2)]);
    ylim([block1-1 block1+plotparams.batchSize]);
    set(gca,'ydir','reverse')
    xlabel('Time (s)');
    ylabel('Block');
    
    print(gcf,'-dpng',['session_vert-' int2str(l)]);    %png format

% Takes a lot of time to save this because there are a lot of graphical
% elements, so comment out unless we need this plot
%    saveas(gcf, ['session_vert-' int2str(l)], 'fig');  %fig format
    
end

end


