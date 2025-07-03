clc, clear, close all



%% choose whether to use manual curation or bomcell output

output_type = 'manual';
% output_type = 'bombcell';

%% choose whether you want GOOD or MUA or NON-SOMA

choice_bc = 'GOOD';
% choice_bc = 'MUA';
% choice_bc = 'NON-SOMA';

% choice_man = 'good';
choice_man = 'mua';

%% load spikes

penetration_No = 3;
configuration_No = 1;

Pconf = sprintf('P%s_conf%s', num2str(penetration_No), num2str(configuration_No));

% fldr = 'C:\NeuralData\Data\Linguine_data_sample\supercat';
% fldr = 'C:\NeuralData\Data\Linguine_data_sample\glbdmx_supercat';
% fldr = 'D:\glbdmx\concatenated';
fldr = 'Z:\kerry\Ferret_Ephys_2025\Linguine_Concatenated_Kilosorted_Data\glbdmx\concatenated';
% fldr = 'D:\glbdmx\individual';
% Pconf = 'Run103_ind';
fldr1 = sprintf('%s', Pconf);
fldr2 = sprintf('%s_g0', Pconf);
fldr3 = sprintf('%s_g0_imec0', Pconf);
% fldr4 = 'kilosort4';
% fldr4 = 'kilosort4_Mya_manual';
% fldr4 = 'kilosort4_Veronica_manual\kilosort4';
% fldr4 = 'kilosort4_Lizzie_manual';
fldr4 = 'kilosort4_Lizzie_curated';

% foldername = 'C:\NeuralData\Data\Quentin_data_for_comparison\catgt_P05-pitch2018_g0\kilosort4';
% foldername = fullfile(fldr, fldr1, fldr2, fldr3, fldr4);
% metafoldername = fullfile(fldr, fldr1, fldr2, fldr3);
% edgefoldername = fullfile(fldr, fldr1, fldr2);

foldername = fullfile(fldr, fldr1, fldr2, fldr3, fldr4);
metafoldername = fullfile(fldr, fldr1, fldr2, fldr3);
edgefoldername = fullfile(fldr, fldr1, fldr2);

spiketimes = readNPY(fullfile(foldername, 'spike_times.npy'));
spikeclusters = readNPY(fullfile(foldername, 'spike_clusters.npy'));


spikelabels = zeros(size(spiketimes));

binfilename = sprintf('%s_g0_tcat.imec0.ap.bin', Pconf);
meta = SGLX_readMeta.ReadMeta(binfilename, metafoldername);

sample_rate = str2double(meta.imSampRate); % in Hz

% a = arrayfun(@(x) strcmp(clusterlabels.group(clusterlabels.cluster_id == x), 'good'), spikeclusters, 'UniformOutput', false);

%% extract pulses

param = cell(1);

param{1} = 'CatGT';
param{end + 1} = sprintf('-dir=%s', fullfile(fldr, fldr1));
param{end + 1} = sprintf('-run=%s', Pconf);
param{end + 1} = '-ob';
param{end + 1} = '-obx=0';
param{end + 1} = '-g=0';
param{end + 1} = '-t=cat';
param{end + 1} = '-bf=1,0,4,1,1,3';

commandline = '';
for s = 1 : numel(param)
    commandline = append(commandline, ' ', param{s});
end

% remove first blank space
commandline(1) = []

% run it
system(commandline);

%% TPrime pulses

param = cell(1);

to_filename = sprintf('%s_g0_tcat.imec0.ap.xd_384_6_500.txt', Pconf);
from_filename = sprintf('%s_g0_tcat.obx0.obx.xd_5_6_500.txt', Pconf);
events_filename_in = sprintf('%s_g0_tcat.obx0.obx.bft_4_1_1.txt', Pconf);
events_filename_out = sprintf('%s_g0_tcat.obx0.obx.bft_4_1_1.ALIGNED.txt', Pconf);

param{1} = 'TPrime';
param{end + 1} = '-syncperiod=1.0';
param{end + 1} = sprintf('-tostream=%s', fullfile(fldr, fldr1, fldr2, fldr3, to_filename));
param{end + 1} = sprintf('-fromstream=1,%s', fullfile(fldr, fldr1, fldr2, from_filename));
param{end + 1} = sprintf('-events=1,%s,%s', fullfile(fldr, fldr1, fldr2, events_filename_in), fullfile(fldr, fldr1, fldr2, events_filename_out));

commandline = '';
for s = 1 : numel(param)
    commandline = append(commandline, ' ', param{s});
end

% remove first blank space
commandline(1) = []

% run it
system(commandline);

%% extract TTL trains

param = cell(1);

param{1} = 'CatGT';
param{end + 1} = sprintf('-dir=%s', fullfile(fldr, fldr1));
param{end + 1} = sprintf('-run=%s', Pconf);
param{end + 1} = '-ob';
param{end + 1} = '-obx=0';
param{end + 1} = '-g=0';
param{end + 1} = '-t=cat';
param{end + 1} = '-bf=1,0,4,10,1,3';

commandline = '';
for s = 1 : numel(param)
    commandline = append(commandline, ' ', param{s});
end

% remove first blank space
commandline(1) = []

% run it
system(commandline);

%% TPrime TTL trains

param = cell(1);

to_filename_TTLcode = sprintf('%s_g0_tcat.imec0.ap.xd_384_6_500.txt', Pconf);
from_filename_TTLcode = sprintf('%s_g0_tcat.obx0.obx.xd_5_6_500.txt', Pconf);
events_filename_in_TTLcode = sprintf('%s_g0_tcat.obx0.obx.bft_4_10_1.txt', Pconf);
events_filename_out_TTLcode = sprintf('%s_g0_tcat.obx0.obx.bft_4_10_1.ALIGNED.txt', Pconf);

param{1} = 'TPrime';
param{end + 1} = '-syncperiod=1.0';
param{end + 1} = sprintf('-tostream=%s', fullfile(fldr, fldr1, fldr2, fldr3, to_filename_TTLcode));
param{end + 1} = sprintf('-fromstream=1,%s', fullfile(fldr, fldr1, fldr2, from_filename_TTLcode));
param{end + 1} = sprintf('-events=1,%s,%s', fullfile(fldr, fldr1, fldr2, events_filename_in_TTLcode), fullfile(fldr, fldr1, fldr2, events_filename_out_TTLcode));

commandline = '';
for s = 1 : numel(param)
    commandline = append(commandline, ' ', param{s});
end

% remove first blank space
commandline(1) = []

% run it
system(commandline);



%% read TPrime'd stim-related pulses
events_filename_out_values = sprintf('%s_g0_tcat.obx0.obx.bfv_4_1_1.txt', Pconf);

pulse_times = readmatrix(fullfile(edgefoldername, events_filename_out));
pulse_values = readmatrix(fullfile(edgefoldername, events_filename_out_values));

pulse_start_times = pulse_times(pulse_values == 1);
pulse_stop_times = pulse_times(pulse_values == 0);

if pulse_stop_times(1) < pulse_start_times(1), pulse_stop_times(1) = []; end


pulse_start_times_correction = zeros(size(pulse_start_times));
pulse_stop_times_correction = zeros(size(pulse_stop_times));

% mend weird issue with P2_conf1

if strcmp(Pconf, 'P2_conf1')
    pulse_start_times_correction(3504 : end) = -0.06;
    pulse_start_times_correction(4299 : end) = -0.15;

    pulse_stop_times_correction(3504 : end) = -0.06;
    pulse_stop_times_correction(4299 : end) = -0.15;
end

pulse_durations = pulse_stop_times - pulse_start_times;

No_of_Pulses = numel(pulse_start_times);


%% read TPrime'd stim-related pulses - NOT ALIGNED - for stim ID decoding
events_filename_out_values = sprintf('%s_g0_tcat.obx0.obx.bfv_4_1_1.txt', Pconf);

pulse_times_na = readmatrix(fullfile(edgefoldername, events_filename_in));

pulse_start_times_na = pulse_times_na(pulse_values == 1);
pulse_stop_times_na = pulse_times_na(pulse_values == 0);

if pulse_stop_times_na(1) < pulse_start_times_na(1), pulse_stop_times_na(1) = []; end


% pulse_start_times_correction = zeros(size(pulse_start_times));
% pulse_stop_times_correction = zeros(size(pulse_stop_times));

% % mend weird issue with P2_conf1
% 
% if strcmp(Pconf, 'P2_conf1')
%     pulse_start_times_correction(3504 : end) = -0.06;
%     pulse_start_times_correction(4299 : end) = -0.15;
% 
%     pulse_stop_times_correction(3504 : end) = -0.06;
%     pulse_stop_times_correction(4299 : end) = -0.15;
% end

pulse_durations_na = pulse_stop_times_na - pulse_start_times_na;

No_of_Pulses = numel(pulse_start_times);


%% read stim type coding TTL trains

binName = sprintf('%s_g0_tcat.obx0.obx.bin', Pconf);
path = fullfile(fldr, fldr1, fldr2);

dw = 1;
dLineList = 10;

TTLtrain = read_pulse_train(binName, path, dw, dLineList);


TTLtrain_times = (1 : numel(TTLtrain)) / 30303;



% %% read TPrime'd stim pulse codes
% 
% pulsecode_times = readmatrix(fullfile(edgefoldername, 'P3_conf2_g0_tcat.obx0.obx.bft_4_10_1.ALIGNED.txt'));
% pulsecode_values = readmatrix(fullfile(edgefoldername, 'P3_conf2_g0_tcat.obx0.obx.bfv_4_10_1.txt'));
% 
% pulsecode_start_times = pulsecode_times(pulsecode_values == 1);
% pulsecode_stop_times = pulsecode_times(pulsecode_values == 0);



%% separate spike streams into PSTHs

ISIs = pulse_start_times(2 : end) - pulse_stop_times(1 : end - 1);
ISIs(end + 1) = 5000;
minISI = min(ISIs);

PSTH_zero = 0.05;  % allow 50 ms before the stimulation

PSTH_starts = pulse_start_times - PSTH_zero; % allow 50 ms before the stimulation
PSTH_ends = pulse_stop_times + minISI - PSTH_zero; % take some time after the stimulus

%% NOT ALIGNED ISIs for stim ID decoding

ISIs_na = pulse_start_times_na(2 : end) - pulse_stop_times_na(1 : end - 1);
ISIs_na(end + 1) = 5000;
minISI_na = min(ISIs_na);

%% parse stim pulse code stream into PSTHs


if ~exist(fullfile(foldername, 'decoded_stim_ID.mat'), 'file')
    load possible_IDs

    BadPulseInd = [];
    for pk = 1 : No_of_Pulses %7005 + (1 : 10) %3500 : 7215 %3500 + (1 : 10)%
        % parsed_TTLtrain{pk} = double(TTLtrain(TTLtrain_times >= pulse_start_times(pk) + pulse_start_times_correction(pk)...
        %     - 0.05 & TTLtrain_times < pulse_stop_times(pk) + pulse_stop_times_correction(pk) + ISIs(pk) - PSTH_zero));

        % parsed_TTLtrain{pk} = double(TTLtrain(TTLtrain_times >= pulse_start_times_na(pk) - 0.05 ...
        %      & TTLtrain_times < pulse_stop_times_na(pk) + ISIs(pk) - PSTH_zero));

        parsed_TTLtrain{pk} = double(TTLtrain(TTLtrain_times >= pulse_start_times_na(pk) - 0.05 ...
             & TTLtrain_times < pulse_stop_times_na(pk) + ISIs_na(pk) - PSTH_zero));
        % if pk == 99
        %     plot(parsed_TTLtrain{pk}), ylim([-1 2])
        %     pause
        % end


        try decoded_stim_ID{pk} = TTLtraindecoder(parsed_TTLtrain{pk}, possible_IDs, [2 6 12]);
            disp([num2str(pk), ' ', decoded_stim_ID{pk}])
        catch
            BadPulseInd = [BadPulseInd; pk];
            decoded_stim_ID{pk} = 'BadPulse';
            disp([num2str(pk), ' ', decoded_stim_ID{pk}])
        end
        % disp([num2str(pk), ' ', decoded_stim_ID{pk}])
        % parsed_pulsecode_start_times{pk} = pulsecode_start_times(pulsecode_start_times >= PSTH_starts(pk) & pulsecode_start_times < PSTH_ends(pk));
        % parsed_pulsecode_stop_times{pk} = pulsecode_stop_times(pulsecode_stop_times >= PSTH_starts(pk) & pulsecode_stop_times < PSTH_ends(pk));
    end

    save(fullfile(foldername, 'decoded_stim_ID.mat'), 'decoded_stim_ID', '-v7.3')
else
    load(fullfile(foldername, 'decoded_stim_ID.mat'), 'decoded_stim_ID')
end

% for pk = 1 : numel(PSTH_starts)
%     % clc
%     parsed_TTLtrain{pk} = TTLtrain(TTLtrain_times >= PSTH_starts(pk) & TTLtrain_times < PSTH_ends(pk));
%     parsed_TTLtrain{pk} = double(parsed_TTLtrain{pk}); 
%     decoded_stim_ID{pk} = TTLtraindecoder(parsed_TTLtrain{pk}, possible_IDs, [2 6 12]);
%     disp([num2str(pk), ' ', decoded_stim_ID{pk}])
% end
%% group same stimulus

u_decoded_stim_ID = unique(decoded_stim_ID);
nos_stim_ID = 1 : numel(u_decoded_stim_ID);

for pk = 1 : No_of_Pulses
    noID(pk) = find(cellfun(@(x) strcmp(decoded_stim_ID{pk}, x), u_decoded_stim_ID));
end


%% parse spikes into individual good units

if exist('SPIKES', 'var')
    clear SPIKES SPIKES_parsed SPIKES_per_stimulus
end

PSTH_binwidth = 0.05;

% get the list of good clusters
if strcmp(output_type, 'manual')
    clusterlabels = readtable(fullfile(foldername, 'cluster_group.tsv'), 'FileType', 'text', 'Delimiter', '\t');
    good_cluster_ids = clusterlabels.cluster_id(strcmp(clusterlabels.group, choice_man));
    savefilename1 = strcat('SPIKES_', 'manual_', choice_man, '.mat');
    savefilename2 = strcat('SPIKES_parsed_', 'manual_', choice_man, '.mat');
    savefilename3 = strcat('SPIKES_per_stimulus_', 'manual_', choice_man, '.mat');
elseif strcmp(output_type, 'bombcell')
    clusterlabels = readtable(fullfile(foldername, 'cluster_bc_unitType.tsv'), 'FileType', 'text', 'Delimiter', '\t');
    good_cluster_ids = clusterlabels.cluster_id(strcmp(clusterlabels.bc_unitType, choice_bc));
    savefilename1 = strcat('SPIKES_', 'bombcell_', choice_bc, '.mat');
    savefilename2 = strcat('SPIKES_parsed_', 'bombcell_', choice_bc, '.mat');
    savefilename3 = strcat('SPIKES_per_stimulus_', 'bombcell_', choice_bc, '.mat');
end

SPIKES = struct;
SPIKES_parsed = struct;
SPIKES_per_stimulus = struct;
% SPIKES_per_stimulus.u_decoded_stim_ID = u_decoded_stim_ID;

for pk = 1 : No_of_Pulses
    ISI = ISIs(pk);
    PSTH_start = pulse_start_times(pk) - PSTH_zero;
    PSTH_end = pulse_stop_times(pk) + ISI - PSTH_zero;
    SPIKES_parsed(pk).noID = noID(pk);
    SPIKES_parsed(pk).stimID = decoded_stim_ID{pk};
    SPIKES_parsed(pk).pulse_start_time = pulse_start_times(pk);
    SPIKES_parsed(pk).pulse_duration = pulse_durations(pk);
    SPIKES_parsed(pk).PSTH_start = PSTH_start;
    SPIKES_parsed(pk).PSTH_end = PSTH_end;
    SPIKES_parsed(pk).PSTH_start_re_stimonset = PSTH_start - SPIKES_parsed(pk).pulse_start_time;
    SPIKES_parsed(pk).PSTH_end_re_stimonset = PSTH_end - SPIKES_parsed(pk).pulse_start_time;
end

for k = 1 : numel(good_cluster_ids)
    SPIKES(k).spiketimes_samples = spiketimes(spikeclusters == good_cluster_ids(k)); % get spike times in samples
    SPIKES(k).spiketimes_seconds = double(spiketimes(spikeclusters == good_cluster_ids(k))) / sample_rate; % get spike times in seconds
    SPIKES(k).cluster_id = good_cluster_ids(k);

    for pk = 1 : No_of_Pulses
        PSTH_start = SPIKES_parsed(pk).PSTH_start;
        PSTH_end = SPIKES_parsed(pk).PSTH_end;
        SPIKES_parsed(pk).unit_responses(k).parsed_spiketimes_seconds = SPIKES(k).spiketimes_seconds(SPIKES(k).spiketimes_seconds >= PSTH_start & SPIKES(k).spiketimes_seconds < PSTH_end);
        % SPIKES_parsed(pk).noID = noID(pk);
        % SPIKES_parsed(pk).stimID = decoded_stim_ID{pk};
        % SPIKES_parsed(pk).pulse_start_time = pulse_start_times(pk);
        % SPIKES_parsed(pk).pulse_duration = pulse_durations(pk);
        SPIKES_parsed(pk).unit_responses(k).parsed_spiketimes_seconds_re_stimonset = SPIKES_parsed(pk).unit_responses(k).parsed_spiketimes_seconds - SPIKES_parsed(pk).pulse_start_time;
        % SPIKES_parsed(pk).PSTH_start = PSTH_start;
        % SPIKES_parsed(pk).PSTH_end = PSTH_end;
        % SPIKES_parsed(pk).PSTH_start_re_stimonset = PSTH_start - SPIKES_parsed(k).unit_responses(pk).pulse_start_time;
        % SPIKES_parsed(pk).PSTH_end_re_stimonset = PSTH_end - SPIKES_parsed(k).unit_responses(pk).pulse_start_time;
    end


    % regroup spikes to compose PSTH
    for kID = 1 : numel(u_decoded_stim_ID)

        ind = find(noID == kID);
        % pause

        SPIKES_per_stimulus(kID).stimID = u_decoded_stim_ID{kID};
        SPIKES_per_stimulus(kID).noID = kID;

        no_iterations = numel(ind);
        SPIKES_per_stimulus(kID).no_iterations = numel(ind);

        pulse_duration = SPIKES_parsed(ind(1)).pulse_duration;
        SPIKES_per_stimulus(kID).pulse_duration = pulse_duration;

        spiketimes_seconds = [];
        spiketimes_seconds_re_stimonset = [];
        PSTH_start_re_stimonset = [];
        PSTH_end_re_stimonset = [];
        iteration = [];

        for k_ind = 1 : numel(ind)
            spiketimes_seconds_re_stimonset = cat(1, spiketimes_seconds_re_stimonset, SPIKES_parsed(ind(k_ind)).unit_responses(k).parsed_spiketimes_seconds_re_stimonset);
            spiketimes_seconds = cat(1, spiketimes_seconds, SPIKES_parsed(ind(k_ind)).unit_responses(k).parsed_spiketimes_seconds);
            PSTH_start_re_stimonset = cat(1, PSTH_start_re_stimonset, SPIKES_parsed(ind(k_ind)).PSTH_start_re_stimonset);
            PSTH_end_re_stimonset = cat(1, PSTH_end_re_stimonset, SPIKES_parsed(ind(k_ind)).PSTH_end_re_stimonset);
            iteration = cat(1, iteration, k_ind * ones(size(SPIKES_parsed(ind(k_ind)).unit_responses(k).parsed_spiketimes_seconds)));
        end

        PSTH_bins = -PSTH_zero : PSTH_binwidth : min(PSTH_end_re_stimonset);

        SPIKES_per_stimulus(kID).PSTH_start_re_stimonset = PSTH_start_re_stimonset;
        SPIKES_per_stimulus(kID).PSTH_end_re_stimonset = PSTH_end_re_stimonset;
        SPIKES_per_stimulus(kID).PSTH_bins = PSTH_bins;

        SPIKES_per_stimulus(kID).spikes_per_stimulus(k).spiketimes_seconds = spiketimes_seconds;
        SPIKES_per_stimulus(kID).spikes_per_stimulus(k).spiketimes_seconds_re_stimonset = spiketimes_seconds_re_stimonset;
        SPIKES_per_stimulus(kID).spikes_per_stimulus(k).iteration = iteration;

        

        PSTH = arrayfun(@(x, y) sum(spiketimes_seconds_re_stimonset > x & spiketimes_seconds_re_stimonset <= y), PSTH_bins(1 : end - 1), PSTH_bins(2 : end)) / no_iterations / PSTH_binwidth; % in sp/s

        SPIKES_per_stimulus(kID).spikes_per_stimulus(k).PSTH = PSTH;

        % SPIKES(k).parsed_responses(pk).noID = noID(pk);
    end

end

% SPIKES_folder = fullfile(fldr, 'SPIKES', fldr1);
SPIKES_folder = fullfile(fldr, 'SPIKES', fldr1, 'Lizzie_manual');

if ~exist(SPIKES_folder, 'dir')
    mkdir(SPIKES_folder)
end

save(fullfile(SPIKES_folder, savefilename1), 'SPIKES', '-v7.3')
save(fullfile(foldername, savefilename1), 'SPIKES', '-v7.3')

save(fullfile(SPIKES_folder, savefilename2), 'SPIKES_parsed', '-v7.3')
save(fullfile(foldername, savefilename2), 'SPIKES_parsed', '-v7.3')

save(fullfile(SPIKES_folder, savefilename3), 'SPIKES_per_stimulus', '-v7.3')
save(fullfile(foldername, savefilename3), 'SPIKES_per_stimulus', '-v7.3')

unique_decoded_stim_ID = u_decoded_stim_ID';

save(fullfile(SPIKES_folder, 'stimuli'), 'unique_decoded_stim_ID', '-v7.3')
save(fullfile(foldername, 'stimuli'), 'unique_decoded_stim_ID', '-v7.3')

%% plot PSTH

% stims_to_plot = {'Search_0Hz_40dB', 'Search_0Hz_60dB' , 'Search_0Hz_80dB'};
% wildcard = 'Search';
wildcard = 'PitchStreaming';
% wildcard = 'Thresholding';
% wildcard = 'FRA';
stims_to_plot = u_decoded_stim_ID(cellfun(@(x) contains(x, wildcard), u_decoded_stim_ID));
% units_to_plot = [1 3 6 8];
units_to_plot = [3];

layout = tiledlayout(numel(units_to_plot), numel(stims_to_plot));

for k_unit = 1 : numel(units_to_plot)
    for k_stim = 1 : numel(stims_to_plot)
        kID = find(cellfun(@(x) strcmp(stims_to_plot{k_stim}, x), u_decoded_stim_ID));
        PSTH = SPIKES_per_stimulus(kID).spikes_per_stimulus(units_to_plot(k_unit)).PSTH;
        PSTH(end + 1) = 0;
        PSTH_bins = SPIKES_per_stimulus(kID).PSTH_bins;
        nexttile
        stairs(PSTH_bins, PSTH)
        xlim([PSTH_bins(1) - 0.1 PSTH_bins(end) + 0.1])
        % ylim([0 max(PSTH) + 0.1])
        ylim([0 15])
        hold on
        plot([0 0], gca().YLim, 'r')
        plot([1 1] * SPIKES_per_stimulus(kID).pulse_duration, gca().YLim, 'r')

        if k_unit == 1
            title(stims_to_plot{k_stim}, 'Interpreter', 'None')
        end

    end
end

%% raster plots

% stims_to_plot = {'Search_0Hz_40dB', 'Search_0Hz_60dB' , 'Search_0Hz_80dB'};
% wildcard = 'Search';
wildcard = 'PitchStreaming';
% wildcard = 'Thresholding';
% wildcard = 'F0MaskHigh';
% wildcard = 'FRA';
stims_to_plot = u_decoded_stim_ID(cellfun(@(x) contains(x, wildcard), u_decoded_stim_ID));
% units_to_plot = [1 3 6 8];
units_to_plot = [3];

figure
layout2 = tiledlayout(numel(units_to_plot), numel(stims_to_plot));

for k_stim = 1 : numel(stims_to_plot)
    for k_unit = 1 : numel(units_to_plot)
        kID = find(cellfun(@(x) strcmp(stims_to_plot{k_stim}, x), u_decoded_stim_ID));
        spike_times = SPIKES_per_stimulus(kID).spikes_per_stimulus(units_to_plot(k_unit)).spiketimes_seconds_re_stimonset;
        iteration = SPIKES_per_stimulus(kID).spikes_per_stimulus(units_to_plot(k_unit)).iteration;
        PSTH_bins = SPIKES_per_stimulus(kID).PSTH_bins;
        maxiter = SPIKES_per_stimulus(kID).no_iterations;
        nexttile
        plot(spike_times, iteration, 'k.')
        xlim([PSTH_bins(1) - 0.1 PSTH_bins(end) + 0.1])
        % ylim([0 max(PSTH) + 0.1])
        ylim([0 maxiter + 1])
        hold on
        plot([0 0], gca().YLim, 'r')
        plot([1 1] * SPIKES_per_stimulus(kID).pulse_duration, gca().YLim, 'r')

        if k_unit == 1
            title(stims_to_plot{k_stim}, 'Interpreter', 'None')
        end

    end
end










% %%
% 
% rootdir = 'C:\NeuralData\Data\Linguine_data_sample\supercat\P3_conf2\';
% filelist = dir(fullfile(rootdir, '**\*.*'));  %get list of files and folders in any subfolder
% 
% 
% % filelist = filelist([filelist.isdir]);  %remove non-folders from list
% for k = 1 : numel(filelist)
%     if contains(filelist(k).name, 'Run120')
%         newname = filelist(k).name;
%         newname = strcat('P3_conf2_', s(strfind(newname, 'g0') : end));
%         movefile(fullfile(rootdir, filelist(k).name), fullfile(rootdir, newname))
%     end
% end




