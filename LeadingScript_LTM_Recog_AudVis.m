
%%

%% LONG-TERM MEMORY RECOGNITION - AUDITORY AND VISUAL SEQUENCES - DATA COLLECTION: AUDITORY PATTERN RECOGNITION 2020

%%

%% 

% Please, note that the following pre-processing refers to all experimental blocks
% included in this data collection, even if the current paper is related
% only to two blocks

%% Maxfilter

%OBS! before running maxfilter you need to close matlab, open the terminal and write: 'use anaconda', then open matlab and run maxfilter script

maxfilter_path = '/neuro/bin/util/maxfilter';
project = 'MINDLAB2020_MEG-AuditoryPatternRecognition';
maxDir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2'; %output path

path = '/raw/sorted/MINDLAB2020_MEG-AuditoryPatternRecognition'; %path with all the subjects folders
jj = dir([path '/0*']); %list all the folders starting with '0' in order to avoid hidden files
for ii = 90:length(jj) %over subjects (STARTING FROM 13, SINCE THE PREVIOUS ONES WERE THE PILOTS (IF THEY DID ALSO THE PROPER EXPERIMENT, THE MAXFILTER COMPUTATION WILL BE DONE IN THE NEXT  SECTION))
    cart = [jj(ii).folder '/' jj(ii).name]; %create a path that combines the folder name and the file name
    pnana = dir([cart '/2*']); %search for folders starting with '2'
    for pp = 1:length(pnana) %loop to explore ad analyze all the folders inside the path above
        cart2 = [pnana(1).folder '/' pnana(pp).name];
        pr = dir([cart2 '/ME*']); %looks for meg folder
        if ~isempty(pr) %if pr is not empty, proceed with subfolders inside the meg path
            pnunu = dir([pr(1).folder '/' pr(1).name '/00*']);
            %if length(pnunu) > 1
            %warning(['subj ' num2str(ii) ' has files nuber = ' num2str(length(pnunu))]) %show a warning message if any subj has more thatn 1 meg sub-folder
            %end
            for dd = 1:length(pnunu)
                if strcmp(pnunu(dd).name(5:6),'re') || strcmp(pnunu(dd).name(5:6),'sa') || strcmp(pnunu(dd).name(5:6),'vi') || strcmp(pnunu(dd).name(5:6),'pd') %checks whether characters 5 to 6 are equal to 're', 'vi, 'sa' or 'pd'; the loop continues if this is true (1) and it stops if this is false (0)
                    %idx2 = strfind(pnunu(1).name,'Mus'); % search for musmelo folder in order to avoid other projects
                    %if ~isempty(idx2)
                    fpath = dir([pnunu(1).folder '/' pnunu(dd).name '/files/*.fif']); % looks for .fif file
                    rawName = ([fpath.folder '/' fpath.name]); %assigns the final path of the .fif file to the rawName path used in the maxfilter command
                    maxfName = ['SUBJ' jj(ii).name '_' fpath.name(1:end-4)]; %define the output name of the maxfilter processing
                    %movement compensation
                    cmd = ['submit_to_cluster -q maxfilter.q -n 4 -p ' ,project, ' "',maxfilter_path,' -f ',[rawName],' -o ' [maxDir '/' maxfName '_tsssdsm.fif'] ' -st 4 -corr 0.98 -movecomp -ds 4 ',' -format float -v | tee ' [maxDir '/log_files/' maxfName '_tsssdsm.log"']];
                    %no movement compensation (to be used if HPI coils did not work properly)
%                     cmd = ['submit_to_cluster -q maxfilter.q -n 4 -p ' ,project, ' "',maxfilter_path,' -f ',[rawName],' -o ' [maxDir '/' maxfName '_tsssdsm.fif'] ' -st 4 -corr 0.98 -ds 4 ',' -format float -v | tee ' [maxDir '/log_files/' maxfName '_tsssdsm.log"']];
                    system(cmd);
                end
            end
        end
    end
end

%% Maxfilter - Subjects who did the experiment (version 2.0) after the first pilot (version 1.0)

%OBS! before running maxfilter you need to close matlab, open the terminal and write: 'use anaconda', then open matlab and run maxfilter script

%settings
maxfilter_path = '/neuro/bin/util/maxfilter';
project = 'MINDLAB2020_MEG-AuditoryPatternRecognition';
maxDir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2'; %output path

clear rawName maxfName
%path to raw files for these particular subjects
pathraw{1} = '/raw/sorted/MINDLAB2020_MEG-AuditoryPatternRecognition/0002/20210413_000000/MEG'; %assigns the final path of the .fif file to the rawName path used in the maxfilter command
pathraw{2} = '/raw/sorted/MINDLAB2020_MEG-AuditoryPatternRecognition/0010/20210416_000000/MEG';
pathraw{3} = '/raw/sorted/MINDLAB2020_MEG-AuditoryPatternRecognition/0011/20210423_000000/MEG';
pathraw{4} = '/raw/sorted/MINDLAB2020_MEG-AuditoryPatternRecognition/0007/20210511_000000/MEG';
pathraw{5} = '/raw/sorted/MINDLAB2020_MEG-AuditoryPatternRecognition/0012/20210622_000000/MEG';

for ii = 5:length(pathraw) %over subjects
    list = dir([pathraw{ii} '/0*']);
    for jj = 1:length(list) %over experimental blocks
        if strcmp(list(jj).name(5:6),'re') || strcmp(list(jj).name(5:6),'sa') || strcmp(list(jj).name(5:6),'vi') || strcmp(list(jj).name(5:6),'pd') %checks whether characters 5 to 6 are equal to 're', 'vi, 'sa' or 'pd'; the loop continues if this is true (1) and it stops if this is false (0)
            
            fpath = dir([list(jj).folder '/' list(jj).name '/files/*.fif']); % looks for .fif file
            rawName = [fpath(1).folder '/' fpath(1).name];
            maxfName = ['SUBJ' pathraw{ii}(56:59) '_' fpath.name(1:end-4) '_bis']; %define the output name of the maxfilter processing
            %movement compensation
            cmd = ['submit_to_cluster -q maxfilter.q -n 4 -p ' ,project, ' "',maxfilter_path,' -f ',[rawName],' -o ' [maxDir '/' maxfName '_tsssdsm.fif'] ' -st 4 -corr 0.98 -movecomp -ds 4 ',' -format float -v | tee ' [maxDir '/log_files/' maxfName '_tsssdsm.log"']];
            %no movement compensation
%             cmd = ['submit_to_cluster -q maxfilter.q -n 4 -p ' ,project, ' "',maxfilter_path,' -f ',[rawName],' -o ' [maxDir '/' maxfName '_tsssdsm.fif'] ' -st 4 -corr 0.98 -ds 4 ',' -format float -v | tee ' [maxDir '/log_files/' maxfName '_tsssdsm.log"']];
            system(cmd);
        end
    end
end

%% Starting up OSL

%OBS! run this before converting the .fif files into SPM objects

addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/osl/osl-core'); %adds the path to OSL functions
osl_startup %starts the osl package

%% Converting the .fif files into SPM objects

%OBS! remember to run 'starting up OSL' first

%setting up the cluster
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing') %add the path to the function that submits the jobs to the cluster
clusterconfig('scheduler', 'cluster');
clusterconfig('long_running', 1); %there are different queues for the cluster depending on the number and length of the jobs you want to submit 
clusterconfig('slot', 1); %slot in the queu

%%

fif_list = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/*.fif'); %creates a list with the .fif files

for ii = 340:341%:length(fif_list) %over the .fif files
    S = []; %structure 'S'                   
    S.dataset = [fif_list(ii).folder '/' fif_list(ii).name];
    D = spm_eeg_convert(S);
%     D = job2cluster(@cluster_spmobject, S); %actual function for conversion
end

%% Removing bad segments using OSLVIEW

%checks data for potential bad segments (periods)
%marking is done by right-clicking in the proximity of the event and click on 'mark event'
%a first click (green dashed label) marks the beginning of a bad period
%a second click indicates the end of a bad period (red)
%this will mean that we are not using about half of the data, but with such bad artefacts this is the best we can do
%we can still obtain good results with what remains
%NB: Push the disk button to save to disk (no prefix will be added, same name is kept)

%OBS! remember to check for bad segments of the signal both at 'megplanar' and 'megmag' channels (you can change the channels in the OSLVIEW interface)

%OBS! remember to mark the trial within the bad segments as 'badtrials' and use the label for removing them from the Averaging (after Epoching) 

spm_list = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/spmeeg*.mat'); %path to SPM objects

for ii = 340:341%:length(spm_list) %over experimental blocks %OBS!
    D = spm_eeg_load([spm_list(ii).folder '/' spm_list(ii).name]);
    D = oslview(D);
    D.save(); %save the selected bad segments and/or channels in OSLVIEW
    disp(ii)
end

%% AFRICA denoising (part I)

%setting up the cluster
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing') %add the path to the function that submits the jobs to the cluster
clusterconfig('scheduler', 'cluster');
clusterconfig('long_running', 1); %there are different queues for the cluster depending on the number and length of the jobs you want to submit 
clusterconfig('slot', 1); %slot in the queu

%%

%ICA calculation
spm_list = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/spmeeg*.mat');

for ii = 339:length(spm_list) %OBS!
    S = [];
    D = spm_eeg_load([spm_list(ii).folder '/' spm_list(ii).name]);
    S.D = D;
    
    jobid = job2cluster(@cluster_africa,S);
%   D = osl_africa(D,'do_ica',true,'do_ident',false,'do_remove',false,'used_maxfilter',true); 
%   D.save();
end

%% AFRICA denoising (part II)

% v = [11 12 19 32];
%visual inspection and removal of artifacted components
%look for EOG and ECG channels (usually the most correlated ones, but check a few more just in case)
spm_list = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/spmeeg*.mat');

for ii = 339:length(spm_list) %OBS!%38:41
    D = spm_eeg_load([spm_list(ii).folder '/' spm_list(ii).name]);
    D = osl_africa(D,'do_ident','manual','do_remove',false,'artefact_channels',{'EOG','ECG'});
    %hacking the function to manage to get around the OUT OF MEMORY problem..
    S = [];
    S.D = D;
    jobid = job2cluster(@cluster_rembadcomp,S);
%   D.save();
    disp(ii)
end

%% Epoching: one epoch per old/new excerpt (baseline = (-)100ms)

prefix_tobeadded = 'e'; %adds this prefix to epoched files
spm_list = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/spmeeg*.mat');

for ii = 339:length(spm_list) %over .mat files
    D = spm_eeg_load([spm_list(ii).folder '/' spm_list(ii).name]); %load spm_list .mat files
    dummy = D.fname; %OBS! D.fname does not work, so we need to use a 'dummy' variable instead
    %if strcmp(dummy(22:26), 'speed') %checks whether characters 22 to 26 are equal to 'speed'; the loop continues if this is true (1) and it stops if this is false (0)
    events = D.events; %look for triggers
    %takes the correct triggers sent during the recording
    clear trigcor
    count_evval = 0; %???
    for ieve = 1:length(events) %over triggers
        if strcmp(events(ieve).type,'STI101_up') %only triggers at the beginning of each stimuli
            if events(ieve).value ~= 103 && events(ieve).value ~= 104 && events(ieve).value ~= 128 && events(ieve).value ~= 8 && events(ieve).value ~= 132 && events(ieve).value ~= 48 && events(ieve).value ~= 32 && events(ieve).value ~= 64 %discard 104 and 128 for random triggers
                count_evval = count_evval + 1;
                trigcor(count_evval,1) = events(ieve).time; %+ 0.010; %this takes the correct triggers and add 10ms of delay of the sound travelling into the tubes
                %variable with all the triggers we need
            end
        end
    end
    trl_sam = zeros(length(trigcor),3); %prepare the samples matrix with 0's in all its cells
    trl_sec = zeros(length(trigcor),3); %prepare the seconds matrix with 0's in all its cells
    %deftrig = zeros(length(trigcor),1); %this is not useful
    for k = 1:length(trigcor) %over selected triggers
        %deftrig(k,1) = 0.012 + trigcor(k,1); %adding a 0.012 seconds delay to the triggers sent during the experiment (this delay was due to technical reasons related to the stimuli)
        trl_sec(k,1) = trigcor(k,1) - 0.1000; %beginning time-window epoch in s (please note that we computed this operation two times, obtaining two slightly different pre-stimulus times.
        %this was done because for some computations was convenient to have a slightly longer pre-stimulus time
        %remove 1000ms of baseline
        if strcmp(dummy(22:26), 'speed')
            epochlength = 5.5;
            trl_sec(k,2) = trigcor(k,1) + epochlength; %end time-window epoch in seconds
        else
            epochlength = 4.4
            trl_sec(k,2) = trigcor(k,1) + epochlength; %end time-window epoch in seconds
        end
        trl_sec(k,3) = trl_sec(k,2) - trl_sec(k,1); %range time-windows in seconds
        trl_sam(k,1) = round(trl_sec(k,1) * 250) + 1; %beginning time-window epoch in samples %250Hz per second
        trl_sam(k,2) = round(trl_sec(k,2) * 250) + 1; %end time-window epoch in samples
        trl_sam(k,3) = -25; %sample before the onset of the stimulus (corresponds to 0.100ms)
    end
    dif = trl_sam(:,2) - trl_sam(:, 1); %difference between the end and the beginning of each sample (just to make sure that everything is fine)
    if ~all(dif == dif(1)) %checking if every element of the vector are the same (i.e. the length of the trials is the same; we may have 1 sample of difference sometimes because of different rounding operations..)
        trl_sam(:,2) = trl_sam(:,1) + dif(1);
    end
    %creates the epochinfo structure that is required for the source reconstruction later
    epochinfo.trl = trl_sam;
    epochinfo.time_continuous = D.time;
    %switch the montage to 0 because for some reason OSL people prefer to do the epoching with the not denoised data
    D = D.montage('switch',0);
    %build structure for spm_eeg_epochs
    S = [];
    S.D = D;
    S.trl = trl_sam;
    S.prefix = prefix_tobeadded;
    D = spm_eeg_epochs(S);
    
    %store the epochinfo structure inside the D object
    D.epochinfo = epochinfo;
    D.save();
    %take bad segments registered in OSLVIEW and check if they overlap with the trials. if so, it gives the number of overlapped trials that will be removed later   
    count = 0;
    Bad_trials = zeros(length(trigcor),1);
    for kkk = 1:length(events) %over events
        if strcmp(events(kkk).type,'artefact_OSL')
            for k = 1:length(trl_sec) %over trials
                if events(kkk).time - trl_sec(k,2) < 0 %if end of trial is > than beginning of artifact
                    if trl_sec(k,1) < (events(kkk).time + epochlength %if beginning of trial is < than end of artifact
                        Bad_trials(k,1) = 1; %it is a bad trial (stored here)
                        count = count + 1;
                    end
                end                  
            end
        end
    end
    %if bad trials were detected, their indices are stored within D.badtrials field
    disp(spm_list(ii).name);
    if count == 0
        disp('there are no bad trials marked in oslview');
    else
        D = badtrials(D,find(Bad_trials),1); %get the indices of the badtrials marked as '1' (that means bad)
%         D = conditions(D,find(Bad_trials),1); %get the indices of the badtrials marked as '1' (that means bad)
        epochinfo = D.epochinfo;
        xcv = find(Bad_trials == 1);
        %this should be done only later.. in any case.. not a problem..
        for jhk = 1:length(xcv)
            D = D.conditions(xcv(jhk),'Bad');
            epochinfo.conditionlabels(xcv(jhk)) = {'Bad'};
            disp([num2str(ii) ' - ' num2str(jhk) ' / ' num2str(length(xcv))])
        end
        D.epochinfo = epochinfo;
        D.save(); %saving on disk
        disp('bad trials are ')
        length(D.badtrials)
    end
    D.save();
    disp(ii)
end

%% Defining the conditions - All blocks

%define conditions - 1 epoch for each old/new excerpt (baseline = (-)100ms)

xlsx_dir_behav = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/BehavioralTaskMEG/Version_2/Final_xlsx'; %dir to MEG behavioral results (.xlsx files)
epoch_list = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*.mat'); %dir to epoched files

for ii = 339:length(epoch_list) %over epoched data
    D = spm_eeg_load([epoch_list(ii).folder '/' epoch_list(ii).name]);
    dummy = D.fname;
    %barbaric solution.. to build the name to be read for the excel files with the MEG behavioral tasks performance
    if strcmp(dummy(18:23),'recogm')
        dumbloc = 'Block_3.xlsx';
        bl = 3;
    elseif strcmp(dummy(18:23),'recogs')
        dumbloc = 'Block_4.xlsx';
        bl = 4;
    elseif strcmp(dummy(18:23),'sameme')
        dumbloc = 'Block_5.xlsx';
        bl = 5;
    elseif strcmp(dummy(18:23),'visual')
        dumbloc = 'Block_6.xlsx';
        bl = 6;
    elseif strcmp(dummy(18:19),'pd')
        dumbloc = 'Project_PD.xlsx';
        bl = 7;
    end
    if strcmp(dummy((end-14):(end-14)+2),'bis')
        dumls = ['Subj_' dummy(13:16) 'bis_' dumbloc]; %getting subject ID directly from the SPM object to reduce the probability to make mistakes
    else
        dumls = ['Subj_' dummy(13:16) '_' dumbloc];
    end
    [~,~,raw_recog] = xlsread([xlsx_dir_behav '/' dumls]); %excel files
    %picking the current block
    if bl == 3 %block 3
        for k = 1:length(D.trialonset)
            if raw_recog{(k + 1),3} == 0 %if there was no response
                D = D.conditions(k,'No_response');
            elseif strcmp(raw_recog{(k + 1),2}(8:9),'ol') && raw_recog{(k + 1),3} == 1 %old correct
                D = D.conditions(k,'Old_Correct'); %assign old correct
            elseif strcmp(raw_recog{(k + 1),2}(8:9),'ol') && raw_recog{(k + 1),3} == 2 %old incorrect
                D = D.conditions(k,'Old_Incorrect'); %otherwise assign new correct
            elseif strcmp(raw_recog{(k + 1),2}(14:15),'t1') && raw_recog{(k + 1),3} == 2 %new t1 correct
                D = D.conditions(k,'New_T1_Correct');
            elseif strcmp(raw_recog{(k + 1),2}(14:15),'t1') && raw_recog{(k + 1),3} == 1 %new t1 incorrect
                D = D.conditions(k,'New_T1_Incorrect');
            elseif strcmp(raw_recog{(k + 1),2}(14:15),'t2') && raw_recog{(k + 1),3} == 2 %new t2 correct
                D = D.conditions(k,'New_T2_Correct');
            elseif strcmp(raw_recog{(k + 1),2}(14:15),'t2') && raw_recog{(k + 1),3} == 1 %new t2 incorrect
                D = D.conditions(k,'New_T2_Incorrect');
            elseif strcmp(raw_recog{(k + 1),2}(14:15),'t3') && raw_recog{(k + 1),3} == 2 %new t3 correct
                D = D.conditions(k,'New_T3_Correct');
            elseif strcmp(raw_recog{(k + 1),2}(14:15),'t3') && raw_recog{(k + 1),3} == 1 %new t3 incorrect
                D = D.conditions(k,'New_T3_Incorrect');
            elseif strcmp(raw_recog{(k + 1),2}(14:15),'t4') && raw_recog{(k + 1),3} == 2 %new t4 correct
                D = D.conditions(k,'New_T4_Correct');
            elseif strcmp(raw_recog{(k + 1),2}(14:15),'t4') && raw_recog{(k + 1),3} == 1 %new t4 incorrect
                D = D.conditions(k,'New_T4_Incorrect');
            end
        end
    elseif bl == 4 %block 4
        for k = 1:length(D.trialonset)
            if raw_recog{(k + 1),3} == 0 %if there was no response
                D = D.conditions(k,'No_response');
            elseif strcmp(raw_recog{(k + 1),2}(6:13),'fast_old') && raw_recog{(k + 1),3} == 1 %old fast correct
                D = D.conditions(k,'Old_Fast_Correct'); %assign old fast correct
            elseif strcmp(raw_recog{(k + 1),2}(6:13),'fast_old') && raw_recog{(k + 1),3} == 2 %old fast incorrect
                D = D.conditions(k,'Old_Fast_Incorrect'); %assign old fast incorrect
            elseif strcmp(raw_recog{(k + 1),2}(6:13),'slow_old') && raw_recog{(k + 1),3} == 1 %old slow correct
                D = D.conditions(k,'Old_Slow_Correct'); %assign old slow correct
            elseif strcmp(raw_recog{(k + 1),2}(6:13),'slow_old') && raw_recog{(k + 1),3} == 2 %old slow incorrect
                D = D.conditions(k,'Old_Slow_Incorrect'); %assign old slow incorrect
            elseif strcmp(raw_recog{(k + 1),2}(8:15),'fast_new') && raw_recog{(k + 1),3} == 2 %new fast correct
                D = D.conditions(k,'New_Fast_Correct'); %assign new fast correct
            elseif strcmp(raw_recog{(k + 1),2}(8:15),'fast_new') && raw_recog{(k + 1),3} == 1 %new fast incorrect
                D = D.conditions(k,'New_Fast_Incorrect'); %assign new fast incorrect
            elseif strcmp(raw_recog{(k + 1),2}(8:15),'slow_new') && raw_recog{(k + 1),3} == 2 %new slow correct
                D = D.conditions(k,'New_Slow_Correct'); %assign new slow correct
            else
                D = D.conditions(k,'New_Slow_Incorrect'); %assign new incorrect
            end
        end
    elseif bl == 5 %block 5
        for k = 1:20 %over the 20 encoding trials
            D = D.conditions(k,'Encoding');
        end
        for k = 1:(length(D.trialonset)-20) %over recognition trials (this would work even if the last trial was out of bonds and thus was not epoched..)
            if raw_recog{(k + 23),3} == 0 %if there was no response
                D = D.conditions(k + 20,'No_response');
            elseif strcmp(raw_recog{(k + 23),2}(9:11),'enc') && raw_recog{(k + 23),3} == 1 %encoding correct
                D = D.conditions(k + 20,'Old_Correct'); %assign encoding correct
            elseif strcmp(raw_recog{(k + 23),2}(9:11),'enc') && raw_recog{(k + 23),3} == 2 %encoding incorrect
                D = D.conditions(k + 20,'Old_Incorrect'); %otherwise assign encoding incorrect
            elseif strcmp(raw_recog{(k + 23),2}(9:11),'rec') && raw_recog{(k + 23),3} == 2 %recognition correct
                D = D.conditions(k + 20,'New_Correct'); %assign recognition correct
            else
                D = D.conditions(k + 20,'New_Incorrect'); %assign new incorrect
            end
        end
    elseif bl == 6 %block 6
        for k = 1:20 %over the 20 encoding trials
            D = D.conditions(k,'Encoding');
        end
        for k = 1:(length(D.trialonset)-20) %over recognition trials (this would work even if the last trial was out of bonds and thus was not epoched..)
            if raw_recog{(k + 23),3} == 0 %if there was no response
                D = D.conditions(k + 20,'No_response');
            elseif strcmp(raw_recog{(k + 23),2}(8:10),'old') && raw_recog{(k + 23),3} == 1 %encoding correct
                D = D.conditions(k + 20,'Old_Correct'); %assign encoding correct
            elseif strcmp(raw_recog{(k + 23),2}(8:10),'old') && raw_recog{(k + 23),3} == 2 %encoding incorrect
                D = D.conditions(k + 20,'Old_Incorrect'); %otherwise assign encoding incorrect
            elseif strcmp(raw_recog{(k + 23),2}(8:10),'new') && raw_recog{(k + 23),3} == 2 %recognition correct
                D = D.conditions(k + 20,'New_Correct'); %assign recognition correct
            else
                D = D.conditions(k + 20,'New_Incorrect'); %assign new incorrect
            end
        end
    elseif bl == 7
        for k = 1:length(D.trialonset) %over trials
            if strcmp(raw_recog{(k + 1),2}(3:7),'porco')
                D = D.conditions(k,'pd');
            else
                D = D.conditions(k,'pm');
            end
        end
    end
    %this is for every block
    if ~isempty(D.badtrials) %overwriting badtrials (if any) on condition labels
        BadTrials = D.badtrials;
        for badcount = 1:length(BadTrials) %over bad trials
            D = D.conditions(BadTrials(badcount),'Bad_trial');
        end
    end
    D = D.montage('switch',1);
    D.epochinfo.conditionlabels = D.conditions; %to add for later use in the source reconstruction
    D.save(); %saving data on disk
    disp(num2str(ii))
end

%% COMPUTING STATISTICS OF BEHAVIORAL TASKS IN MEG

%% All blocks

%define conditions - 1 epoch for each old/new excerpt (baseline = (-)100ms)

xlsx_dir_behav = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/BehavioralTaskMEG/Version_2/Final_xlsx/'; %dir to MEG behavioral results (.xlsx files)

for bb = 3:4 %over experimental blocks
%     if bb == 5
%         list_beh = dir([xlsx_dir_behav '*PD.xlsx']); %PD project
%     else
        list_beh = dir([xlsx_dir_behav 'Subj*' num2str(bb + 2) '.xlsx']); %normal blocks
%     end
    bl = bb + 2;
    if bl == 3
        Block_3 = cell(length(list_beh)+1,13);
    elseif bl == 4
        Block_4 = cell(length(list_beh)+1,11);
    elseif bl == 5
        Block_5 = cell(length(list_beh)+1,7);
    elseif bl == 6
        Block_6 = cell(length(list_beh)+1,7);
    end
    for ii = 1:length(list_beh) %over subjects for block bb
        %barbaric solution.. to build the name to be read for the excel files with the MEG behavioral tasks performance
        [~,~,raw_recog] = xlsread([list_beh(ii).folder '/' list_beh(ii).name]); %excel files
        %picking the current block
        if bl == 5 %block 5
            Block_5{1,1} = 'Subject'; Block_5{1,2} = 'OLD_Cor'; Block_5{1,3} = 'OLD_Cor %'; Block_5{1,4} = 'New_Cor'; Block_5{1,5} = 'New_Cor %'; Block_5{1,6} = 'No response'; Block_5{1,7} = 'No response %'; Block_5{1,8} = 'Mean RT Old Corr'; Block_5{1,9} = 'Mean RT New Corr'; Block_5{1,10} = 'Std Dev RT Old Corr'; Block_5{1,11} = 'Std Dev RT New Corr';
            nr = 0; old = 0; new = 0; bumo = []; bumn = [];
            for k = 1:48 %over recognition trials (this would work even if the last trial was out of bonds and thus was not epoched..)
                if raw_recog{(k + 23),3} == 0 %if there was no response
                    nr = nr + 1;
                elseif strcmp(raw_recog{(k + 23),2}(9:11),'enc') && raw_recog{(k + 23),3} == 1 %encoding correct
                    old = old + 1;
                    bumo = cat(1,bumo,raw_recog{(k + 23),4});
                elseif strcmp(raw_recog{(k + 23),2}(9:11),'rec') && raw_recog{(k + 23),3} == 2 %recognition correct
                    new = new + 1;
                    bumn = cat(1,bumn,raw_recog{(k + 23),4});
                end
            end
            disp(num2str(['Block ' num2str(bb+2) ' - Subject ' num2str(ii)]))
            Block_5{ii+1,1} = list_beh(ii).name(6:9); Block_5{ii+1,2} = old; Block_5{ii+1,3} = (old/24)*100; Block_5{ii+1,4} = new; Block_5{ii+1,5} = (new/24)*100; Block_5{ii+1,6} = nr; Block_5{ii+1,7} = (nr/48)*100;
            Block_5{ii+1,8} = mean(bumo); Block_5{ii+1,9} = mean(bumn); Block_5{ii+1,10} = std(bumo); Block_5{ii+1,11} = std(bumn);
        elseif bl == 6 %block 6            
            Block_6{1,1} = 'Subject'; Block_6{1,2} = 'OLD_Cor'; Block_6{1,3} = 'OLD_Cor %'; Block_6{1,4} = 'New_Cor'; Block_6{1,5} = 'New_Cor %'; Block_6{1,6} = 'No response'; Block_6{1,7} = 'No response %'; Block_6{1,8} = 'Mean RT Old Corr'; Block_6{1,9} = 'Mean RT New Corr'; Block_6{1,10} = 'Std Dev RT Old Corr'; Block_6{1,11} = 'Std Dev RT New Corr';
            nr = 0; old = 0; new = 0; bumo = []; bumn = [];
            for k = 1:48 %over recognition trials (this would work even if the last trial was out of bonds and thus was not epoched..)
                if raw_recog{(k + 23),3} == 0 %if there was no response
                    nr = nr + 1;
                elseif strcmp(raw_recog{(k + 23),2}(8:10),'old') && raw_recog{(k + 23),3} == 1 %encoding correct
                    old = old + 1;
                    bumo = cat(1,bumo,raw_recog{(k + 23),4});
                elseif strcmp(raw_recog{(k + 23),2}(8:10),'new') && raw_recog{(k + 23),3} == 2 %recognition correct
                    new = new + 1;
                    bumn = cat(1,bumn,raw_recog{(k + 23),4});
                end
            end
            disp(num2str(['Block ' num2str(bb+2) ' - Subject ' num2str(ii)]))
            Block_6{ii+1,1} = list_beh(ii).name(6:9); Block_6{ii+1,2} = old; Block_6{ii+1,3} = (old/24)*100; Block_6{ii+1,4} = new; Block_6{ii+1,5} = (new/24)*100; Block_6{ii+1,6} = nr; Block_6{ii+1,7} = (nr/48)*100;
            Block_6{ii+1,8} = mean(bumo); Block_6{ii+1,9} = mean(bumn); Block_6{ii+1,10} = std(bumo); Block_6{ii+1,11} = std(bumn);
        end
    end
end
Block_5 = cell2table(Block_5); %remove the possible empty cell
Block_6 = cell2table(Block_6); %remove the possible empty cell

disp(['Block 5 - mean (and std dev) across subjcts RT Old Correct: ' num2str(mean(cell2mat(table2array(Block_5(2:end,8))))) ' +/- ' num2str(mean(cell2mat(table2array(Block_5(2:end,10)))))])
disp(['Block 5 - mean (and std dev) across subjcts RT New Correct: ' num2str(mean(cell2mat(table2array(Block_5(2:end,9))))) ' +/- ' num2str(mean(cell2mat(table2array(Block_5(2:end,11)))))])
disp(['Block 6 - mean (and std dev) across subjcts RT Old Correct: ' num2str(mean(cell2mat(table2array(Block_6(2:end,8))))) ' +/- ' num2str(mean(cell2mat(table2array(Block_6(2:end,10)))))])
disp(['Block 6 - mean (and std dev) across subjcts RT New Correct: ' num2str(mean(cell2mat(table2array(Block_6(2:end,9))))) ' +/- ' num2str(mean(cell2mat(table2array(Block_6(2:end,11)))))])

% [~,p5,~,stats5] = ttest(cell2mat(table2array(Block_5(2:end,8))),cell2mat(table2array(Block_5(2:end,9))))
% [~,p6,~,stats6] = ttest(cell2mat(table2array(Block_6(2:end,8))),cell2mat(table2array(Block_6(2:end,9))))

%AUDITORY
%accuracy
[p5,~,stats5] = signrank(cell2mat(table2array(Block_5(2:end,2))),cell2mat(table2array(Block_5(2:end,4))))
stats5.zval
disp(['Block 5 - mean (and std dev) across subjcts accuracy Old Correct: ' num2str(mean(cell2mat(table2array(Block_5(2:end,2))))) ' +/- ' num2str(std(cell2mat(table2array(Block_5(2:end,2)))))])
disp(['Block 5 - mean (and std dev) across subjcts accuracy New Correct: ' num2str(mean(cell2mat(table2array(Block_5(2:end,4))))) ' +/- ' num2str(std(cell2mat(table2array(Block_5(2:end,4)))))])
%RT
[p5,~,stats5] = signrank(cell2mat(table2array(Block_5(2:end,8))),cell2mat(table2array(Block_5(2:end,9))))
stats5.zval
disp(['Block 5 - mean (and std dev) across subjcts RT Old Correct: ' num2str(mean(cell2mat(table2array(Block_5(2:end,8))))) ' +/- ' num2str(mean(cell2mat(table2array(Block_5(2:end,10)))))])
disp(['Block 5 - mean (and std dev) across subjcts RT New Correct: ' num2str(mean(cell2mat(table2array(Block_5(2:end,9))))) ' +/- ' num2str(mean(cell2mat(table2array(Block_5(2:end,11)))))])

%VISUAL
%accuracy
[p6,~,stats6] = signrank(cell2mat(table2array(Block_6(2:end,2))),cell2mat(table2array(Block_6(2:end,4))))
stats6.zval
disp(['Block 6 - mean (and std dev) across subjcts accuracy Old Correct: ' num2str(mean(cell2mat(table2array(Block_6(2:end,2))))) ' +/- ' num2str(std(cell2mat(table2array(Block_6(2:end,2)))))])
disp(['Block 6 - mean (and std dev) across subjcts accuracy New Correct: ' num2str(mean(cell2mat(table2array(Block_6(2:end,4))))) ' +/- ' num2str(std(cell2mat(table2array(Block_6(2:end,4)))))])
%RT
[p6,~,stats6] = signrank(cell2mat(table2array(Block_6(2:end,8))),cell2mat(table2array(Block_6(2:end,9))))
stats6.zval
disp(['Block 6 - mean (and std dev) across subjcts RT Old Correct: ' num2str(mean(cell2mat(table2array(Block_6(2:end,8))))) ' +/- ' num2str(mean(cell2mat(table2array(Block_6(2:end,10)))))])
disp(['Block 6 - mean (and std dev) across subjcts RT New Correct: ' num2str(mean(cell2mat(table2array(Block_6(2:end,9))))) ' +/- ' num2str(mean(cell2mat(table2array(Block_6(2:end,11)))))])


%% 

%% THE FOLLOWING SECTIONS (AVERAGING, COMBINING PLANAR GRADIOMETERS AND PLOTTING) ARE PERFORMED FOR INSPECTION PURPOSES BUT ARE NOT REPORTED IN THE MANUSCRIPT

% The next section directly related to the manuscript is the decoding section 

%% Averaging and Combining planar gradiometers

%settings for cluster (parallel computing)
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing') %add the path to the function that submits the jobs to the cluster
clusterconfig('scheduler', 'cluster'); %set automatically the long run queue
clusterconfig('long_running', 1); %set automatically the long run queue
clusterconfig('slot', 1); %set manually the job cluster slots
% between 1 and 12 (n x 8gb of ram)

%% averaging

output_prefix_to_be_set = 'm';

v = [339:342]; %only a selection of files

epoch_list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*mat'); %dir to epoched files (encoding)
for ii = 1:length(v)%1:length(epoch_list) %over epoched files
    %distribute 
    input = [];
    input.D = [epoch_list(v(ii)).folder '/' epoch_list(v(ii)).name];
    input.prefix = output_prefix_to_be_set;
    jobid = job2cluster(@sensor_average, input); % this is the command for send the job to the cluster, in the brackets you can find the name on the function to run (afeter the @) and the variable for the input (in this case input)
    % look the script for more details about the function work
end

%% combining planar gradiometers

average_list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/m*mat'); %dir to epoched files (encoding)
v = [339:342]; %only a selection of files

for ii = 1:length(v)%1:length(average_list) %over files
    input = [];
    input.D = [average_list(v(ii)).folder '/' average_list(v(ii)).name];
    D = spm_eeg_load(input.D);
    D = D.montage('switch',1);
    D.save();
    jobid = job2cluster(@combining_planar_cluster, input); % this is the command for send the job to the cluster, in the brackets you can find the name on the function to run (afeter the @) and the variable for the input (in this case input)
end

%% LBPD_startup_D

pathl = '/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD'; %path to stored functions
addpath(pathl);
LBPD_startup_D(pathl);
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing') %add the path where is the function for submit the jobs to the server

%% Extracting MEG sensor data

%%% OBS!! ONLY BLOCKS 5 AND 6 ARE RELATED TO THE CURRENT MANUSCRIPT; THE OTHER BLOCKS WERE REPORTED IN DIFFERENT PAPERS %%%

% Remember there are a few 'pd' participants in the Dementia project with Elisa (and perhaps even somewhere else.. check them..) 

block = 6; % 3 = recogminor; 4 = recogspeed; 5 = samemel; 6 = visualpat; 7 = pd
channels_plot = [189]; %13;95;;9; %95, 13, 15, 11, 141, 101, 9 % empty for plotting single channels; otherwise number(s) of channels to be averaged and plotted (e.g. [13] or [13 18])
% channels_plot = []; % empty for plotting single channels; otherwise number(s) of channels to be averaged and plotted (e.g. [13] or [13 18])

%1321 1411
save_data = 0;
load_data = 1; %set 1 if you want to load the data instead of extracting it from SPM objects
v = [1:83]; %subjects
% v = [3 4 5 8]; %subjects
%bad 8,9 and a bit 6 (recogminor)

S = [];
%computing data
if block == 3
    S.conditions = {'Old_Correct','New_T1_Correct','New_T2_Correct','New_T3_Correct','New_T4_Correct'};
%     S.conditions = {'Old_Correct','New_T1_Correct'};
elseif block == 4
    % S.conditions = {'Old_Fast_Correct','Old_Slow_Correct','New_Fast_Correct','New_Slow_Correct'};
%     S.conditions = {'Old_Fast_Correct','New_Fast_Correct'};
    S.conditions = {'Old_Slow_Correct','New_Slow_Correct'};
elseif block == 5
    S.conditions = {'Old_Correct','New_Correct'};
%     S.conditions = {'Old_Correct','Encoding'};
elseif block == 6
    S.conditions = {'Old_Correct','New_Correct'};
%     S.conditions = {'Old_Correct','Encoding'};
elseif block == 7
    S.conditions = {'pd','pm'};
end
if block == 3
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/P*_recogminor*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 4
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/P*recogspeed*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 5
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/P*samemel*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 6
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/P*visualpat*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 7
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/P*pd*_tsssdsm.mat'); %dir to epoched files (encoding)
end
% v = 1:length(list); %subjects
% v = [2];
if ~exist('chanlabels','var')
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter/MEG_sensors/recogminor_all_conditions.mat', 'chanlabels')
end
outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors'; %path to write output in
S.outdir = outdir;
S.data = [];
if load_data == 1 %if you already computed and saved on disk the t-tests you can load them here
    load([outdir '/Block_' num2str(block) '.mat']);
    S.data = data_mat(:,:,v,:);
    S.chanlabels = chanlabels;
    S.time_real = time_sel;
else %otherwise you can extract the data from SPM MEEG objects (one for each subject)
%     S.spm_list = cell(1,length(list));
% v = 7;
    S.spm_list = cell(1,length(v));
    for ii = 1:length(v)
        S.spm_list(ii) = {[list(v(ii)).folder '/' list(v(ii)).name]};
    end
end

S.timeextract = []; %time-points to be extracted
S.centerdata0 = 0; %1 to make data starting at 0
S.save_data = save_data; %only meaningfull if you read data from SPM objects saved on disk
S.save_name_data = ['Block_' num2str(block)];

%individual waveform plotting
if isempty(channels_plot)
    S.waveform_singlechannels_label = 1; %1 to plot single channel waveforms
else
    S.waveform_singlechannels_label = 0; %1 to plot single channel waveforms
end
S.wave_plot_conditions_together = 0; %1 for plotting the average of all
S.mag_lab = 1; %1 for magnetometers; 2 for gradiometers
S.x_lim_temp_wave = []; %limits for time (in secs) (E.g. [-0.1 3.4])
S.y_lim_ampl_wave = [-200 200]; %limit for amplitude (E.g. [0 120] magnetometes, [0 6] gradiometers)

%averaged waveform plotting
if isempty(channels_plot)
    S.waveform_average_label = 0; %average of some channels
    S.left_mag = 95; %13 %37 (visual) %43 (visual) %199 (visual) %203 (visual) %channels for averaging
else
    S.waveform_average_label = 1; %average of some channels
    S.left_mag = channels_plot; %13 %37 (visual) %43 (visual) %199 (visual) %203 (visual) %channels for averaging
end
% S.left_mag = [2:2:204];
S.legc = 1; %set 1 for legend
% S.left_mag = 99;
S.signtp = {[]};
% S.sr = 150; %sampling rate (Hz)
S.avewave_contrast = 0; %1 to plot the contrast between conditions (averaged waveform)
S.save_label_waveaverage = 0;
S.label_plot = 'c';
%t-tests
S.t_test_for_permutations = 0;
S.cond_ttests_tobeplotted_topoplot = [1 2]; %this is for both topoplot and t-tests!! (here [1 2] means cond1 vs cond2!!!!!!!)

%topoplotting
S.topoplot_label = 0;
S.fieldtrip_mask = '/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External';
S.topocontr = 0;
S.topocondsing = [1]; %condition for topoplot
% S.xlim = [0.75 0.85]; %time topolot
% S.xlim = [1.1 1.2]; %time topolot
S.xlim = [0.51 0.53]; 
S.zlimmag = []; %magnetometers amplitude topoplot limits
S.zlimgrad = []; %gradiometers amplitude topoplot limits
S.colormap_spec = 0;
% x = []; x.bottom = [0 0 1]; x.botmiddle = [0 0.5 1]; x.middle = [1 1 1]; x.topmiddle = [1 1 0.5]; x.top = [1 0.95 0]; %yellow - blue
x = []; x.bottom = [0 0 0.5]; x.botmiddle = [0 0.5 1]; x.middle = [1 1 1]; x.topmiddle = [1 0 0]; x.top = [0.6 0 0]; %red - blue
S.colormap_spec_x = x;
S.topoplot_save_label = 0;

[out] = MEG_sensors_plotting_ttest_LBPD_D2(S);

%% EXTRACTING MAGNETOMETERS AND ADJUSTING THE SIGN (USEFUL FOR LATER COMPUTATIONS)

block_l = 6; % 5 = auditory; 6 = visual

if block_l == 5
    timex = 45:52;
else
    timex = 55:59;
end
load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_' num2str(block_l) '.mat'])
vect = zeros(102,1);
cnt = 0;
for jj = 1:2:204 %over MEG magnetometers
    
    cnt = cnt + 1;
    
    burb = sort(abs(data_mat(jj,timex(end)+1:526,1)),'descend'); %sorting time-points later on up to 2 seconds
    barb = abs(squeeze(mean(data_mat(jj,round(mean(timex)),1),2))); %N100 value
    birb = length(find(barb>burb))/length(burb); %percentile of value of N100 compared to the remaining values
    
    if block_l == 2 && birb < .50 %not reversing the sign if the visual N100 is not prominent for source leakage in the brain voxel jj
        vect(cnt,1) = 1;
    else
        if squeeze(mean(data_mat(jj,timex,1),2)) > 0 %if the data in voxel jj is positive during N100 time
            vect(cnt,1) = -1; %storing a vector with 1 and -1 to be used for later statistics
        else
            vect(cnt,1) = 1;
        end
    end
end

mag_adj = zeros(102,size(data_mat,2),size(data_mat,3),size(data_mat,4));
cnt = 0;
for jj = 1:2:204 %over MEG magnetometers
    cnt = cnt + 1;
    for pp = 1:size(data_mat,3)
        for cc = 1:size(data_mat,4)
            mag_adj(cnt,:,pp,cc) = data_mat(jj,:,pp,cc) .* vect(cnt,1); %reversing (or not)..
        end
    end
    disp(jj)
end
chanslabmag = chanlabels(1:2:204);
save(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_' num2str(block_l) 'Mag_SignAdj.mat'],'mag_adj','chanslabmag','time_sel','S')

%%

%% DECODING (I used the 'normally' epoched files)

%% *** DECODING (MULTIVARIATE PATTERN ANALYSIS) ***

%The decoding consists of support vector machines (SVM) implemented in
%external functions that can be found at the following link:
%http://www.csie.ntu.edu.tw/~cjlin/libsvm/
%Those functions can be also used in MATLAB with a few adjustments. We implemented them by using the AU server.
%After that, we provided the output of the SVM algorithm to produce statistics and plots.

%% SETTINGS FOR AU SERVER AND SVM ALGORITHM

cd /projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding')
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding/scilearnlab')
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding/scilearnlab/external');
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding/scilearnlab/external/libsvm-3.21')
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding/scilearnlab/external/libsvm-3.21/matlab')
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding/SpatialLocation')
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding/SpatialLocation/plotchannel')
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding/permutationlab')
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding/permutationlab/private1')
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/MITDecodingToServer/Decoding/permutationlab/developer')
make

clusterconfig('scheduler', 'cluster'); %set to 'cluster' for running jobs in the cluster or 'none' for running jobs locally
clusterconfig('long_running', 1); %set to 0 for short queue, 1 for all queue or 2 for long queue
clusterconfig('slot', 1); %default amount of slots is 1 and maximum amount of slots is 12
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing') %function that submits the jobs to the cluster

%% PREPARING DATA FOR DECODING FUNCTIONS (ENCODING AND REPLAY) (DECODING MUSICAL MELODIES FROM VISUAL PATTERNS (VISUAL DOTS))

time = [1 1126];
savedirdum = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat';
list1 = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*mat']); %dir to epoched files (encoding)
list2 = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*mat']); %dir to epoched files (encoding)
conds = {'Encoding'};
conds2 = {'Replay_Aud','Replay_Vis'}; %condition names

numperm = 100; %number of permutations
kfold = 4; %number of categories for k-fold classification
pairl = 1; %1 = pairwise decoding; 2 = multiclass (confusion matrix)

for ii = 1:length(list1) %over files
    savedir = [savedirdum '/Aud_vs_Vis'];
    mkdir(savedir);
    D1 = spm_eeg_load([list1(ii).folder '/' list1(ii).name]); %load data
    D2 = spm_eeg_load([list2(ii).folder '/' list2(ii).name]); %load data
    ppn = D1.fname;
    cond1 = find(strcmp(conds{1},D1.conditions)); %index of cond 1
    cond2 = find(strcmp(conds{1},D2.conditions)); %index of cond 2
    clear data condid
    %conditions label
    condid(1:length(cond1)) = conds2(1); %condition label (tone 1)
    condid(length(cond1)+1:(length(cond1)+length(cond2))) = conds2(2); %condition label (tone 2)
    %MEG channels indices and data for cond 1 
    idxMEGc1 = find(strcmp(D1.chanlabels,'MEG0111')); %index of extreme channels
    idxMEGc2 = find(strcmp(D1.chanlabels,'MEG2643')); %index of extreme channels
    data = D1(idxMEGc1:idxMEGc2,time(1):time(2),cond1); %extracting data (MEG channels, timepoints, indices)
    %MEG channels indices and data for cond 2 
    idxMEGc1 = find(strcmp(D2.chanlabels,'MEG0111')); %index of extreme channels
    idxMEGc2 = find(strcmp(D2.chanlabels,'MEG2643')); %index of extreme channels
    data = cat(3,data,D2(idxMEGc1:idxMEGc2,time(1):time(2),cond2)); %extracting data (MEG channels, timepoints, indices)
    S = []; %empty structure
    S.pairl = pairl; %1 = pairwise decoding; 2 = multiclass (confusion matrix)
    S.data = data; %data matrix
    S.condid = condid; %condition labels
    S.numperm = numperm; %number of permutations
    S.kfold = kfold; %number of k-folds
    S.savedir = savedir; %output path
    S.ii = ppn(13:16); %subject number
    disp(ii) %display subject number
    jobid = job2cluster(@decoding, S); %cluster function
    
    if ii == 1 %saving D.time (time in seconds), only once
        time_sel = D1.time(time(1):time(2));
        save([savedir 'time.mat'],'time_sel');
    end
end

%% RECOGNITION (DECODING OLD FROM NEW, INDEPENDENTLY FOR MELODIES (SAMEMEL) AND VISUAL (DOT) PATTERNS)

block = 6; %5 = samemel; 6 = visualpat

time = [1 1126]; %defining time of interest (this refers to 0.100sec before the onset of the stimuli)
numperm = 100; %number of permutations
kfold = 4; %number of categories for k-fold classification
pairl = 1; %1 = pairwise decoding; 2 = multiclass (confusion matrix)

if block == 5
    list = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*mat']); %dir to epoched files (encoding)
    savedir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel';
else
    list = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*mat']); %dir to epoched files (encoding)
    savedir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat';
end
mkdir(savedir);
for ii = 1:length(list) %length(subjnum)
    %loading data
    D = spm_eeg_load([list(ii).folder '/' list(ii).name]);
    ppn = D.fname;
    old = find(strcmp('Old_Correct',D.conditions)); %getting condition old indices
    new = find(strcmp('New_Correct',D.conditions)); %getting condition newTx indices
    clear data condid ind
    condid(1:length(old)) = {'O'}; %creating condition labels (first old)
    condid(length(old)+1:(length(old)+length(new))) = {'N'}; %(then new)
    ind = [old new]; %rearranging indices (first old and then new)
    idxMEGc1 = find(strcmp(D.chanlabels,'MEG0111')); %getting extreme channels indexes
    idxMEGc2 = find(strcmp(D.chanlabels,'MEG2643')); %same
    data = D(idxMEGc1:idxMEGc2,time(1):time(2),ind); %extracting data
    %structure with inputs for AU server
    S = [];
    S.pairl = pairl;
    S.data = data;
    S.condid = condid;
    S.numperm = numperm;
    S.kfold = kfold;
    S.savedir = savedir;
    S.ii = ppn(13:16);
    disp(ii)
    %job to cluster
    jobid = job2cluster(@decoding, S);
    
    if ii == 1 %saving D.time (time in seconds), only once
        time_sel = D.time(time(1):time(2));
        save([savedir 'time.mat'],'time_sel');
    end
end

%% DECODING OLD MELODIES/VISUAL PATTERN - ENCODING FROM RECOGNITION (EXACTLY THE SAME SEQUENCES)

block = 6; %5 = samemel; 6 = visualpat

time = [1 1126]; %defining time of interest (this refers to 0.100sec before the onset of the stimuli)
numperm = 100; %number of permutations
kfold = 4; %number of categories for k-fold classification
pairl = 1; %1 = pairwise decoding; 2 = multiclass (confusion matrix)

if block == 5
    list = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*mat']); %dir to epoched files (encoding)
    savedir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemel';
else
    list = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*mat']); %dir to epoched files (encoding)
    savedir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpat';
end
mkdir(savedir);
for ii = 1:length(list) %length(subjnum)
    %loading data
    D = spm_eeg_load([list(ii).folder '/' list(ii).name]);
    ppn = D.fname;
    old = find(strcmp('Encoding',D.conditions)); %getting condition old indices
    new = find(strcmp('Old_Correct',D.conditions)); %getting condition newTx indices
    clear data condid ind
    condid(1:length(old)) = {'E'}; %creating condition labels (first old)
    condid(length(old)+1:(length(old)+length(new))) = {'O'}; %(then new)
    ind = [old new]; %rearranging indices (first old and then new)
    idxMEGc1 = find(strcmp(D.chanlabels,'MEG0111')); %getting extreme channels indexes
    idxMEGc2 = find(strcmp(D.chanlabels,'MEG2643')); %same
    data = D(idxMEGc1:idxMEGc2,time(1):time(2),ind); %extracting data
    %structure with inputs for AU server
    S = [];
    S.pairl = pairl;
    S.data = data;
    S.condid = condid;
    S.numperm = numperm;
    S.kfold = kfold;
    S.savedir = savedir;
    S.ii = ppn(13:16);
    disp(ii)
    %job to cluster
    jobid = job2cluster(@decoding, S);
    
    if ii == 1 %saving D.time (time in seconds), only once
        time_sel = D.time(time(1):time(2));
        save([savedir 'time.mat'],'time_sel');
    end
end

%%

%% DECODING RECOGNITION PHASE (OLD MELODIES) OF AUDITORY VERSUS VISUAL SEQUENCES

time = [1 1126]; %defining time of interest (this refers to 0.100sec before the onset of the stimuli)
numperm = 100; %number of permutations
kfold = 4; %number of categories for k-fold classification
pairl = 1; %1 = pairwise decoding; 2 = multiclass (confusion matrix)

list1 = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*mat']); %dir to epoched files (encoding)
savedir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis';
list2 = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*mat']); %dir to epoched files (encoding)
mkdir(savedir);

for ii = 1:length(list1) %length(subjnum)
    %loading data
    D1 = spm_eeg_load([list1(ii).folder '/' list1(ii).name]);
    ppn = D1.fname;
    old = find(strcmp('Old_Correct',D1.conditions)); %getting condition old indices in melodies
    D2 = spm_eeg_load([list2(ii).folder '/' list2(ii).name]);
    new = find(strcmp('Old_Correct',D2.conditions)); %getting condition old indices in visual sequences
    clear data condid
    condid(1:length(old)) = {'Aud'}; %creating condition labels (first auditory)
    condid(length(old)+1:(length(old)+length(new))) = {'Vis'}; %(then visual)    
%     ind = [old new]; %rearranging indices (first old and then new)
    %melodies
    idxMEGc1 = find(strcmp(D1.chanlabels,'MEG0111')); %getting extreme channels indexes
    idxMEGc2 = find(strcmp(D1.chanlabels,'MEG2643')); %same
    data1 = D1(idxMEGc1:idxMEGc2,time(1):time(2),old); %extracting data
    %visual sequences
    idxMEGc1 = find(strcmp(D2.chanlabels,'MEG0111')); %getting extreme channels indexes
    idxMEGc2 = find(strcmp(D2.chanlabels,'MEG2643')); %same
    data2 = D2(idxMEGc1:idxMEGc2,time(1):time(2),new); %extracting data
    data = cat(3,data1,data2);
    
    %structure with inputs for AU server
    S = [];
    S.pairl = pairl;
    S.data = data;
    S.condid = condid;
    S.numperm = numperm;
    S.kfold = kfold;
    S.savedir = savedir;
    S.ii = ppn(13:16);
    disp(ii)
    %job to cluster
    jobid = job2cluster(@decoding, S);
    
    if ii == 1 %saving D.time (time in seconds), only once
        time_sel = D1.time(time(1):time(2));
        save([savedir '/time.mat'],'time_sel');
    end
end


%% DECODING OLD FROM NEW IN RECOGNITION PHASE HAVING TOGETHER AUDITORY AND VISUAL SEQUENCES

time = [1 1126]; %defining time of interest (this refers to 0.100sec before the onset of the stimuli)
numperm = 100; %number of permutations
kfold = 4; %number of categories for k-fold classification
pairl = 1; %1 = pairwise decoding; 2 = multiclass (confusion matrix)

list1 = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*mat']); %dir to epoched files (encoding)
list2 = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*mat']); %dir to epoched files (encoding)
savedir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat';
mkdir(savedir);

for ii = 1:length(list1) %length(subjnum)
    %loading data
    D1 = spm_eeg_load([list1(ii).folder '/' list1(ii).name]);
    ppn = D1.fname;
    old1 = find(strcmp('Old_Correct',D1.conditions)); %getting condition old indices in melodies
    new1 = find(strcmp('New_Correct',D1.conditions)); %getting condition old indices in visual sequences
    
    D2 = spm_eeg_load([list2(ii).folder '/' list2(ii).name]);
    old2 = find(strcmp('Old_Correct',D2.conditions)); %getting condition old indices in melodies
    new2 = find(strcmp('New_Correct',D2.conditions)); %getting condition old indices in visual sequences
    
    clear data condid
    condid(1:(length(old1)+length(old2))) = {'O'}; %creating condition labels (first auditory)
    condid((length(old1)+length(old2))+1:((length(old1)+length(old2))+(length(new1)+length(new2)))) = {'N'}; %(then visual)
    %     ind = [old new]; %rearranging indices (first old and then new)
    %melodies
    idxMEGc1 = find(strcmp(D1.chanlabels,'MEG0111')); %getting extreme channels indexes
    idxMEGc2 = find(strcmp(D1.chanlabels,'MEG2643')); %same
    data1old = D1(idxMEGc1:idxMEGc2,time(1):time(2),old1); %extracting data
    data2old = D2(idxMEGc1:idxMEGc2,time(1):time(2),old2); %extracting data
    data1new = D1(idxMEGc1:idxMEGc2,time(1):time(2),new1); %extracting data
    data2new = D2(idxMEGc1:idxMEGc2,time(1):time(2),new2); %extracting data
    
    data = cat(3,data1old,data2old,data1new,data2new);
    
    %structure with inputs for AU server
    S = [];
    S.pairl = pairl;
    S.data = data;
    S.condid = condid;
    S.numperm = numperm;
    S.kfold = kfold;
    S.savedir = savedir;
    S.ii = ppn(13:16);
    disp(ii)
    %job to cluster
    jobid = job2cluster(@decoding, S);
    
    if ii == 1 %saving D.time (time in seconds), only once
        time_sel = D1.time(time(1):time(2));
        save([savedir '/time.mat'],'time_sel');
    end
end


%% PLOTTING PAIRWISE DECODING (TIME SERIES) (ENCODING OF MUSICAL MELODIES FROM VISUAL DOTS)

%%% OBS!! THIS RESULT (DECODING TIME SERIES) IS INCLUDED IN THE TEMPORAL GENERALISATION MATRICES.. I LEAVE THIS CODE HERE JUST IN CASE.. BUT IT SHOULD BE IGNORED AND IT IS NOT REPORTED IN THE MANUSCRIPT %%% 

% list_PD = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Aud_vs_Vis/PD*.mat');
% load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Aud_vs_Vistime.mat'); %time in seconds
% dd1 = zeros(length(time_sel),length(list_PD)); %preallocate variable dd1 (time samples and PD files)
% for ff = 1:length(list_PD) %over PD files
%     load([list_PD(ff).folder '/' list_PD(ff).name]); %load PD file
%     dd1(:,ff) = d.d; %save d structure
%     disp(ff)
% end
% dd12 = mean(dd1,2); %average participants
% figure
% plot(time_sel,dd12) %plot average over time
% xlim([time_sel(1) time_sel(end)]) %plot time in seconds
% grid minor %add grid to plot

%% TEMPORAL GENERALISATION (SOMETIMES OUT OF MEMORY!! - USE FUNCTION ON THE CLUSTER INSTEAD)

encoding_l = 1; %1 = encoding samemel/visualpat; 2 = old/new recognition samemel; 3 = old/new recognition visualpat; 4 = Encoding vs Recognition of samemel; 5 = Encoding vs Recognition of visualpat

if encoding_l == 1
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Encoding_Aud_vs_Vis/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Aud_vs_Vistime.mat'); %time in seconds
elseif encoding_l == 2
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemeltime.mat');
elseif encoding_l == 3
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpattime.mat');
elseif encoding_l == 4
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemel/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemeltime.mat'); %time in seconds
elseif encoding_l == 5
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpat/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpattime.mat'); %time in seconds
end
dd1 = zeros(length(time_sel),length(time_sel),length(list_TG)); %preallocate variable dd1 (time samples and TG files)
for ff = 1:length(list_TG) %over TG files
    load([list_TG(ff).folder '/' list_TG(ff).name]); %load TG file
    dd1(:,:,ff) = d.d; %save d structure
    disp(ff)
end
ddTGm = mean(dd1,3); %average participants
figure; imagesc(time_sel,time_sel,ddTGm); xlabel('Train time (s)'); ylabel('Test time (s)'); set(gca,'YDir','normal'); %settings for figure
colorbar %add colorbar
set(gcf,'Color','w')
ddTGm = mean(dd1,3); %average participants
ddTGm(ddTGm<55)=0;
figure; imagesc(time_sel,time_sel,ddTGm); xlabel('Train time (s)'); ylabel('Test time (s)'); set(gca,'YDir','normal'); %settings for figure
colorbar %add colorbar
set(gcf,'Color','w')
ddTGm = mean(dd1,3); %average participants
ddTGm(ddTGm<60)=0;
figure; imagesc(time_sel,time_sel,ddTGm); xlabel('Train time (s)'); ylabel('Test time (s)'); set(gca,'YDir','normal'); %settings for figure
colorbar %add colorbar
set(gcf,'Color','w')

%%

%% STATISTICS ON TEMPORAL GENERALISATION

clear
encoding_l = 2; %1 = encoding samemel/visualpat; 2 = old/new recognition samemel; 3 = old/new recognition visualpat; 4 = Encoding vs Recognition of samemel; 5 = Encoding vs Recognition of visualpat
%                6 = Old recognition samemel/visualpat; 7 = old/new samemel and visualpat together 

if encoding_l == 1
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Encoding_Aud_vs_Vis/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Aud_vs_Vistime.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Encoding_Aud_vs_Vis';
elseif encoding_l == 2
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemeltime.mat');
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel';
elseif encoding_l == 3
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpattime.mat');
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat';
elseif encoding_l == 4
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemel/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemeltime.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemel';
elseif encoding_l == 5
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpat/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpattime.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpat';
elseif encoding_l == 6
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis/time.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis';
elseif encoding_l == 7
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat/TG*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat/time.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat';
end
ddTG = zeros(length(time_sel),length(time_sel),length(list_TG)); %preallocate variable dd1 (time samples and TG files)
for ff = 1:length(list_TG) %over TG files
    load([list_TG(ff).folder '/' list_TG(ff).name]); %load TG file
    ddTG(:,:,ff) = d.d; %save d structure
    clear d
    disp(ff)
end
%reshaping temporal generalization decoding acuracy for submitting it to statistical testing
ddTG2 = ddTG(1:size(ddTG,1),1:size(ddTG,1),:) - 50; %subtracting 50 since the function tests significance against 0 (here represented by 50% chance level)
ddTG2 = ddTG2(1:776,1:776,:); %only working on first 3 seconds since these are the ones that actually matter
clear ddTG d
dat = cell(1,size(ddTG2,3));
for ii = 1:size(ddTG2,3)
    dat(1,ii) = {ddTG2(:,:,ii)};
end
%computing statistics
stat = pl_permtest(dat,'alpha',0.05); %actual function
% if encoding_l == 2
%     
%     clusterconfig('scheduler', 'cluster'); %set to 'cluster' for running jobs in the cluster or 'none' for running jobs locally
%     clusterconfig('long_running', 1); %set to 0 for short queue, 1 for all queue or 2 for long queue
%     clusterconfig('slot', 3); %default amount of slots is 1 and maximum amount of slots is 12
%     addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing') %function that submits the jobs to the cluster
% 
%     S = [];
%     S.ddTG2 = ddTG2;
%     S.stat = stat;
%     statt = stat.statmappv(1:776,1:776);
%     P2 = zeros(size(statt,1),size(statt,1));
%     P2(statt<0.05) = 1;
%     S.P2 = P2;
%     S.thresh = 0;
%     S.permut = 1000;
%     S.threshMC = 0.001;
%     S.perm_max = 1;
%     S.t1 = time_sel(1:776); S.t2 = t1;
%     
%     jobid = job2cluster(@decoding_MCS, S);
% 
% else
    %saving the results
    save([outdir '/Stats.mat'],'stat','ddTG2')
% end

%% plotting the results of the statistics

encoding_l = 6; %1 = encoding samemel/visualpat; 2 = old/new recognition samemel; 3 = old/new recognition visualpat; 4 = Encoding vs Recognition of samemel; 5 = Encoding vs Recognition of visualpat
%                6 = Old recognition samemel/visualpat; 7 = old/new samemel and visualpat together 

if encoding_l == 1
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Encoding_Aud_vs_Vis/Stats.mat');
    name = 'Enc_AV';
elseif encoding_l == 2
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel/Stats.mat');
    name = 'Rec_A_ON';
elseif encoding_l == 3
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat/Stats.mat');
    name = 'Rec_V_ON';
elseif encoding_l == 4
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemel/Stats.mat');
    name = 'Enc_Rec_A';
elseif encoding_l == 5
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpat/Stats.mat');
    name = 'Enc_Rec_V';
elseif encoding_l == 6
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis/Stats.mat'); %time in seconds
    name = 'Rec_O_AV';
elseif encoding_l == 7
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat/Stats.mat'); %time in seconds
    name = 'Rec_AV_ON';
end
%loading time (it should be the same for all cases)
load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpattime.mat'); %time in seconds
stat.FDR

%t-values
figure; imagesc(time_sel(1:776),time_sel(1:776),stat.statmap(1:776,1:776)); xlabel('Train time (s)'); ylabel('Test time (s)'); set(gca,'YDir','normal');
% figure; imagesc(time_sel,time_sel,stat.statmap); xlabel('Train time (s)'); ylabel('Test time (s)'); set(gca,'YDir','normal')
colorbar
set(gcf,'Color','w')
caxis([-5 10])
title('t-stats')
export_fig(['/aux/MINDLAB2023_MEG-AuditMemDement/11Apr2025/TG_Tval_' name '.eps'])
export_fig(['/aux/MINDLAB2023_MEG-AuditMemDement/11Apr2025/TG_Tval_' name '.png'])


% if encoding_l == 2 %only one case had no survival time-points after FDR correction but it had after MCS cluster-based correction
%     load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel/')
%     %plotting significant t-values after cluster-based correction for multiple comparisons
%     BUM = OUT{1,9};
%     figure; imagesc(time_sel(1:776),time_sel(1:776),BUM(1:776,1:776)); xlabel('Train time (s)'); ylabel('Test time (s)'); set(gca,'YDir','normal');
%     colorbar
%     set(gcf,'Color','w')
%     title('Significant time-points after cluster-based MCS')
% else
    %FDR corrected
    figure; imagesc(time_sel(1:776),time_sel(1:776),stat.FDR.criticalmap(1:776,1:776)); xlabel('Train time (s)'); ylabel('Test time (s)'); set(gca,'YDir','normal');
    colorbar
    set(gcf,'Color','w')
    title('FDR corrected')
    export_fig(['/aux/MINDLAB2023_MEG-AuditMemDement/11Apr2025/TG_FDR_' name '.eps'])
    export_fig(['/aux/MINDLAB2023_MEG-AuditMemDement/11Apr2025/TG_FDR_' name '.png'])
    % end

%%


%%

%% PLOTTING ACTIVATION PATTERNS IN TOPOPLOTS AND AND WAVEFORMS FROM THE KEY ACTIVATION PATTERNS

clear
encoding_l = 7; %1 = encoding samemel/visualpat; 2 = old/new recognition samemel; 3 = old/new recognition visualpat; 4 = Encoding vs Recognition of samemel; 5 = Encoding vs Recognition of visualpat
%                6 = Old recognition samemel/visualpat; 7 = old/new samemel and visualpat together 


if encoding_l == 1
    lims = [-5000 5000];
    name = 'Enc_AV';
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Encoding_Aud_vs_Vis/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Aud_vs_Vistime.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Encoding_Aud_vs_Vis';
elseif encoding_l == 2
    lims = [-1800 1800];
    name = 'Rec_A_ON';
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemeltime.mat');
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel';
elseif encoding_l == 3
    lims = [-1800 1800];
    name = 'Rec_V_ON';
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpattime.mat');
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat';
elseif encoding_l == 4
    lims = [-2200 2200];
    name = 'Enc_Rec_A';
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemel/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemeltime.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemel';
elseif encoding_l == 5
    lims = [-2000 2000];
    name = 'Enc_Rec_V';
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpat/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpattime.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpat';
elseif encoding_l == 6
    lims = [-5000 5000];
    name = 'Rec_O_AV';
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis/time.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis';
elseif encoding_l == 7
    lims = [-1400 1400];
    name = 'Rec_AV_ON';
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat/time.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat';
end
ddpatt = zeros(306,length(time_sel),length(list_TG)); %preallocate variable dd1 (time samples and TG files)
for ff = 1:length(list_TG) %over TG files
    load([list_TG(ff).folder '/' list_TG(ff).name]); %load TG file
    ddpatt(:,:,ff) = d.pattern; %save d structure
    disp(ff)
end

% ACTUAL PLOTTING HERE

% 6 time-windows: 1 for each item (sound or visual dot) of the sequences, plus one final larger one for the time related to the response 
vect = [0.001 0.350; 0.351 0.700; 0.701 1.050; 1.051 1.400; 1.401 1.750; 1.751 2.200]; %vector with time-windows
% vect = [1.401 1.750]; %vector with time-windows


%extracting magnetometers for plotting purposes
dp = mean(ddpatt,3); %average over subjects
avg = dp(1:3:end,:); %extracting magnetometers only
% BOMBA{encoding_l} = avg;

%plotting topoplot (fieldtrip function)
%creating the mask for the data
fieldtrip_example = load('/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External/fieldmask.mat');
label2 = fieldtrip_example.M_timb_lock_gradplanarComb.label;
label = label2(103:end);
%setting labels according to the ones in the layout
for ii = 1:102
    label{ii,1} = [label{ii,1}(1:3) label{ii,1}(5:end)];
end
cfgdummy = fieldtrip_example.M_timb_lock_gradplanarComb.cfg;
cfgdummy.previous = [];
data = [];
data.cfg = cfgdummy;
data.time(1,:) = time_sel(:);
data.label = label;
data.dimord = fieldtrip_example.M_timb_lock_gradplanarComb.dimord;
data.grad = fieldtrip_example.M_timb_lock_gradplanarComb.grad;
data.avg = avg;
for vv = 1:size(vect,1)
    signt = vect(vv,:); %significant time-point(s) you want to plot
    %creating the cfg for the actual plotting (magnetometers)
    cfg = [];
    cfg.layout = '/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External/neuromag306mag.lay';
    cfg.colorbar = 'yes';
    cfg.xlim = signt; %set temporal limits (in seconds)
    if ~isempty(lims)
        cfg.zlim = [lims];
    else
        cfg.zlim = [];
    end
    cfg.colormap = 'jet';
    figure
    ft_topoplotER(cfg,data);
    set(gcf,'Color','w')
    %colormap with white for 0 values
    x = []; x.bottom = [0 0 0.5]; x.botmiddle = [0 0.5 1]; x.middle = [1 1 1]; x.topmiddle = [1 0 0]; x.top = [0.6 0 0]; %red - blue
    colormap(bluewhitered_PD(0,x))
    title(num2str(vv))
    export_fig(['/aux/MINDLAB2023_MEG-AuditMemDement/11Apr2025/MAG_ActivPatt_' name '_TimeWind_' num2str(vv) '.eps'])
    export_fig(['/aux/MINDLAB2023_MEG-AuditMemDement/11Apr2025/MAG_ActivPatt_' name '_TimeWind_' num2str(vv) '.png'])
end

%% PLOTTING WAVEFORM OF (SIGNED ADJUSTED) MAGNETOMETERS BASED ON THE MAIN ACTIVATION PATTERNS

load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_5Mag_SignAdj.mat'])
audmag = mag_adj;
load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_6Mag_SignAdj.mat'])
vismag = mag_adj;

color_line = colormap(lines(5)); %extracting some colours from a colormap
color_line2 = color_line;
color_line2(1,:) = color_line(2,:);
color_line2(2,:) = color_line(1,:);
color_line2(5,:) = [0.4 0.4 0.4];
if encoding_l == 1
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_6Mag_SignAdj.mat'])
    vismag = mag_adj;
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1)),'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Enc Old')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    %visual
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,1),3),1)),'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Vis Enc Old')
    hold on
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,1),3),1)) + squeeze((nanstd(nanstd(vismag(idx,:,:,1),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,1),3),1)) - squeeze((nanstd(nanstd(vismag(idx,:,:,1),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Encoding Old Auditory vs Visual')
elseif encoding_l == 2
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %old auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)),'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Old')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    %new auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1)),'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Aud New')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,3),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,3),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Recognition Old vs New Auditory')
elseif encoding_l == 3
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_6Mag_SignAdj.mat'])
    audmag = mag_adj; %this is actually the visual block, for lazyness I have not changed it since it does not really matter..
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %old visual
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)),'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Vis Old')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    %new visual
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1)),'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Vis New')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,3),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,3),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Recognition Old vs New Visual')
elseif encoding_l == 4
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %old auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1)),'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Enc Old')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    %new auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)),'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Aud Rec Old')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Encoding vs Recognition Auditory')
elseif encoding_l == 5
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_6Mag_SignAdj.mat'])
    audmag = mag_adj; %this is actually the visual block, for lazyness I have not changed it since it does not really matter..
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %old auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1)),'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Vis Enc Old')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    %new auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)),'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Vis Rec Old')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Encoding vs Recognition Visual')
elseif encoding_l == 6
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_6Mag_SignAdj.mat'])
    vismag = mag_adj;
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)),'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Rec Old')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    %visual
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,2),3),1)),'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Vis Rec Old')
    hold on
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,2),3),1)) + squeeze((nanstd(nanstd(vismag(idx,:,:,2),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,2),3),1)) - squeeze((nanstd(nanstd(vismag(idx,:,:,2),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Recognition Old Auditory vs Recognition Old Visual')
elseif encoding_l == 7
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/MEG_sensors/Block_6Mag_SignAdj.mat'])
    vismag = mag_adj;
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)),'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Old')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(1,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    %visual
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,2),3),1)),'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Vis Old')
    hold on
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,2),3),1)) + squeeze((nanstd(nanstd(vismag(idx,:,:,2),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,2),3),1)) - squeeze((nanstd(nanstd(vismag(idx,:,:,2),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(2,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    %auditory
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1)),'Color',color_line2(3,:),'LineWidth',2,'DisplayName','Aud New')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1)) + squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(3,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(audmag,2)),squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1)) - squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3)))),':','Color',color_line2(3,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    %visual
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,3),3),1)),'Color',color_line2(4,:),'LineWidth',2,'DisplayName','Vis New')
    hold on
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,3),3),1)) + squeeze((nanstd(nanstd(vismag(idx,:,:,3),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(4,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    plot(time_sel(1:size(vismag,2)),squeeze(nanmean(nanmean(vismag(idx,:,:,3),3),1)) - squeeze((nanstd(nanstd(vismag(idx,:,:,3),0,3),0,1)./sqrt(size(vismag,3)))),':','Color',color_line2(4,:),'LineWidth',0.5,'HandleVisibility','Off')
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Recognition Old Aud-Vis vs Recognition New Aud-Vis')
end

%%

%%

%% *** SOURCE RECONSTRUCTION ***

%%

%% LBPD_startup_D

pathl = '/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD'; %path to stored functions
addpath(pathl);
LBPD_startup_D(pathl);

%%

%% CREATING 8mm PARCELLATION FOR EASIER INSPECTION IN FSLEYES
%OBS!! This section is done only for better handling of some visualization purposes, but it does not affect any of the beamforming algorithm;
% it is just important not to mix up the MNI coordinates, thus I would recommend to use the following lines

%1) USE load_nii TO LOAD A PREVIOUS NIFTI IMAGE
imag_8mm = load_nii('/scratch7/MINDLAB2017_MEG-LearningBach/DTI_Portis/Templates/MNI152_T1_8mm_brain.nii.gz');
Minfo = size(imag_8mm.img); %get info about the size of the original image
M8 = zeros(Minfo(1), Minfo(2), Minfo(3)); %Initialize an empty matrix with the same dimensions as the original .nii image
cc = 0; %set a counter
M1 = imag_8mm.img;
for ii = 1:Minfo(1) %loop across each voxel of every dimension
    for jj = 1:Minfo(2)
        for zz = 1:Minfo(3)
            if M1(ii,jj,zz) ~= 0 %if we have an actual brain voxel
                cc = cc+1;
                M8(ii,jj,zz) = cc;
            end
        end
    end
end
%2) PUT YOUR MATRIX IN THE FIELD ".img"
imag_8mm.img = M8; %assign values to new matrix 
%3) SAVE NIFTI IMAGE USING save_nii
save_nii(imag_8mm,'/scratch7/MINDLAB2017_MEG-LearningBach/DTI_Portis/Templates/MNI152_8mm_brain_diy.nii.gz');
%4) USE FSLEYES TO LOOK AT THE FIGURE
%Create parcellation on the 8mm template
for ii = 1:3559 %for each 8mm voxel
    cmd = ['fslmaths /scratch7/MINDLAB2017_MEG-LearningBach/DTI_Portis/Templates/MNI152_8mm_brain_diy.nii.nii.gz -thr ' num2str(ii) ' -uthr ' num2str(ii) ' -bin /scratch7/MINDLAB2017_MEG-LearningBach/DTI_Portis/Templates/AAL_80mm_3559ROIs/' num2str(ii) '.nii.gz'];
    system(cmd)
    disp(ii)
end
%5) GET MNI COORDINATES OF THE NEW FIGURE AND SAVE THEM ON DISK
MNI8 = zeros(3559,3);
for mm = 1:3559 %over brain voxel
    path_8mm = ['/scratch7/MINDLAB2017_MEG-LearningBach/DTI_Portis/Templates/parcel_80mm_3559ROIs/' num2str(mm) '.nii.gz']; %path for each of the 3559 parcels
    [mni_coord,pkfo] = osl_mnimask2mnicoords(path_8mm);  %getting MNI coordinates
    MNI8(mm,:) = mni_coord; %storing MNI coordinates
end
%saving on disk
save('/scratch7/MINDLAB2017_MEG-LearningBach/DTI_Portis/Templates/MNI152_8mm_coord_dyi.mat', 'MNI8');


%% CONVERSION T1 - DICOM TO NIFTI

addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/osl/dicm2nii'); %adds path to the dcm2nii folder in osl
MRIsubj = dir('/projects/MINDLAB2020_MEG-AuditoryPatternRecognition/raw/0*');
MRIoutput = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/MRI_nifti';
MRIout_block{1} = 'Block_3'; MRIout_block{2} = 'Block_4'; MRIout_block{3} = 'Block_5'; MRIout_block{4} = 'Block_6'; MRIout_block{5} = 'Block_7';

for bb = 1:5 %over experimental blocks
    for ii = 1:length(MRIsubj) %over subjects
        asd = ['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/MRI_nifti/Block_' num2str(bb+2) '/' MRIsubj(ii).name];
        if ~exist(asd,'dir') %checking whether the directory exists
            mkdir(asd); %if not, creating it
        end
        if isempty(dir([asd '/*.nii'])) %if there are no nifti images.. I need to convert them
            flagg = 0;
            MRIMEGdate = dir([MRIsubj(ii).folder '/' MRIsubj(ii).name '/20*']);
            niiFolder = [MRIoutput '/' MRIout_block{bb} '/' MRIsubj(ii).name];
            for jj = 1:length(MRIMEGdate) %over dates of recording
                if ~isempty(dir([MRIMEGdate(jj).folder '/' MRIMEGdate(jj).name '/MR*'])) %if we get an MRI recording
                    MRI2 = dir([MRIMEGdate(jj).folder '/' MRIMEGdate(jj).name '/MR/*fatsat']); %looking for T1
                    if ~isempty(MRI2) %if we have it
                        flagg = 1; %determining that I could convert MRI T1
                        dcmSource = [MRI2(1).folder '/' MRI2(1).name '/files/'];
                        if ii ~= 68 || jj ~= 3 %this is because subject 0068 got two MRIs stored.. but the second one (indexed by jj = 3) is of another subject (0086); in this moment, subject 0086 is perfectly fine, but in subject 0068 there are still the two MRIs (for 0068 (jj = 2) and for 0086 (jj = 3))
                            dicm2nii(dcmSource, niiFolder, '.nii');
                        end
                    end
                end
            end
            if flagg == 0
                warning(['subject ' MRIsubj(ii).name ' has no MRI T1']);
            end
        end
        disp(ii)
    end
end

%% SETTING FOR CLUSTER (PARALLEL COMPUTING)

% clusterconfig('scheduler', 'none'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
clusterconfig('scheduler', 'cluster'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
clusterconfig('long_running', 1); % This is the cue we want to use for the clsuter. There are 3 different cues. Cue 0 is the short one, which should be enough for us
clusterconfig('slot', 1); %slot is memory, and 1 memory slot is about 8 GB. Hence, set to 2 = 16 GB
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing')

%% RHINO coregistration

%block to be run RHINO coregistrartion on
block = 6; % 3 = recogminor; 4 = recogspeed; 5 = samemel; 6 = visualpat; 7 = pd

if block == 3
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*recogminor*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 4
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*recogspeed*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 5
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 6
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 7
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*pd*_tsssdsm.mat'); %dir to epoched files (encoding)
end

%running rhino
%OBS! check that all MEG data are in the same order and number as MRI nifti files!
a = ['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/MRI_nifti/Block_' num2str(block)]; %set path to MRI subjects' folders
for ii = 35%1:length(list) %OBS! change this depending on atonal vs. major
    S = [];
    S.ii = ii;
    S.D = [list(ii).folder '/' list(ii).name]; %path to major files
    D = spm_eeg_load(S.D);
    if ~isfield(D,'inv') %checking if the coregistration was already run
        dummyname = D.fname;
        if 7 == exist([a '/' dummyname(13:16)],'dir') %if you have the MRI folder
            dummymri = dir([a '/' dummyname(13:16) '/*.nii']); %path to nifti files (ending with .nii)
            if ~isempty(dummymri)
                S.mri = [dummymri(1).folder '/' dummymri(1).name];
                %standard parameters
                S.useheadshape = 1;
                S.use_rhino = 1; %set 1 for rhino, 0 for no rhino
                %         S.forward_meg = 'MEG Local Spheres';
                S.forward_meg = 'Single Shell'; %CHECK WHY IT SEEMS TO WORK ONLY WITH SINGLE SHELL!!
                S.fid.label.nasion = 'Nasion';
                S.fid.label.lpa = 'LPA';
                S.fid.label.rpa = 'RPA';
                jobid = job2cluster(@coregfunc,S); %running with parallel computing
            else
                warning(['subject ' dummyname(13:16) ' does not have the MRI'])
            end
        end
    else
        if isempty(D.inv{1}) %checking whether the coregistration was run but now it is empty..
            warning(['subject ' D.fname ' has an empty rhino..']);
        end
    end
    disp(ii)
end

%% checking (or copying) RHINO

copy_label = 0; % 1 = pasting inv RHINO from epoched data (where it was computed) to continuous data; 0 = simply showing RHINO coregistration
%block to be run RHINO coregistration on
block = 3; % 3 = recogminor; 4 = recogspeed; 5 = samemel; 6 = visualpat; 7 = pd

if block == 3
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*recogminor*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 4
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*recogspeed*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 5
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 6
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*_tsssdsm.mat'); %dir to epoched files (encoding)
elseif block == 7
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*pd*_tsssdsm.mat'); %dir to epoched files (encoding)
end

for ii = 35%30,44,66%1:length(list)
    D = spm_eeg_load([list(ii).folder '/' list(ii).name]);
    if isfield(D,'inv')
        if copy_label == 0 %simply displaying RHINO coregistration
            if isfield(D,'inv') %checking if the coregistration was already run
                rhino_display(D)
            end
        else %pasting inv RHINO from epoched data (where it was computed) to continuous data
            inv_rhino = D.inv;
            D2 = spm_eeg_load([list(ii).folder '/' list(ii).name(2:end)]);
            D2.inv = inv_rhino;
            D2.save();
        end
    end
    disp(['Block ' num2str(block) ' - Subject ' num2str(ii)])
end
%block 4 subj 1

%%

%% BEAMFORMING - RECONSTRUCITON OF BRAIN SIGNAL (NO WEIGHTS FROM THE DECODING)

%% SETTING FOR CLUSTER (PARALLEL COMPUTING)

% clusterconfig('scheduler', 'none'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
clusterconfig('scheduler', 'cluster'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
clusterconfig('long_running', 1); % This is the cue we want to use for the clsuter. There are 3 different cues. Cue 0 is the short one, which should be enough for us
clusterconfig('slot', 1); %slot is memory, and 1 memory slot is about 8 GB. Hence, set to 2 = 16 GB
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing')

%% FUNCTION FOR SOURCE RECONSTRUCTION

%%% OBS!! CHECK THAT YOU DON'T RUN THIS FOR SUBJECTS WITH NO D.INV.. %%%

%user settings
clust_l = 1; %1 = using cluster of computers (CFIN-MIB, Aarhus University); 0 = running locally
timek = 1:1026; %time-points
freqq = []; %frequency range (empty [] for broad band)
% freqq = [0.1 1]; %frequency range (empty [] for broad band)
% freqq = [2 8]; %frequency range (empty [] for broad band)
sensl = 1; %1 = magnetometers only; 2 = gradiometers only; 3 = both magnetometers and gradiometers (SUGGESTED 1!)
workingdir2 = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD'; %high-order working directory (a subfolder for each analysis with information about frequency, time and absolute value will be created)
block = 5; % 3 = recogminor; 4 = recogspeed; 5 = samemel; 6 = visualpat; 7 = pd
invers = 1; %1-4 = different ways (e.g. mean, t-values, etc.) to aggregate trials and then source reconstruct only one trial; 5 for single trial independent source reconstruction

if isempty(freqq)
    absl = 0; % 1 = absolute value of sources; 0 = not
else
    absl = 0;
end

%actual computation
%list of subjects with coregistration (RHINO - OSL/FSL) - epoched
if block == 3
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*recogminor*_tsssdsm.mat'); %dir to epoched files (encoding)
    condss = {'Old_Correct','New_T1_Correct','New_T2_Correct','New_T3_Correct','New_T4_Correct'};
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/time_normal.mat');
elseif block == 4
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*recogspeed*_tsssdsm.mat'); %dir to epoched files (encoding)
    condss = {'Old_Fast_Correct','Old_Slow_Correct','New_Fast_Correct','New_Slow_Correct'};
elseif block == 5
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*_tsssdsm.mat'); %dir to epoched files (encoding)
    condss = {'Encoding','Old_Correct','New_Correct'};
elseif block == 6
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*_tsssdsm.mat'); %dir to epoched files (encoding)
    condss = {'Encoding','Old_Correct','New_Correct'};
elseif block == 7
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*pd*_tsssdsm.mat'); %dir to epoched files (encoding)
    condss = {'pd','pm'};
end
if isempty(freqq)
    workingdir = [workingdir2 '/Block_' num2str(block) '/Beam_abs_' num2str(absl) '_sens_' num2str(sensl) '_freq_broadband_invers_' num2str(invers)];
else
    workingdir = [workingdir2 '/Block_' num2str(block) '/Beam_abs_' num2str(absl) '_sens_' num2str(sensl) '_freq_' num2str(freqq(1)) '_' num2str(freqq(2)) '_invers_' num2str(invers)];
end
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing');
if ~exist(workingdir,'dir') %creating working folder if it does not exist
    mkdir(workingdir)
end
for ii = 1:length(list) %over subjects
    S = [];
    if ~isempty(freqq) %if you want to apply the bandpass filter, you need to provide continuous data
        %             disp(['copying continuous data for subj ' num2str(ii)])
        %thus pasting it here
        %             copyfile([list_c(ii).folder '/' list_c(ii).name],[workingdir '/' list_c(ii).name]); %.mat file
        %             copyfile([list_c(ii).folder '/' list_c(ii).name(1:end-3) 'dat'],[workingdir '/' list_c(ii).name(1:end-3) 'dat']); %.dat file
        %and assigning the path to the structure S
        S.norm_megsensors.MEGdata_c = [list(ii).folder '/' list(ii).name(2:end)];
    end
    %copy-pasting epoched files
    %         disp(['copying epoched data for subj ' num2str(ii)])
    %         copyfile([list(ii).folder '/' list(ii).name],[workingdir '/' list(ii).name]); %.mat file
    %         copyfile([list(ii).folder '/' list(ii).name(1:end-3) 'dat'],[workingdir '/' list(ii).name(1:end-3) 'dat']); %.dat file
    
    S.Aarhus_cluster = clust_l; %1 for parallel computing; 0 for local computation
    
    S.norm_megsensors.zscorel_cov = 1; % 1 for zscore normalization; 0 otherwise
    S.norm_megsensors.workdir = workingdir;
    S.norm_megsensors.MEGdata_e = [list(ii).folder '/' list(ii).name];
    S.norm_megsensors.freq = freqq; %frequency range
    S.norm_megsensors.forward = 'Single Shell'; %forward solution (for now better to stick to 'Single Shell')
    
    S.beamfilters.sensl = sensl; %1 = magnetometers; 2 = gradiometers; 3 = both MEG sensors (mag and grad) (SUGGESTED 3!)
    S.beamfilters.maskfname = '/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External/MNI152_T1_8mm_brain.nii.gz'; % path to brain mask: (e.g. 8mm MNI152-T1: '/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External/MNI152_T1_8mm_brain.nii.gz')
    
    %%% CHECK THIS ONE ESPECIALLY!!!!!!! %%%
    S.inversion.znorml = 0; % 1 for inverting MEG data using the zscored normalized one; (SUGGESTED 0 IN BOTH CASES!)
    %                                 0 to normalize the original data with respect to maximum and minimum of the experimental conditions if you have both magnetometers and gradiometers.
    %                                 0 to use original data in the inversion if you have only mag or grad (while e.g. you may have used zscored-data for covariance matrix)
    %
    S.inversion.timef = timek; %data-points to be extracted (e.g. 1:300); leave it empty [] for working on the full length of the epoch
    S.inversion.conditions = condss; %cell with characters for the labels of the experimental conditions (e.g. {'Old_Correct','New_Correct'})
    S.inversion.bc = [1 26]; %extreme time-samples for baseline correction (leave empty [] if you do not want to apply it)
    S.inversion.abs = absl; %1 for absolute values of sources time-series (recommendnded 1!)
    S.inversion.effects = invers;
    
    S.smoothing.spatsmootl = 0; %1 for spatial smoothing; 0 otherwise
    S.smoothing.spat_fwhm = 100; %spatial smoothing fwhm (suggested = 100)
    S.smoothing.tempsmootl = 0; %1 for temporal smoothing; 0 otherwise
    S.smoothing.temp_param = 0.01; %temporal smoothing parameter (suggested = 0.01)
    S.smoothing.tempplot = [1 2030 3269]; %vector with sources indices to be plotted (original vs temporally smoothed timeseries; e.g. [1 2030 3269]). Leave empty [] for not having any plot.
    
    S.nifti = 1; %1 for plotting nifti images of the reconstructed sources of the experimental conditions
    S.out_name = ['SUBJ_' list(ii).name(13:16)]; %name (character) for output nifti images (conditions name is automatically detected and added)
    
    if clust_l ~= 1 %useful  mainly for begugging purposes
        MEG_SR_Beam_LBPD(S);
    else
        jobid = job2cluster(@MEG_SR_Beam_LBPD,S); %running with parallel computing
    end
end


%% SETTING FOR CLUSTER (PARALLEL COMPUTING)

% clusterconfig('scheduler', 'none'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
clusterconfig('scheduler', 'cluster'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
clusterconfig('long_running', 1); % This is the cue we want to use for the clsuter. There are 3 different cues. Cue 0 is the short one, which should be enough for us
clusterconfig('slot', 6); %slot is memory, and 1 memory slot is about 8 GB. Hence, set to 2 = 16 GB
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing')


%% STATISTICS OVER PARTICIPANTS (USING PARALLEL COMPUTING, PARTICULARLY USEFUL IF YOU HAVE SEVERAL CONTRASTS)

block = 5; % 3 = recogminor; 4 = recogspeed; 5 = samemel; 6 = visualpat; 7 = pd
clust = 1; % 1 = using Aarhus cluster (parallel computing); 0 = run locally
analys_n = 1; %analysis number (in the list indexed below)

%building structure
asd = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Block_' num2str(block) '/Beam*']);
S = [];
S.workingdir = [asd(analys_n).folder '/' asd(analys_n).name]; %path where the data from MEG_SR_Beam_LBPD.m is stored
S.sensl = 1; % 1 = magnetometers only; 2 = gradiometers only; 3 = both magnetometers and gradiometers.
S.plot_nifti = 1; %1 to plot nifti images; 0 otherwise
S.plot_nifti_name = []; %character with name for nifti files (it may be useful if you run separate analysis); Leave empty [] to not  specify any name
% S.contrast = [1 0 0 0 0 0 -1; 0 1 0 0 0 0 -1; 0 0 1 0 0 0 -1; 0 0 0 1 0 0 -1; 0 0 0 0 1 0 -1; 0 0 0 0 0 1 -1; 1 1 1 1 1 1 -1]; %one row per contrast (e.g. having 3 conditions, [1 -1 0; 1 -1 -1; 0 1 -1]; two or more -1 or 1 are interpreted as the mean over them first and then the contrast. Leave empty [] for no contrasts. 
if block == 3
    S.contrast = [1 -1 0 0 0; 1 0 -1 0 0; 1 0 0 -1 0; 1 0 0 0 -1];
elseif block == 4
        S.contrast = [1 0 -1 0; 0 1 0 -1];
elseif block == 5 || block == 6
    S.contrast = [0 1 -1; -1 1 0];
else
    S.contrast = [1 -1];
end
S.effects = 1; %mean over subjects for now
if clust == 1
    S.Aarhus_clust = 1; %1 to use paralle computing (Aarhus University, contact me, Leonardo Bonetti, for more information; leonardo.bonetti@clin.au.dk)
    %actual function
    jobid = job2cluster(@MEG_SR_Stats1_Fast_LBPD,S); %running with parallel computing
else
    S.Aarhus_clust = 0; %1 to use paralle computing (Aarhus University, contact me, Leonardo Bonetti, for more information; leonardo.bonetti@clin.au.dk)
    MEG_SR_Stats1_Fast_LBPD(S)
end

%%

%% BEAMFORMING - RECONSTRUCITON OF DECODING WEIGHTS

%%

%% FIRST, MERGING BLOCK 5 AND 6 (AUDITORY AND VISUAL DATASETS)

%%% example code for merging

epoch_list1 = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*.mat'); %dir to epoched files
epoch_list2 = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*.mat'); %dir to epoched files

for ii = 56:length(epoch_list1)
    S = []; %empty structure
    S.recode = 'same';
    S.prefix = 'merg'; %merged
    S.D{1} = spm_eeg_load([epoch_list1(ii).folder '/' epoch_list1(ii).name]);
    S.D{2} = spm_eeg_load([epoch_list2(ii).folder '/' epoch_list2(ii).name]);
    Dout = spm_eeg_merge(S); %actual function
    disp(ii)
end

%% making sure that the montage is switched to 1, meaning the ICA denoised data 

list = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/merge*samemel*.mat'); %dir to epoched files
for ii = 1:length(list)
    D = spm_eeg_load([list(ii).folder '/' list(ii).name]);
    D = D.montage('switch',1);
    disp(ii)
end

%% SOURCE RECONSTRUCTION FOR DATASETS COMBINED (AUDITORY AND VISUAL) WHICH IS RELEVANT FOR CASES WHERE THE DECODING WAS DONE ON BOTH AUDITORY AND VISUAL STIMULI AT THE SAME TIME

%% SETTING FOR CLUSTER (PARALLEL COMPUTING)

% clusterconfig('scheduler', 'none'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
clusterconfig('scheduler', 'cluster'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
clusterconfig('long_running', 1); % This is the cue we want to use for the clsuter. There are 3 different cues. Cue 0 is the short one, which should be enough for us
clusterconfig('slot', 1); %slot is memory, and 1 memory slot is about 8 GB. Hence, set to 2 = 16 GB
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing')

%% FUNCTION FOR SOURCE RECONSTRUCTION

encoding_l = 7; %1 = encoding samemel/visualpat; 2 = old/new recognition samemel; 3 = old/new recognition visualpat; 4 = Encoding vs Recognition of samemel; 5 = Encoding vs Recognition of visualpat
%                6 = Old recognition samemel/visualpat; 7 = old/new samemel and visualpat together 

%user settings
clust_l = 1; %1 = using cluster of computers (CFIN-MIB, Aarhus University); 0 = running locally
timek = []; %time-points
freqq = []; %frequency range (empty [] for broad band)
% freqq = [0.1 1]; %frequency range (empty [] for broad band)
% freqq = [2 8]; %frequency range (empty [] for broad band)
sensl = 1; %1 = magnetometers only; 2 = gradiometers only; 3 = both magnetometers and gradiometers (SUGGESTED 1!)
workingdir2 = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD'; %high-order working directory (a subfolder for each analysis with information about frequency, time and absolute value will be created)
invers = 6; %1-4 = different ways (e.g. mean, t-values, etc.) to aggregate trials and then source reconstruct only one trial; 5 for single trial independent source reconstruction
absl = 0; % 1 = absolute value of sources; 0 = not

%actual computation
%list of subjects with coregistration (RHINO - OSL/FSL) - epoched
if encoding_l == 1
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/merge*samemel*_tsssdsm.mat'); %dir to epoched files (encoding)
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Encoding_Aud_vs_Vis/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Aud_vs_Vistime.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Encoding_Aud_vs_Vis';
elseif encoding_l == 2
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*_tsssdsm.mat'); %dir to epoched files (encoding)
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemeltime.mat');
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel';
elseif encoding_l == 3
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*_tsssdsm.mat'); %dir to epoched files (encoding)
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpattime.mat');
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat';
elseif encoding_l == 4
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*samemel*_tsssdsm.mat'); %dir to epoched files (encoding)
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemel/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemeltime.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_samemel';
elseif encoding_l == 5
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/e*visualpat*_tsssdsm.mat'); %dir to epoched files (encoding)
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpat/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpattime.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Enc_Rec_visualpat';
elseif encoding_l == 6
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/merge*samemel*_tsssdsm.mat'); %dir to epoched files (encoding)
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis/time.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Old_Rec_AudVsVis';
elseif encoding_l == 7
    list = dir ('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/merge*samemel*_tsssdsm.mat'); %dir to epoched files (encoding)
    list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat/PD*.mat');
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat/time.mat'); %time in seconds
    outdir = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Rec_OldNew_SamemelVisualpat';
end
condss = {'Encoding','Old_Correct','New_Correct'};
condss2 = {'Decoding'};

if isempty(freqq)
    workingdir = [workingdir2 '/Decoding/Case_' num2str(encoding_l) '_Beam_abs_' num2str(absl) '_sens_' num2str(sensl) '_freq_broadband_invers_' num2str(invers)];
else
    workingdir = [workingdir2 '/Decoding/Case_' num2str(encoding_l) '_Beam_abs_' num2str(absl) '_sens_' num2str(sensl) '_freq_' num2str(freqq(1)) '_' num2str(freqq(2)) '_invers_' num2str(invers)];
end
addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing');
if ~exist(workingdir,'dir') %creating working folder if it does not exist
    mkdir(workingdir)
end
for ii = 1:length(list) %over subjects
    S = [];
    if ~isempty(freqq) %if you want to apply the bandpass filter, you need to provide continuous data
        %             disp(['copying continuous data for subj ' num2str(ii)])
        %thus pasting it here
        %             copyfile([list_c(ii).folder '/' list_c(ii).name],[workingdir '/' list_c(ii).name]); %.mat file
        %             copyfile([list_c(ii).folder '/' list_c(ii).name(1:end-3) 'dat'],[workingdir '/' list_c(ii).name(1:end-3) 'dat']); %.dat file
        %and assigning the path to the structure S
        S.norm_megsensors.MEGdata_c = [list(ii).folder '/' list(ii).name(2:end)];
    end
    %copy-pasting epoched files
    %         disp(['copying epoched data for subj ' num2str(ii)])
    %         copyfile([list(ii).folder '/' list(ii).name],[workingdir '/' list(ii).name]); %.mat file
    %         copyfile([list(ii).folder '/' list(ii).name(1:end-3) 'dat'],[workingdir '/' list(ii).name(1:end-3) 'dat']); %.dat file
    
    S.Aarhus_cluster = clust_l; %1 for parallel computing; 0 for local computation
    
    S.norm_megsensors.zscorel_cov = 1; % 1 for zscore normalization; 0 otherwise
    S.norm_megsensors.workdir = workingdir;
    S.norm_megsensors.MEGdata_e = [list(ii).folder '/' list(ii).name];
    S.norm_megsensors.freq = freqq; %frequency range
    S.norm_megsensors.forward = 'Single Shell'; %forward solution (for now better to stick to 'Single Shell')
    
    S.beamfilters.sensl = sensl; %1 = magnetometers; 2 = gradiometers; 3 = both MEG sensors (mag and grad) (SUGGESTED 3!)
    S.beamfilters.maskfname = '/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External/MNI152_T1_8mm_brain.nii.gz'; % path to brain mask: (e.g. 8mm MNI152-T1: '/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External/MNI152_T1_8mm_brain.nii.gz')
    
    %%% CHECK THIS ONE ESPECIALLY!!!!!!! %%%
    S.inversion.znorml = 0; % 1 for inverting MEG data using the zscored normalized one; (SUGGESTED 0 IN BOTH CASES!)
    %                                 0 to normalize the original data with respect to maximum and minimum of the experimental conditions if you have both magnetometers and gradiometers.
    %                                 0 to use original data in the inversion if you have only mag or grad (while e.g. you may have used zscored-data for covariance matrix)
    %
    S.inversion.timef = timek; %data-points to be extracted (e.g. 1:300); leave it empty [] for working on the full length of the epoch
    S.inversion.conditions = condss; %cell with characters for the labels of the experimental conditions (e.g. {'Old_Correct','New_Correct'})
    S.inversion.bc = [1 26]; %extreme time-samples for baseline correction (leave empty [] if you do not want to apply it)
    S.inversion.abs = absl; %1 for absolute values of sources time-series (recommendnded 1!)
    S.inversion.effects = invers;
    if encoding_l == 1 || encoding_l == 6 || encoding_l == 7
        load([list_TG(1).folder '/PD_SUBJ' list(ii).name(17:20) '.mat']); %load TG file
    else
        load([list_TG(1).folder '/PD_SUBJ' list(ii).name(13:16) '.mat']); %load TG file
    end
    S.inversion.alternative_data{1} = d.pattern(1:3:end,:);
    S.inversion.alternative_data{2} = condss2;
    
    
    S.smoothing.spatsmootl = 0; %1 for spatial smoothing; 0 otherwise
    S.smoothing.spat_fwhm = 100; %spatial smoothing fwhm (suggested = 100)
    S.smoothing.tempsmootl = 0; %1 for temporal smoothing; 0 otherwise
    S.smoothing.temp_param = 0.01; %temporal smoothing parameter (suggested = 0.01)
    S.smoothing.tempplot = [1 2030 3269]; %vector with sources indices to be plotted (original vs temporally smoothed timeseries; e.g. [1 2030 3269]). Leave empty [] for not having any plot.
    
    S.nifti = 1; %1 for plotting nifti images of the reconstructed sources of the experimental conditions
    if encoding_l == 1 || encoding_l == 6 || encoding_l == 7
        S.out_name = ['SUBJ_' list(ii).name(17:20)]; %name (character) for output nifti images (conditions name is automatically detected and added)
    else
        S.out_name = ['SUBJ_' list(ii).name(13:16)]; %name (character) for output nifti images (conditions name is automatically detected and added)
    end
    
    if clust_l ~= 1 %useful  mainly for begugging purposes
        MEG_SR_Beam_LBPD(S);
    else
        jobid = job2cluster(@MEG_SR_Beam_LBPD,S); %running with parallel computing
    end
    disp(ii)
end


%% SETTING FOR CLUSTER (PARALLEL COMPUTING)
% 
% % clusterconfig('scheduler', 'none'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
% clusterconfig('scheduler', 'cluster'); %If you do not want to submit to the cluster, but simply want to test the script on the hyades computer, you can instead of 'cluster', write 'none'
% clusterconfig('long_running', 1); % This is the cue we want to use for the clsuter. There are 3 different cues. Cue 0 is the short one, which should be enough for us
% clusterconfig('slot', 4); %slot is memory, and 1 memory slot is about 8 GB. Hence, set to 2 = 16 GB
% addpath('/projects/MINDLAB2017_MEG-LearningBach/scripts/Cluster_ParallelComputing')
% 

%% STATISTICS OVER PARTICIPANTS (USING PARALLEL COMPUTING, PARTICULARLY USEFUL IF YOU HAVE SEVERAL CONTRASTS)

% encoding_l = 7; %1 = encoding samemel/visualpat; 2 = old/new recognition samemel; 3 = old/new recognition visualpat; 4 = Encoding vs Recognition of samemel; 5 = Encoding vs Recognition of visualpat
% %                6 = Old recognition samemel/visualpat; 7 = old/new samemel and visualpat together 
% 
% clust = 1; % 1 = using Aarhus cluster (parallel computing); 0 = run locally
% analys_n = 1; %analysis number (in the list indexed below)
% 
% %building structure
% S = [];
% S.workingdir = ['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Decoding/Case_' num2str(encoding_l) '_Beam_abs_1_sens_1_freq_broadband_invers_6']; %path where the data from MEG_SR_Beam_LBPD.m is stored
% S.sensl = 1; % 1 = magnetometers only; 2 = gradiometers only; 3 = both magnetometers and gradiometers.
% S.plot_nifti = 1; %1 to plot nifti images; 0 otherwise
% S.plot_nifti_name = []; %character with name for nifti files (it may be useful if you run separate analysis); Leave empty [] to not  specify any name
% % S.contrast = [1 0 0 0 0 0 -1; 0 1 0 0 0 0 -1; 0 0 1 0 0 0 -1; 0 0 0 1 0 0 -1; 0 0 0 0 1 0 -1; 0 0 0 0 0 1 -1; 1 1 1 1 1 1 -1]; %one row per contrast (e.g. having 3 conditions, [1 -1 0; 1 -1 -1; 0 1 -1]; two or more -1 or 1 are interpreted as the mean over them first and then the contrast. Leave empty [] for no contrasts. 
% S.contrast = [];
% S.effects = 1; %mean over subjects for now
% if clust == 1
%     S.Aarhus_clust = 1; %1 to use paralle computing (Aarhus University, contact me, Leonardo Bonetti, for more information; leonardo.bonetti@clin.au.dk)
%     %actual function
%     jobid = job2cluster(@MEG_SR_Stats1_Fast_LBPD,S); %running with parallel computing
% else
%     S.Aarhus_clust = 0; %1 to use paralle computing (Aarhus University, contact me, Leonardo Bonetti, for more information; leonardo.bonetti@clin.au.dk)
%     MEG_SR_Stats1_Fast_LBPD(S)
% end

%%



%% PLOTTING DECODING AVERAGED FOR 6 TIME-WINDOWS

% encoding_l = 6; %1 = encoding samemel/visualpat; 2 = old/new recognition samemel; 3 = old/new recognition visualpat; 4 = Encoding vs Recognition of samemel; 5 = Encoding vs Recognition of visualpat
% %                6 = Old recognition samemel/visualpat; 7 = old/new samemel and visualpat together 
% 
% vect = [0.001 0.350; 0.351 0.700; 0.701 1.050; 1.051 1.400; 1.401 1.750; 1.751 2.200]; %vector with time-windows
% 
% % load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Decoding/Case_' num2str(encoding_l) '_Beam_abs_1_sens_1_freq_broadband_invers_6/sources_main_effects.mat']);
% 
% load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Decoding/Case_' num2str(encoding_l) '_Beam_abs_1_sens_1_freq_broadband_invers_6/SUBJ_0074_norm0_abs_1.mat']);
% t_val_s = OUT.sources_ERFs;
% 
% load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/time_normal.mat');
% WD = ['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Decoding/Case_' num2str(encoding_l) '_Beam_abs_1_sens_1_freq_broadband_invers_6/TimewWindows']; %path and name of the image to be saved
% mkdir(WD);
% 
% BUM = zeros(3559,size(vect,1));
% for ii = 1:size(vect,1) %over time-windows
%     [~,idx1] = min(abs(vect(ii,1)-time)); %finding index of time 1 in the time-window
%     [~,idx2] = min(abs(vect(ii,2)-time)); %finding index of time 2 in the time-window
%     
%     %%% OBS!! THIS IS NOT IDEAL AND TOBE FIXED TRUING AGIAN THE UPDATED FUNCTION
%     BIM = mean(t_val_s,3); %THIS IS TO BE DONE ONLY NOW AND THEN HOPEFULLY FIXED IN THE FUNCTION!!
%     %%% OBS!! UNTIL HERE
%     
%     BUM = mean(BIM(:,idx1:idx2),2); %average of the activation patterns in source space over the time window ii
%     BUM = BUM./max(BUM); %normalising activation patterns
%     
%     %seting to 0 values below mean plus 1 standard deviation
%     BUM(BUM<(mean(BUM) + std(BUM))) = 0;
%     
%     %preparing nifti images
%     %loading mask
%     maskk = load_nii('/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External/MNI152_8mm_brain_diy.nii.gz'); %getting the mask for creating the figure
%     
%     %building nifti image
%     fnamenii = [WD '/TimeWin_' num2str(ii) '.nii.gz']; %name
%     SS = size(maskk.img);
%     dumimg = zeros(SS(1),SS(2),SS(3));
%     for iii = 1:size(BUM,1) %over brain sources
%         dum = find(maskk.img == iii); %finding index of sources ii in mask image (MNI152_8mm_brain_diy.nii.gz)
%         [i1,i2,i3] = ind2sub([SS(1),SS(2),SS(3)],dum); %getting subscript in 3D from index
%         dumimg(i1,i2,i3,:) = BUM(iii); %storing values for all time-points in the image matrix
%     end
%     nii = make_nii(dumimg,[8 8 8]);
%     nii.img = dumimg; %storing matrix within image structure
%     nii.hdr.hist = maskk.hdr.hist; %copying some information from maskk
%     disp(['saving nifti image - time-window ' num2str(ii)])
%     save_nii(nii,fnamenii); %printing image
% end
% 

%% SOURCE RECONSTRUCTION - PLOTTING DECODING AVERAGED FOR 6 TIME-WINDOWS
% 
clear
encoding_l = 6; %1 = encoding samemel/visualpat; 2 = old/new recognition samemel; 3 = old/new recognition visualpat; 4 = Encoding vs Recognition of samemel; 5 = Encoding vs Recognition of visualpat
%                6 = Old recognition samemel/visualpat; 7 = old/new samemel and visualpat together 


% load(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Decoding/Case_' num2str(encoding_l) '_Beam_abs_1_sens_1_freq_broadband_invers_6/sources_main_effects.mat']);

list = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Decoding/Case_' num2str(encoding_l) '_Beam_abs_0_sens_1_freq_broadband_invers_6/SUBJ*.mat']);
% list(3:end) = [];
t_val_s = zeros(3559,800,length(list));
for ii = 1:length(list)
    load([list(1).folder '/' list(ii).name]);
    t_val_s(:,1:800,ii) = OUT.sources_ERFs(:,1:800);
    disp(ii)
end
BIM = mean(t_val_s,3);

load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/time_normal.mat');
WD = ['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Decoding/Case_' num2str(encoding_l) '_Beam_abs_0_sens_1_freq_broadband_invers_6/TimewWindows']; %path and name of the image to be saved
mkdir(WD);

vect = [0.001 0.350; 0.351 0.700; 0.701 1.050; 1.051 1.400; 1.401 1.750; 1.751 2.200]; %vector with time-windows

% BUM = zeros(3559,size(vect,1));
for ii = 1:size(vect,1) %over time-windows
    [~,idx1] = min(abs(vect(ii,1)-time)); %finding index of time 1 in the time-window
    [~,idx2] = min(abs(vect(ii,2)-time)); %finding index of time 2 in the time-window
    
    BUM = mean(BIM(:,idx1:idx2),2); %average of the activation patterns in source space over the time window ii
    BUM = abs(BUM); %getting absolute values to pinpoint the actual sources of the brain which contributed the most to the decoding.. independently on their sign ambiguity
    BUM = BUM./max(BUM); %normalising activation patterns
    
    %seting to 0 values below mean plus 1 standard deviation
    BUM(BUM<(mean(BUM) + std(BUM))) = 0;
%     BUM(abs(BUM)<(mean(abs(BUM)) + std(abs(BUM)))) = 0;
    

    %preparing nifti images
    %loading mask
    maskk = load_nii('/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External/MNI152_8mm_brain_diy.nii.gz'); %getting the mask for creating the figure
    
    %building nifti image
    fnamenii = [WD '/TimeWin_' num2str(ii) '.nii.gz']; %name
    SS = size(maskk.img);
    dumimg = zeros(SS(1),SS(2),SS(3));
    for iii = 1:size(BUM,1) %over brain sources
        dum = find(maskk.img == iii); %finding index of sources ii in mask image (MNI152_8mm_brain_diy.nii.gz)
        [i1,i2,i3] = ind2sub([SS(1),SS(2),SS(3)],dum); %getting subscript in 3D from index
        dumimg(i1,i2,i3,:) = BUM(iii); %storing values for all time-points in the image matrix
    end
    nii = make_nii(dumimg,[8 8 8]);
    nii.img = dumimg; %storing matrix within image structure
    nii.hdr.hist = maskk.hdr.hist; %copying some information from maskk
    disp(['saving nifti image - time-window ' num2str(ii)])
    save_nii(nii,fnamenii); %printing image
end

%% TRYING TO FIGURE OUT WHY ALL DECODING SOURCES SEEM TO BE NEARLY THE SAME!!

%% DON"T CARE TOO MUCH ABOUT THE FOLLOWING SINCE YOU RAN IT AGAIN PROPERLY WITH NO ABS IN SOURCE RECONSTRUCTION FUNCTION
%%% ABSOLUTE VALUE MIGHT BE DONE JUST AT THE VERY END AFTER THE AVERAGING OVER PARTICIPANTS %%% 

% encoding_l = 2;
% 
% 
% load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/time_normal.mat');
% list = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Decoding/Case_' num2str(encoding_l) '_Beam_abs_1_sens_1_freq_broadband_invers_6/SUBJ*.mat']);
% % list(3:end) = [];
% % t_val_s = zeros(3559,1126,length(list));
% SOU = zeros(3559,300,length(list));
% for iii = 1:length(list)
%     load([list(1).folder '/' list(iii).name]);
%     W = OUT.W;
%     
%     list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_samemel/PD*.mat');
%     load([list_TG(1).folder '/PD_SUBJ' list(iii).name(6:9) '.mat']); %load TG file
%     bom = d.pattern(1:3:end,:);
%     
%     for ii = 1:length(W) %over spatial filters (brain sources)
%         for tt = 1:300%length(time) %over time-points
%             SOU(ii,tt,iii) = W{ii} * bom(:,tt); %actual inversion
%         end
% %         disp(ii)
%     end
%     disp(iii)
% end
% save('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/temp/samemel.mat','SOU');
% SOUMm=mean(SOU,3);
% figure
% imagesc(SOUMm)
% 
% %%
% 
% encoding_l = 3;
% 
% load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/time_normal.mat');
% list = dir(['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Decoding/Case_' num2str(encoding_l) '_Beam_abs_1_sens_1_freq_broadband_invers_6/SUBJ*.mat']);
% % list(3:end) = [];
% % t_val_s = zeros(3559,1126,length(list));
% SOU = zeros(3559,300,length(list));
% for iii = 1:length(list)
%     load([list(1).folder '/' list(iii).name]);
%     W = OUT.W;
%     
%     list_TG = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/decoding_replay_samemel_visualpat/Recognition_visualpat/PD*.mat');
%     load([list_TG(1).folder '/PD_SUBJ' list(iii).name(6:9) '.mat']); %load TG file
%     bom = d.pattern(1:3:end,:);
%     
% %     SOU = zeros(length(W),length(time));
%     for ii = 1:length(W) %over spatial filters (brain sources)
%         for tt = 1:300%length(time) %over time-points
%             SOU(ii,tt) = W{ii} * bom(:,tt); %actual inversion
%         end
% %         disp(ii)
%     end
%     disp(iii)
% end
% save('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/temp/visualpat.mat','SOU');
% SOUMm=mean(abs(SOU),3);
% SOUMm = SOUMm./max(max(abs(SOUMm)));
% figure
% imagesc(SOUMm)
% colorbar
% 
% %%
% 
% ll = 1; %1 = samemel; 2 = visualpat
% 
% if ll == 1
%     load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/temp/samemel.mat')
%     fnamenii = ['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/temp/SM.nii.gz']; %name
% else
%     load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/temp/visualpat.mat')
%     fnamenii = ['/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/temp/VP.nii.gz']; %name
% end
% 
% maskk = load_nii('/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD/External/MNI152_8mm_brain_diy.nii.gz'); %getting the mask for creating the figure
% BUM = mean(mean(SOU(:,114:201,:),3),2);
% BUM = BUM./(max(abs(BUM)));
% %building nifti image
% SS = size(maskk.img);
% dumimg = zeros(SS(1),SS(2),SS(3));
% for iii = 1:size(BUM,1) %over brain sources
%     dum = find(maskk.img == iii); %finding index of sources ii in mask image (MNI152_8mm_brain_diy.nii.gz)
%     [i1,i2,i3] = ind2sub([SS(1),SS(2),SS(3)],dum); %getting subscript in 3D from index
%     dumimg(i1,i2,i3,:) = abs(BUM(iii)); %storing values for all time-points in the image matrix
% end
% nii = make_nii(dumimg,[8 8 8]);
% nii.img = dumimg; %storing matrix within image structure
% nii.hdr.hist = maskk.hdr.hist; %copying some information from maskk
% disp(['saving nifti image - time-window ' num2str(ii)])
% save_nii(nii,fnamenii); %printing image
% 
% %%% MORALE DELLA FACCENDA, BETTER NOT TO DO DECODING WITH ABSOLUTE VALUES..
% %%% CHECK IF THIS IS TRUE ONCE YOU RUN AGAI THE SOURCE RECONSUTRCITON
% %%% WITHOUT ABSOLUTE VALUE FOR CASE = 2 (OLD VS NEW IN AUDITORY MEMORY)
% %%% YOU CAN DO ABSOLUTE VALUE LATER THOUGH, AT THE VERY END TO MAKE RESULTS
% %%% MORE EASILY INTERPRETABLE

%%

%% *** BROADNESS ***

%% LBPD functions

%1) Add LBPD functions
% starting up some of the functions that I wrote for the following analysis
pathl = '/projects/MINDLAB2017_MEG-LearningBach/scripts/Leonardo_FunctionsPhD'; %path to stored functions (THIS MUST BECOME A FOLDER ON YOUR OWN COMPUTER)
addpath(pathl);
LBPD_startup_D(pathl); % add to path LBPD and other OSL functions

%% LOADING AVERAGE OVER SUBJECTS

block = 2; %1 = samemel; 2 = visualpat

%loading data in 3559-voxel space (8mm)
%getting sign of the voxels based on the aggregated source reconstruction (over participants) - AVERAGED TRIALS
if block == 1
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Block_5/Beam_abs_0_sens_1_freq_broadband_invers_1/sources_main_effects.mat');
    timex = 45:52;
else
    load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Block_6/Beam_abs_0_sens_1_freq_broadband_invers_1/sources_main_effects.mat');
    timex = 55:59;
end
%actual computation
%adjusting polarity
vect = zeros(3559,1);
for jj = 1:3559 %over brain voxels
    
    burb = sort(abs(t_val_s(jj,timex(end)+1:526,1)),'descend'); %sorting time-points later on up to 2 seconds
    barb = abs(squeeze(mean(t_val_s(jj,round(mean(timex)),1),2))); %N100 value
    birb = length(find(barb>burb))/length(burb); %percentile of value of N100 compared to the remaining values
    
    if birb < .50 %not reversing the sign if the visual N100 is not prominent for source leakage in the brain voxel jj
        vect(jj,1) = 1;
    else
        if squeeze(mean(t_val_s(jj,timex,1),2)) > 0 %if the data in voxel jj is positive during N100 time
            vect(jj,1) = -1; %storing a vector with 1 and -1 to be used for later statistics
        else
            vect(jj,1) = 1;
        end
    end
end
% vect(:) = 1;
dum = zeros(size(t_val_s,1),size(t_val_s,2),size(t_val_s,3));
for cc = 1:size(dum,3) %over conditions
    for jj = 1:size(t_val_s,1) %over brain voxels
        dum(jj,:,cc) = t_val_s(jj,:,cc) .* vect(jj,1); %reversing (or not)..
        disp(['condition ' num2str(cc) ' - source ' num2str(jj)])
    end
end

% load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Block_3/Beam_abs_0_sens_1_freq_broadband_invers_5/GenEig_AverageOverSubjects.mat');

%% PRINCIPAL COMPONENT ANALYSIS

load('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/time_normal.mat');

S = [];
S.H = dum(:,:,:);
S.permnum = -4;
S.fig_l = 1;
S.sign_eig = '0';
if block == 1
    S.namenii = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/Papers/AudVis_Recog/BROADNESS/SM_';
else
    S.namenii = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/Papers/AudVis_Recog/BROADNESS/VP_';
end
S.time = time(1:1026);
S.rand_l = 1;
S.onefig = 0;

[ OUT ] = PCA_LBPD( S )

wcoeff = OUT.W;

%% TIME SERIES OF SINGLE SUBJECTS USING PCA WEIGHTS ON AVERAGED SUBJECTS DATA (this requires the two sections above to be run first)

wd = '/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/Papers/AudVis_Recog/BROADNESS';
% This is just to have a further confirmation that everything worked fine, but it is not the actual statistical testing
if block == 1
    list = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Block_5/Beam_abs_0_sens_1_freq_broadband_invers_1/SUBJ*.mat');
    name = 'Block_5.mat';
else
    list = dir('/scratch7/MINDLAB2020_MEG-AuditoryPatternRecognition/leonardo/after_maxfilter_v2/Source_LBPD/Block_6/Beam_abs_0_sens_1_freq_broadband_invers_1/SUBJ*.mat');
    name = 'Block_6.mat';
end
J = zeros(size(wcoeff,2),4,length(list),3);

for ii = 1:length(list)
    load([list(ii).folder '/' list(ii).name])
    t_val_s = OUT.sources_ERFs;
    dum = zeros(size(t_val_s,1),size(t_val_s,2),size(t_val_s,3));
    for cc = 1:size(dum,3) %over conditions
        for jj = 1:size(t_val_s,1) %over brain voxels
            dum(jj,:,cc) = t_val_s(jj,:,cc) .* vect(jj,1); %reversing (or not)..
            %            disp(['condition ' num2str(cc) ' - source ' num2str(jj)])
        end
    end
    for iii = 1:3 %over experimental conditions
        J(:,:,ii,iii) = dum(:,1:size(wcoeff,2),iii)' * wcoeff(:,1:4); %matrix multiplication for getting a time series obtained by multiplying, for each time-point, each voxel activation by its corresponding load
    end
    disp(ii)
end
conds = S_struct.inversion.conditions;
save([wd '/' name],'J','conds','time')

%%

%% T-TESTS (OLD VS NEW AND ECONDING OLD VS RECOGNITION OLD)

J = permute(J,[2 1 4 3]);

P = zeros(size(J,1),size(J,2),(size(J,3))-1); %PCs x time-points x contrasts (every NewTX versus Old)
T = zeros(size(J,1),size(J,2),(size(J,3))-1); %PCs x time-points x contrasts (every NewTX versus Old)

%%%%%%%%%%% T-test %%%%%%%%%%% 
for ii = 1:size(J,1) %over principal components
    for jj = 1:size(J,2) %ove time-points
        for cc = 1:(size(J,3)-1) %over experimental conditions
            if cc == 1
                buuum = 1; %condition encoding
            elseif cc == 2
                buuum = 3; %condition new
            end
            %codes t-test
            [~,p,~,stats] = ttest(squeeze(J(ii,jj,2,:)),squeeze(J(ii,jj,buuum,:))); %contrasting cond "old" vs either "encoding" or "new"
            P(ii,jj,cc) = p;
            T(ii,jj,cc) = stats.tstat;
        end
        disp([num2str(ii) ' - ' num2str(jj)])
    end

end

%% CLUSTER-BASED PERMUTATION TEST (CHIARA)

addpath('/projects/MINDLAB2023_MEG-AuditMemDement/scripts/chiaramalvaso/Broadness')

% cluster-based permutation test
comparisons = 2;
if block == 1
    PCs = 3;
else
    PCs = 4;
end
S = [];
S.nperm  = 1000;
S.alpha = 0.05;
S.threshold = 0.001;
S.time = time(1:1025);
S.stattype = 'size';
Permtest_results = cell(PCs,comparisons);
elapsedtime_forcomponent = zeros(PCs,1);
J = permute(J,[2 1 4 3]);
for pp = 1:PCs % iterate the process for each principal component
    S.reference = squeeze(J(pp,:,2,:)); %selecting the current component and condition 1 since we are testing everything against it
    tic;
    for cc = 1:comparisons % iterate the process for each comparisons
        
        if cc == 1
            buuum = 1; %condition encoding
        elseif cc == 2
            buuum = 3; %condition new
        end
        
        disp(['PC: ' num2str(pp) ' comparison: 2 VS ' num2str(buuum)])
        
        S.testing = squeeze(J(pp,:,buuum,:)); % selecting the current component and the current condition
        
        Permtest_results{pp,cc} = clusterbased_permutationtest(S); 
    end
    elapsedtime_forcomponent(pp) = toc;
end
if block == 1
    save([wd '/Block_SM_result03_clusterbased_permutationtest_' (S.stattype)], 'Permtest_results')
else
    save([wd '/Block_VP_result03_clusterbased_permutationtest_' (S.stattype)], 'Permtest_results')
end

%%






