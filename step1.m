%{
This script implements the first step of the testing approach.
The step takes intial bounds on the frequency range of interest and the
amplitude of the input. Those are then used to initialize a search over the
frequencyes and amplitudes to get an upper bound for the non-linearity
threshold based on sinusoidal inputs
%}

%% approach inputs
% frequency bounds
f_min = 0.005;
f_max = 3;
% ampliltude bound
amplitude_max = 20;
delta_amp = 0.3;

%% init search - start with thresholds at f_min and f_max
% minimum frequency
[amp_max, amp_min] = binary_search_sinusoidal(sut_nl, nl_threshold, num_periods, sampling_time, settle_time, ...
                              f_min, delta_amp, amplitude_max, dir_params);
nlth_upper_bound = [f_min, amp_max, amp_min]; % initialize matrix of upper bounds
% maximum frequency
[amp_max, amp_min] = binary_search_sinusoidal(sut_nl, nl_threshold, num_periods, sampling_time, settle_time, ...
                              f_max, delta_amp, amplitude_max, dir_params);
nlth_upper_bound = [nlth_upper_bound;
                    f_max, amp_max, amp_min]; % add to matrix of upper bounds

%% iterative exploration
% iterate until we get desired resolution along amplitude axis for
% upperbound of nonlinear threshold
next_freq = sample_frequency(nlth_upper_bound, delta_amp)
while next_freq
    [amp_max, amp_min] = binary_search_sinusoidal(sut_nl, nl_threshold, num_periods, sampling_time, settle_time, ...
                                                  f_max, delta_amp, amplitude_max, dir_params);
    nlth_upper_bound = [nlth_upper_bound;
                        f_max, amp_max, amp_min]; % add to matrix of upper bounds
    next_freq = sample_frequency(nlth_upper_bound)
end


%% plotting
figure
hold on
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
