%{
Script to run run the preliminary investigation on how many periods are
needed to evalute the degree of non-linearity
%}

% we need to overwrite the number of periods for the test
% NOTE: this is set back to the default at the end of the script
num_periods_default = num_periods;
num_periods = 10;      % number of input periods to evaluate (should be large)

%% test case definition
% we just need one test case that fails. The system seems to be robust to
% non-linearities within the prescribed range for sinusoidal inputs so we
% use steps instead.
test_case.shape        = preliminary_test_case_shape;
test_case.amplitude    = preliminary_test_case_amplitude;
test_case.time_scaling = preliminary_test_case_time_scaling;

%% test execution
target_file_path = printf_test_file_path(sut_nl, test_case, dir_params);
% remove file of test to make sure that it is re-run
fprintf("I am going to delete file %s\n", target_file_path)
delete(target_file_path)
test_results = feval(dir_params.run_single_test_fcn,target_file_path, num_periods, sampling_time, settle_time, dir_params);

%% analyse
% iterate over number of available periods and analyse for each of them
for num_p = 1:num_periods
    % compute how many datapoints we can use
    settle_samples = settle_time/sampling_time; % include settling time
    analysis_samples = num_p*(1/test_case.time_scaling)*(1/sampling_time);
    data_end = floor(settle_samples+analysis_samples)+1;
    % main components
    [ref_freq_peaks,ref_amp_peaks] = fA_main_components(test_results(1:data_end,2),...
                                                        sampling_time,...
                                                        settle_time,...
                                                        exclude_zeroHz_in_normalization);
    % compute degree of non-linearity
    dnl = non_linearity_degree(test_results(1:data_end,3), ...
        sampling_time,settle_time,ref_freq_peaks,ref_amp_peaks,exclude_zeroHz_in_normalization);
    fprintf("With %d periods Non-Linearity degree is: %f\n",num_p, dnl)
end % iteration over number of periods
