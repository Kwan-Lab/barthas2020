function plot_subjectday(input,dates,batchSize)
% % plot_subjectday %
%PURPOSE:   Plot diagnostic; list subjects and which day data were
%           collected
%AUTHORS:   AC Kwan 170613
%
%INPUT ARGUMENTS
%   subj_info:    Structure generated by groupbysubject().
%   dates:        Separate argument passed for days, allowing plotting
%                 using relative or absolute date depending on user input
%   batchSize:    If too many subject, figure is hard to read so plot in
%                 batches over multiple figures

%%
subjectID = input.subjectID;
subjectLabel = input.subjectLabel;
subjCond = input.subjCond;

numSubject = numel(unique(subjectID));
numBatch=ceil(numSubject/batchSize);

for ll=1:numBatch
    
    figure; hold on;
    
    subj1=(ll-1)*batchSize+1;
    subj2=subj1+batchSize-1;
    if subj2>numSubject
        subj2=numSubject;
    end
    
    % plot individual experiments
    for j=subj1:subj2
        if subjCond(j)==0 
            col='k';
        elseif subjCond(j)==1 
            col='r';
        else
            col='g';       
        end
        plot(dates(subjectID == j),(j-subj1+1),'.','Color',col,'MarkerSize',30);
    end
    
    % plot the connecting line
    for j=subj1:subj2
        if subjCond(j)==0
            col='k';
        elseif subjCond(j)==1
            col='r';
        else
            col='g';
        end
        dayaxis = sort(dates(subjectID == j));
        plot(dayaxis,(j-subj1+1)*ones(size(dayaxis)),'-','Color',col,'LineWidth',3);
    end
    
    ylabel('Subject');
    ylim([0 batchSize+1]);
    set(gca,'TickLabelInterpreter','none')
    set(gca,'Ydir','reverse');
    set(gca,'YTick',[1:subj2-subj1+1]);
    set(gca,'YTickLabel',subjectLabel(subj1:subj2));
    
    xlabel('Day');
    xlim([0 max(dates)+1]);
    
    %%
    print(gcf,'-dpng',['subjectday-' int2str(ll)]);    %png format
    saveas(gcf, ['subjectday-' int2str(ll)], 'fig');
    
end

end


