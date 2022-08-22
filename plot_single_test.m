%{
Script to plot and analyse the resutls of a test from the traces recorded
in the csv file.
%}

%% testing parameters

settle_time = 5;
sampling_time = 0.05;

input_non_linearity = inl_none;
friction_non_linearity = fnl_quadratic;

%% test file

test_case.shape = 'steps';
test_case.amplitude = 5;
test_case.time_scaling = 0.1;

target_file_path = printf_test_file_path(input_non_linearity, friction_non_linearity, test_case, dir_params);
test_results = readmatrix(target_file_path);

%% unpack data
time = test_results(:,1);
data = test_results(:,2:end);

%% analyse
% full spectra of reference and output
[ref_freqs,ref_amps] = fourier_transform_wrap(test_results(settle_time/sampling_time:end,2), sampling_time);
[out_freqs,out_amps] = fourier_transform_wrap(test_results(settle_time/sampling_time:end,3), sampling_time);
% main components
[ref_freq_peaks,ref_amp_peaks] = fA_main_components(test_results(:,2), sampling_time, settle_time);
[out_freq_peaks,out_amp_peaks] = fA_main_components(test_results(:,3), sampling_time, settle_time);
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
plot(time,data),grid

% frequency domain plotting
figure(3)
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
