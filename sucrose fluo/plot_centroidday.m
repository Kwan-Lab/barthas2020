function plot_centroidday(input,dates,exptIDArray,cellIDArray,centroidArray)
% % plot_centroidday %
%PURPOSE:   Plot diagnostic; for each subject, plot the location of ROI for each day
%AUTHORS:   AC Kwan 190321
%
%INPUT ARGUMENTS
%   subj_info:    Structure generated by groupbysubject().
%   dates:        Separate argument passed for days, allowing plotting
%                 using relative or absolute date depending on user input
%   exptIDArray:  Array containing experiment IDs for each cell
%   cellIDArray:  Array containing cell IDs for each cell
%   centroidArray:  Array containing centroid values for each cell

%%
subjectID = input.subjectID;
subjectLabel = input.subjectLabel;

for j=1:numel(subjectLabel)   %for each subject...
    exptIdx = find(subjectID==j); %indices of all experiments associated with that subject
    cellID = cellIDArray(exptIDArray==exptIdx(1));  %indices of all cells associated with that subject (use #cells on expt1)
    
    figure;
    for k=1:numel(cellID)  %for each cell...
        subplot(5,11,k); hold on;
        for l=1:numel(exptIdx)  %for each experiment...
            
            cellIdx = find(cellIDArray==cellID(k) & exptIDArray==exptIdx(l)); %there should be 1 cell index that correspond to that exact cell and exact experiment
            %day = dates(exptIdx(l));
            
            loc=centroidArray{cellIdx};
            
            plot(loc(1),loc(2),'ko','MarkerSize',10,'LineWidth',2);
        end
        xlim([0 512]);
        ylim([0 512]);
        box on;
        set(gca,'XTickLabel',[]);
        set(gca,'YTickLabel',[]);
        axis square;
        if k==1
            title(['Subject ' subjectLabel{j}]);
        end
    end
    
    %%
    print(gcf,'-dpng',['subject ROImap-' subjectLabel{j}]);    %png format
    saveas(gcf, ['subject ROImap-' subjectLabel{j}], 'fig');
    
end

end

