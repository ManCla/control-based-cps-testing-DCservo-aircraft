%{
Implement step 4 of apporach.
We want to display:
 - fA plot with degre of non-linearity
 - fA plot with degre of non-linearity by shapes
 - fA plot with ground truth of non-linear phenomena
 - fA plot with degre of filtering
 - plot of degree of filtering over the frequencies

% For each fA point: [freq,amp,dnl,dof,nl_ground truth]

%}


%% prepare
% open files with list of test cases and put them in one matrix
% We should have the same number of tests for each shape and the same
% number of tests per frequency.
% Hence the frequency vector can be shared across the shapes.

% Initialize test set data with first shape
first_set = readmatrix(sprintf("%s%s-testset.csv",directory,shapes(s_idx)));
num_tests_per_shape = length(first_set(:,1));
num_shapes = length(shapes);

test_cases = [first_set, zeros(num_tests_per_shape,num_shapes-1)];

% iterate over the rest of the shapes
for s_idx = 2:length(shapes)
    % get test set from file
    test_cases_of_shape = readmatrix(sprintf("%s%s-testset.csv",directory,shapes(s_idx)));
    test_cases(:,1+s_idx) = test_cases_of_shape(:,2);
end % shapes loop


%% extract fA points from tests
% iterate over tests and extract fa points
% do we do it by shape or create a single one for all?

% iterate over shapes
for s_idx = 1:length(shapes)

    % open file for storing the fA points
    fa_file_path = sprintf("%s%s-fa-points.csv",directory,shapes(s_idx))

    test_case.shape        = shapes(s_idx);

    % iterate over the tests
    for f_idx = 1:num_tests_per_shape

        % define test case we look at
        test_case.amplitude    = test_cases(f_idx,s_idx+1);
        test_case.time_scaling = test_cases(f_idx,1);
        % get test output file and data
        target_file_path = printf_test_file_path(sut_nl, test_case, dir_params);
        test_results = readmatrix(target_file_path);
        % analyse test resutls
        [ref_freq_peaks,ref_amp_peaks] = fA_main_components(test_results(:,2), sampling_time, settle_time);
        % compute degree of non-linearity
        dnl = non_linearity_degree(test_results(:,3),sampling_time,settle_time,ref_freq_peaks,ref_amp_peaks);
        % compute filtering degree
        dof = filtering_degree(test_results(:,3),sampling_time,settle_time,ref_freq_peaks,ref_amp_peaks);

        % store fA points
        % iterate over main fa components
        for pt_idx = 1:length(ref_freq_peaks)
            % freq,amp,dnl,dof
            point_string = sprintf("%g, %g, %g, %g", ...
                           ref_freq_peaks(pt_idx),ref_amp_peaks(pt_idx),dnl,dof(pt_idx));
            writelines(point_string,fa_file_path,WriteMode="append")
        end % iteration over main fa components
    end % iteration over test cases
end % iteration over shapes

