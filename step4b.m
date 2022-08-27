%{
Implement step 4 of apporach.
We want to display:
 - fA plot with degre of non-linearity
 - fA plot with degre of non-linearity by shapes
 - fA plot with ground truth of non-linear phenomena
 - fA plot with degre of filtering
 - plot of degree of filtering over the frequencies

% For each fA point: [freq,amp,dnl,dof,nl_ground truth]

%}

dot_size = 8; % size of dots in all scatter plot

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
    ylabel(shapes(s_idx))
    ylim([0 7])
    grid on
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    subplot(length(shapes),2,s_idx*2)
    scatter(fa_points(lin_indexes,1),fa_points(lin_indexes,2),dot_size,'filled','CData',dof(lin_indexes))
    ylim([0 7])
    grid on
    set(gca,'xscale','log')
    set(gca,'yscale','log')

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

%% plot dnl and dof all shapes together
lin_indexes = fa_all(:,3)<nl_threshold; % filter out points that show non linear behaviour
dnl = min(fa_all(:,3),nl_threshold);
dof = min(fa_all(:,4),1);

figure(2)
subplot(1,2,1)
scatter(fa_all(:,1),fa_all(:,2),dot_size,'filled','CData',dnl)
xlabel('Frequency')
ylabel('Amplitude')
title('Degre of Non-Linearity')
ylim([0 7])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
subplot(1,2,2)
scatter(fa_all(lin_indexes,1),fa_all(lin_indexes,2),dot_size,'filled','CData',dof(lin_indexes))
xlabel('Frequency')
title('Degre of Filtering')
ylim([0 7])
grid on
set(gca,'xscale','log')
set(gca,'yscale','log')
