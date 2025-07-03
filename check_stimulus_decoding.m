clc, clear, close all

%%

% stims = readtable('C:\NeuralData\Data\Linguine_data_sample\supercat\P2_conf1\Logs\All_stimuli.txt');
% stims = readtable('C:\NeuralData\Data\Linguine_data_sample\supercat\P2_conf1\Logs\All_stimuli.txt');
stims = readtable('C:\NeuralData\Data\Linguine_data_sample\supercat\P3_conf1\Logs\All_stimuli.txt');
% stims = readtable('D:\glbdmx\individual\Run103_ind\All_stimuli.txt');
% if ~exist("SPIKES_parsed", "var")
    % load('D:\glbdmx\concatenated\SPIKES\P3_conf2\SPIKES_parsed_manual_GOOD.mat')
    % load('Z:\kerry\Ferret_Ephys_2025\Linguine_Concatenated_Kilosorted_Data\glbdmx\concatenated\P2_conf2\kilosort4_Veronica_manual\kilosort4\SPIKES_parsed_manual_good.mat')
    % load('Z:\kerry\Ferret_Ephys_2025\Linguine_Concatenated_Kilosorted_Data\glbdmx\concatenated\SPIKES\P2_conf1\Lizzie_manual\SPIKES_parsed_manual_good.mat')
    load('Z:\kerry\Ferret_Ephys_2025\Linguine_Concatenated_Kilosorted_Data\glbdmx\concatenated\P3_conf1\P3_conf1_g0\P3_conf1_g0_imec0\kilosort4_Lizzie_curated\SPIKES_parsed_manual_good.mat'); SPIKES_parsed(4529:5068) = [];
    % load('D:\glbdmx\concatenated\SPIKES\P2_conf1\SPIKES_parsed_bombcell_GOOD.mat')
    % load('D:\glbdmx\concatenated\SPIKES\P3_conf2\SPIKES_parsed_bombcell_GOOD.mat')
    % load('D:\glbdmx\individual\SPIKES\Run103_ind\SPIKES_parsed_bombcell_GOOD.mat')
% end
stimtype = stims.Var4;
Var5 = stims.Var5;
Var6 = stims.Var6;

if size(stims, 2) > 6
    Var7 = stims.Var7;
end


STRING = cell(numel(stimtype), 1);
identical_strings = nan(numel(stimtype), 1);

pitchtype = {'rand', 'alt', 'CT', 'allHarm', 'SAMtones', 'tone', 'low', 'high', 'F0Mask'};


%%%%% ATTENTION %%%%%%%%%%%%%
% SPIKES_parsed(4529:5068) = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parsed_strings = {SPIKES_parsed.stimID};

for k = 1 : numel(stimtype)

    substr = cell(1);

    if strcmp(stimtype{k}, 'Search')
        substr{1} = 'Search';
        substr{2} = '0Hz';
        substr{3} = [num2str(Var5(k)), 'dB'];
    end

    if strcmp(stimtype{k}, 'FRA')
        substr{1} = 'FRA';
        substr{2} = [num2str(Var5(k)), 'Hz'];
        substr{3} = [num2str(Var7(k)), 'dB'];
    end

    if contains(stimtype{k}, 'bin') % if Pitch Streaming

        S = strsplit(stimtype{k}, '_');
        S2 = strsplit(S{3}, '.');
        substr{1} = 'PitchStreaming';
        substr{2} = S2{1};
        substr{3} = S{1};
        substr{4} = S{2};
    end

    if contains(stimtype{k}, 'TiN') % if Tone In Noise

        substr{1} = 'TiN';
        substr{2} = [num2str(Var5(k)), 'Hz'];
        substr{3} = [num2str(Var7(k)), 'dB'];
    end

    if contains(stimtype{k}, 'Thresholding') % if Thresholding

        substr{1} = 'Thresholding';
        substr{2} = [num2str(Var5(k)), 'Hz'];
        substr{3} = [num2str(Var7(k)), 'dB'];
    end

    if sum(cellfun(@(x) contains(stimtype{k}, x) & ~contains(stimtype{k}, 'bin'), pitchtype)) % if Pitch stimuli

        substr{1} = stimtype{k};
        substr{2} = [num2str(Var5(k)), 'Hz'];
        substr{3} = [num2str(Var6(k)), 'dB'];
    end

    STRING{k, 1} = '';
    for ks = 1 : numel(substr)
        STRING{k, 1} = strcat(STRING{k, 1}, '_', substr{ks});
    end
    STRING{k, 1}(1) = [];
    sa = STRING{k, 1};
    % pause
    identical_strings(k, 1) = strcmp(STRING{k, 1}, parsed_strings{k});
    % si = identical_strings(k, 1)
end

outcome = unique(identical_strings)