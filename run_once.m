%{
Script to run run one specific test. Results are stored in csv file in
target directory and can be displayed with the plotting script.
%}

%% test case definition
test_case.shape = 'steps';
test_case.amplitude = 5;
test_case.time_scaling = 0.1;

%% test execution
target_file_path = printf_test_file_path(sut_nl, test_case, dir_params);
test_results = feval(dir_params.run_single_test_fcn, target_file_path, num_periods, sampling_time, settle_time, dir_params);
% NOTE: output is written to file by the run_single_test function only if
% test is actually executed. Otherwise it just opens the file and returns
% the test resutls.
