
%% open file
data_directory = 'dcServo_test_data/';

shape = 'steps';
amplitude = 5;
time_scaling = 0.1;

file_path = sprintf('%s%s-%g-%g.csv',data_directory,shape,amplitude,time_scaling);
test_results = readmatrix(file_path);

%% unpack data
time = test_results(:,1);
data = test_results(:,2:end);

%% analyse and plot results
% full spectra of reference and output
[ref_freqs,ref_amps] = fourier_transform_wrap(test_results(settle_time/sampling_time:end,2), sampling_time);
[out_freqs,out_amps] = fourier_transform_wrap(test_results(settle_time/sampling_time:end,3), sampling_time);
% main components
[ref_freq_peaks,ref_amp_peaks] = fA_main_components(test_results(:,2), sampling_time, settle_time);
[out_freq_peaks,put_amp_peaks] = fA_main_components(test_results(:,3), sampling_time, settle_time);
% degree of non-linearity

% filtering degree
dof = filtering_degree(test_results(:,3),sampling_time,settle_time,ref_freq_peaks,ref_amp_peaks);
disp("Filtering degree is: ")
disp(dof)

figure(2)
plot(time,data),grid

figure(3)
clf
hold on
scatter(ref_freqs,ref_amps,5,'blue','o')
scatter(out_freqs,out_amps,5,'red','o')
scatter(ref_freq_peaks,ref_amp_peaks,80,'blue','x')
scatter(out_freq_peaks,out_amp_peaks,80,'red','x')
grid
set(gca,'xscale','log')
set(gca,'yscale','log')
hold off
