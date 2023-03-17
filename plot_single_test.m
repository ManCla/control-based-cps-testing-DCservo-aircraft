%{
Script to plot and analyse the resutls of a test from the traces recorded
in the csv file.
%}

%% test file

test_case.shape = 'steps';
test_case.amplitude = 5;
test_case.time_scaling = 0.1;

target_file_path = printf_test_file_path(sut_nl, test_case, dir_params);
test_results = readmatrix(target_file_path);

%% analyse
% full spectra of reference and output
[ref_freqs,ref_amps] = fourier_transform_wrap(test_results(settle_time/sampling_time:end,2), sampling_time);
[out_freqs,out_amps] = fourier_transform_wrap(test_results(settle_time/sampling_time:end,3), sampling_time);
% main components
[ref_freq_peaks,ref_amp_peaks] = fA_main_components(test_results(:,2), sampling_time, settle_time);
[out_freq_peaks,out_amp_peaks] = fA_main_components(test_results(:,3), sampling_time, settle_time);

% if saturation time quantification is available (as of now, only for the
% DC servo), plot it. NOTE: this assumes that the number of elements logged
% is smaller than the number of time samples (when using the min function).
if min(size(test_results))>4
    % compute actuator saturation time
    % NOTE: this uses hardcoded saturation bounds because we use it only for
    % the DCservo as of now
    sat_perc = saturation_percentage(test_results(:,4));
    disp("Percentage of time that actuator is saturated: ")
    disp(sat_perc)
    % compute actuator saturation time
    % NOTE: this uses hardcoded saturation bounds because we use it only for
    % the DCservo as of now
    sensor_sat_perc = saturation_percentage(test_results(:,3));
    disp("Percentage of time that sensor is saturated: ")
    disp(sensor_sat_perc)
end

% compute degree of non-linearity
dnl = non_linearity_degree(test_results(:,3),sampling_time,settle_time,ref_freq_peaks,ref_amp_peaks);
disp("Non-Linearity degree is: ")
disp(dnl)
% compute filtering degree
dof = filtering_degree(test_results(:,3),sampling_time,settle_time,ref_freq_peaks,ref_amp_peaks);
disp("Filtering degree is: ")
disp(dof)

%% plot

% time domain plotting
figure(2)
plot(test_results(:,1),test_results(:,2:4)),grid
legend('reference', 'output', 'actuation')
% if nl phenomena quantification is available (as of now, only for the DC 
% servo), plot it. NOTE: this assumes that the number of elements logged is
% smaller than the number of time samples (when using the min function).
if min(size(test_results))>4
    figure(3)
    plot(test_results(:,1),test_results(:,5:7)),grid
    legend('input measured non linearity', 'friction measured non linearity')
end

% frequency domain plotting
figure(4)
clf
hold on
% just for plotting purposes otherwise zero frequency does not show up in
% logarithmic scale
ref_freqs(1) = 0.001;
out_freqs(1) = 0.001;
if ref_freq_peaks(1)==0
    ref_freq_peaks(1) = 0.001;
    out_freq_peaks(1) = 0.001;
end
% scatter plot full spectra
scatter(ref_freqs,ref_amps,5,'blue','o')
scatter(out_freqs,out_amps,5,'red','o')
% scatter plot main components
scatter(ref_freq_peaks,ref_amp_peaks,80,'blue','x')
scatter(out_freq_peaks,out_amp_peaks,80,'red','x')
grid
set(gca,'xscale','log')
set(gca,'yscale','log')
hold off
