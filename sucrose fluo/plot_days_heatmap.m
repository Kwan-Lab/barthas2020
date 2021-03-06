function plot_days_heatmap(val,subj_info,exptIDArray,cellIDArray,params)
% % plot_days_heatmap %
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

valbyCell = nan(300,numel(xscale));    %#cell by time points
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
    
    subplot(3,4,[j j+4]); hold on;
    set(gca,'color',[0.5 0.5 0.5]);     %so the NaN values look gray
    
    temp = valbyCell(condbyCell==condList(j),:);
    
    % determine order to sort/display the cells
    [~,idxSort]=sort(nanmean(temp(:,2:3),2));  %sort by mean value across all days
    
    %plot in pseudocolor
    b=image(xscale - params.stressDays(1),1:size(temp,1),temp(idxSort,:),'CDataMapping','scaled');
    colormap(colors);
    caxis(params.zrange);
    set(b,'AlphaData',~isnan(temp));    %so the NaN values look gray
    
    xlabel('Day');
    ylabel('Cells');
    xlim([xscale(1)-0.5 xscale(end)+0.5]-params.stressDays(1));
    ylim([0 sum(condbyCell==mode(condbyCell))]);  %max at the most frequent value
    title([subjCondLabel{j} ' (n = ' int2str(size(temp,1)) ')']);
end

%make a color scale bar
subplot(3,15,45);
image(0,linspace(params.zrange(1),params.zrange(2),100),linspace(params.zrange(1),params.zrange(2),100)','CDataMapping','scaled');
colormap(colors);
caxis([params.zrange(1) params.zrange(2)]);
title(params.ztitle);
set(gca,'YDir','normal');
set(gca,'XTick',[]);

print(gcf,'-dpng','days_infer_heatmap');    %png format
saveas(gcf, 'days_infer_heatmap', 'fig');

%% run hierarchical clustering

if nCond==3
    input = valbyCell(condbyCell~=condList(1),:);   %take everything except control
    input = input(:,1:7);   %use the first 7 sessions (because lots of NaN in last session)
    input_trim = input(~any(isnan(input),2),:);       %remove rows if any of its entry is NaN
    cond_trim = condbyCell(~any(isnan(input),2));   %keep tabs of what the remaining cells are
    
    params.numClust = 5;
    
    [C_sorted, cellIdx_sorted] = hier_clust(input_trim,params);
    
    %later will also look at pre-stress raw activity level, so prepare
    %those values too
    rawinput = rawbyCell(condbyCell~=condList(1),:);   %take everything except control
    rawinput = rawinput(:,1:7);   %use the first 7 sessions (because lots of NaN in last session)
    rawinput_trim = rawinput(~any(isnan(input),2),:);       %remove rows if any of its entry is NaN
end

%% plot the traces by averaging across cells in each cluster

figure;
numClust = numel(unique(C_sorted)); 

for j = 1:numClust
    subplot(2,3,j); hold on;
    plot(xscale(1:7) - params.stressDays(1),nanmedian(input_trim(C_sorted==j,:),1),'k.-','MarkerSize',30,'LineWidth',4);
    plot(xscale(1:7) - params.stressDays(1),prctile(input_trim(C_sorted==j,:),20,1),'k--','LineWidth',2);
    plot(xscale(1:7) - params.stressDays(1),prctile(input_trim(C_sorted==j,:),80,1),'k--','LineWidth',2);
    plot([xscale(1) xscale(7)] - params.stressDays(1),[0 0],'k','LineWidth',2);
    ylim([-1 1]);
    xlabel('Day');
    ylabel({'Change in Ca^{2+} event rate';'[relative to pre-stress]'});
    title(['Type ' int2str(j) ' (n= ' int2str(sum(C_sorted==j)) ' cells)']);
end

print(gcf,'-dpng','days_infer_clusteravg');    %png format
saveas(gcf, 'days_infer_clusteravg', 'fig');

%--- same but separate out susceptible and resilient
figure;

for j = 1:numClust
    subplot(2,3,j); hold on;
    %susceptible
    h1=plot(xscale(1:7) - params.stressDays(1),nanmedian(input_trim(C_sorted==j & (cond_trim==1),:),1),'r.-','MarkerSize',30,'LineWidth',4);
    %resilient
    h2=plot(xscale(1:7) - params.stressDays(1),nanmedian(input_trim(C_sorted==j & (cond_trim==2),:),1),'k.-','MarkerSize',30,'LineWidth',4);
    plot([xscale(1) xscale(7)] - params.stressDays(1),[0 0],'k','LineWidth',2);
    ylim([-1 1]);
    xlabel('Day');
    ylabel({'Change in Ca^{2+} event rate';'[relative to pre-stress]'});
    title(['Type ' int2str(j) ' (n= ' int2str(sum(C_sorted==j)) ' cells)']);
    if j==1
        legend([h1 h2],'Susceptible','Resilient');
        legend box off;
    end
end

print(gcf,'-dpng','days_infer_clusteravg2');    %png format
saveas(gcf, 'days_infer_clusteravg2', 'fig');

%% plot membership of each cluster

figure;
subplot(2,2,1); hold on;
for k = 1:numClust
    %susceptible
    n1 = sum((C_sorted==k) & (cond_trim==1));
    N1 = sum(cond_trim==1);
    h1=bar(k-0.15,100*n1/N1,0.3,'r');
    str1 = [subjCondLabel{2}];
    
    %resilient
    n2 = sum((C_sorted==k) & (cond_trim==2));
    N2 = sum(cond_trim==2);
    
    h2=bar(k+0.15,100*n2/N2,0.3,'k');
    str2 = [subjCondLabel{3}];

    % Chi-square test of fractions 
    % Pooled estimate of proportion
    p0 = (n1+n2) / (N1+N2);
    % Expected counts under H0 (null hypothesis)
    n10 = N1 * p0;
    n20 = N2 * p0;
    % Chi-square test, by hand
    observed = [n1 N1-n1 n2 N2-n2];
    expected = [n10 N1-n10 n20 N2-n20];
    disp(['Chi-square test for cluster ' int2str(k) ':']);
    chi2stat = sum((observed-expected).^2 ./ expected)
    p = 1 - chi2cdf(chi2stat,1)
end
    
ylim([0 100]);
xlim([0 numClust+1]);
xticks([1:numClust]);
xlabel('Type');
ylabel({'Percentage of cells (%)'});
legend([h1 h2],str1,str2);
legend boxoff;

% plot median baseline activity of each cluster on day -1
subplot(2,2,2); hold on;
for j = 1:numClust  
    temp1 = rawinput_trim(C_sorted==j & (cond_trim==1),1); %susceptible
    temp2 = rawinput_trim(C_sorted==j & (cond_trim==2),1); %resilient
    plot(j-0.2,median(temp1),'r.','MarkerSize',50);
    h1=plot([j-0.2 j-0.2],[prctile(temp1,25) prctile(temp1,75)],'r','LineWidth',3);
    plot(j+0.2,median(temp2),'k.','MarkerSize',50);
    h2=plot([j+0.2 j+0.2],[prctile(temp2,25) prctile(temp2,75)],'k','LineWidth',3);
end

ylabel('Ca^{2+} event rate, pre-stress (Hz)');
ylim([0 6.5]);
xticks([1:numClust]);
xlabel('Type');
xlim([0.5 numClust+0.5]);
legend([h1 h2],str1,str2);
legend boxoff;

% ANOVA
currdat = rawinput_trim(:,1);
clust = C_sorted(:);
con = cond_trim(:);

isdat = currdat(~isnan(currdat) & (con==1 | con==2) & (clust<=4));
isclust = clust(~isnan(currdat) & (con==1 | con==2) & (clust<=4));
iscon = con(~isnan(currdat) & (con==1 | con==2) & (clust<=4));

terms=[1 0; 0 1; 1 1];  %including interaction terms

[p,tab,stats]=anovan(isdat,{isclust iscon},'model','interaction','varnames',{'Cluster' 'Condition'},'display','off');
tab
[c,m,h,nms] = multcompare(stats,'Dimension',[1],'display','off');
c
    
print(gcf,'-dpng','days_infer_clustercount');    %png format
saveas(gcf, 'days_infer_clustercount', 'fig');

end

