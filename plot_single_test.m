
%% open file
data_directory = 'dcServo_test_data/';

shape = 'steps';
amplitude = 5;
time_scaling = 0.1;

file_path = sprintf('%s%s-%f-%f.csv',data_directory,shape,amplitude,time_scaling);
test_results = readmatrix(file_path);

%% unpack data
time = test_results(:,1);
data = test_results(:,2:end);

%% plot results
figure(2)
plot(time,data),grid

[freq_peaks,amp_peaks] = fA_main_components(test_results(:,2), sampling_time, settle_time);
figure(3)
scatter(freq_peaks,amp_peaks,20,'blue','x'),grid
set(gca,'xscale','log')
set(gca,'yscale','log')
