function plot_days_prepost(val,subj_info,exptIDArray,cellIDArray,params)
% % plot_days_twodays %
%PURPOSE:   Plot inferred spontaneous event rates (from fluorescence)
%           across days
%AUTHORS:   AC Kwan 180814

%INPUT ARGUMENTS
%   val:          Vector of the values to be plotted across days
%   subj_info:    Structure generated by groupbysuject().
%   exptIDArray:
%   cellIDArray:
%   params:       Plotting parameters

%% Plotting parameters
colors=cbrewer('div','RdBu',256);
colors=flipud(colors);

xscale = [1:2:15];

%% organize data based on cells

valbyCell = nan(300,numel(xscale));    %#cell by day (so valbyCell(:,2) correspond to day 1)
condbyCell = nan(300,1);    %#cell

nCells = 0;
for j=1:numel(subj_info.subjectLabel)   %for each subject...
    exptIdx = find(subj_info.subjectID==j); %indices of all experiments associated with that subject
    cellID = cellIDArray(exptIDArray==exptIdx(1));  %indices of all cells associated with that subject (use #cells on expt1)
    
    day = [];
    val_day = [];
    for k=1:numel(cellID)  %for each cell...
        
        %extract the day-by-day value for that cell
        for l=1:numel(exptIdx)
            cellIdx = find(cellIDArray==cellID(k) & exptIDArray==exptIdx(l)); %there should be 1 cell index that correspond to that exact cell and exact experiment
            
            day(l) = subj_info.acqdate(exptIdx(l));            
            val_day(l) = val(cellIdx);
        end
        
        %if there were useful measurements for >= 5 sessions, and if first day can be used (for normalization)
        % store for plotting and advance cell counter
        if sum(~isnan(val_day)) > 0 && any(day(~isnan(val_day))==1)           
            nCells = nCells + 1;
            
            temp = interp1(day(~isnan(val_day)),val_day(~isnan(val_day)),xscale);  % ----- note ---- interpolate for days in between that are missing
            
            rawbyCell(nCells,:) = temp; %raw values
            valbyCell(nCells,:) = (temp-temp(1))./(temp+temp(1));  %as a function of normalized difference from pre-stress value
            condbyCell(nCells,1) = subj_info.subjClassif(j);    %susceptible, resilient, or control
        end
    end
end

rawbyCell=rawbyCell(1:nCells,:);
valbyCell=valbyCell(1:nCells,:);
condbyCell=condbyCell(1:nCells,1);

%% plot as a function of day per cell
figure;

%number of conditions (e.g., control, susceptible, resilient)
if isfield(subj_info,'subjClassif') %split into susceptible/resilient
    subjCond = subj_info.subjClassif;
    subjCondLabel = subj_info.classiflabel;
else
    subjCond = subj_info.subjCond;
    subjCondLabel = subj_info.condlabel;
end
condList = unique(condbyCell);
condList = condList(~isnan(condList));
nCond = numel(condList);

for j=1:nCond
    
    subplot(3,7,[j j+7]); hold on;
    set(gca,'color',[0.5 0.5 0.5]);     %so the NaN values look gray
    
    temp = valbyCell(condbyCell==condList(j),:);    
    
    % determine order to sort/display the cells
    [~,idxSort]=sort(nanmean(temp(:,2),2));  %sort by mean value across all days
    
    %plot in pseudocolor
    b=image(xscale - params.stressDays(1),1:size(temp,1),temp(idxSort,:),'CDataMapping','scaled');
    colormap(colors);
    caxis(params.zrange);
    set(b,'AlphaData',~isnan(temp));    %so the NaN values look gray
    
    xlabel('Day');
    if j==1
        ylabel('Cells');
    end
    xlim([0 2]);
    ylim([0 sum(condbyCell==mode(condbyCell))]);
    title(subjCondLabel{j});
    
    % histogram
    subplot(3,3,3*j); hold on;
    edges=[-1:0.1:1];
    n=histc(temp(:,2),edges);
    bar(edges+mean(diff(edges))/2,n,0.5,'k','LineWidth',3);
    if j==nCond
        xlabel(params.ztitle);
    end
    ylabel('Number of cells');
    title([subjCondLabel{j}]);
end

%make a color scale bar
subplot(3,20,52);
image(0,linspace(params.zrange(1),params.zrange(2),100),linspace(params.zrange(1),params.zrange(2),100)','CDataMapping','scaled');
colormap(colors);
caxis([params.zrange(1) params.zrange(2)]);
title(params.ztitle);
set(gca,'YDir','normal');
set(gca,'XTick',[]);

print(gcf,'-dpng','days_infer_prepost');    %png format
saveas(gcf, 'days_infer_prepost', 'fig');

%% plot median of day 1 minus day -1

figure;

subplot(2,4,1); hold on;
temp = valbyCell(condbyCell==condList(1),2);
plot(1,median(temp),'k.','MarkerSize',50);
plot([1 1],[prctile(temp,25) prctile(temp,75)],'k','LineWidth',3);
temp = valbyCell(condbyCell==condList(2),2);
plot(2,median(temp),'k.','MarkerSize',50);
plot([2 2],[prctile(temp,25) prctile(temp,75)],'k','LineWidth',3);
temp = valbyCell(condbyCell==condList(3),2);
plot(3,median(temp),'k.','MarkerSize',50);
plot([3 3],[prctile(temp,25) prctile(temp,75)],'k','LineWidth',3);

ylabel(params.ztitle);
ylim([-0.5 0.5]);
xticks([1 2 3]);
xlim([0.5 3.5]);

%% plot median of day -1

subplot(2,4,2); hold on;
temp = rawbyCell(condbyCell==condList(1),1);
plot(1,median(temp),'k.','MarkerSize',50);
plot([1 1],[prctile(temp,25) prctile(temp,75)],'k','LineWidth',3);
temp = rawbyCell(condbyCell==condList(2),1);
plot(2,median(temp),'k.','MarkerSize',50);
plot([2 2],[prctile(temp,25) prctile(temp,75)],'k','LineWidth',3);
temp = rawbyCell(condbyCell==condList(3),1);
plot(3,median(temp),'k.','MarkerSize',50);
plot([3 3],[prctile(temp,25) prctile(temp,75)],'k','LineWidth',3);

ylabel({'Ca^{2+} event rate (Hz)';'pre-stress [day -1]'});
ylim([0 5]);
xticks([1 2 3]);
xlim([0.5 3.5]);

%% plot distribution of baseline activity on day -1
% for j=1:nCond
%     
%     temp = rawbyCell(condbyCell==condList(j),:);    
%         
%     % histogram
%     subplot(3,3,3*j); hold on;
%     edges=[0:0.2:10];
%     n=histc(temp(:,1),edges);
%     bar(edges+mean(diff(edges))/2,n,0.5,'k','LineWidth',3);
%     if j==nCond
%         xlabel(params.ztitle);
%     end
%     ylabel('Number of cells');
%     title([subjCondLabel{j}]);
% end

%% plot activity change vs baseline activity (active cells become more active?)
% subplot(2,2,2); hold on;
% temp1 = rawbyCell(condbyCell==condList(1),1); %baseline rate on day -1
% temp2 = rawbyCell(condbyCell==condList(1),2); %activity change day 1 vs -1
% plot(temp1,temp2,'k.','MarkerSize',30);
% title(subjCondLabel{1});
% xlabel('Ca^{2+} event rate (day -1)');
% ylabel('Ca^{2+} event rate (day 1)');
% plot([0 12],[0 12],'k--'); xlim([0 12]); ylim([0 12]); axis square; 
% 
% subplot(2,2,3); hold on;
% temp1 = rawbyCell(condbyCell==condList(2),1); %baseline rate on day -1
% temp2 = rawbyCell(condbyCell==condList(2),2); %activity change day 1 vs -1
% plot(temp1,temp2,'k.','MarkerSize',30);
% title(subjCondLabel{2});
% xlabel('Ca^{2+} event rate (day -1)');
% ylabel('Ca^{2+} event rate (day 1)');
% plot([0 12],[0 12],'k--'); xlim([0 12]); ylim([0 12]); axis square; 
% 
% subplot(2,2,4); hold on;
% temp1 = rawbyCell(condbyCell==condList(3),1); %baseline rate on day -1
% temp2 = rawbyCell(condbyCell==condList(3),2); %activity change day 1 vs -1
% plot(temp1,temp2,'k.','MarkerSize',30);
% title(subjCondLabel{3});
% xlabel('Ca^{2+} event rate (day -1)');
% ylabel('Ca^{2+} event rate (day 1)');
% plot([0 12],[0 12],'k--'); xlim([0 12]); ylim([0 12]); axis square; 

print(gcf,'-dpng','days_infer_prepost2');    %png format
saveas(gcf, 'days_infer_prepost2', 'fig');

%% statistical test
% are the distributions for post-stress values different?

if nCond == 3

    %unpaired comparison of activity change across conditions
    disp('Comparing activity change day 1 minus day -1');
    [~,p] = kstest2(valbyCell(condbyCell==condList(1),2),valbyCell(condbyCell==condList(2),2));
    disp(['KS tests for ' subjCondLabel{1} ' vs. ' subjCondLabel{2} ': ' num2str(p)]);

    [~,p] = kstest2(valbyCell(condbyCell==condList(1),2),valbyCell(condbyCell==condList(3),2));
    disp(['KS tests for ' subjCondLabel{1} ' vs. ' subjCondLabel{3} ': ' num2str(p)]);
    
    [~,p] = kstest2(valbyCell(condbyCell==condList(2),2),valbyCell(condbyCell==condList(3),2));
    disp(['KS tests for ' subjCondLabel{2} ' vs. ' subjCondLabel{3} ': ' num2str(p)]);

    for j = 1:3
        disp(['--- for ' subjCondLabel{j}]);
        disp(['25 percentile = ' num2str(prctile(valbyCell(condbyCell==condList(j),2),25))]);
        disp(['50 percentile = ' num2str(prctile(valbyCell(condbyCell==condList(j),2),50))]);
        disp(['75 percentile = ' num2str(prctile(valbyCell(condbyCell==condList(j),2),75))]);
    end
    
    p = ranksum(valbyCell(condbyCell==condList(1),2),valbyCell(condbyCell==condList(2),2));
    disp(['Wilcoxon for ' subjCondLabel{1} ' vs. ' subjCondLabel{2} ': ' num2str(p)]);

    p = ranksum(valbyCell(condbyCell==condList(1),2),valbyCell(condbyCell==condList(3),2));
    disp(['Wilcoxon for ' subjCondLabel{1} ' vs. ' subjCondLabel{3} ': ' num2str(p)]);
    
    p = ranksum(valbyCell(condbyCell==condList(2),2),valbyCell(condbyCell==condList(3),2));
    disp(['Wilcoxon for ' subjCondLabel{2} ' vs. ' subjCondLabel{3} ': ' num2str(p)]);
    

    %baseline activity on day -1
    disp('Comparing baseline activity day -1');

    [~,p] = kstest2(rawbyCell(condbyCell==condList(1),1),rawbyCell(condbyCell==condList(2),1));
    disp(['KS tests for ' subjCondLabel{1} ' vs. ' subjCondLabel{2} ': ' num2str(p)]);
    
    [~,p] = kstest2(rawbyCell(condbyCell==condList(1),1),rawbyCell(condbyCell==condList(3),1));
    disp(['KS tests for ' subjCondLabel{1} ' vs. ' subjCondLabel{3} ': ' num2str(p)]);
    
    [~,p] = kstest2(rawbyCell(condbyCell==condList(2),1),rawbyCell(condbyCell==condList(3),1));
    disp(['KS tests for ' subjCondLabel{2} ' vs. ' subjCondLabel{3} ': ' num2str(p)]);

    p = ranksum(rawbyCell(condbyCell==condList(1),1),rawbyCell(condbyCell==condList(2),1));
    disp(['Wilcoxon for ' subjCondLabel{1} ' vs. ' subjCondLabel{2} ': ' num2str(p)]);

    p = ranksum(rawbyCell(condbyCell==condList(1),1),rawbyCell(condbyCell==condList(3),1));
    disp(['Wilcoxon for ' subjCondLabel{1} ' vs. ' subjCondLabel{3} ': ' num2str(p)]);
    
    p = ranksum(rawbyCell(condbyCell==condList(2),1),rawbyCell(condbyCell==condList(3),1));
    disp(['Wilcoxon for ' subjCondLabel{2} ' vs. ' subjCondLabel{3} ': ' num2str(p)]);
end

end


