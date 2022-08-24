%{
Function that, given an reference input trace, computes the main frequency
components used for the mapping to the frequency-amplitude
characterization.
INPUTS:
 - signal        : vector of values over time of signal which we want to
                   compute the main frequency amplitude components
 - sampling_time : constant time gap between two samples of vector above
 - settle_time   : time of signal that we want to skip from beginning to
                   avoid analysing the transient
OUTPUTS:
 - freq_peaks    : frequencies of main components
 - amp_peaks     : amplitudes of main components

NOTE: the peaks are selected according to the relative threshold defined by
the local parameter peaks_threshold. This parameter defines the percentage
of the amplitude of the largest peak above which we consider the other
peaks.
%}


function [freq_peaks, amp_peaks] = fA_main_components(signal, sampling_time, settle_time)
    
    %%% FUNCTION PARAMETER %%%
    peaks_threshold = 0.1; % threshold above which we consider the peaks relevant
    %%%

    values = signal(settle_time/sampling_time:end); % exclude settling
    [freqs, ref_fft] = fourier_transform_wrap(values, sampling_time); % fft computation
    [ref_peaks, ref_peaks_indexes] = findpeaks(ref_fft); % find peaks
    % manually include zero frequency
    ref_peaks = [ref_fft(1), ref_peaks];
    ref_peaks_indexes = [1,ref_peaks_indexes];
    freq_peaks = freqs(ref_peaks_indexes);

    % select only peaks above relative threshold
    indexes = ref_peaks>(peaks_threshold*max(ref_fft));
    amp_peaks  = ref_peaks(indexes);
    freq_peaks = freq_peaks(indexes);
end
