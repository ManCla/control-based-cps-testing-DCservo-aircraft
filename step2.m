%{
This script implements the second step of the testing approach.
In the second step, the upperbound of the nonlinear threshold is used to
generate a testset for each shape

% NOTE: the script assumes that the shapes are defined over unit period and
that main freq is lowests.
%}

% set seed for random generator
rng(1)

%% open ile containing sinusoidal based upperbound of nonlinear threshold
nlth_file_path = sprintf("%s/nlth_upper_bound_fmin%g_fmax%g_damp%g_amax%g.csv", ...
                         directory,f_min,f_max,delta_amp,amplitude_max);
nlth = readmatrix(nlth_file_path);

%% test case generation for each shape

% uniformly spaced sampling of frequencies
freqs_vector    = f_min:freq_resolution:f_max;

% iterate over shapes
for s_idx = 1:length(shapes)
    fprintf("Generating test set for shape %s\n",shapes(s_idx));
    test_cases = []; % init test cases vector
    % iterate over frequencies
    for f_idx = 1:length(freqs_vector)
        freq = freqs_vector(f_idx);
        a_max = get_nlth_at_freq(nlth,freq); % get amp[litude upper bound at given freq
        % random sampling with beta distribution of amplitudes
        n_samples_at_freq = floor((a_max-delta_amp)/delta_amp)+1;
        amps = delta_amp + (a_max-delta_amp)*(betarnd(5,0.8,[n_samples_at_freq,1]));
        % append to test cases vector
        test_cases = [test_cases; freq*ones(n_samples_at_freq,1), amps]; %#ok<AGROW> 
    end % frequencies loop

    % store test set for shape
    test_set_file_path = sprintf("%s%s.csv",directory,shapes(s_idx));
    writematrix(test_cases,test_set_file_path);

end % shapes loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Test case generation is now finished, now on there is only some %%%%%
%%%%%                 plotting stuff used for debugging.              %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plotting of test sets (short version: only frequency and amplitude scaling)
% iterate over shapes
for s_idx = 1:length(shapes)
    figure
    test_cases = readmatrix(sprintf("%s%s.csv",directory,shapes(s_idx)));
    scatter(test_cases(:,1),test_cases(:,2))
    grid
    title(sprintf("Test set generated for %s shape",shapes(s_idx)))
    set(gca,'xscale','log')
    set(gca,'yscale','log')
end

%% plotting of test sets (long version: all main components)
% be aware that this takes some time
% iterate over shapes
% for s_idx = 1:length(shapes)
% 
%     figure
%     hold on
%     test_case.shape = shapes(s_idx);
%     for tc_idx = 1:length(test_cases(:,1))
%         % test amplitude and time scaling
%         test_case.amplitude = test_cases(tc_idx,2);
%         test_case.time_scaling = test_cases(tc_idx,1); % assuming shape defined over unit period
%                                                        % and that main freq is lowest
%         [reference, test_duration] = generate_input_sequence(test_case, num_periods, sampling_time, settle_time);
%         [ref_freq_peaks,ref_amp_peaks] = fA_main_components(reference(:,2), sampling_time, settle_time);
%         scatter(ref_freq_peaks,ref_amp_peaks)
%     end
%     grid
%     set(gca,'xscale','log')
%     set(gca,'yscale','log')
%     hold off
% end
