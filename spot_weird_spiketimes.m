clc, clear, close all

%% load data

penetration_No = 2;
configuration_No = 1;

Pconf = sprintf('P%s_conf%s', num2str(penetration_No), num2str(configuration_No));

% fldr = 'C:\NeuralData\Data\Linguine_data_sample\supercat';
fldr = 'D:\glbdmx\concatenated';
fldr1 = sprintf('%s', Pconf);
fldr2 = sprintf('%s_g0', Pconf);
fldr3 = sprintf('%s_g0_imec0', Pconf);
% fldr4 = 'kilosort4';
fldr4 = 'kilosort4_Mya_manual';

% foldername = fullfile(fldr, fldr1, fldr2, fldr3, fldr4);

% foldername = 'Z:\kerry\Ferret_Ephys_2025\Linguine_Concatenated_Kilosorted_Data\glbdmx\concatenated\SPIKES\P2_conf1\Lizzie_manual';
foldername = 'Z:\kerry\Ferret_Ephys_2025\Linguine_Concatenated_Kilosorted_Data\glbdmx\concatenated\P3_conf1\P3_conf1_g0\P3_conf1_g0_imec0\kilosort4_Lizzie_curated';

% choice_bc = 'MUA';
% % choice_bc = 'GOOD';

choice_man = 'mua';
% choice_man = 'good';

% load(fullfile(foldername, ['SPIKES_per_stimulus_bombcell_', choice_bc, '.mat']), 'SPIKES_per_stimulus')
% load(fullfile(foldername, ['SPIKES_parsed_bombcell_', choice_bc, '.mat']), 'SPIKES_parsed')
% load(fullfile(foldername, ['SPIKES_bombcell_', choice_bc, '.mat']), 'SPIKES')

load(fullfile(foldername, ['SPIKES_per_stimulus_manual_', choice_man, '.mat']), 'SPIKES_per_stimulus')
load(fullfile(foldername, ['SPIKES_parsed_manual_', choice_man, '.mat']), 'SPIKES_parsed')
load(fullfile(foldername, ['SPIKES_manual_', choice_man, '.mat']), 'SPIKES')

load(fullfile(foldername,'stimuli.mat'), 'unique_decoded_stim_ID')

%% find long spike latencies

nstim = numel(SPIKES_parsed);

K = [];

for kstim = 1 : nstim
    s = {SPIKES_parsed(kstim).unit_responses.parsed_spiketimes_seconds_re_stimonset};
    K1 = [];
    for kunit = 1 : numel(s)        
        if ~isempty(s{kunit})
            ind = find(s{kunit} > 5);
            if ~isempty(ind)
                K1 = [K1; max(s{kunit}(ind))];
            end
        end        
    end

    if ~isempty(K1)
        K = [K; kstim max(K1)];
    end
end

% uK = unique(K(:, 1))

for k = 1 : size(K, 1)
    if K(k, 1) < nstim
        d(k, 1) = SPIKES_parsed(K(k, 1) + 1).pulse_start_time - SPIKES_parsed(K(k, 1)).pulse_start_time;
    else
        d(k, 1) = 10000000;
    end
end

summary = [K(:, 2) d];

G = K(:, 2) < d;

sum(G == 0) % if 0 then there is no spikes that are attributed to more than one stimulus




