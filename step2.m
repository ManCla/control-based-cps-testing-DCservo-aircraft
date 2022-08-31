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
nlth_upper_bound = readmatrix(nlth_file_path);

%% test case generation for each shape

% uniformly spaced sampling of frequencies
freqs_vector    = f_min:freq_resolution:f_max;
% test case with amp_scale=1 and time_scale=1 for amp and time scalings
test_case.amplitude = 1;
test_case.time_scaling = 1;
% iterate over shapes
for s_idx = 1:length(shapes)
    fprintf("Generating test set for shape %s\n",shapes(s_idx));
    % get test with amp_scale=1 and time_scale=1 for scaling coeffs
    test_case.shape = shapes(s_idx);
    [reference, ~] = generate_input_sequence(test_case, num_periods, sampling_time, settle_time);
    [ref_freq_peaks,ref_amp_peaks] = fA_main_components(reference(:,2), sampling_time, settle_time);
    [fft_amp_scale, max_amp_idx] = max(ref_amp_peaks);
    % fft_freq_scale 1 if shapes are defined over unit period and main component is lowest
    fft_freq_scale = ref_freq_peaks(max_amp_idx);

    test_cases = []; % init test cases vector
    % iterate over frequencies
    for f_idx = 1:length(freqs_vector)
        freq = freqs_vector(f_idx);
        % get amplitude upper bound at given freq in time domain
        a_max = get_nlth_at_freq(nlth_upper_bound,freq)/fft_amp_scale;

        % random sampling with beta distribution of amplitudes
        n_samples_at_freq = floor((a_max-delta_amp)/delta_amp);
        amps = delta_amp + (a_max-delta_amp)*(betarnd(5,0.8,[n_samples_at_freq,1]));
        % append to test cases vector
        test_cases = [test_cases; freq/fft_freq_scale*ones(n_samples_at_freq,1), amps]; %#ok<AGROW>
    end % frequencies loop

    % store test set for shape
    test_set_file_path = sprintf("%s%s-testset.csv",directory,shapes(s_idx));
    writematrix(test_cases,test_set_file_path);

end % shapes loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Test case generation is now finished, now on there is only some %%%%%
%%%%%                 plotting stuff used for debugging.              %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plotting of test sets
% iterate over shapes
for s_idx = 1:length(shapes)
    % open file with test cases
    test_set_file_path = sprintf("%s%s-testset.csv",directory,shapes(s_idx));
    test_cases = readmatrix(test_set_file_path);
    % create figure object and plot nlth upperbound
    fig_num=20+s_idx;
    figure(fig_num)
    clf(fig_num)
    hold on
    % plot nlth upperbound
    plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
    plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
    test_case.shape = shapes(s_idx);
    frequencies = [];
    amplitudes = [];
    for tc_idx = 1:length(test_cases(:,1))
        % test amplitude and time scaling
        test_case.amplitude = test_cases(tc_idx,2);
        test_case.time_scaling = test_cases(tc_idx,1); % assuming shape defined over unit period
                                                       % and that main freq is lowest
        [reference, test_duration] = generate_input_sequence(test_case, num_periods, sampling_time, settle_time);
        [ref_freq_peaks,ref_amp_peaks] = fA_main_components(reference(:,2), sampling_time, settle_time);
        frequencies = [frequencies, ref_freq_peaks]; %#ok<AGROW> 
        amplitudes  = [amplitudes,  ref_amp_peaks ]; %#ok<AGROW> 
    end
    scatter(frequencies,amplitudes,8,'blue','filled')
    grid
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([f_min, f_max*10])
    ylim([delta_amp max(nlth_upper_bound(:,2))+1])
    hold off
end
