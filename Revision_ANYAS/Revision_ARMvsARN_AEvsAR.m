%% =============================================================
% DIRECT COMPARISON OF TEMPORAL GENERALISATION MATRICES
%
% Reviewer 1:
% Direct statistical comparison of:
%
%   ARM vs ARN
%       versus
%   AE vs AR
%
% ddTG2 dimensions:
%
%   ARM vs ARN:
%       776 x 776 x participants
%
%   AE vs AR:
%       1126 x 1126 x participants
%
% Both analyses start at the same physical time.
% Therefore, AE vs AR is restricted to the temporal window
% covered by ARM vs ARN before statistical comparison.
%
% Statistics:
%   Paired comparison across participants
%   Sign-flip permutation test
%   Maximum-|t| FWE correction across the COMPLETE
%   common train-time x test-time matrix
%
% Positive t-values:
%       AE vs AR > ARM vs ARN
%
% Negative t-values:
%       ARM vs ARN > AE vs AR
%
% ===============================================================

clear
close all
clc

%% =============================================================
% SETTINGS
% ===============================================================

file_ARM_ARN = ...
    '/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/AnnalsNewYork/Revision_I/Codex/Data/Decoding/ARM_vs_ARN/Stats.mat';

file_AE_AR = ...
    '/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/AnnalsNewYork/Revision_I/Codex/Data/Decoding/AE_vs_AR/Stats.mat';

% File containing the complete time vector
file_MEG = ...
    '/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/AnnalsNewYork/Revision_I/Codex/Data/MEG_Univariate/MEGUni.mat';

nPerm = 5000;

alpha = 0.05;

rng(12345);

outDir = fullfile( ...
    fileparts(file_ARM_ARN), ...
    'TG_DirectComparison_ARM_ARN_vs_AE_AR');

if ~exist(outDir,'dir')
    mkdir(outDir)
end

%% =============================================================
% LOAD TEMPORAL GENERALISATION DATA
% ===============================================================

A = load(file_ARM_ARN,'ddTG2');

B = load(file_AE_AR,'ddTG2');

TG_ARM_ARN = A.ddTG2;

TG_AE_AR_full = B.ddTG2;

%% =============================================================
% LOAD TIME VECTOR
% ===============================================================

T = load(file_MEG,'time');

timeFull = T.time(:)';

%% =============================================================
% DISPLAY ORIGINAL DIMENSIONS
% ===============================================================

fprintf('\n=============================================\n')
fprintf('ORIGINAL DATA DIMENSIONS\n')
fprintf('=============================================\n')

fprintf('ARM vs ARN:\n')
disp(size(TG_ARM_ARN))

fprintf('AE vs AR:\n')
disp(size(TG_AE_AR_full))

%% =============================================================
% CHECK PARTICIPANT DIMENSION
% ===============================================================

nSub_ARM = size(TG_ARM_ARN,3);

nSub_AE = size(TG_AE_AR_full,3);

if nSub_ARM ~= nSub_AE

    error(['Different number of participants: ' ...
        'ARM-ARN = %d, AE-AR = %d'], ...
        nSub_ARM,nSub_AE)

end

nSub = nSub_ARM;

fprintf('Participants: %d\n',nSub)

%% =============================================================
% DEFINE COMMON TEMPORAL WINDOW
%
% ARM vs ARN is the shorter analysis.
%
% Both analyses begin at exactly the same physical time.
% Therefore, retain the first N samples from AE vs AR,
% where N is the length of ARM vs ARN.
% ===============================================================

nCommon = size(TG_ARM_ARN,1);

if size(TG_ARM_ARN,2) ~= nCommon

    error('ARM vs ARN temporal-generalisation matrix is not square.')

end

if size(TG_AE_AR_full,1) < nCommon || ...
        size(TG_AE_AR_full,2) < nCommon

    error('AE vs AR is shorter than ARM vs ARN.')

end

%% Restrict AE vs AR to common window

TG_AE_AR = ...
    TG_AE_AR_full(1:nCommon,1:nCommon,:);

%% Restrict time vector

if length(timeFull) < nCommon

    error('Time vector is shorter than the common analysis window.')

end

time = timeFull(1:nCommon);

fprintf('\n=============================================\n')
fprintf('COMMON TEMPORAL WINDOW\n')
fprintf('=============================================\n')

fprintf('Number of common time points: %d\n',nCommon)

fprintf('Start time: %.4f s\n',time(1))

fprintf('End time: %.4f s\n',time(end))

fprintf('Restricted AE vs AR dimensions:\n')
disp(size(TG_AE_AR))

%% =============================================================
% CHECK FINAL DIMENSIONS
% ===============================================================

if ~isequal(size(TG_ARM_ARN),size(TG_AE_AR))

    error('Matrices still differ after temporal restriction.')

end

%% =============================================================
% PARTICIPANT-LEVEL DIFFERENCE MATRIX
%
% D > 0:
%   AE vs AR has larger TG values
%
% D < 0:
%   ARM vs ARN has larger TG values
% ===============================================================

D = TG_AE_AR - TG_ARM_ARN;

%% =============================================================
% RESHAPE
%
% Original:
%   train x test x participants
%
% Statistical representation:
%   participants x matrix elements
% ===============================================================

D2 = permute(D,[3 1 2]);

D2 = reshape( ...
    D2, ...
    nSub, ...
    nCommon*nCommon);

%% =============================================================
% CHECK FOR NaNs
% ===============================================================

if any(isnan(D2(:)))

    error('NaN values detected in participant-level difference matrices.')

end

%% =============================================================
% OBSERVED PAIRED T-STATISTIC
% ===============================================================

meanD = mean(D2,1);

sdD = std(D2,0,1);

tObs = meanD ./ ...
    (sdD ./ sqrt(nSub));

%% =============================================================
% SIGN-FLIP PERMUTATION
%
% For every permutation:
%
%   1. randomly multiply each participant's difference
%      matrix by +1 or -1
%
%   2. calculate t at every train x test cell
%
%   3. retain the largest absolute t anywhere in the matrix
%
% This provides FWE correction across the complete
% train-time x test-time search space.
% ===============================================================

maxT = zeros(nPerm,1);

sumSq = sum(D2.^2,1);

chunkSize = 50;

nDone = 0;

fprintf('\n=============================================\n')
fprintf('RUNNING PERMUTATIONS\n')
fprintf('=============================================\n')

while nDone < nPerm

    nThis = min( ...
        chunkSize, ...
        nPerm-nDone);

    %% Random +/- signs for participants

    signs = ...
        2*(rand(nThis,nSub) > 0.5)-1;

    %% Permuted means

    permMean = ...
        (signs * D2) ./ nSub;

    %% Permuted variance

    permVar = ...
        (sumSq - nSub*(permMean.^2)) ...
        ./ (nSub-1);

    permVar(permVar < 0) = 0;

    permSD = sqrt(permVar);

    %% Permuted t-values

    permT = ...
        permMean ./ ...
        (permSD ./ sqrt(nSub));

    %% Maximum absolute t across entire matrix

    maxT(nDone+1:nDone+nThis) = ...
        max(abs(permT),[],2);

    nDone = nDone + nThis;

    fprintf('Permutation %d / %d\n', ...
        nDone,nPerm)

end

%% =============================================================
% FWE-CORRECTED P VALUES
% ===============================================================

absObs = abs(tObs);

pCorr = zeros(size(absObs));

for kk = 1:length(absObs)

    pCorr(kk) = ...
        (1 + sum(maxT >= absObs(kk))) ...
        / (nPerm + 1);

end

%% =============================================================
% RESHAPE BACK TO TRAIN x TEST
% ===============================================================

tMap = reshape( ...
    tObs, ...
    nCommon,nCommon);

pMap = reshape( ...
    pCorr, ...
    nCommon,nCommon);

sigMap = pMap < alpha;

%% =============================================================
% FWE THRESHOLD
% ===============================================================

threshold = ...
    prctile( ...
    maxT, ...
    100*(1-alpha));

%% =============================================================
% GROUP MEAN MATRICES
% ===============================================================

mean_ARM_ARN = ...
    mean(TG_ARM_ARN,3);

mean_AE_AR = ...
    mean(TG_AE_AR,3);

meanDifference = ...
    mean(D,3);

%% =============================================================
% PRINT KEY RESULTS
% ===============================================================

fprintf('\n\n=============================================\n')
fprintf('DIRECT TEMPORAL-GENERALISATION COMPARISON\n')
fprintf('AE vs AR minus ARM vs ARN\n')
fprintf('=============================================\n')

fprintf('Participants: %d\n',nSub)

fprintf('Common time points: %d\n',nCommon)

fprintf('Time window: %.4f to %.4f s\n', ...
    time(1),time(end))

fprintf('Permutations: %d\n',nPerm)

fprintf('FWE threshold |t|: %.3f\n',threshold)

nSig = sum(sigMap(:));

fprintf('FWE-significant train-test samples: %d\n', ...
    nSig)

%% =============================================================
% PEAK RESULT
% ===============================================================

if any(sigMap(:))

    absT = abs(tMap);

    absT(~sigMap) = -Inf;

    [peakAbsT,idx] = max(absT(:));

    [trainIdx,testIdx] = ...
        ind2sub(size(absT),idx);

    peakT = ...
        tMap(trainIdx,testIdx);

    peakP = ...
        pMap(trainIdx,testIdx);

    peakTrainTime = ...
        time(trainIdx);

    peakTestTime = ...
        time(testIdx);

    fprintf('\nPeak significant |t|: %.3f\n', ...
        peakAbsT)

    fprintf('Peak signed t: %.3f\n', ...
        peakT)

    fprintf('Peak corrected p: %.5f\n', ...
        peakP)

    fprintf('Peak train time: %.4f s\n', ...
        peakTrainTime)

    fprintf('Peak test time: %.4f s\n', ...
        peakTestTime)

    if peakT > 0

        fprintf(['Direction at peak: ' ...
            'AE vs AR > ARM vs ARN\n'])

    else

        fprintf(['Direction at peak: ' ...
            'ARM vs ARN > AE vs AR\n'])

    end

else

    peakAbsT = NaN;
    peakT = NaN;
    peakP = NaN;
    peakTrainTime = NaN;
    peakTestTime = NaN;

    fprintf('\nNo train-test sample survived FWE correction.\n')

end

%% =============================================================
% NUMBER OF POSITIVE / NEGATIVE SIGNIFICANT CELLS
% ===============================================================

nPositive = ...
    sum(sigMap(:) & tMap(:) > 0);

nNegative = ...
    sum(sigMap(:) & tMap(:) < 0);

fprintf('\nSignificant AE vs AR > ARM vs ARN samples: %d\n', ...
    nPositive)

fprintf('Significant ARM vs ARN > AE vs AR samples: %d\n', ...
    nNegative)

%% =============================================================
% FIGURE
%
% A = ARM vs ARN
% B = AE vs AR
% C = DIRECT STATISTICAL COMPARISON
% ===============================================================

figure( ...
    'Color','w', ...
    'Position',[100 100 1500 500])

tl = tiledlayout( ...
    1,3, ...
    'TileSpacing','compact', ...
    'Padding','compact');

title( ...
    tl, ...
    'Direct comparison of temporal generalisation patterns', ...
    'FontWeight','bold')

%% =============================================================
% COMMON SCALE FOR ORIGINAL MATRICES
% ===============================================================

minOriginal = min( ...
    [mean_ARM_ARN(:); mean_AE_AR(:)]);

maxOriginal = max( ...
    [mean_ARM_ARN(:); mean_AE_AR(:)]);

%% -------------------------------------------------------------
% PANEL A
% ARM vs ARN
% --------------------------------------------------------------

nexttile

imagesc( ...
    time,time, ...
    mean_ARM_ARN)

axis xy
axis square

caxis([minOriginal maxOriginal])

xlabel('Test time (s)')

ylabel('Train time (s)')

title('ARM vs ARN')

colorbar

hold on

plot( ...
    [time(1) time(end)], ...
    [time(1) time(end)], ...
    'k--', ...
    'LineWidth',0.5)

%% -------------------------------------------------------------
% PANEL B
% AE vs AR
% --------------------------------------------------------------

nexttile

imagesc( ...
    time,time, ...
    mean_AE_AR)

axis xy
axis square

caxis([minOriginal maxOriginal])

xlabel('Test time (s)')

ylabel('Train time (s)')

title('AE vs AR')

colorbar

hold on

plot( ...
    [time(1) time(end)], ...
    [time(1) time(end)], ...
    'k--', ...
    'LineWidth',0.5)

%% -------------------------------------------------------------
% PANEL C
% DIRECT COMPARISON
% --------------------------------------------------------------

nexttile

imagesc( ...
    time,time, ...
    tMap)

axis xy
axis square

%% Symmetrical t-value scale

tLim = max(abs(tMap(:)));

caxis([-tLim tLim])

xlabel('Test time (s)')

ylabel('Train time (s)')

title('AE vs AR - ARM vs ARN')

cb = colorbar;

ylabel(cb,'paired t-value')

hold on

%% Main diagonal

plot( ...
    [time(1) time(end)], ...
    [time(1) time(end)], ...
    'k--', ...
    'LineWidth',0.5)

%% FWE-significant areas

if any(sigMap(:))

    contour( ...
        time,time, ...
        double(sigMap), ...
        [1 1], ...
        'k', ...
        'LineWidth',1)

end

%% =============================================================
% EXPORT FIGURE
% ===============================================================

exportgraphics( ...
    gcf, ...
    fullfile( ...
    outDir, ...
    'TG_DirectComparison_ARM_ARN_vs_AE_AR.pdf'), ...
    'ContentType','vector')

%% =============================================================
% SUMMARY TABLE
% ===============================================================

Summary = table;

Summary.Nsubjects = nSub;

Summary.Npermutations = nPerm;

Summary.N_common_timepoints = nCommon;

Summary.Start_time_s = time(1);

Summary.End_time_s = time(end);

Summary.FWE_t_threshold = threshold;

Summary.N_FWE_significant_train_test_samples = nSig;

Summary.N_AE_AR_greater_ARM_ARN = nPositive;

Summary.N_ARM_ARN_greater_AE_AR = nNegative;

Summary.Peak_abs_t = peakAbsT;

Summary.Peak_signed_t = peakT;

Summary.Peak_corrected_p = peakP;

Summary.Peak_train_time_s = peakTrainTime;

Summary.Peak_test_time_s = peakTestTime;

writetable( ...
    Summary, ...
    fullfile( ...
    outDir, ...
    'TG_DirectComparison_Summary.xlsx'))

%% =============================================================
% SAVE COMPLETE RESULTS
% ===============================================================

save( ...
    fullfile( ...
    outDir, ...
    'TG_DirectComparison_ARM_ARN_vs_AE_AR.mat'), ...
    'TG_ARM_ARN', ...
    'TG_AE_AR', ...
    'mean_ARM_ARN', ...
    'mean_AE_AR', ...
    'meanDifference', ...
    'tMap', ...
    'pMap', ...
    'sigMap', ...
    'maxT', ...
    'threshold', ...
    'time', ...
    'nPerm', ...
    'alpha', ...
    '-v7.3')

%% =============================================================
% DONE
% ===============================================================

fprintf('\n=============================================\n')
fprintf('ANALYSIS COMPLETE\n')
fprintf('=============================================\n')

fprintf('Results saved in:\n%s\n',outDir)