function plot_sucrose_stats(input,plotparams)
% % plot_sucrose_stats %
%PURPOSE:   Plot behavioral performance in free-operant sucrose-consumption task
%AUTHORS:   AC Kwan 170609
%
%INPUT ARGUMENTS
%   input:        Structure generated by sucrose_stats().
%   plotparams:   Parameters to do with how to plot
%       tlabel:       Text to put as title of the plot
%       colors:       Colors assocaited with the reinforcement types
%       gray:         Gray color used to plot individual data points

%%
if numel(input)>1  %more than 1 data set, plot mean+-sem
    typeLabel=input{1}.typeLabel;
    for j=1:numel(input)
        nFRActions(j)=input{j}.nFRActions;
        nFRActionsbyType(:,j)=input{j}.nFRActionsbyType;
    end
else        %plot the 1 data set
    typeLabel=input.typeLabel;
    nFRActions=input.nFRActions;
    nFRActionsbyType=input.nFRActionsbyType;
end

nType=numel(typeLabel);   %number of reinforcement types

%% plot

figure;

%% panel with stat
subplot(2,5,1); hold on;
temp=nFRActions;
ytitle='Rewards earned';
yrange=[0 100*ceil(nanmax(temp)/100)]; %ceiling nearest 100

%plot individual data point
for jj=1:size(temp,2)
    randx=rand*0.3-0.15;
    plot(1+randx,temp(jj),'o','Color',plotparams.gray,'MarkerSize',10,'LineWidth',2);
end
%plot mean
bar(1,nanmean(temp),0.5,'EdgeColor','k','LineWidth',3,'FaceColor','none');
plot([1 1],nanmean(temp)+nanstd(temp)/sqrt(numel(temp))*[-1 1],'Color','k','LineWidth',3);

xlim([0 2]);
ylim(yrange);
set(gca,'xtick',[]);
ylabel(ytitle);
title(plotparams.tlabel,'interpreter','none');

%% panel with stat separated by block type
temp=nFRActionsbyType;  %sucrose preference, using all blocks
temp=100*temp./(temp+repmat(temp(1,:),4,1));
ytitle={'Sucrose preference (%)'};

yrange=[10*floor(nanmin(temp(:))/10) 10*ceil(nanmax(temp(:))/10)]; %ceiling nearest 10

subplot(2,5,[6 7]); hold on;

for kk=1:nType
    %plot individual data point
    for jj=1:size(temp,2)
        randx=rand*0.3-0.15;
        plot(kk+randx,temp(kk,jj),'o','Color',plotparams.gray,'MarkerSize',10,'LineWidth',2);
    end
    
    %plot mean
    bar(kk,nanmean(temp(kk,:)),0.5,'EdgeColor',plotparams.colors{kk},'LineWidth',3,'FaceColor','none');
    plot([kk kk],nanmean(temp(kk,:))+nanstd(temp(kk,:))/sqrt(numel(temp(kk,:)))*[-1 1],'Color',plotparams.colors{kk},'LineWidth',3);
end

plot([0 5],[50 50],'k--','LineWidth',2);
xlim([0.5 4.5]);
ylim(yrange);
ylabel(ytitle);
set(gca,'XTickLabel',typeLabel,'xtick',1:1:4);
xlabel('Block type');

%% panel with stat separated by block type
temp=nFRActionsbyType;  %sucrose preference, using all blocks
temp=100*temp./repmat(temp(1,:),4,1);
ytitle={'Rewards earned (%)'};

yrange=[10*floor(nanmin(temp(:))/10) 10*ceil(nanmax(temp(:))/10)]; %ceiling nearest 10

subplot(2,5,[9 10]); hold on;

for kk=1:nType
    %plot individual data point
    for jj=1:size(temp,2)
        randx=rand*0.3-0.15;
        plot(kk+randx,temp(kk,jj),'o','Color',plotparams.gray,'MarkerSize',10,'LineWidth',2);
    end
    
    %plot mean
    bar(kk,nanmean(temp(kk,:)),0.5,'EdgeColor',plotparams.colors{kk},'LineWidth',3,'FaceColor','none');
    plot([kk kk],nanmean(temp(kk,:))+nanstd(temp(kk,:))/sqrt(numel(temp(kk,:)))*[-1 1],'Color',plotparams.colors{kk},'LineWidth',3);
end

plot([0 5],[100 100],'k--','LineWidth',2);
xlim([0.5 4.5]);
ylim([50 250]);
ylabel(ytitle);
set(gca,'XTickLabel',typeLabel,'xtick',1:1:4);
xlabel('Block type');

print(gcf,'-dpng','sucrose_stats');    %png format
saveas(gcf, 'sucrose_stats', 'fig');

%% anova test
subj=[]; rtype=[];
for ii=1:size(temp,1)          %reward type
    for jj=1:size(temp,2)      %subject
        rtype(ii,jj)=ii;
        subj(ii,jj)=jj;
    end
end

dat = temp(:);
rtype = rtype(:);
subj=subj(:);

disp('One-way ANOVA: Sucrose preference');
[p,tab,stats] = anovan(dat,{rtype,subj},'random',2,'varnames',{'Reward type','Subject'},'display','off');
tab
[c,m,h,nms] = multcompare(stats,'Dimension',[1],'display','off');
c

end


