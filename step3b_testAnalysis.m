%{
Implement step 4 of apporach.
Step 4 is divided in two parts: the analysis of the tests resutls (this
script: step4a) and the actual visualization (step4b).
This script iterates over all of the tests (shapes, frequencies and
amplitudes) and computes the fa points with the associated dnl, dof, and
evaluation of ground truth of nonlinear behaivour.

For each fA point: [freq,amp,dnl,dof, (TODO: nl_ground truth)]

%}

%% extract fA points from tests
% iterate over tests and extract fa points
% do we do it by shape or create a single one for all?

fprintf("I am now analysing test data for SUT:\n%s\n",directory)

% saturate dnl and dof: convenient for plotting in latex
saturate_dnl_dof = 1;
if saturate_dnl_dof
    fprintf('-- I will saturate dnl and dof (to %g and 1) and invert the dof\n',nl_threshold)
end

% iterate over shapes
for s_idx = 1:length(shapes)
    % get test set from file
    test_cases_of_shape = readmatrix(sprintf("%s%s-testset.csv",directory,shapes(s_idx)));
    num_tests_of_this_shape = length(test_cases_of_shape(:,1));

    % file for storing the fA points
    % delete old one, normally would be overwritten but in append mode
    % it is not. So deletion is relevant.
    fa_file_path = sprintf("%s%s-fa-points.csv",directory,shapes(s_idx));
    delete(fa_file_path)
    % file for storing the fA points - only main component
    fa_file_path_largest = sprintf("%s%s-fa-points-largest-only.csv",directory,shapes(s_idx));
    delete(fa_file_path_largest)
    % file for storing the fA points - only tests with liner behaviour
    fa_file_path_linear = sprintf("%s%s-fa-points-linear-only.csv",directory,shapes(s_idx));
    delete(fa_file_path_linear)

    fprintf("-- Analysing shape: %s\n",shapes(s_idx))

    % iterate over the tests
    test_case.shape = shapes(s_idx);
    for tc_idx = 1:num_tests_of_this_shape

        % define test case we look at
        test_case.amplitude    = test_cases_of_shape(tc_idx,2);
        test_case.time_scaling = test_cases_of_shape(tc_idx,1);
        % get test output file and data
        target_file_path = printf_test_file_path(sut_nl, test_case, dir_params);
        test_results = readmatrix(target_file_path);

        %%%% analyse test resutls %%%%
        % (i)   compute fA main components
        [ref_freq_peaks,ref_amp_peaks] = fA_main_components(test_results(:,2), sampling_time, settle_time, exclude_zeroHz_in_normalization);
        % (ii)  compute degree of non-linearity
        dnl = non_linearity_degree(test_results(:,3),sampling_time,settle_time,ref_freq_peaks,ref_amp_peaks, exclude_zeroHz_in_normalization);
        % (iii) compute filtering degree
        dof = filtering_degree(test_results(:,3),sampling_time,settle_time,ref_freq_peaks,ref_amp_peaks);
        % (iv)  if possible, compute "ground truth" of non-lienar behaviour
        sat_actuation_perc = saturation_percentage(test_results(:,4),actuation_max,actuation_min,sat_resolution);
        % NOTE: we are skipping index 5 because the simulink exit at that
        % index is empty because of a refuso
        % evaluate occurrence of nonlinear phenomena other than actuator
        % saturation only if they are available
        if size(test_results,2)>4 
            sat_sensor_perc = saturation_percentage(test_results(:,3),sensor_max,sensor_min,sat_resolution);
            input_nl_avg    = mean(abs(test_results(:,6)));
            friction_nl_avg = mean(abs(test_results(:,7)));
        else
            sat_sensor_perc = 0;
            input_nl_avg    = 0;
            friction_nl_avg = 0;
        end
        if saturate_dnl_dof
            dnl = min(dnl,nl_threshold);
            dof = 1-min(dof,1);
        end
        %%%% end analysis part %%%%

        % store fA points
        % only component with largest amplitude
        if exclude_zeroHz_in_normalization
            [m,pt_idx]=max(ref_amp_peaks(2:end));
            pt_idx = pt_idx+1;
        else
            [m,pt_idx]=max(ref_amp_peaks);
        end
        point_string = sprintf("%g, %g, %g, %g, %g, %g, %g, %g", ...
                       ref_freq_peaks(pt_idx),ref_amp_peaks(pt_idx),dnl,dof(pt_idx),...
                       sat_actuation_perc, sat_sensor_perc, input_nl_avg,friction_nl_avg);
        writelines(point_string,fa_file_path_largest,WriteMode="append")

        % storing of all points
        % iterate over main fa components
        for pt_idx = 1:length(ref_freq_peaks)
            % freq,amp,dnl,dof
            point_string = sprintf("%g, %g, %g, %g, %g, %g, %g, %g", ...
                           ref_freq_peaks(pt_idx),ref_amp_peaks(pt_idx),dnl,dof(pt_idx),...
                           sat_actuation_perc, sat_sensor_perc, input_nl_avg,friction_nl_avg);
            writelines(point_string,fa_file_path,WriteMode="append")
        end % iteration over main fa components

        % storing of points associated to tests with linear behaviour
        % iterate over main fa components
        if dnl<nl_threshold
            for pt_idx = 1:length(ref_freq_peaks)
                % freq,amp,dnl,dof
                point_string = sprintf("%g, %g, %g, %g, %g, %g, %g, %g", ...
                               ref_freq_peaks(pt_idx),ref_amp_peaks(pt_idx),dnl,dof(pt_idx),...
                               sat_actuation_perc, sat_sensor_perc, input_nl_avg,friction_nl_avg);
                writelines(point_string,fa_file_path_linear,WriteMode="append")
            end % iteration over main fa components
        end
    end % iteration over test cases
end % iteration over shapes

