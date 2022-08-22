%{
Script to run run one specific test. Results are stored in csv file in
target directory and can be displayed with the plotting script.
%}

%% testing parameters

num_periods = 5;      % number of input periods included in test
sampling_time = 0.05; % should be taken from SUT
settle_time = 5;      % extra time in test for allowing for transients

input_non_linearity = inl_none;
friction_non_linearity = fnl_quadratic;

% check if we have both input and friction non-linearities
if input_non_linearity~=0 && friction_non_linearity~=0
    disp('Are you sure you want to apply two non-linearities at once?')
end

%% test case definition
shape = 'steps';
amplitude = 7;
time_scaling = 0.1;

%% test execution
target_file_path = printf_test_file_path(input_non_linearity, friction_non_linearity, shape, amplitude, time_scaling, dir_params);
test_results = run_single_test(target_file_path, num_periods, sampling_time, settle_time,dir_params);

%% write traces to csv
% this overwrites the existing file with the same data
% apparently this is not nice but in this single-test script it's
% accaptable. I guess that technically we should not care about storing the results of
% an individual test (but we need it to plot with another script)
writematrix(test_results,target_file_path)
