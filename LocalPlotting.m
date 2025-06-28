%%

%% PLOTTING WAVEFORM OF (SIGN ADJUSTED) MAGNETOMETERS BASED ON THE MAIN ACTIVATION PATTERNS

encoding_l = 7; %1 = encoding samemel/visualpat; 2 = old/new recognition samemel; 3 = old/new recognition visualpat; 4 = Encoding vs Recognition of samemel; 5 = Encoding vs Recognition of visualpat
%                6 = Old recognition samemel/visualpat; 7 = old/new samemel and visualpat together 


load('/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/BOMBA.mat')
color_line = colormap(lines(5)); %extracting some colours from a colormap
color_line2 = color_line;
% color_line2(1,:) = color_line(2,:);
% color_line2(2,:) = color_line(1,:);
% color_line2(5,:) = [0.4 0.4 0.4];
color_line2(1,:) = [0.75, 0.1, 0.2];
color_line2(2,:) = [0.1, 0.3, 0.7];
color_line2(3,:) = [0 0 0];

if encoding_l == 1
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_6Mag_SignAdj.mat'])
    vismag = mag_adj;
    avg = BOMBA{encoding_l};
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    %auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3))));
    figure
    plot(time_sel(1:size(audmag,2)),ananmean,'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Enc Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(1,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    %visual
    ananmean = squeeze(nanmean(nanmean(vismag(idx,:,:,1),3),1));
    stdey = squeeze((nanstd(nanstd(vismag(idx,:,:,1),0,3),0,1)./sqrt(size(vismag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Vis Enc Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(2,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Encoding Old Auditory vs Visual')
    exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Amended/Wave_Enc_AudVis.pdf'],'Resolution',300)
elseif encoding_l == 2
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    avg = BOMBA{encoding_l};
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %old auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(audmag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Rec Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(1,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    %new auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,3),0,3),0,1)./sqrt(size(audmag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Aud Rec New')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(2,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Recognition Old vs New Auditory')
    exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Amended/Wave_RecAud_OldNew.pdf'],'Resolution',300)
elseif encoding_l == 3
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_6Mag_SignAdj.mat'])
    audmag = mag_adj; %this is actually the visual block, for lazyness I have not changed it since it does not really matter..
    avg = BOMBA{encoding_l};
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %old auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(audmag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Vis Rec Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(1,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    %new auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,3),0,3),0,1)./sqrt(size(audmag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Vis Rec New')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(2,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Recognition Old vs New Visual')
    exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Amended/Wave_RecVis_OldNew.pdf'],'Resolution',300)
elseif encoding_l == 4
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    avg = BOMBA{encoding_l};
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %old auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Enc Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(1,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    %new auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(audmag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Aud Rec Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(2,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Encoding vs Recognition Auditory')
    exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Amended/Wave_Aud_EncRec.pdf'],'Resolution',300)
elseif encoding_l == 5
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_6Mag_SignAdj.mat'])
    audmag = mag_adj; %this is actually the visual block, for lazyness I have not changed it since it does not really matter..
    avg = BOMBA{encoding_l};
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    figure
    %old auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,1),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,1),0,3),0,1)./sqrt(size(audmag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Vis Enc Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(1,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    %new auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(audmag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Vis Rec Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(2,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Encoding vs Recognition Visual')
    exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Amended/Wave_Vis_EncRec.pdf'],'Resolution',300)
elseif encoding_l == 6
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_6Mag_SignAdj.mat'])
    vismag = mag_adj;
    avg = BOMBA{encoding_l};
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    %auditory
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(audmag,3))));
    figure
    plot(time_sel(1:size(audmag,2)),ananmean,'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Rec Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(1,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    %visual
    ananmean = squeeze(nanmean(nanmean(vismag(idx,:,:,2),3),1));
    stdey = squeeze((nanstd(nanstd(vismag(idx,:,:,2),0,3),0,1)./sqrt(size(vismag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Vis Rec Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(2,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Recognition Old Auditory vs Recognition Old Visual')
    exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Amended/Wave_Rec_AudVis.pdf'],'Resolution',300)
elseif encoding_l == 7
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_5Mag_SignAdj.mat'])
    audmag = mag_adj;
    load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_6Mag_SignAdj.mat'])
    vismag = mag_adj;
    avg = BOMBA{encoding_l};
    avg2 = mean(avg(:,26:576),2); %taking activation patterns of the time between beginning of sequence (26) to the averge resposne time of the participants (576)
    idx = find(abs(avg2)>(mean(abs(avg2))+std(abs(avg2))));
    %new set of colors for light and dark red and blue
    color_line2 = [
        0.9, 0.5, 0.5;  % Slightly darker Light Red
        0.5, 0.1, 0.1;  % Mid Dark Red
        0.5, 0.7, 0.9;  % Slightly darker Light Blue
        0.1, 0.2, 0.5;  % Mid Dark Blue
        ];
    %auditory old
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,2),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,2),0,3),0,1)./sqrt(size(audmag,3))));
    figure
    plot(time_sel(1:size(audmag,2)),ananmean,'Color',color_line2(1,:),'LineWidth',2,'DisplayName','Aud Rec Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(1,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    %auditory new
    ananmean = squeeze(nanmean(nanmean(audmag(idx,:,:,3),3),1));
    stdey = squeeze((nanstd(nanstd(audmag(idx,:,:,3),0,3),0,1)./sqrt(size(audmag,3))));
    plot(time_sel(1:size(audmag,2)),ananmean,'Color',color_line2(2,:),'LineWidth',2,'DisplayName','Aud Rec New')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(2,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    %visual old
    ananmean = squeeze(nanmean(nanmean(vismag(idx,:,:,2),3),1));
    stdey = squeeze((nanstd(nanstd(vismag(idx,:,:,2),0,3),0,1)./sqrt(size(vismag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(3,:),'LineWidth',2,'DisplayName','Vis Rec Old')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(3,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    %visual new
    ananmean = squeeze(nanmean(nanmean(vismag(idx,:,:,3),3),1));
    stdey = squeeze((nanstd(nanstd(vismag(idx,:,:,3),0,3),0,1)./sqrt(size(vismag,3))));
    plot(time_sel(1:size(vismag,2)),ananmean,'Color',color_line2(4,:),'LineWidth',2,'DisplayName','Vis Rec New')
    hold on
    fill([time_sel fliplr(time_sel)],[ananmean + stdey fliplr(ananmean - stdey)],color_line2(4,:), 'FaceAlpha', 0.3,'linestyle','none');
    hold on
    grid minor
    legend('show')
    xlim([-0.1 3.4])
    %     ylim(limmy)
    set(gcf,'color','w')
    title('Recognition Old Aud-Vis vs Recognition New Aud-Vis')
    exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Amended/Wave_Rec_AudVis_OldNew.pdf'],'Resolution',300)
end

%%

%% BROADNESS - TIME SERIES

block = 1; % 1 = auditory; 2 = visual
export_l = 1; %1 = export images; 0 = not


addpath('/Users/au550322/Documents/AarhusUniversitet/SEMPRE_TempSeqAges2021/Papers/Paper_Elderly_Bach_MEG/Manuscript/CommunicationsBiology/FirstRevision/Codes')
% loading data
if block == 1
    load('/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/BROADNESS/Block_5.mat');
    load('/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/BROADNESS/Block_SM_result03_clusterbased_permutationtest_size.mat');
    bimba = {1:83};
    ylimm = [-2000 1000]; %amplitude limits; leave empty [] for automatic adjustment
else
    load('/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/BROADNESS/Block_6.mat');
    load('/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/BROADNESS/Block_VP_result03_clusterbased_permutationtest_size.mat');
    bimba = {1:82};
    ylimm = [-1000 1000]; %amplitude limits; leave empty [] for automatic adjustment
end
load(['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/Block_5Mag_SignAdj.mat'],'time_sel')


% load('C:\Users\malva\OneDrive\Desktop\APPLIED_PHYSICS\Tesi\PCA\Broadness\Figure2\result02_fdr.mat');
% load('C:\Users\malva\OneDrive\Desktop\APPLIED_PHYSICS\Tesi\PCA\Broadness\Figure2\timeserie_PCAonmaineffect.mat');
% load('C:\Users\malva\OneDrive\Desktop\APPLIED_PHYSICS\Tesi\PCA\TempChiara\TempChiara/time.mat'); %loading time

col_l = 1 ; %1 for significant time-windows with different colors; 0 = only grey color

PCs = 2;  % Number of principal components you want to plot

% cnt = 0;
data = permute(J,[2 1 3 4]); 
close all
for cc = 1:size(Permtest_results,1) %over principal components
    lineplotdum = [20 1]; %number instructing where to place the lines showing significant time-windows; leave empty [] if you want to have shaded colors instead
    lineplot = lineplotdum; 
    S = [];
    S.sbrim = 0.15;
    S.ii = cc;
    S.conds = {'Enc ', 'Old', 'NewT1'};
    S.data = data(cc,:,:,:);
    S.STE = 2; %1 = dot lines for standard error; 2 = shadows
    S.transp = 0.3; %transparency for standard errors shadow
    S.time_real = time_sel(1:1025);
%     S.colorline = [1 0 0; 0.3686 0.6314 0.7412; 0.1882 0.4902 0.8118; 0.0784 0.1569 0.5255; 0 0 0];     
    S.colorline = [0.1, 0.3, 0.7; 0.75, 0.1, 0.2; 0.85, 0.45, 0.0; 0 0 0; 0.3686 0.6314 0.7412; 0.1882 0.4902 0.8118; 0.0784 0.1569 0.5255; 0 0 0];     
    
    if export_l == 1
        S.legendl = 0;
    else
        S.legendl = 1;
    end
    S.x_lim = [-0.1 3.4]; % Set x limits
    S.y_lim = ylimm; %Set y limits
    S.ROI_n = 1;
    S.condition_n = 1:3;
    S.ROIs_labels = {'PC'}; 
    S.lineplot = lineplot;
    bum = [];
    %%%SIGNIFICATIVITA%%%
    signtp_col = [];
    for ss = 1:size(Permtest_results,2) %over contrasts between conditions
        sbam = size(Permtest_results{cc,ss},2);
        clear signtp_temp;
        for ll = 1:sbam %over the number of the significant time-windows for contrast ss
            bum = cat(2,bum,{Permtest_results{cc,ss}(ll).time}); %concatenating all significant time-windows, for one contrast at a time
            
            if ss == 1
                signtp_temp(ll) = 1; %getting the color code (number of the significant time-windows for each contrast)
            elseif ss == 2
                signtp_temp(ll) = 3; %getting the color code (number of the significant time-windows for each contrast)
            end
        end
        signtp_col = cat(2, signtp_col, signtp_temp);
    end
    S.signtp = bum;
    if col_l == 1
        S.signtp_col = signtp_col;
        S.colorsign = S.colorline;
    else
        S.signtp_col = [];
        S.colorsign = {'*';'+'};
    end
    
    S.groups = {1}; % this is one bc you subjects are not divided in groups, set this to 1 and don't ever touch it 
    S.gsubj = bimba; %same as above, this contains the indices of subjects and they range from 0 to 83 since your subjects are not divided in groups
    waveplot_groups_local_v2(S) %actual function
    
    if export_l == 1
        if block == 1
            exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Figure_5/Block_Aud_BrainNetwork_' num2str(cc) '.pdf'],'Resolution',300)
        else
            exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Figure_5/Block_Vis_BrainNetwork_' num2str(cc) '.pdf'],'Resolution',300)
        end
    end
    %end
    hold on;
end

%%

%% PLOTTING VARIANCE AUDITORY AND VISUAL BLOCKS - BROADNESS

VAR = 1:30; % PCs whose variance to be plotted
% block = 1; % 1 = auditory; 2 = visual

% if block == 1
    load('/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/BROADNESS/VARRAUD.mat');
    vare = VARRAUD;
% else
% end
%actual plotting

figure
plot(vare(VAR),'Color',[0.75, 0.1, 0.2],'DisplayName','Aud')
hold on
plot(vare(VAR),'*','Color',[0.75, 0.1, 0.2],'MarkerSize',7,'HandleVisibility','Off')
hold on
load('/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/11Apr2025/BROADNESS/VARRVIS.mat');
vare = VARRVIS;
plot(vare(VAR),'Color',[0.1, 0.3, 0.7],'DisplayName','Vis')
hold on
plot(vare(VAR),'*','Color',[0.1, 0.3, 0.7],'MarkerSize',7,'HandleVisibility','Off')
grid minor
legend('show')
set(gcf,'color','w')
title('variance (eigenvalues) of PCs')
exportgraphics(gcf,['/Users/au550322/Documents/AarhusUniversitet/Postdoc/DataCollection_AuditoryPatternRecognition2020/Papers/Encoding_Recognition_Auditory_Visual/Figures_Elements/Figure_5/VarianceExplained_AudVis.pdf'],'Resolution',300)

%%

%%
