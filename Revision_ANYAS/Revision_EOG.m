%% IMPACT OF POTENTIAL RESIDUAL EYEBLINK ON THE NEURAL DATA

%% =============================================================
%  EOG CONTROL ANALYSIS
%
%  Reviewer 2: potential ocular contamination of visual MEG effects
%
%  Data:
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
%  EOG channel:
%    EOG001
%
%  Cross-modal comparisons:
%
%    1. Auditory encoding (AE) vs Visual encoding (VE)
%    2. Auditory recognition previously memorised (ARM)
%       vs Visual recognition previously memorised (VRM)
%    3. Auditory recognition novel (ARN)
%       vs Visual recognition novel (VRN)
%
%  Statistics:
%    - RMS EOG magnitude during sequence
%    - paired sign-flip permutation test
%    - Holm correction across the three RMS comparisons
%    - time-resolved paired t-test
%    - max-|t| sign-flip FWE correction across the complete time axis
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

nPerm = 5000;

alpha = 0.05;

rng(12345);

outDir = fullfile(fileparts(fileName),'EOG_Control');

if ~exist(outDir,'dir')
    mkdir(outDir)
end

%% =============================================================
%  LOAD DATA
% ===============================================================

load(fileName,'DATAMEL','DATAVIS','time');

modalities = {'Auditory','Visual'};

dataSets = {DATAMEL,DATAVIS};

%% =============================================================
%  SEQUENCE WINDOW
% ===============================================================

% Five items, 350 ms each
sequenceOffset = 1.75;

baselineIdx = time < 0;

stimIdx = time >= 0 & time <= sequenceOffset;


%% =============================================================
%  CONTRAST DEFINITIONS
% ===============================================================

% Actual condition labels in the MATLAB data

condAuditory = {
    'Encoding'
    'Old_Correct'
    'New_Correct'
    };

condVisual = {
    'Encoding'
    'Old_Correct'
    'New_Correct'
    };

% Paper terminology

paperLabels = {
    'Auditory encoding (AE) vs visual encoding (VE)'
    'Auditory recognition previously memorised (ARM) vs visual recognition previously memorised (VRM)'
    'Auditory recognition novel (ARN) vs visual recognition novel (VRN)'
    };

contrastNames = {
    'AE_vs_VE'
    'ARM_vs_VRM'
    'ARN_vs_VRN'
    };

%% =============================================================
%  FIND PARTICIPANTS WITH ALL REQUIRED CONDITIONS
% ===============================================================

nAud = size(DATAMEL,1);

nVis = size(DATAVIS,1);

if nAud ~= nVis

    error('Auditory and visual datasets contain different numbers of participants.')

end

nSubjects = nAud;

useSubj = false(nSubjects,1);

for ss = 1:nSubjects

    condLabelsAud = DATAMEL{ss,3};

    condLabelsVis = DATAVIS{ss,3};

    if isstring(condLabelsAud)
        condLabelsAud = cellstr(condLabelsAud);
    end

    if isstring(condLabelsVis)
        condLabelsVis = cellstr(condLabelsVis);
    end

    hasAudEnc = ~isempty(find(strcmpi(condLabelsAud,'Encoding'),1));
    hasAudOld = ~isempty(find(strcmpi(condLabelsAud,'Old_Correct'),1));
    hasAudNew = ~isempty(find(strcmpi(condLabelsAud,'New_Correct'),1));

    hasVisEnc = ~isempty(find(strcmpi(condLabelsVis,'Encoding'),1));
    hasVisOld = ~isempty(find(strcmpi(condLabelsVis,'Old_Correct'),1));
    hasVisNew = ~isempty(find(strcmpi(condLabelsVis,'New_Correct'),1));

    if hasAudEnc && hasAudOld && hasAudNew && ...
       hasVisEnc && hasVisOld && hasVisNew

        useSubj(ss) = true;

    end

end

subj = find(useSubj);

n = length(subj);

fprintf('\n=============================================\n')
fprintf('EOG CONTROL ANALYSIS\n')
fprintf('=============================================\n')

fprintf('Participants included: %d\n',n)

if n < 10

    error('Too few participants with all required conditions.')

end

%% =============================================================
%  CHECK EOG001
% ===============================================================

eogIdxAud = nan(n,1);

eogIdxVis = nan(n,1);

for ii = 1:n

    ss = subj(ii);

    labelsAud = DATAMEL{ss,2};

    labelsVis = DATAVIS{ss,2};

    if isstring(labelsAud)
        labelsAud = cellstr(labelsAud);
    end

    if isstring(labelsVis)
        labelsVis = cellstr(labelsVis);
    end

    eogIdxAud(ii) = find(strcmp(labelsAud,'EOG001'),1);

    eogIdxVis(ii) = find(strcmp(labelsVis,'EOG001'),1);

    if isnan(eogIdxAud(ii))

        error(['EOG001 not found in auditory participant ' num2str(ss)])

    end

    if isnan(eogIdxVis(ii))

        error(['EOG001 not found in visual participant ' num2str(ss)])

    end

end

fprintf('EOG001 found in all participants.\n')

%% =============================================================
%  EXTRACT CONDITION-SPECIFIC EOG
%
%  eogAud(:,:,condition)
%  eogVis(:,:,condition)
%
%  dimensions:
%  participant x time x condition
% ===============================================================

nTime = length(time);

eogAud = nan(n,nTime,3);

eogVis = nan(n,nTime,3);

for ii = 1:n

    ss = subj(ii);

    %% Auditory

    XA = DATAMEL{ss,1};

    labelsA = DATAMEL{ss,3};

    if isstring(labelsA)
        labelsA = cellstr(labelsA);
    end

    idxEncA = find(strcmpi(labelsA,'Encoding'),1);
    idxOldA = find(strcmpi(labelsA,'Old_Correct'),1);
    idxNewA = find(strcmpi(labelsA,'New_Correct'),1);

    eogAud(ii,:,1) = XA(eogIdxAud(ii),:,idxEncA);
    eogAud(ii,:,2) = XA(eogIdxAud(ii),:,idxOldA);
    eogAud(ii,:,3) = XA(eogIdxAud(ii),:,idxNewA);

    %% Visual

    XV = DATAVIS{ss,1};

    labelsV = DATAVIS{ss,3};

    if isstring(labelsV)
        labelsV = cellstr(labelsV);
    end

    idxEncV = find(strcmpi(labelsV,'Encoding'),1);
    idxOldV = find(strcmpi(labelsV,'Old_Correct'),1);
    idxNewV = find(strcmpi(labelsV,'New_Correct'),1);

    eogVis(ii,:,1) = XV(eogIdxVis(ii),:,idxEncV);
    eogVis(ii,:,2) = XV(eogIdxVis(ii),:,idxOldV);
    eogVis(ii,:,3) = XV(eogIdxVis(ii),:,idxNewV);

end

%% =============================================================
%  BASELINE CORRECTION
%
%  Baseline is removed separately for each participant and
%  condition using the pre-stimulus period.
% ===============================================================

for ii = 1:n

    for cc = 1:3

        baseA = mean(eogAud(ii,baselineIdx,cc));

        baseV = mean(eogVis(ii,baselineIdx,cc));

        eogAud(ii,:,cc) = eogAud(ii,:,cc) - baseA;

        eogVis(ii,:,cc) = eogVis(ii,:,cc) - baseV;

    end

end

%% =============================================================
%  CONVERT TO EOG MAGNITUDE
%
%  We use absolute EOG amplitude because signed EOG signals can
%  cancel when eye movements occur in opposite directions.
% ===============================================================

eogAudMag = abs(eogAud);

eogVisMag = abs(eogVis);

%% =============================================================
%  STORAGE
% ===============================================================

timeResults = cell(3,1);

rmsAud = nan(n,3);

rmsVis = nan(n,3);

rmsDiff = nan(n,3);

rmsP = nan(3,1);

rmsT = nan(3,1);

rmsMeanAud = nan(3,1);

rmsMeanVis = nan(3,1);

rmsMeanDiff = nan(3,1);

%% =============================================================
%  RUN THREE CROSS-MODAL COMPARISONS
% ===============================================================

for cc = 1:3

    fprintf('\n---------------------------------------------\n')

    fprintf('%s\n',paperLabels{cc})

    fprintf('---------------------------------------------\n')

    %% ---------------------------------------------------------
    %  EOG RMS DURING SEQUENCE
    % ----------------------------------------------------------

    for ii = 1:n

        xA = squeeze(eogAudMag(ii,stimIdx,cc));

        xV = squeeze(eogVisMag(ii,stimIdx,cc));

        rmsAud(ii,cc) = sqrt(mean(xA.^2));

        rmsVis(ii,cc) = sqrt(mean(xV.^2));

        rmsDiff(ii,cc) = rmsAud(ii,cc) - rmsVis(ii,cc);

    end

    rmsMeanAud(cc) = mean(rmsAud(:,cc));

    rmsMeanVis(cc) = mean(rmsVis(:,cc));

    rmsMeanDiff(cc) = mean(rmsDiff(:,cc));

    %% ---------------------------------------------------------
    %  PERMUTATION TEST FOR RMS
    % ----------------------------------------------------------

    d = rmsDiff(:,cc);

    obsT = mean(d) / ...
        (std(d,0,1) / sqrt(n));

    permT = zeros(nPerm,1);

    signs = 2*(rand(nPerm,n) > 0.5)-1;

    permMean = mean(signs .* d',2);

    permSD = std(signs .* d',0,2);

    permT = permMean ./ ...
        (permSD ./ sqrt(n));

    rmsP(cc) = ...
        (1 + sum(abs(permT) >= abs(obsT))) ...
        / (nPerm + 1);

    rmsT(cc) = obsT;

    %% ---------------------------------------------------------
    %  TIME-RESOLVED ANALYSIS
    % ----------------------------------------------------------

    D = squeeze(eogAudMag(:,:,cc) - eogVisMag(:,:,cc));

    % Observed t
    meanD = mean(D,1);

    sdD = std(D,0,1);

    tObs = meanD ./ ...
        (sdD ./ sqrt(n));

    %% ---------------------------------------------------------
    %  MAX-T SIGN-FLIP PERMUTATIONS ACROSS TIME
    % ----------------------------------------------------------

    maxT = zeros(nPerm,1);

    chunkSize = 100;

    nDone = 0;

    while nDone < nPerm

        nThis = min(chunkSize,nPerm-nDone);

        signs = ...
            2*(rand(nThis,n) > 0.5)-1;

        permMean = ...
            (signs * D) ./ n;

        sumSq = sum(D.^2,1);

        permVar = ...
            (sumSq - n*(permMean.^2)) ./ (n-1);

        permVar(permVar < 0) = 0;

        permSD = sqrt(permVar);

        permT = ...
            permMean ./ ...
            (permSD ./ sqrt(n));

        maxT(nDone+1:nDone+nThis) = ...
            max(abs(permT),[],2);

        nDone = nDone + nThis;

    end

    %% ---------------------------------------------------------
    %  FWE-CORRECTED P VALUES
    % ----------------------------------------------------------

    pCorr = zeros(1,nTime);

    for tt = 1:nTime

        pCorr(tt) = ...
            (1 + sum(maxT >= abs(tObs(tt)))) ...
            / (nPerm + 1);

    end

    sig = pCorr < alpha;

    %% ---------------------------------------------------------
    %  SAVE RESULTS
    % ----------------------------------------------------------

    R = [];

    R.paperLabel = paperLabels{cc};

    R.contrast = contrastNames{cc};

    R.t = tObs;

    R.p = pCorr;

    R.sig = sig;

    R.maxT = maxT;

    R.threshold = ...
        prctile(maxT,100*(1-alpha));

    R.firstSig = NaN;

    R.lastSig = NaN;

    R.peakAbsT = NaN;

    R.peakSignedT = NaN;

    R.peakTime = NaN;

    R.rmsAud = rmsAud(:,cc);

    R.rmsVis = rmsVis(:,cc);

    R.rmsDiff = rmsDiff(:,cc);

    R.rmsT = obsT;

    R.rmsP = rmsP(cc);

    if any(sig)

        sigTimes = find(sig);

        R.firstSig = time(sigTimes(1));

        R.lastSig = time(sigTimes(end));

        absT = abs(tObs);

        absT(~sig) = -Inf;

        [R.peakAbsT,idxPeak] = max(absT);

        R.peakSignedT = tObs(idxPeak);

        R.peakTime = time(idxPeak);

    end

    timeResults{cc} = R;

    %% ---------------------------------------------------------
    %  PRINT RESULTS
    % ----------------------------------------------------------

    fprintf('Auditory RMS: %.6f\n',rmsMeanAud(cc))

    fprintf('Visual RMS: %.6f\n',rmsMeanVis(cc))

    fprintf('Auditory - Visual RMS: %.6f\n',rmsMeanDiff(cc))

    fprintf('RMS permutation t: %.3f\n',rmsT(cc))

    fprintf('RMS permutation p: %.5f\n',rmsP(cc))

    fprintf('Time FWE threshold |t|: %.3f\n',R.threshold)

    if any(sig)

        fprintf('Time-resolved FWE-significant effect: YES\n')

        fprintf('Peak |t|: %.3f\n',R.peakAbsT)

        fprintf('Peak t: %.3f\n',R.peakSignedT)

        fprintf('Peak time: %.4f s\n',R.peakTime)

        fprintf('First significant time: %.4f s\n',R.firstSig)

        fprintf('Last significant time: %.4f s\n',R.lastSig)

    else

        fprintf('Time-resolved FWE-significant effect: NO\n')

    end

end

%% =============================================================
%  HOLM CORRECTION ACROSS THE THREE RMS TESTS
% ===============================================================

[rmsPSorted,sortIdx] = sort(rmsP);

m = numel(rmsP);

% Standard Holm-Bonferroni correction
pAdjusted = (m:-1:1)' .* rmsPSorted(:);

% Enforce monotonicity
pAdjusted = min(1,cummax(pAdjusted));

% Restore original comparison order
holmP = nan(size(rmsP));
holmP(sortIdx) = pAdjusted;


%% =============================================================
%  ADD HOLM P VALUES TO RESULTS
% ===============================================================

for cc = 1:3

    timeResults{cc}.rmsPHolm = holmP(cc);

end

%% =============================================================
%  SUMMARY TABLE
% ===============================================================

Summary = table;

for cc = 1:3

    R = timeResults{cc};

    row = table;

    row.Contrast = {contrastNames{cc}};

    row.ContrastLabel = {paperLabels{cc}};

    row.Nsubjects = n;

    row.Npermutations = nPerm;

    row.Auditory_RMS = rmsMeanAud(cc);

    row.Visual_RMS = rmsMeanVis(cc);

    row.Auditory_minus_Visual_RMS = rmsMeanDiff(cc);

    row.RMS_t = rmsT(cc);

    row.RMS_p = rmsP(cc);

    row.RMS_p_Holm = holmP(cc);

    row.Time_FWE_t_threshold = R.threshold;

    row.Peak_abs_t = R.peakAbsT;

    row.Peak_signed_t = R.peakSignedT;

    row.Peak_time_s = R.peakTime;

    row.First_significant_time_s = R.firstSig;

    row.Last_significant_time_s = R.lastSig;

    if any(R.sig)

        row.Time_FWE_significant = {'Yes'};

    else

        row.Time_FWE_significant = {'No'};

    end

    if cc == 1

        Summary = row;

    else

        Summary = [Summary;row];

    end

end

writetable(Summary, ...
    fullfile(outDir,'EOG_Control_Statistics_Summary.xlsx'))

%% =============================================================
%  SAVE MATLAB RESULTS
% ===============================================================

save(fullfile(outDir,'EOG_Control_Results.mat'), ...
    'timeResults', ...
    'eogAud', ...
    'eogVis', ...
    'eogAudMag', ...
    'eogVisMag', ...
    'rmsAud', ...
    'rmsVis', ...
    'rmsDiff', ...
    'holmP', ...
    'time', ...
    'subj', ...
    'nPerm', ...
    'alpha', ...
    '-v7.3')

%% =============================================================
%  CREATE FIGURE
% ===============================================================

makeEOGFigure( ...
    timeResults, ...
    time, ...
    sequenceOffset, ...
    rmsMeanAud, ...
    rmsMeanVis, ...
    holmP, ...
    fullfile(outDir,'Figure_S4_EOG_Control.pdf'))

%% =============================================================
%  DONE
% ===============================================================

fprintf('\n\n=============================================\n')
fprintf('EOG ANALYSIS COMPLETE\n')
fprintf('=============================================\n')

fprintf('Results saved in:\n%s\n',outDir)


%% =============================================================
%  FUNCTION:
%  CREATE EOG FIGURE
% ===============================================================

function makeEOGFigure( ...
    results, ...
    time, ...
    sequenceOffset, ...
    rmsAud, ...
    rmsVis, ...
    holmP, ...
    fileName)

    figure( ...
        'Color','w', ...
        'Position',[100 100 1400 1000])

    tl = tiledlayout(2,2, ...
        'TileSpacing','compact', ...
        'Padding','compact');

    title(tl, ...
        'FontWeight','bold')

    %% =========================================================
    %  PANELS A-C: EOG TIME COURSES
    % ==========================================================

    for cc = 1:3

        nexttile

        R = results{cc};

        %% Participant-level mean time courses

        % These are absolute EOG signals.
        %
        % We reconstruct the group mean from the stored
        % participant-level RMS-related time courses if needed.
        %
        % Here we use the time-resolved t-statistic as the
        % inferential display.

        plot(time,R.t, ...
            'k','LineWidth',1.2)

        hold on

        yline(0,'k:')

        xline(0,'k--')

        xline(sequenceOffset,'k:', ...
            'LineWidth',1)

        %% Highlight significant periods

        y = R.t;

        y(~R.sig) = NaN;

        plot(time,y, ...
            'r','LineWidth',2)

        xlabel('Time (s)')

        ylabel('t-value')

        title(R.paperLabel, ...
            'Interpreter','none')

        if any(R.sig)

            txt = sprintf( ...
                'FWE-significant: %.3f-%.3f s', ...
                R.firstSig, ...
                R.lastSig);

            text( ...
                0.02,0.95,txt, ...
                'Units','normalized', ...
                'VerticalAlignment','top')

        else

            text( ...
                0.02,0.95, ...
                'No FWE-significant time points', ...
                'Units','normalized', ...
                'VerticalAlignment','top')

        end

        legend( ...
            {'t-value','FWE-significant'}, ...
            'Location','best')

        box off

    end

    %% =========================================================
    %  PANEL D: RMS SUMMARY
    % ==========================================================

    nexttile

    X = 1:3;

    hold on

    for kk = 1:3

        plot( ...
            [X(kk)-0.12 X(kk)+0.12], ...
            [rmsAud(kk) rmsAud(kk)], ...
            'ko-', ...
            'MarkerFaceColor','k')

        plot( ...
            [X(kk)-0.12 X(kk)+0.12], ...
            [rmsVis(kk) rmsVis(kk)], ...
            'ks-', ...
            'MarkerFaceColor','w')

    end

    xlim([0.5 3.5])

    xticks(1:3)

    xticklabels({'AE vs VE','ARM vs VRM','ARN vs VRN'})

    xtickangle(20)

    ylabel('Mean EOG RMS')

    title('Residual EOG magnitude during sequence')

    legend( ...
        {'Auditory','Visual'}, ...
        'Location','best')

    %% Add Holm p-values

    for kk = 1:3

        yMax = max(rmsAud(kk),rmsVis(kk));

        ylimNow = ylim;

        text( ...
            kk, ...
            yMax + 0.04*(ylimNow(2)-ylimNow(1)), ...
            sprintf('p_{Holm}=%.3f',holmP(kk)), ...
            'HorizontalAlignment','center')

    end

    box off

    %% =========================================================
    %  EXPORT
    % ==========================================================

    exportgraphics( ...
        gcf, ...
        fileName, ...
        'ContentType','vector')

    close(gcf)

end

%%