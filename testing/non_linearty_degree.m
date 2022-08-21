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

function nld = non_linearity_degree(measurement,sampling_time,settle_time, ...
                                             main_freqs,main_amps)

    % compute fft of measurements

end
