function output = plot_water_blocks(input,plotparams,filelabel)
% % plot_water_blocks %
%PURPOSE:   Plot number of rewards by block (no sucrose fluids, only water)
%AUTHORS:   AC Kwan 170609
%
%INPUT ARGUMENTS
%   input:        Structure generated by sucrose_blocks().
%   plotparams:   Parameters to do with how to plot
%       tlabel:       Text to put as title of the plot
%       colors:       Colors assocaited with the reinforcement types
%       symbols:      Symbols associated with the reinforcement types
%       nBlock:       Plot up to this number of blocks
%       fitModel:     True or false, fit to opportunity cost model
%   filelabel:    Text to be used as part of the filename for the saved .tiff/.fig
%
%OUTPUT ARGUMENTS
%   output:       Analysis output, from model fitting

%%
%if no filename is supplied, then set it to empty string
if nargin < 3
    filelabel = '';
end

if isempty(input)     %if there is no data provided
    return;
elseif iscell(input)  %more than 1 data set, plot mean+-sem
    typeLabel = input{1}.typeLabel;
    rewardType = input{1}.blocksRewardType;
    for j=1:numel(input)
        rewardByBlock(:,j) = input{j}.blocksReward;
    end    
else
    typeLabel = input.typeLabel;
    rewardByBlock = input.blocksReward;
    rewardType = input.blocksRewardType;
end

nType = numel(typeLabel);   %number of reinforcement types

%% Model fitting
% see Niv et al., Psychopharmacology, 2007; Cools et al., Neuropsychopharmacology, 2011

if (plotparams.fitModel)
    op=optimset('fminsearch');
    op.MaxIter=10000;
    op.MaxFunEvals=10000;
    op.TolFun=1e-6;
    op.TolX=1e-6;

    dat = nanmean(rewardByBlock,2);
    
    disp('Model fitting - water experiment');
    
    alphaList = [0.1 0.2 0.4 0.8 1.6];
    kList = [1e-4 1e-3 1e-2];
    CPList = [100 300 500];
    
    xparList=[]; sqErrList=[];   
    for j=1:numel(kList)
        disp(['Testing k ' num2str(j) '/' num2str(numel(kList)) ' in model fitting..']);
        for l=1:numel(alphaList)
            for m=1:numel(CPList)
                ipar=[kList(j) 1 1 1 alphaList(l) CPList(m)];
                lb=[0 1 1 1 0 0];
                ub=[inf 1 1 1 inf inf];
                
                [xpar, sqErr, exitflag]=fminsearchbnd(@costfun, ipar, lb, ub, op, dat');
                
                if exitflag==1  %converged to a solution
                    xparList=[xparList; xpar];
                    sqErrList=[sqErrList; sqErr];
                else
                    xparList=[xparList; nan(size(ipar))];
                    sqErrList=[sqErrList; NaN];
                end
            end
        end
    end
    
    [val,idx]=min(sqErrList);
    
    output.xparFit=xparList(idx(1),:)';
    output.sqErrFit=val;
    [~,output.fittedRate]=costfun(output.xparFit,dat');

else
    output = [];
end

%% Plot actions completed versus blocks

numBlock = min([plotparams.nBlock size(rewardByBlock,1)]);

figure;
subplot(2,1,1); hold on;

% plot the connecting line
if (plotparams.fitModel)  %if there is a model fit, plot the fitted line
    h(1)=plot(1:numBlock,output.fittedRate(1:numBlock),'k','LineWidth',2);
else           %else, just connect the dots (experimental data)
    h(1)=plot(1:numBlock,nanmean(rewardByBlock(1:numBlock,:),2),'k','LineWidth',2);
end

% plot sem
if numel(input)>1
    for j=1:numBlock
        tempmean=nanmean(rewardByBlock(j,:));
        tempsem=nanstd(rewardByBlock(j,:))/sqrt(numel(input));
        plot([j j],tempmean+tempsem*[-1 1],'Color','k','LineWidth',2);
    end
end

% plot mean values
for j=1:nType
    idx=strcmp(rewardType,typeLabel(j));
    h(j+1)=plot(find(idx),nanmean(rewardByBlock(idx,:),2),plotparams.symbols{j},'Color',plotparams.colors{j},'MarkerSize',14,'MarkerFaceColor',plotparams.colors{j});
end

legend(h(2:2+nType-1),typeLabel);
legend('boxoff');
xlabel('Block');
ylabel('Rewards earned');
ylim([0 ceil(max(rewardByBlock(:)))*1.1]);
xlim([0 numBlock]);
title(plotparams.tlabel,'interpreter','none');
   
%%
print(gcf,'-dpng',['blocks' filelabel]);    %png format
saveas(gcf, ['blocks' filelabel], 'fig');

end


