%{
Function that computes the degree of non-linearity for a given test.

INPUTS:
 - measurement      : the measured output of the test
 - sampling_time    : time intervals at which output is  sampled
 - settle_time      : initial part of test to be discarded as warmup.
                      we want to avoid analysing the transient
 - main_freqs       : frequencies of the main components of input
                      (as computed by fa_main_components)
 - main_amps        : amplitudes of the main components of input
                      (as computed by fa_main_components)
OUTPUTS:
 - filtering_degree : a vector containing the measured filtering degree for
                      the frequencies of the main components of the input
%}

function nld = non_linearity_degree(measurement,sampling_time,settle_time,main_freqs,main_amps)

    to_analyse = measurement(settle_time/sampling_time:end); % exclude settling
    [out_freqs,out_amps] = fourier_transform_wrap(to_analyse, sampling_time); % compute fft of measurements
    % remove main components from output spectrum
    main_indexes = ismember(out_freqs,main_freqs);
    out_minor_components = out_amps(~main_indexes);
    % actual dnl computation
    [v,i]=max(out_minor_components);
    nld = v/max(main_amps);
%     if i==1 && nld>0.15 % zero frequency check (mainly for curiosity at the moment)
%         disp('-- DNL COMPUTATION: zero frequency is determining an high dnl')
%     end

end
