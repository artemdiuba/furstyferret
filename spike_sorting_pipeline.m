clc, clear, close all

% This is a spike sorting pipeline after the recording with Neuropixels 2.0,
% OneBox and SpikeGLX. It assumes that one of the analogue OneBox aux channels
% carries pulses corresponding to the length of the sound stimulation and
% that another aux channel contains "barcodes" for every stimulus.
% Recording is assumed to  consist of several Runs. Every Run is attributed
% to one penetration and configuration.
% Penetration is one entry point of the probe.
% Configuration is an arrangement of the recording sites defined in the
% SpikeGLX during recording.
% Runs performed from the same penetration and with the same configuration
% may be concatenated to increase the quality of the Kilosort4 output.
% This pipeline consists of:
% - common average referencing (glbcar or glbdmx), time alignment and high
% pass or band pass filtering of the row neural data;
% - concatenating, if any, of the runs prepared on the previous step
% - preparing the probe file describing the recording site arrangements. It
% is needed for Kilosort4
% - running the Kilosort4
% - running the Bombcell on the kilosort output
% - parsing the spike times into individual units and stimulus types
% - number of sanity checks


%% CatGT: apply common average referencing and tshift

penetration_No = 1;
configuration_No = 2;

Pconf = sprintf('P%s_conf%s', num2str(penetration_No), num2str(configuration_No));

% run_Nos variable contains the number of runs to be concatenated for this
% penetration/configuration.

% run_Nos = 45; %P1_conf1
run_Nos = [45 46 48 49]; %P1_conf2
% run_Nos = [46 48 49]; %P1_conf2 without 45_g1
% run_Nos = [51 52 53 56 58]; %P1_conf3
% run_Nos = [60 61 62 63 74 75 76 77 78 80 81 86 87 89 90 91]; %P2_conf1
% run_Nos = [99 100 101 103 104]; %P2_conf2
% run_Nos = [105]; %P2_conf3
% run_Nos = [106 107]; %P2_conf4
% run_Nos = [106 107]; %P2_conf4
% run_Nos = [112 113 114 115 116 117 118]; %P3_conf1
% run_Nos = [120 121 122 123 125 126 127 133]; %P3_conf2

% dirsource is where the raw data are
dirsource = 'Y:\kerry\Ferret_Ephys_2025\Neural_Data\SpikeGLX\Linguine_03_04_MAR2025';

% dirdest is where the CAR'd & filtered data will go
dirdest = fullfile('D:\glbdmx\', sprintf('%s_glbdmx', Pconf));

if ~exist(dirdest, 'dir')
    mkdir(dirdest)
end


% below is the 
k = 0;
for rN = run_Nos
    k = k + 1;
    commandline_imec = ''; commandline_obx = '';
    % param_imec{1} = 'C:\NeuralData\Software\CatGT\CatGT-win\runit.bat';
    param_imec{1} = 'CatGT';
    param_imec{2} = ['-dir=', dirsource];
    param_imec{3} = ['-run=Run', num2str(rN)];
    param_imec{4} = '-prb_fld';
    param_imec{5} = '-ap';
    param_imec{6} = '-prb=0';
    param_imec{7} = '-g=0';
    if rN == 45 && penetration_No == 1 && configuration_No == 2, param_imec{7} = '-g=1'; end %if k == numel(run_Nos), param_imec{7} = '-g=1'; end; % 
    param_imec{8} = '-t=0';
    % param_imec{9} = '-gblcar';
    param_imec{9} = '-gbldmx';
    % param_imec{10} = '-apfilter=butter,12,300,0';
    param_imec{10} = '-apfilter=butter,12,300,9000';
    param_imec{11} = ['-dest=', dirdest];
    param_imec{12} = '-out_prb_fld';

    % param_obx{1} = 'C:\NeuralData\Software\CatGT\CatGT-win\runit.bat';
    param_obx{1} = 'CatGT';
    param_obx{2} = ['-dir=', dirsource];
    param_obx{3} = ['-run=Run', num2str(rN)];
    param_obx{4} = '-prb_fld';
    param_obx{5} = '-ob';
    param_obx{6} = '-obx=0';
    param_obx{7} = '-g=0';
    if rN == 45 && penetration_No == 1 && configuration_No == 2, param_obx{7} = '-g=1'; end %if k == numel(run_Nos), param_obx{7} = '-g=1'; end; % if rN == 45, param_obx{7} = '-g=1'; end
    param_obx{8} = '-t=0';
    % param_obx{9} = '-gblcar';
    param_obx{9} = '-gbldmx';
    param_obx{10} = ['-dest=', dirdest];

    for s = 1 : numel(param_imec)
        commandline_imec = append(commandline_imec, ' ', param_imec{s});
    end

    for s = 1 : numel(param_obx)
        commandline_obx = append(commandline_obx, ' ', param_obx{s});
    end

    % remove first blank space
    commandline_imec(1) = []
    commandline_obx(1) = []

    % run CatGT
    system(commandline_imec);
    system(commandline_obx);

    % if obx files with 'tcat' were not created, make them
    runfolder = strcat('Run', num2str(rN), '_g0');
    runfolder_catgt = strcat('catgt_Run', num2str(rN), '_g0');

    obxbinfile_t0 = strcat('Run', num2str(rN), '_g0_t0.obx0.obx.bin');
    obxbinfile_t0_fullfile = fullfile(dirsource, runfolder, obxbinfile_t0);
    obxbinfile_tcat = strcat('Run', num2str(rN), '_g0_tcat.obx0.obx.bin');
    obxbinfile_tcat_fullfile = fullfile(dirdest, runfolder_catgt, obxbinfile_tcat);

    obxmetafile_t0 = strcat('Run', num2str(rN), '_g0_t0.obx0.obx.bin');
    obxmetafile_t0_fullfile = fullfile(dirsource, runfolder, obxbinfile_t0);
    obxmetafile_tcat = strcat('Run', num2str(rN), '_g0_tcat.obx0.obx.bin');
    obxmetafile_tcat_fullfile = fullfile(dirdest, runfolder_catgt, obxbinfile_tcat);

    if ~isfile(obxbinfile_tcat_fullfile)
        copyfile(obxbinfile_t0_fullfile, obxbinfile_tcat_fullfile)
    end

    if ~isfile(obxmetafile_tcat_fullfile)
        copyfile(obxmetafile_t0_fullfile, obxmetafile_tcat_fullfile)
    end
end


%% CatGT: concatenate runs

% penetration_No = 2;
% configuration_No = 3;

% Pconf = sprintf('P%s_conf%s', num2str(penetration_No), num2str(configuration_No));

% dirdest = 'D:\glbdmx\P2_conf3_glbdmx';

% run_Nos = [45 46 48 49]; %P1_conf2

Pconf = 'Run103_ind';
run_Nos = 103;
dirdest = 'D:\glbdmx\P2_conf2_glbdmx\';

% run_Nos = [112 113 114 115 116 117 118]; %P3_conf1
% run_Nos = [120 121 122 123 125 126 127 133]; %P3_conf2
% run_Nos = [106 107]; %P2_conf4
% run_Nos = [105]; %P2_conf3

runs_string = strrep(num2str(run_Nos), '  ', '_');
% concatenated_folder = strcat(parent_path, filesep, 'Linguine_data_concatenated_Runs_', runs_string);

% concatenated_folder = strcat('C:\NeuralData\Data\Linguine_data_sample\supercat\P',...
%     num2str(penetration_No), '_conf',...
%     num2str(configuration_No));

% concatenated_folder = strcat('D:\glbdmx\concatenated\P',...
%     num2str(penetration_No), '_conf',...
%     num2str(configuration_No));

% concatenated_folder = strcat('D:\glbdmx\concatenated\', Pconf);
concatenated_folder = strcat('D:\glbdmx\individual\', Pconf);

if ~exist(concatenated_folder, 'dir')
    mkdir(concatenated_folder)
end

if numel(run_Nos) > 1

supercat_param = [];

% supercat_param{1} = 'C:\NeuralData\Software\CatGT\CatGT-win\runit.bat';
supercat_param{1} = 'CatGT';
supercat_param{2} = '-supercat=';

commandline_supercat = '';
for s = 1 : numel(supercat_param)
    commandline_supercat = append(commandline_supercat, ' ', supercat_param{s});
end

supercat_folders = cell(1, numel(run_Nos));

for k = 1 : numel(run_Nos)
    supercat_folders{k} = ['{', dirdest, ',catgt_Run', num2str(run_Nos(k)),'_g0','}'];
     % if k == numel(run_Nos)
     %     supercat_folders{k} = ['{', dirdest, ',catgt_Run', num2str(run_Nos(k)),'_g1','}'];
     % end
end

for s = 1 : numel(supercat_folders)
    commandline_supercat = append(commandline_supercat, supercat_folders{s});
end

supercat_param{end + 1} = '-prb_fld';
supercat_param{end + 1} = '-ap';
supercat_param{end + 1} = '-ob';
supercat_param{end + 1} = '-prb=0';
supercat_param{end + 1} = '-obx=0';
supercat_param{end + 1} = strcat('-dest=',concatenated_folder);
supercat_param{end + 1} = '-supercat_trim_edges';
supercat_param{end + 1} = '-pass1_force_ni_ob_bin';
supercat_param{end + 1} = '-out_prb_fld';

for s = 3 : numel(supercat_param)
    commandline_supercat = append(commandline_supercat, ' ', supercat_param{s});
end

commandline_supercat(1) = []

% run CatGT
system(commandline_supercat);

% system('C:\NeuralData\Software\CatGT\CatGT-win\runit.bat -dir=C:\NeuralData\Data\Linguine_data_sample_duplicate -run=Run81 -prb_fld -ap -prb=0 -g=0 -t=0 -gblcar', '-echo')

else
    copyfile(fullfile(dirdest, ['catgt_Run', num2str(run_Nos),'_g0']),...
        fullfile(concatenated_folder, [Pconf, '_g0']))
end

%% rename the files and folders

% concatenated_folder = 'D:\glbdmx\concatenated\test_P2_conf3';

list = dir([concatenated_folder,'\**\*.*']);
list = list(end : -1 : 1); % order starting from the deepest level

firstrun = ['Run', num2str(run_Nos(1))];

for k = 1 : numel(list)
    if contains(list(k).name, firstrun)
        old = firstrun;
        new = Pconf;
        newname = strrep(list(k).name, old, new);
        oldfullfile = fullfile(list(k).folder, list(k).name)
        newfullfile = fullfile(list(k).folder, newname)
        % pause
        movefile(fullfile(list(k).folder, list(k).name), fullfile(list(k).folder, newname))
    end

    if contains(list(k).name, 'supercat_')
        newname = sprintf('%s_g0', Pconf);
        oldfullfile = fullfile(list(k).folder, list(k).name)
        newfullfile = fullfile(list(k).folder, newname)
        % pause
        movefile(fullfile(list(k).folder, list(k).name), fullfile(list(k).folder, newname))
    end

end

%% Make probe file
d = dir(concatenated_folder);
d(1:2) = [];

dirFlags = [d.isdir];
if sum(dirFlags) > 1
    error('There''s more than 1 run folder')
end

runfolder = d(dirFlags).name;


d2 = dir(fullfile(concatenated_folder, runfolder));
d2(1:2) = [];

dirFlags2 = [d2.isdir];
if sum(dirFlags2) > 1
    error('There''s more than 1 probe folder')
end

probefolder = d2(dirFlags2).name;

d3 = dir(fullfile(concatenated_folder, runfolder, probefolder, '*.meta'));

if sum(numel(d3)) > 1
    error('There''s more than 1 .meta file')
end

metafile = d3.name;

probefldr = fullfile(concatenated_folder, runfolder, probefolder);

SGLXMetaToCoords_AD(fullfile(concatenated_folder, runfolder, probefolder, metafile), 0, 1, fullfile(concatenated_folder, runfolder, probefolder))
close(gcf)

%% Kilosort them!

% filename = 'C:\NeuralData\Data\Quentin_data_for_comparison\catgt_P05-pitch2018_g0\P05-pitch2018_g0_tcat.imec.ap.bin';
% kilosort_output_path = 'C:\NeuralData\Data\Quentin_data_for_comparison\catgt_P05-pitch2018_g0';
% probe = 'C:\NeuralData\Data\Quentin_data_for_comparison\catgt_P05-pitch2018_g0\P05-pitch2018_g0_tcat.imec.ap_kilosortChanMap.mat';

% filename = 'C:\NeuralData\Data\Linguine_data_sample\supercat\P2_conf3\P2_conf3_g0\P2_conf3_g0_imec0\P2_conf3_g0_tcat.imec0.ap.bin';
% kilosort_output_path = 'C:\NeuralData\Data\Linguine_data_sample\supercat\P2_conf3\P2_conf3_g0\P2_conf3_g0_imec0\kilosort4';
% probe = 'C:\NeuralData\Data\Linguine_data_sample\supercat\P2_conf3\P2_conf3_g0\P2_conf3_g0_imec0\P2_conf3_g0_tcat.imec0.ap_kilosortChanMap.mat';

% filename = 'C:\NeuralData\Data\Linguine_data_sample\supercat\P3_conf2\P3_conf2_g0\P3_conf2_g0_imec0\P3_conf2_g0_tcat.imec0.ap.bin';
% kilosort_output_path = 'C:\NeuralData\Data\Linguine_data_sample\supercat\P3_conf2\P3_conf2_g0\P3_conf2_g0_imec0\kilosort4';
% probe = 'C:\NeuralData\Data\Linguine_data_sample\supercat\P3_conf2\P3_conf2_g0\P3_conf2_g0_imec0\P3_conf2_g0_tcat.imec0.ap_kilosortChanMap.mat';

% name = 'P2_conf4';
name = Pconf;
% fldr = 'C:\NeuralData\Data\Linguine_data_sample\supercat';
% fldr = 'C:\NeuralData\Data\Linguine_data_sample\glbdmx_supercat';
% fldr = 'D:\glbdmx\concatenated';
fldr = 'D:\glbdmx\individual';
fldr1 = name;
fldr2 = sprintf('%s_g0', name);
fldr3 = sprintf('%s_g0_imec0', name);
fnameAP = sprintf('%s_g0_tcat.imec0.ap.bin', name);
fnameProbe = sprintf('%s_g0_tcat.imec0.ap_kilosortChanMap.mat', name);

filename = fullfile(fldr, fldr1, fldr2, fldr3, fnameAP);
kilosort_output_path = fullfile(fldr, fldr1, fldr2, fldr3, 'kilosort4');
probe = fullfile(fldr, fldr1, fldr2, fldr3, fnameProbe);

pyrunfile('AP_run_kilosort4_AD.py', ...
    data_filename = filename, ...
    kilosort_output_path = kilosort_output_path, ...);
    probe = probe);

%% Bombcell them!

name = 'P3_conf2';

fldr = 'D:\glbdmx\concatenated';
% fldr = 'D:\glbdmx\individual';
fldr1 = name;
fldr2 = sprintf('%s_g0', name);
fldr3 = sprintf('%s_g0_imec0', name);
fnameAP = sprintf('%s_g0_tcat.imec0.ap.bin', name);
fnameProbe = sprintf('%s_g0_tcat.imec0.ap_kilosortChanMap.mat', name);

filename = fullfile(fldr, fldr1, fldr2, fldr3, fnameAP);
% kilosort_output_path = fullfile(fldr, fldr1, fldr2, fldr3, 'kilosort4');
kilosort_output_path = fullfile(fldr, fldr1, fldr2, fldr3, 'kilosort4_remove_duplicate_spikes_in_Bombcell');
probe = fullfile(fldr, fldr1, fldr2, fldr3, fnameProbe);

dataset_location = kilosort_output_path;
meta_location = fullfile(fldr, fldr1, fldr2, fldr3);
ephysKilosortPath = dataset_location;
ephysRawFile = filename; % path to your raw .bin or .dat data
ephysMetaDir = dir([meta_location '*ap*.*meta']); % path to your .meta or .oebin meta file
savePath = [dataset_location 'qMetrics']; % where you want to save the quality metrics

kilosortVersion = 4; % if using kilosort4, you need to have this value kilosertVersion=4. Otherwise it does not matter. 
gain_to_uV = NaN; % use this if you are not using spikeGLX or openEphys to record your data. this value, 
% % when mulitplied by your raw data should convert it to  microvolts. 

% Load data

[spikeTimes_samples, spikeClusters, templateWaveforms, templateAmplitudes, pcFeatures, ...
    pcFeatureIdx, channelPositions] = bc.load.loadEphysData(ephysKilosortPath, savePath);

% RUN QUALITY METRICS
% Parameters

param = bc.qm.qualityParamValues(ephysMetaDir, ephysRawFile, ephysKilosortPath, gain_to_uV, kilosortVersion);

param.nChannels = 385;
param.nSyncChannels = 1;

% if using SpikeGLX, you can use this function: 
if ~isempty(ephysMetaDir)
    if endsWith(ephysMetaDir.name, '.ap.meta') %spikeGLX file-naming convention
        meta = bc.dependencies.SGLX_readMeta.ReadMeta(ephysMetaDir.name, ephysMetaDir.folder);
        [AP, ~, SY] = bc.dependencies.SGLX_readMeta.ChannelCountsIM(meta);
        param.nChannels = AP + SY;
        param.nSyncChannels = SY;
    end
end

% Run all your quality metrics

[qMetric, unitType] = bc.qm.runAllQualityMetrics(param, spikeTimes_samples, spikeClusters, ...
        templateWaveforms, templateAmplitudes, pcFeatures, pcFeatureIdx, channelPositions, savePath);

% Run GUI

loadRawTraces = 0; % default: don't load in raw data (this makes the GUI significantly faster)
bc.load.loadMetricsForGUI;

unitQualityGuiHandle = bc.viz.unitQualityGUI_synced(memMapData, ephysData, qMetric, forGUI, rawWaveforms, ...
    param, probeLocation, unitType, loadRawTraces);

% Get the unit labels

goodUnits = unitType == 1;
muaUnits = unitType == 2;
noiseUnits = unitType == 0;
nonSomaticUnits = unitType == 3; 

% example: get all good units number of spikes
all_good_units_number_of_spikes = qMetric.nSpikes(goodUnits);



% (for use with another language: output a .tsv file of labels. You can then simply load this) 
label_table = table(unitType);
writetable(label_table,[savePath filesep 'templates._bc_unit_labels.tsv'],'FileType', 'text','Delimiter','\t');

No_of_good_units = sum(goodUnits)
