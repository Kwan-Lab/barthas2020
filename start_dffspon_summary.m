%% Summary plots from many analyses of behavioral performance
% run this after running start_beh

clearvars;
close all;

%% setup path and plotting formats

sucrose_setPathList;

setup_figprop;  %set up default figure plotting parameters

%% load data
centroidArray=[]; dFFArray=[]; exptIDArray=[]; cellIDArray=[];
inferRateArray=[]; amplArray=[];

j = 1;
for k=0:1
    switch k
        case 0  %load control
            disp('----- loading control -----');
            data_subdir = fullfile(data_dir,'M2spon_CSDS');
            [ dirs, expData ] = expData_M2spon_control(data_subdir);
            
        case 1  %load stress
            disp('----- loading stressed -----');
            data_subdir = fullfile(data_dir,'M2spon_CSDS');
            [ dirs, expData ] = expData_M2spon_stress(data_subdir);
    end
    
    for i = 1:numel(expData)
        disp(['Loading file ' int2str(i) '/' int2str(numel(expData)) '.']);
        
        if isfield(expData(i),'onefolder')   %all the log files saved in one folder
            temp = sprintf('%04d',i);
            cd(fullfile(dirs.analysis,expData(i).sub_dir,temp));
        else
            cd(fullfile(dirs.analysis,expData(i).sub_dir));
        end
        
        load('dff.mat');
        if isfield(cells,'t')  %only store data and advance counter if there are actual imaging data
            
            load('beh.mat');
            
            fileinfo(j) = expData(i);
            cond(j) = k;    %0 = control; 1 = stress
            subject{j}=sessionData.subject;
            expdate(j)=datenum(sessionData.dateTime{1},'mm/dd/yyyy');
            
            load('dff.mat');
            
            tArray{j}=cells.t;
            centroidArray=[centroidArray cells.centroid];
            dFFArray=[dFFArray cells.dFF];
            exptIDArray=[exptIDArray j*ones(1,numel(cells.dFF))];
            cellIDArray=[cellIDArray 1:numel(cells.dFF)];
            
            load('dff_peeled.mat');
            inferRateArray = [inferRateArray cell2mat(cells_peeled.spikeRateInfer)];
            
            temp = cell2mat(cells_peeled.prctile');
            %normalized amplitude of dF/F
            %95 percentile minus 50 percentile (the upward deflection),
            %normalized by 50 percentile minus 5 percentile (the downward
            %deflection). Should be >>1 for actual calcium transients
            amplArray = [amplArray (temp(:,3)-temp(:,2))'./(temp(:,2)-temp(:,1))'];
            
            j = j + 1;  %advance counter
        end
        
        clearvars -except i j k data_dir dirs expData ...
            fileinfo cond subject expdate tArray centroidArray dFFArray exptIDArray cellIDArray...
            inferRateArray amplArray;
    end
end

%% make summary plots
savebehfigpath = fullfile(dirs.summary,'figs-fluo');
if ~exist(savebehfigpath,'dir')
    mkdir(savebehfigpath);
end

cd(savebehfigpath);

%%
%manual adjustments of subject name (sometimes when experimenter use wrong capitalization or
%another variation to name the subject)
[subject_mod, expdate_mod] = correctname_M2Spon(subject, expdate);

%organize the experiment information for each subject
roundAcqDate = 2;  %rounding up the day # of the imaging session
subj_info_raw = groupbysubject(subject_mod,expdate_mod,cond,roundAcqDate);
subj_info_raw.condlabel = {'Control','Stressed'};

%diagnostic plot to see what subject/date data we have
batchSize=20; %plot in batches of subjects
plot_subjectday(subj_info_raw, subj_info_raw.acqdate, batchSize);

%diagnostic plot to see where the ROIs are across days
% plot_centroidday(subj_info_raw, subj_info_raw.acqdate, exptIDArray, cellIDArray, centroidArray);
% close all;

%% add the social interaction test results to the subj_info
%threshold = -10;  %if want to treat all stressed as susceptible
threshold = 1;    %threshold for determining susceptible vs. resilient
subj_info = SIRatio_CSDS(subj_info_raw, threshold);

%% plot histogram of all inferred spike rate to see if there is a reasonable place to pick the criteria

critRate = 0.02; %inferred spike rate too low = too low a rate to be physiological
critAmpl = 1.2;  %ampl too low = transients not large enough, so probably there was no cell and it was noise

figure;
semilogx(inferRateArray,amplArray,'k.','MarkerSize',20);
hold on;
plot(critRate*[1 1],[0 20],'r');
plot([2e-3 20],critAmpl*[1 1],'r');
xlim([2e-3 20]);
ylim([0 20]);
xlabel('Inferred spike rate (Hz)');
ylabel('Amplitude of dF/F');

disp(['Total number of ROIs across all imaging experiments: ' int2str(numel(inferRateArray))]);
disp(['# ROIs fulfilling inferred event rate criterion: ' int2str(sum(inferRateArray >= critRate))]);
disp(['# ROIs fulfilling amplitude criterion: ' int2str(sum(amplArray >= critAmpl))]);
disp(['# ROIs fulfilling both criteria: ' int2str(sum((inferRateArray >= critRate) & (amplArray >= critAmpl)))]);

%% find cells that could be tracked properly across days, plot their raw data
% for others, exclude

animals_inferRateArray = [];
cells_inferRateArray = [];          %if there is data for >= 5 sessions (for longitudinal analysis)
cells_inferRateArray_twodays = [];  %if there is data for first two sessions (for stress vs control comp)

for j=1:numel(subj_info.subjectLabel)   %for each subject...
    exptIdx = find(subj_info.subjectID==j); %indices of all experiments associated with that subject
    cellID = cellIDArray(exptIDArray==exptIdx(1));  %indices of all cells associated with that subject (use #cells on expt1)
    
    inferRate = []; ampl = [];
    inferRate_twodays = [];
    
    for k=1:numel(cellID)  %for each cell...
        
        t=[]; dFF=[]; day=[];
        for l=1:numel(exptIdx)
            cellIdx = find(cellIDArray==cellID(k) & exptIDArray==exptIdx(l)); %there should be 1 cell index that correspond to that exact cell and exact experiment
            
            if ~isempty(cellIdx)
                day(l) = subj_info.acqdate(exptIdx(l));
                t{l} = tArray{exptIdx(l)};
                dFF{l} = dFFArray{cellIdx};
                % fulfill the two criteria - inferred spike rate and ampl
                if (inferRateArray(cellIdx) >= critRate) && (amplArray(cellIdx) >= critAmpl)
                    inferRate(k,l) = inferRateArray(cellIdx);
                    ampl(k,l) = amplArray(cellIdx);
                else
                    inferRate(k,l) = NaN;
                    ampl(k,l) = NaN;
                end
            else
                day(l) = NaN;
                t{l} = NaN;
                dFF{l} = NaN;
                inferRate(k,l) = NaN;
                ampl(k,l) = NaN;
            end
        end
        
        % criterion #3a: have data for pre-stress and one of first two post-stress sessions, can compare initial repsonse to stress vs control
        inferRate_twodays(k,:) = nan(size(inferRate(k,:)));
         
        temp1 = NaN; temp3 = NaN; temp5 = NaN;
        if any(day==1)   %if day 1 present, access it...
            temp1 = inferRate(k,day==1);
        end
        if any(day==3)
            temp3 = inferRate(k,day==3);
        end
        if any(day==5)
            temp5 = inferRate(k,day==5);
        end
        
        if ~isnan(temp1) && (~isnan(temp3) || ~isnan(temp5))  %must have usable data for day 1 plus day 3 or 5
            inferRate_twodays(k,day==1) = temp1;
            inferRate_twodays(k,day==3) = temp3;
            inferRate_twodays(k,day==5) = temp5;
        end
        
        % criterion #3b: have data for at least 5 sessions, that is we tracked the cell
        if sum(~isnan(inferRate(k,:))) >= 5
            % plot the data for each cell?
            % tlabel = ['Subject ' subj_info.subjectLabel{j} ' Cell ' num2str(cellID(k))];
            % plot_days_fluo_cellbycell(t,dFF,inferRate(k,:),ampl(k,:),day,tlabel);
            % print(gcf,'-dpng',strcat('dff_subj_',tlabel));    %png format
            % saveas(gcf, ['dff_subj_' tlabel], 'fig');
        else
            inferRate(k,:) = NaN;    %if did not fit criterion, blank everything
            ampl(k,:) = NaN;
        end
    end
    
    %save the per-animal summary
    for l=1:numel(exptIdx)
        animals_inferRateArray{exptIdx(l)}.medianSpikeRateInfer = nanmedian(inferRate(:,l));
    end
    
    %save the per-cell summary
    for k=1:numel(cellID)  %for each cell...
        for l=1:numel(exptIdx)
            cellIdx = find(cellIDArray==cellID(k) & exptIDArray==exptIdx(l)); %there should be 1 cell index that correspond to that exact cell and exact experiment
            cells_inferRateArray(cellIdx) = inferRate(k,l);
            cells_inferRateArray_twodays(cellIdx) = inferRate_twodays(k,l);
        end
    end
    
    close all;
    pause(5);  %pause for 5 seconds in case user wants to abort
end

%% per cell - plot number of inferred calcium event rates for day pre vs post-stress

standard_days_params = [];
standard_days_params.stressDays = [2 11];
standard_days_params.stress_shade=[1 0.9 0.9];   %color for shaded area denoting chronic stress period
standard_days_params.maxDay = 16; % only plot data up to this day (because beyond this date, do not have as much data)

params = standard_days_params;
params.zrange = [-1 1];
params.ztitle = {'Change in Ca^{2+} event rate';'([day 1]-[day -1])/([day 1]+[day -1])'};

% plot #events inferred from fluorescence data
plot_days_prepost(cells_inferRateArray_twodays',subj_info,exptIDArray,cellIDArray,params);

%% per cell - plot number of inferred calcium event rates as function of days
% as a heatmap

standard_days_params = [];
standard_days_params.stressDays = [2 11];
standard_days_params.stress_shade=[1 0.9 0.9];   %color for shaded area denoting chronic stress period
standard_days_params.maxDay = 16; % only plot data up to this day (because beyond this date, do not have as much data)

params = standard_days_params;
params.zrange = [-1 1];
params.ztitle = {'Change in Ca^{2+} event rate';'[relative to pre-stress]'};

% plot #events inferred from fluorescence data
plot_days_heatmap(cells_inferRateArray',subj_info,exptIDArray,cellIDArray,params);

%% plays sound when done
load train;
sound(y,Fs);