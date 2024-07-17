%{
Main script to run the DC servo case study.
This script simply calls in sequence the various scripts implementing the
testing approach, after the appropriate initialisation script.
At the end it calls the plotting script that shows the same figures as in
the paper.
%}

disp("#############################################")
disp("# Running Lightweight Aircraft test subject #")
disp("#############################################")
LWaltitude_init
disp("#########")
disp("# Step1 #")
disp("#########")
step1
disp("#########")
disp("# Step2 #")
disp("#########")
step2
disp("#########")
disp("# Step3 #")
disp("#########")
step3a_testExecution
step3b_testAnalysis
close all % close figures opened by previous scripts
step3c_visualisation_paper_figures_lwAltitude
