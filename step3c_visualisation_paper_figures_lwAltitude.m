%{
Generate same figures as in paper
For each fA point: [freq,amp,dnl,dof,sat_actuation_perc,sat_sensor_perc,input_nl_avg,friction_nl_avg]

%}

%% plotting options
dot_size = 8;            % size of dots in all scatter plot


%% open ile containing sinusoidal based upperbound of nonlinear threshold
% this is used for  plotting the nlth as reference
nlth_file_path = sprintf("%s/nlth_upper_bound_fmin%g_fmax%g_damp%g_amax%g.csv", ...
                         directory,f_min,f_max,delta_amp,amplitude_max);
nlth_upper_bound = readmatrix(nlth_file_path);

%% plot dnl and dof by shapes

fa_all = []; % init variable to collect fA points for all shapes

% iterate over shapes
for s_idx = 1:length(shapes)

    % open files storing the fA points for tests of given shape
    fa_file_path_all = sprintf("%s%s-fa-points.csv",directory,shapes(s_idx));
    fa_file_path_main_component = sprintf("%s%s-fa-points-largest-only.csv",directory,shapes(s_idx));
    
    fa_points_all_components = readmatrix(fa_file_path_all);
    fa_points_main_component = readmatrix(fa_file_path_main_component);
    fa_all = [fa_all; fa_points_main_component]; %#ok<AGROW>
    lin_indexes = fa_points_all_components(:,3)<nl_threshold; % filter out points that show non linear behaviour
    % saturate dnl and dof
    dnl_main_component = min(fa_points_main_component(:,3),nl_threshold);
    dof_all_components = min(fa_points_all_components(:,4),1);

    % figure by shapes
    figure(1)
    subplot(1,length(shapes),s_idx)
    hold on
    scatter(fa_points_main_component(:,1),fa_points_main_component(:,2),dot_size,'filled','CData',dnl_main_component)
    hold off
    colorbar
    title(shapes(s_idx))
    ylabel('Amplitude')
    xlim([f_min_plot, f_max_plot])
    ylim([amp_min_plot amp_max_plot])
    clim([0,nl_threshold])
    grid on
    set(gca,'xscale','log')
    set(gca,'yscale','log')

    % degree of filtering over freuqnecies plot (by shape)
    figure(3)
    subplot(1,length(shapes),s_idx)
    grid on
    hold on
    plot([f_min_plot, f_max_plot],[0.5,0.5],'--r')
    scatter(fa_points_all_components(lin_indexes,1),dof_all_components(lin_indexes),dot_size,'filled','black')
    xlim([f_min_plot, f_max_plot])
    title(shapes(s_idx))
    hold off
    
end % iteration over shapes

% add titles and labels
figure(3)
xlabel('Frequency')
sgtitle('Fig. 19: Degree of filtering over frequencies -- Lightweight Aircraft')

figure(1)
xlabel('Frequency')
sgtitle('Fig. 18: dnl  -- Lightweight Aircraft')

%% plot dnl and dof all shapes together
lin_indexes_all = fa_all(:,3)<nl_threshold; % filter out points that show non linear behaviour
dnl_all = min(fa_all(:,3),nl_threshold);
dof_all = min(fa_all(:,4),1);

% plot actuator saturation
figure(5)
title('Fig. 12b: Actuator Saturation -- Lightweight Aircraft')
hold on
scatter(fa_all(:,1),fa_all(:,2),dot_size,'filled','CData',fa_all(:,5))
hold off
colorbar
xlabel('Frequency')
ylabel('Amplitude')
xlim([f_min_plot, f_max_plot])
ylim([amp_min_plot amp_max_plot])
% clim([0,nl_threshold])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
colormap('jet')

