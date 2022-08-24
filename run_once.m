%{
Script to run run one specific test. Results are stored in csv file in
target directory and can be displayed with the plotting script.
%}

%% test case definition
test_case.shape = 'steps';
test_case.amplitude = 5;
test_case.time_scaling = 0.1;

%% test execution
target_file_path = printf_test_file_path(input_non_linearity, friction_non_linearity, test_case, dir_params);
test_results = run_single_test(target_file_path, num_periods, sampling_time, settle_time, dir_params);

%% write traces to csv
% this overwrites the existing file with the same data
% apparently this is not nice but in this single-test script it's
% accaptable. I guess that technically we should not care about storing the results of
% an individual test (but we need it to plot with another script)
writematrix(test_results,target_file_path)
