%{
Implementation of step 3 of the apporach: test case execution
%}

%% step implementation
% iterate over shapes
for s_idx = 1:length(shapes)
    fprintf("Running tests for shape %s\n",shapes(s_idx));

    % get test set from file
    test_cases = readmatrix(sprintf("%s%s.csv",directory,shapes(s_idx)));
    % all test cases of this iteration will have the same shape
    test_case.shape = shapes(s_idx);

    % iterate over test cases (amplitude and time scaling pairs)
    for tc_idx = 1:length(test_cases(:,1))
        % test case definition
        test_case.amplitude    = test_cases(tc_idx,2);
        test_case.time_scaling = test_cases(tc_idx,1);
        fprintf("-- running test: (amp: %f ,t_scaling %f )\n", ...
                 test_case.amplitude, test_case.time_scaling);
        target_file_path = printf_test_file_path(sut_nl, test_case, dir_params);
        % run test case
        test_results = run_single_test(target_file_path, num_periods, sampling_time, settle_time, dir_params);

    end % test cases loop
end % shapes loop
