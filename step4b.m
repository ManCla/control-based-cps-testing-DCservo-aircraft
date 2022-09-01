%{
Implement plotting part of step 4 of apporach.
We display:
 (Fig.1)   fA plot with non-linearity by shapes and all shapes together
 (Fig.2)   fA plot with filtering degree all shapes together
 (Fig.3)   plot of degree of filtering over the frequencies
 - fA plot with ground truth of non-linear phenomena
 
For each fA point: [freq,amp,dnl,dof,sat_actuation_perc,sat_sensor_perc,input_nl_avg,friction_nl_avg]

%}

%% some plotting parameters
dot_size = 8; % size of dots in all scatter plot
f_min_plot = f_min;
f_max_plot = 10;

% use only largest fA component for dnl plots
use_largest_fa_only = 1;

%% open ile containing sinusoidal based upperbound of nonlinear threshold
% this is used for  plotting the nlth as reference
nlth_file_path = sprintf("%s/nlth_upper_bound_fmin%g_fmax%g_damp%g_amax%g.csv", ...
                         directory,f_min,f_max,delta_amp,amplitude_max);
nlth_upper_bound = readmatrix(nlth_file_path);

%% plot dnl and dof by shapes

fa_all = []; % init variable to collect fA points for all shapes

% iterate over shapes
for s_idx = 1:length(shapes)

    % open file for storing the fA points for tests of given shape
    if ~use_largest_fa_only % default to use all fA points
        fa_file_path = sprintf("%s%s-fa-points.csv",directory,shapes(s_idx));
    else
        fa_file_path = sprintf("%s%s-fa-points-largest-only.csv",directory,shapes(s_idx));
    end
    fa_points = readmatrix(fa_file_path);
    fa_all = [fa_all; fa_points]; %#ok<AGROW>
    lin_indexes = fa_points(:,3)<nl_threshold; % filter out points that show non linear behaviour
    % saturate dnl and dof
    dnl = min(fa_points(:,3),nl_threshold);
    dof = min(fa_points(:,4),1);

    % figure by shapes
    figure(1)
    subplot(length(shapes),2,s_idx*2-1)
    hold on
    scatter(fa_points(:,1),fa_points(:,2),dot_size,'filled','CData',dnl)
    plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
    plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
    hold off
    colorbar
    title(shapes(s_idx))
    ylabel('Amplitude')
    xlim([f_min_plot, f_max_plot])
    ylim([0 7])
    clim([0,nl_threshold])
    grid on
    set(gca,'xscale','log')
    set(gca,'yscale','log')

    % degree of filtering over freuqnecies plot (by shape)
    figure(3)
    subplot(length(shapes),1,s_idx)
    grid on
    hold on
    plot([f_min_plot, f_max_plot],[0.5,0.5],'--r')
    scatter(fa_points(lin_indexes,1),1-dof(lin_indexes),dot_size,'filled','black')
    xlim([f_min_plot, f_max_plot])
    hold off
    
end % iteration over shapes

% add titles and labels
figure(3)
xlabel('Frequency')
subplot(length(shapes),1,1)
title('Degree of filtering over frequencies')

%% plot dnl and dof all shapes together
lin_indexes_all = fa_all(:,3)<nl_threshold; % filter out points that show non linear behaviour
dnl_all = min(fa_all(:,3),nl_threshold);
dof_all = min(fa_all(:,4),1);

% dnl plot for all shapes on right-hand side of figure
figure(1)
sgtitle('Degree of Non-Linearity')
subplot(length(shapes),2,2*length(shapes)-1)
xlabel('Frequency')
subplot(1,2,2)
hold on
scatter(fa_all(:,1),fa_all(:,2),dot_size,'filled','CData',dnl_all)
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
hold off
colorbar
title('Degree of Non-Linearity: all shapes together')
xlabel('Frequency')
ylabel('Amplitude')
xlim([f_min_plot, f_max_plot])
ylim([0 7])
clim([0,nl_threshold])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
colormap('jet')

figure(2)
hold on
scatter(fa_all(lin_indexes_all,1),fa_all(lin_indexes_all,2),dot_size,'filled','CData',dof_all(lin_indexes_all))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
hold off
colorbar
xlabel('Frequency')
title('Degree of Filtering: all shapes together')
xlim([f_min_plot, f_max_plot])
ylim([0 7])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
colormap('jet')

% dnl plot for all shapes on right-hand side of figure
figure(5)
subplot(1,4,1) % plot actuator saturation
title('actuator saturation')
hold on
scatter(fa_all(:,1),fa_all(:,2),dot_size,'filled','CData',fa_all(:,5))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
hold off
colorbar
xlabel('Frequency')
ylabel('Amplitude')
xlim([f_min_plot, f_max_plot])
ylim([0 7])
% clim([0,nl_threshold])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
colormap('jet')

subplot(1,4,2) % plot sensor saturation
title('sensor saturation')
hold on
scatter(fa_all(:,1),fa_all(:,2),dot_size,'filled','CData',fa_all(:,6))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
hold off
colorbar
xlabel('Frequency')
ylabel('Amplitude')
xlim([f_min_plot, f_max_plot])
ylim([0 7])
% clim([0,nl_threshold])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
colormap('jet')

subplot(1,4,3) % plot actuator saturation
title('input non linearity')
hold on
scatter(fa_all(:,1),fa_all(:,2),dot_size,'filled','CData',fa_all(:,7))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
hold off
colorbar
xlabel('Frequency')
ylabel('Amplitude')
xlim([f_min_plot, f_max_plot])
ylim([0 7])
% clim([0,nl_threshold])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
colormap('jet')

subplot(1,4,4) % plot sensor saturation
title('friction non linearity')
hold on
scatter(fa_all(:,1),fa_all(:,2),dot_size,'filled','CData',fa_all(:,8))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,2))
plot(nlth_upper_bound(:,1), nlth_upper_bound(:,3))
hold off
colorbar
xlabel('Frequency')
ylabel('Amplitude')
xlim([f_min_plot, f_max_plot])
ylim([0 7])
% clim([0,nl_threshold])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
colormap('jet')
