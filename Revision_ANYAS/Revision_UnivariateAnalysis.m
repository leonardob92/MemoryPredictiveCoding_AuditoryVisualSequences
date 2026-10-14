% % AUDIO/VISUAL RECOGNITION - REVISION - ANNALS OF THE NEW YORK ACADEMY OF SCIENCES

%% =============================================================
%  UNIVARIATE ANALYSIS
%
%  Complementary mass-univariate analysis for Reviewer 1
%
%  DATA
%    DATAMEL = auditory data, 83 x 3 cell
%    DATAVIS = visual data,   83 x 3 cell
%    time    = 1 x 1126 vector
%
%  Column 1:
%    channels x time x conditions
%
%  Column 2:
%    channel labels
%
%  Column 3:
%    condition labels
%
%  CONDITION LABELS IN THE DATA
%    Encoding
%    Old_Correct
%    New_Correct
%
%  PAPER TERMINOLOGY
%    Auditory recognition previously memorised (ARM)
%    Auditory recognition novel (ARN)
%    Visual recognition previously memorised (VRM)
%    Visual recognition novel (VRN)
%    Auditory encoding (AE)
%    Auditory recognition (AR)
%    Visual encoding (VE)
%    Visual recognition (VR)
%
%  CONTRASTS
%    1. ARM vs ARN
%       Old_Correct - New_Correct
%
%    2. AE vs AR
%       Encoding - Old_Correct
%
%  Analysed independently for:
%    - Magnetometers
%    - Combined planar gradiometers
%
%  STATISTICS
%    Paired t-test across participants at every sensor/time point
%    Sign-flip permutation test
%    Maximum-|t| FWE correction across the complete sensor x time matrix
%
%  No FieldTrip or external statistical functions required.
%
% ===============================================================

clear
close all
clc

%% =============================================================
%  SETTINGS
% ===============================================================

fileName = '/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/AnnalsNewYork/Revision_I/Codex/Data/MEG_Univariate/MEGUni.mat';

nPerm = 5000;       % number of sign-flip permutations
alpha = 0.05;       % family-wise alpha
rng(12345);         % reproducibility

outDir = fullfile(fileparts(fileName),'Univariate_AllContrasts');

if ~exist(outDir,'dir')
    mkdir(outDir)
end

%% =============================================================
%  SEQUENCE TIMING FOR FIGURES
% ===============================================================

itemOnsets = [0 0.35 0.70 1.05 1.40];

sequenceOffset = 1.75;

%% =============================================================
%  LOAD DATA
% ===============================================================

load(fileName,'DATAMEL','DATAVIS','time');

modalities = {'Auditory','Visual'};

dataSets = {DATAMEL,DATAVIS};

%% =============================================================
%  CONTRAST DEFINITIONS
%
%  NOTE:
%  condA / condB are the actual MATLAB condition names.
%  paperLabel is the terminology used in the manuscript.
% ===============================================================

contrastNames = {
    'ARM_vs_ARN'
    'AE_vs_AR'
    };

paperLabelsAuditory = {
    'Auditory recognition previously memorised (ARM) vs auditory recognition novel (ARN)'
    'Auditory encoding (AE) vs auditory recognition (AR)'
    };

paperLabelsVisual = {
    'Visual recognition previously memorised (VRM) vs visual recognition novel (VRN)'
    'Visual encoding (VE) vs visual recognition (VR)'
    };

condA_names = {
    'Old_Correct'
    'Encoding'
    };

condB_names = {
    'New_Correct'
    'Old_Correct'
    };

%% =============================================================
%  RESULTS STORAGE
%
%  allResults{modality,contrast,sensor}
%
%  modality:
%    1 = auditory
%    2 = visual
%
%  contrast:
%    1 = recognition previously memorised vs novel
%    2 = encoding vs recognition
%
%  sensor:
%    1 = magnetometers
%    2 = planar gradiometers
% ===============================================================

allResults = cell(2,2,2);

%% =============================================================
%  MAIN LOOP
% ===============================================================

for mm = 1:2
    
    fprintf('\n\n=============================================\n')
    fprintf('%s\n',modalities{mm})
    fprintf('=============================================\n')
    
    dataCell = dataSets{mm};
    
    %% ---------------------------------------------------------
    %  PAPER LABELS FOR THIS MODALITY
    % ----------------------------------------------------------
    
    if mm == 1
        
        paperLabels = paperLabelsAuditory;
        
    else
        
        paperLabels = paperLabelsVisual;
        
    end
    
    %% ---------------------------------------------------------
    %  FIND PARTICIPANTS
    % ----------------------------------------------------------
    
    nSubjects = size(dataCell,1);
    
    useSubj = false(nSubjects,1);
    
    for ss = 1:nSubjects
        
        condLabels = dataCell{ss,3};
        
        if isstring(condLabels)
            condLabels = cellstr(condLabels);
        end
        
        hasOld = ~isempty(find(strcmpi(condLabels,'Old_Correct'),1));
        
        hasNew = ~isempty(find(strcmpi(condLabels,'New_Correct'),1));
        
        hasEnc = ~isempty(find(strcmpi(condLabels,'Encoding'),1));
        
        if hasOld && hasNew && hasEnc
            
            useSubj(ss) = true;
            
        end
        
    end
    
    subj = find(useSubj);
    
    n = length(subj);
    
    fprintf('Participants included: %d\n',n)
    
    if n < 10
        
        error('Too few participants with all required conditions.')
        
    end
    
    %% ---------------------------------------------------------
    %  CHANNEL INFORMATION
    % ----------------------------------------------------------
    
    chanLabelsAll = dataCell{subj(1),2};
    
    if isstring(chanLabelsAll)
        
        chanLabelsAll = cellstr(chanLabelsAll);
        
    end
    
    % Find MEG channels
    megIdx = find(startsWith(chanLabelsAll,'MEG'));
    
    if isempty(megIdx)
        
        error('No MEG channels found.')
        
    end
    
    % Existing data structure:
    % magnetometer / combined planar / magnetometer / combined planar
    
    magIdx = megIdx(1:2:end);
    
    gradIdx = megIdx(2:2:end);
    
    magLabels = chanLabelsAll(magIdx);
    
    gradLabels = chanLabelsAll(gradIdx);
    
    fprintf('MEG channels found: %d\n',length(megIdx))
    
    fprintf('Magnetometers: %d\n',length(magIdx))
    
    fprintf('Combined planar gradiometers: %d\n',length(gradIdx))
    
    %% ---------------------------------------------------------
    %  BASIC DATA SIZE CHECK
    % ----------------------------------------------------------
    
    nTime = length(time);
    
    Xfirst = dataCell{subj(1),1};
    
    if size(Xfirst,2) ~= nTime
        
        error('Number of time points in data does not match time vector.')
        
    end
    
    %% ---------------------------------------------------------
    %  LOOP OVER CONTRASTS
    % ----------------------------------------------------------
    
    for cc = 1:2
        
        fprintf('\n---------------------------------------------\n')
        fprintf('%s\n',paperLabels{cc})
        fprintf('---------------------------------------------\n')
        
        %% -----------------------------------------------------
        %  CREATE PARTICIPANT x CHANNEL x TIME DIFFERENCES
        % ------------------------------------------------------
        
        nMag = length(magIdx);
        
        nGrad = length(gradIdx);
        
        diffMag = nan(n,nMag,nTime);
        
        diffGrad = nan(n,nGrad,nTime);
        
        for ii = 1:n
            
            ss = subj(ii);
            
            condLabels = dataCell{ss,3};
            
            if isstring(condLabels)
                
                condLabels = cellstr(condLabels);
                
            end
            
            idxA = find(strcmpi(condLabels,condA_names{cc}),1);
            
            idxB = find(strcmpi(condLabels,condB_names{cc}),1);
            
            if isempty(idxA) || isempty(idxB)
                
                error(['Missing condition in participant ' num2str(ss)])
                
            end
            
            X = dataCell{ss,1};
            
            if size(X,2) ~= nTime
                
                error('Time dimension differs across participants.')
                
            end
            
            % Difference according to contrast
            %
            % cc = 1:
            %   Old_Correct - New_Correct
            %
            % cc = 2:
            %   Encoding - Old_Correct
            
            dataA = X(:,:,idxA);
            
            dataB = X(:,:,idxB);
            
            d = dataA - dataB;
            
            diffMag(ii,:,:) = d(magIdx,:);
            
            diffGrad(ii,:,:) = d(gradIdx,:);
            
        end
        
        %% -----------------------------------------------------
        %  CHECK FOR NaNs
        % ------------------------------------------------------
        
        if any(isnan(diffMag(:)))
            
            error('NaN values found in magnetometer data.')
            
        end
        
        if any(isnan(diffGrad(:)))
            
            error('NaN values found in gradiometer data.')
            
        end
        
        %% -----------------------------------------------------
        %  MAGNETOMETERS
        % ------------------------------------------------------
        
        fprintf('\nRunning magnetometer analysis...\n')
        
        resultsMag = maxT_permutation(diffMag,nPerm,alpha);
        
        resultsMag.labels = magLabels;
        
        resultsMag.sensorType = 'Magnetometers';
        
        resultsMag.modality = modalities{mm};
        
        resultsMag.contrast = contrastNames{cc};
        
        resultsMag.paperLabel = paperLabels{cc};
        
        resultsMag.subjects = subj;
        
        allResults{mm,cc,1} = resultsMag;
        
        %% -----------------------------------------------------
        %  PLANAR GRADIOMETERS
        % ------------------------------------------------------
        
        fprintf('\nRunning planar gradiometer analysis...\n')
        
        resultsGrad = maxT_permutation(diffGrad,nPerm,alpha);
        
        resultsGrad.labels = gradLabels;
        
        resultsGrad.sensorType = 'Planar gradiometers';
        
        resultsGrad.modality = modalities{mm};
        
        resultsGrad.contrast = contrastNames{cc};
        
        resultsGrad.paperLabel = paperLabels{cc};
        
        resultsGrad.subjects = subj;
        
        allResults{mm,cc,2} = resultsGrad;
        
        %% -----------------------------------------------------
        %  PRINT RESULTS
        % ------------------------------------------------------
        
        printResults(resultsMag,time)
        
        printResults(resultsGrad,time)
        
    end
end

%% =============================================================
%  SAVE ALL RESULTS
% ===============================================================

save(fullfile(outDir,'All_Univariate_Results.mat'), ...
    'allResults','time','modalities', ...
    'contrastNames','nPerm','alpha','-v7.3')

%% =============================================================
%  CREATE SUMMARY TABLE
% ===============================================================

Summary = table;

row = 0;

for mm = 1:2
    
    for cc = 1:2
        
        for ss = 1:2
            
            row = row + 1;
            
            R = allResults{mm,cc,ss};
            
            T = summaryTable(R,time);
            
            T.Modality = {modalities{mm}};
            
            T.Contrast = {R.contrast};
            
            T.ContrastLabel = {R.paperLabel};
            
            T.SensorType = {R.sensorType};
            
            if row == 1
                
                Summary = T;
                
            else
                
                Summary = [Summary; T];
                
            end
            
        end
        
    end
    
end

writetable(Summary, ...
    fullfile(outDir,'All_Univariate_Statistics_Summary.xlsx'))

%% =============================================================
%  FIGURE U1
%
%  RECOGNITION:
%
%  Auditory recognition previously memorised (ARM)
%  vs auditory recognition novel (ARN)
%
%  Visual recognition previously memorised (VRM)
%  vs visual recognition novel (VRN)
% ===============================================================

makeCompositeFigure( ...
    allResults, ...
    1, ...
    time, ...
    'Recognition of previously memorised vs novel sequences', ...
    fullfile(outDir,'Figure_U1_Univariate_ARM_ARN_VRM_VRN.pdf'), ...
    itemOnsets, ...
    sequenceOffset)

%% =============================================================
%  FIGURE U2
%
%  Auditory encoding (AE) vs auditory recognition (AR)
%  Visual encoding (VE) vs visual recognition (VR)
% ===============================================================

makeCompositeFigure( ...
    allResults, ...
    2, ...
    time, ...
    'Encoding vs recognition of sequences', ...
    fullfile(outDir,'Figure_U2_Univariate_AE_AR_VE_VR.pdf'), ...
    itemOnsets, ...
    sequenceOffset)

%% =============================================================
%  DONE
% ===============================================================

fprintf('\n\n=============================================\n')
fprintf('DONE\n')
fprintf('=============================================\n')

fprintf('Results saved in:\n%s\n',outDir)


%% =============================================================
%  FUNCTION 1:
%  MAX-T SIGN-FLIP PERMUTATION
% ===============================================================

function results = maxT_permutation(diffData,nPerm,alpha)

% diffData:
% subjects x channels x time

[nSub,nChan,nTime] = size(diffData);

% Reshape:
% subjects x (channels x time)

D = reshape(diffData,nSub,nChan*nTime);

%% Observed paired t-statistic

meanD = mean(D,1);

sdD = std(D,0,1);

tObs = meanD ./ (sdD ./ sqrt(nSub));

%% Sign-flip permutations

maxT = zeros(nPerm,1);

chunkSize = 50;

nDone = 0;

sumSq = sum(D.^2,1);

while nDone < nPerm
    
    nThis = min(chunkSize,nPerm-nDone);
    
    % Random +/-1 signs
    
    signs = 2*(rand(nThis,nSub) > 0.5)-1;
    
    % Permuted mean
    
    permMean = (signs * D) ./ nSub;
    
    % Permutation variance
    
    permVar = ...
        (sumSq - nSub*(permMean.^2)) ./ (nSub-1);
    
    permVar(permVar < 0) = 0;
    
    permSD = sqrt(permVar);
    
    % Permutation t
    
    permT = permMean ./ ...
        (permSD ./ sqrt(nSub));
    
    % Maximum absolute statistic over:
    % ALL sensors x ALL time points
    
    maxT(nDone+1:nDone+nThis) = ...
        max(abs(permT),[],2);
    
    nDone = nDone + nThis;
    
    fprintf('  permutation %d / %d\n', ...
        nDone,nPerm)
    
end

%% FWE-corrected p values

absObs = abs(tObs);

pCorr = zeros(size(absObs));

for kk = 1:length(absObs)
    
    pCorr(kk) = ...
        (1 + sum(maxT >= absObs(kk))) ...
        / (nPerm + 1);
    
end

%% Reshape back to channel x time

results = [];

results.t = reshape(tObs,nChan,nTime);

results.p = reshape(pCorr,nChan,nTime);

results.sig = results.p < alpha;

results.maxT = maxT;

results.threshold = ...
    prctile(maxT,100*(1-alpha));

results.nSubjects = nSub;

results.nPerm = nPerm;

end


%% =============================================================
%  FUNCTION 2:
%  PRINT KEY RESULTS
% ===============================================================

function printResults(results,time)

fprintf('\n---------------------------------------------\n')

fprintf('%s\n',results.modality)

fprintf('%s\n',results.paperLabel)

fprintf('%s\n',results.sensorType)

fprintf('---------------------------------------------\n')

sig = results.sig;

nSig = sum(sig(:));

fprintf('Participants: %d\n',results.nSubjects)

fprintf('Permutations: %d\n',results.nPerm)

fprintf('FWE threshold |t|: %.3f\n',results.threshold)

fprintf('FWE-significant sensor-time samples: %d\n',nSig)

if nSig > 0
    
    absT = abs(results.t);
    
    absT(~sig) = -Inf;
    
    [peakAbsT,idx] = max(absT(:));
    
    [chanIdx,timeIdx] = ind2sub(size(absT),idx);
    
    peakSignedT = results.t(chanIdx,timeIdx);
    
    peakP = results.p(chanIdx,timeIdx);
    
    fprintf('Peak significant |t|: %.3f\n',peakAbsT)
    
    fprintf('Peak signed t: %.3f\n',peakSignedT)
    
    fprintf('Peak time: %.4f s\n',time(timeIdx))
    
    fprintf('Peak channel: %s\n', ...
        results.labels{chanIdx})
    
    fprintf('Corrected p at peak: %.5f\n',peakP)
    
    if peakSignedT > 0
        
        fprintf('Direction: first condition > second condition\n')
        
    else
        
        fprintf('Direction: first condition < second condition\n')
        
    end
    
    sigTimes = find(any(sig,1));
    
    if ~isempty(sigTimes)
        
        fprintf('First significant time point: %.4f s\n', ...
            time(sigTimes(1)))
        
        fprintf('Last significant time point: %.4f s\n', ...
            time(sigTimes(end)))
        
    end
    
else
    
    fprintf('No sensor-time point survived FWE correction.\n')
    
end

end


%% =============================================================
%  FUNCTION 3:
%  COMPOSITE 2 x 2 FIGURE
% ===============================================================

function makeCompositeFigure( ...
    allResults, ...
    contrastIndex, ...
    time, ...
    figureTitle, ...
    fileName, ...
    itemOnsets, ...
    sequenceOffset)

%% ---------------------------------------------------------
%  COLLECT RESULTS
% ----------------------------------------------------------

R_AM = allResults{1,contrastIndex,1};

R_AG = allResults{1,contrastIndex,2};

R_VM = allResults{2,contrastIndex,1};

R_VG = allResults{2,contrastIndex,2};

Rall = {R_AM,R_AG,R_VM,R_VG};

%% ---------------------------------------------------------
%  COMMON COLOR SCALE
% ----------------------------------------------------------

maxAbsT = 0;

for kk = 1:4
    
    maxAbsT = max( ...
        maxAbsT, ...
        max(abs(Rall{kk}.t(:))));
    
end

zmax = ceil(maxAbsT);

if zmax < 4
    
    zmax = 4;
    
end

%% ---------------------------------------------------------
%  FIGURE
% ----------------------------------------------------------

figure( ...
    'Color','w', ...
    'Position',[100 100 1400 1000])

tl = tiledlayout(2,2, ...
    'TileSpacing','compact', ...
    'Padding','compact');

title(tl,figureTitle,'FontWeight','bold')

for kk = 1:4
    
    R = Rall{kk};
    
    nexttile
    
    %% T MAP
    
    imagesc( ...
        time, ...
        1:length(R.labels), ...
        R.t)
    
    axis xy
    
    caxis([-zmax zmax])
    
    xlabel('Time (s)')
    
    ylabel('MEG channel')
    
    %% Use paper terminology in titles
    
    %% Use paper terminology + sensor type in titles
    
    if strcmp(R.modality,'Auditory')
        
        if strcmp(R.contrast,'ARM_vs_ARN')
            
            if strcmp(R.sensorType,'Magnetometers')
                title('Auditory: ARM vs ARN - Magnetometers')
            else
                title('Auditory: ARM vs ARN - Planar gradiometers')
            end
            
        else
            
            if strcmp(R.sensorType,'Magnetometers')
                title('Auditory: AE vs AR - Magnetometers')
            else
                title('Auditory: AE vs AR - Planar gradiometers')
            end
            
        end
        
    else
        
        if strcmp(R.contrast,'ARM_vs_ARN')
            
            if strcmp(R.sensorType,'Magnetometers')
                title('Visual: VRM vs VRN - Magnetometers')
            else
                title('Visual: VRM vs VRN - Planar gradiometers')
            end
            
        else
            
            if strcmp(R.sensorType,'Magnetometers')
                title('Visual: VE vs VR - Magnetometers')
            else
                title('Visual: VE vs VR - Planar gradiometers')
            end
            
        end
        
    end
    
    hold on
    
    %% FWE SIGNIFICANCE
    
    contour( ...
        time, ...
        1:length(R.labels), ...
        R.sig, ...
        [1 1], ...
        'k', ...
        'LineWidth',0.5)
    
    %% ITEM ONSETS
    
    for tt = 1:length(itemOnsets)
        
        xline( ...
            itemOnsets(tt), ...
            'k--', ...
            'LineWidth',0.5)
        
    end
    
    %% SEQUENCE OFFSET
    
    xline( ...
        sequenceOffset, ...
        'k:', ...
        'LineWidth',0.8)
    
    %% STIMULUS ONSET
    
    xline( ...
        0, ...
        'k', ...
        'LineWidth',0.8)
    
    set(gca,'Layer','top')
    
    cb = colorbar;
    
    ylabel(cb,'t-value')
    
end

%% ---------------------------------------------------------
%  COLORMAP
% ----------------------------------------------------------

colormap(makeBlueWhiteRed(256))

%% ---------------------------------------------------------
%  EXPORT
% ----------------------------------------------------------

exportgraphics( ...
    gcf, ...
    fileName, ...
    'ContentType','vector')

close(gcf)

end


%% =============================================================
%  FUNCTION 4:
%  SUMMARY TABLE
% ===============================================================

function T = summaryTable(results,time)

sig = results.sig;

if any(sig(:))
    
    absT = abs(results.t);
    
    absT(~sig) = -Inf;
    
    [peakAbsT,idx] = max(absT(:));
    
    [peakChan,peakTime] = ind2sub(size(absT),idx);
    
    peakSignedT = results.t(peakChan,peakTime);
    
    peakP = results.p(peakChan,peakTime);
    
    sigTimes = find(any(sig,1));
    
    firstSig = time(sigTimes(1));
    
    lastSig = time(sigTimes(end));
    
    nSig = sum(sig(:));
    
    if peakSignedT > 0
        
        direction = 'First condition > second condition';
        
    else
        
        direction = 'First condition < second condition';
        
    end
    
else
    
    peakAbsT = NaN;
    
    peakSignedT = NaN;
    
    peakChan = NaN;
    
    peakTime = NaN;
    
    peakP = NaN;
    
    firstSig = NaN;
    
    lastSig = NaN;
    
    nSig = 0;
    
    direction = 'None';
    
end

%% Create table

T = table;

T.Nsubjects = results.nSubjects;

T.Npermutations = results.nPerm;

T.FWE_t_threshold = results.threshold;

T.N_FWE_significant_sensor_time_samples = nSig;

T.Peak_abs_t = peakAbsT;

T.Peak_signed_t = peakSignedT;

if ~isnan(peakChan)
    
    T.Peak_channel = ...
        {results.labels{peakChan}};
    
else
    
    T.Peak_channel = {''};
    
end

if ~isnan(peakTime)
    
    T.Peak_time_s = time(peakTime);
    
else
    
    T.Peak_time_s = NaN;
    
end

T.Peak_corrected_p = peakP;

T.Peak_direction = {direction};

T.First_significant_time_s = firstSig;

T.Last_significant_time_s = lastSig;

end


%% =============================================================
%  FUNCTION 5:
%  BLUE-WHITE-RED COLORMAP
% ===============================================================

function cmap = makeBlueWhiteRed(n)

n1 = floor(n/2);

n2 = n - n1;

blueToWhite = ...
    [linspace(0,1,n1)' ...
    linspace(0,1,n1)' ...
    ones(n1,1)];

whiteToRed = ...
    [ones(n2,1) ...
    linspace(1,0,n2)' ...
    linspace(1,0,n2)'];

cmap = [blueToWhite;whiteToRed];

end

%%
