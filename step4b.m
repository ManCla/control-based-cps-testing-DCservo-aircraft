%{
Implement step 4 of apporach.
We display:
 (Fig.1)   fA plot with non-linearity and filtering degree by shapes
 (Fig.2)   fA plot with non-linearity and filtering degree
 (Fig.3)   plot of degree of filtering over the frequencies
 - fA plot with ground truth of non-linear phenomena
 
% For each fA point: [freq,amp,dnl,dof,nl_ground truth]

%}

%% some plotting parameters
clf(3)
dot_size = 8; % size of dots in all scatter plot
f_min_plot = f_min;
f_max_plot = 10;

%% plot dnl and dof by shapes

fa_all = [];

% iterate over shapes
for s_idx = 1:length(shapes)

    % open file for storing the fA points
    fa_file_path = sprintf("%s%s-fa-points.csv",directory,shapes(s_idx));
    fa_points = readmatrix(fa_file_path);
    fa_all = [fa_all; fa_points];
    lin_indexes = fa_points(:,3)<nl_threshold; % filter out points that show non linear behaviour
    dnl = 0.15-min(fa_points(:,3),nl_threshold);
    dof = min(fa_points(:,4),1);

    figure(1)
    subplot(length(shapes),2,s_idx*2-1)
    scatter(fa_points(:,1),fa_points(:,2),dot_size,'filled','CData',dnl)
    colorbar
    ylabel(shapes(s_idx))
    xlim([f_min_plot, f_max_plot])
    ylim([0 7])
    grid on
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    subplot(length(shapes),2,s_idx*2)
    scatter(fa_points(lin_indexes,1),fa_points(lin_indexes,2),dot_size,'filled','CData',dof(lin_indexes))
    colorbar
    ylim([0 7])
    xlim([f_min_plot, f_max_plot])
    grid on
    set(gca,'xscale','log')
    set(gca,'yscale','log')

    figure(3)
    subplot(length(shapes),1,s_idx)
    grid on
    hold on
    plot([f_min_plot, f_max_plot],[0.5,0.5],'--r')
    scatter(fa_points(lin_indexes,1),1-dof(lin_indexes),dot_size,'filled','black')
    xlim([f_min_plot, f_max_plot])
    hold off
    
end % iteration over shapes

figure(1)
subplot(length(shapes),2,1)
title('Degre of Non-Linearity')
subplot(length(shapes),2,2)
title('Degre of Filtering')
subplot(length(shapes),2,2*length(shapes)-1)
xlabel('Frequency')
subplot(length(shapes),2,2*length(shapes))
xlabel('Frequency')
colormap('jet')

figure(3)
xlabel('Frequency')
subplot(length(shapes),1,1)
title('Degree of filtering over frequencies')

%% plot dnl and dof all shapes together
lin_indexes = fa_all(:,3)<nl_threshold; % filter out points that show non linear behaviour
dnl = min(fa_all(:,3),nl_threshold);
dof = min(fa_all(:,4),1);

figure(2)
subplot(1,2,1)
scatter(fa_all(:,1),fa_all(:,2),dot_size,'filled','CData',dnl)
colorbar
xlabel('Frequency')
ylabel('Amplitude')
title('Degre of Non-Linearity')
xlim([f_min_plot, f_max_plot])
ylim([0 7])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
subplot(1,2,2)
scatter(fa_all(lin_indexes,1),fa_all(lin_indexes,2),dot_size,'filled','CData',dof(lin_indexes))
colorbar
xlabel('Frequency')
title('Degre of Filtering')
xlim([f_min_plot, f_max_plot])
ylim([0 7])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
colormap('jet')
