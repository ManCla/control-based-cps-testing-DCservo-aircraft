%{
This script implements the first step of the testing approach.
The step takes intial bounds on the frequency range of interest and the
amplitude of the input. Those are then used to initialize a search over the
frequencyes and amplitudes to get an upper bound for the non-linearity
threshold based on sinusoidal inputs

NOTE: amplutudes in the non-linear threshold upper bound are in the
      frequency domain while amplitudes that will be used to define test
      cases are amplitude scalings in the time domain
%}

%% init search - start with thresholds at f_min and f_max
% minimum frequency
[amp_max, amp_min] = binary_search_sinusoidal(sut_nl, nl_threshold, num_periods, sampling_time, settle_time, ...
                              f_min, delta_amp, amplitude_max, dir_params, exclude_zeroHz_in_normalization);
nlth_upper_bound = [f_min, amp_max, amp_min]; % initialize matrix of upper bounds
% maximum frequency
[amp_max, amp_min] = binary_search_sinusoidal(sut_nl, nl_threshold, num_periods, sampling_time, settle_time, ...
                              f_max, delta_amp, amplitude_max, dir_params, exclude_zeroHz_in_normalization);
nlth_upper_bound = [nlth_upper_bound;
                    f_max, amp_max, amp_min]; % add to matrix of upper bounds

%% iterative exploration
% iterate until we get desired resolution along amplitude axis for
% upperbound of nonlinear threshold
next_freq = sample_frequency(nlth_upper_bound, delta_amp, freq_resolution);
while next_freq
    [amp_max, amp_min] = binary_search_sinusoidal(sut_nl, nl_threshold, num_periods, sampling_time, settle_time, ...
                                                  next_freq, delta_amp, amplitude_max, dir_params, exclude_zeroHz_in_normalization);
    for i=2:size(nlth_upper_bound,1)
        if next_freq<nlth_upper_bound(i,1)
            % add in matrix of upper bounds
            nlth_upper_bound = [nlth_upper_bound(1:i-1,:);
                                next_freq, amp_max, amp_min;
                                nlth_upper_bound(i:end,:);];
            break
        end
    end
    next_freq = sample_frequency(nlth_upper_bound, delta_amp, freq_resolution);
end

nlth_file_path = sprintf("%s/nlth_upper_bound_fmin%g_fmax%g_damp%g_amax%g.csv", ...
                         directory,f_min,f_max,delta_amp,amplitude_max);
writematrix(nlth_upper_bound,nlth_file_path)

%% plotting
figure
hold on
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
set(gca,'xscale','log')
set(gca,'yscale','log')
grid
xlim([f_min, f_max])
ylim([min(nlth_upper_bound(:,3))-1 max(nlth_upper_bound(:,2))+1])
hold off
