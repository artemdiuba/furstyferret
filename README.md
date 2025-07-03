This is a spike sorting pipeline after the recording with Neuropixels 2.0,
OneBox and SpikeGLX. It assumes that one of the analogue OneBox aux channels
carries pulses corresponding to the length of the sound stimulation and
that another aux channel contains "barcodes" for every stimulus.
Recording is assumed to  consist of several Runs. Every Run is attributed
to one penetration and configuration.
Penetration is one entry point of the probe.
Configuration is an arrangement of the recording sites defined in the
SpikeGLX during recording.
Runs performed from the same penetration and with the same configuration
may be concatenated to increase the quality of the Kilosort4 output.

This pipeline consists of:

spike_sorting_pipeline.m:

- common average referencing (glbcar or glbdmx), time alignment and high
pass or band pass filtering of the row neural data;
- concatenating, if any, of the runs prepared on the previous step
- preparing the probe file describing the recording site arrangements. It
is needed for Kilosort4
- running the Kilosort4
- running the Bombcell on the kilosort output

 spike_times_per_unit.m:

- parsing the spike times into individual units and stimulus types

check_stimulus_decoding.m and spot_weird_spiketimes.m

- number of sanity checks
