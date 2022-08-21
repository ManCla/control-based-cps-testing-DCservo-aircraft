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
%}


function [freq_peaks, amp_peaks] = fA_main_components(signal, sampling_time, settle_time)
    
    % LOCAL PARAMETER
    peaks_threshold = 0.1; % threshold above which we consider the peaks relevant

    % preliminaries
    values = signal(settle_time/sampling_time:end);
    test_duration = length(signal)*sampling_time-settle_time;
    num_samples = length(values);

    % compute fft
    ref_fft = abs(fft(values)/num_samples); % compute abs of fft and normalize over numb of samples
    ref_fft = ref_fft(1:floor(num_samples/2)+1);
    freqs = (1/test_duration)*(0:(num_samples/2));
    % find peaks
    [ref_peaks, ref_peaks_indexes] = findpeaks(ref_fft);
    freq_peaks = freqs(ref_peaks_indexes);
    % select only peaks above relative threshold
    indexes = ref_peaks>(peaks_threshold*max(ref_fft));
    amp_peaks  = ref_peaks(indexes);
    freq_peaks = freq_peaks(indexes);
end
