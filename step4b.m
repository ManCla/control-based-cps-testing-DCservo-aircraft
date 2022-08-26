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

%% actual plotting

% iterate over shapes
for s_idx = 1:length(shapes)

    % open file for storing the fA points
    fa_file_path = sprintf("%s%s-fa-points.csv",directory,shapes(s_idx));
    fa_points = readmatrix(fa_file_path);
    % TODO: filter out points that show non linear behaviour
    dnl = min(fa_points(:,3),nl_threshold);
    dof = min(fa_points(:,4),1);

    figure(1)
    subplot(length(shapes),2,s_idx*2-1)
    scatter(fa_points(:,1),fa_points(:,2),4,'CData',dnl)
    ylabel(shapes(s_idx))
    ylim([0 7])
    grid on
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    subplot(length(shapes),2,s_idx*2)
    scatter(fa_points(:,1),fa_points(:,2),4,'CData',dof)
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
xlabel('frequency')
subplot(length(shapes),2,2*length(shapes))
xlabel('frequency')
