%{
Function that implements the binary search along a frequency for the
non-linear threshold upper bound given by the sinusoidal inputs. 
%}

function [amp_max, amp_min] = binary_search_sinusoidal(sut_nl, nl_threshold,...
                                  num_periods, sampling_time, settle_time,...
                                  frequency, delta_amp, amplitude_max,...
                                  dir_params, exclude_zeroHz_in_normalization)
    test_case.shape = 'sinus';
    % compute normalization coefficient of amplitude
    test_case.amplitude = 1;
    test_case.time_scaling = 1;
    [reference, ~] = generate_input_sequence(test_case, num_periods, sampling_time, settle_time);
    [~,ref_amp_peaks] = fA_main_components(reference(:,2),...
                                           sampling_time,...
                                           settle_time,...
                                           exclude_zeroHz_in_normalization);
    fft_amp_scale = 1/max(ref_amp_peaks);

    fprintf("Binary search along frequency %f\n",frequency);
    test_case.time_scaling = frequency; % this assumes shapes are defined over 1 second
                                        % AND that main freq component is the lowest

    % init binary search
    lower = delta_amp;
    upper = amplitude_max;
    amp = amplitude_max/2; % start search from mid range
    while (upper-lower)>delta_amp
        test_case.amplitude = amp;
        target_file_path = printf_test_file_path(sut_nl, test_case, dir_params);
        fprintf("I am now executing test %s\n",target_file_path);
        test_results = feval(dir_params.run_single_test_fcn, target_file_path, num_periods, sampling_time, settle_time, dir_params);
        writematrix(test_results,target_file_path); % store results
        [ref_freq_peaks,ref_amp_peaks] = fA_main_components(test_results(:,2),...
                                                            sampling_time,...
                                                            settle_time,...
                                                            exclude_zeroHz_in_normalization);
        dnl = non_linearity_degree(test_results(:,3),...
                                   sampling_time,...
                                   settle_time,...
                                   ref_freq_peaks,...
                                   ref_amp_peaks,...
                                   exclude_zeroHz_in_normalization);
        if dnl > nl_threshold
            upper = amp;
        else
            lower = amp;
        end
        amp = (upper+lower)/2;
    end
    % normalize amplitude to make it usable across shapes
    amp_max = upper/fft_amp_scale;
    amp_min = lower/fft_amp_scale;
end
