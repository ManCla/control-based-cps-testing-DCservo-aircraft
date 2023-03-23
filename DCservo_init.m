close all
clear all

%{
Initialization script for the DC servo case of study.
Only assignments and small input sanity checks can go in here.
It initializes:
 - paths
 - non linearites namings
 - SUT non linearities
 - testing approach parameters
 - data directories
%}

%% initialize paths

addpath('models/DCservo/')  % path containig the simulink model
addpath('testing')          % paths for implementation of testing approach
addpath('testing/analysis')
addpath('testing/utils')
addpath('testing/approach/')

%% variables for readable naming
% NOTE: the actual values are important as they are used for routing by
%       the Multi-Port Switch simulink block. Alsu ised for indexing to the
%       vectors od strings above-used for directories storing test data.
inl_none      = 0; % no input non-linearity
inl_dead_zone = 1; % dead-zone input non-linearity
inl_backlash  = 2; % backlash input non-linearity

fnl_linear    = 0; % linear friction
fnl_quadratic = 1; % quadratic friction
fnl_coulomb   = 2; % coulomb friction (static+linear)

%% test case for preliminary evaluation
preliminary_test_case_shape = 'steps';
preliminary_test_case_amplitude = 20;
preliminary_test_case_time_scaling = 3;

%% testing apporach parameters

num_periods = 7;      % number of input periods included in test
sampling_time = 0.05; % should be taken from SUT
settle_time = 5;      % extra time in test for allowing for transients

nl_threshold = 0.15;  % threshold on dnl above which we consider the teest
                      % to behave non-linearly

% when true 0Hz are excluded from the input amp normalization used for the
% main frequnecy components and the dnl. this is usefull when inputs
% require a large offset (e.g. hovering altitude) that would exclude 
% practically all components and always reduce the dnl to very small values 
exclude_zeroHz_in_normalization = false;

% struct containing the parameters that trigger the different types of
% non-linearity in the DCservo simulink model
sut_nl.input_non_linearity = inl_none;
sut_nl.friction_non_linearity = fnl_linear;
% check if we have both input and friction non-linearities
if sut_nl.input_non_linearity~=0 && sut_nl.friction_non_linearity~=0
    disp('Are you sure you want to apply two non-linearities at once?')
end

% shapes list (note that it excludes the sinus shape as that is always necessary)
shapes = ["steps", "ramp", "trapezoidal", "triangular"];

f_min = 0.005;         %  frequency range min
f_max = 3;             % frequency range max
freq_resolution = 0.1; % freq resolution to uniformly sample in test case generation
amplitude_max = 20;    % ampliltude bound
delta_amp = 0.5;       % amplitude resolution

%% subdirectory name for given type of non-linearity

dir_params.data_directory = sprintf('dcServo_test_data_%dperiods',num_periods);
% string names of non linearities to separate data of different SUTs
% (where the different SUTs in this case are always the DC-servo but with
% different types of non-linearities)
% used also (only?) for directory generation
dir_params.inl_names = ["inl_none", "inl_dead_zone", "inl_backlash"];
dir_params.fnl_names = ["fnl_linear", "fnl_quadratic", "fnl_coulomb"];
% Name of Function to execute one test
% while this seems totally unnecessary, it is due to the mess that Simulink
% does when executing C code that forced us to implement a custom
% run_single_test function for the DC servo (and hence for each case of
% study)
dir_params.run_single_test_fcn = 'DCservo_run_single_test';

directory = sprintf('%s/%s-%s/',dir_params.data_directory, ...
                                dir_params.inl_names(sut_nl.input_non_linearity+1), ...
                                dir_params.fnl_names(sut_nl.friction_non_linearity+1));

%% parameters for plotting
f_min_plot = f_min;
f_max_plot = 3.1;
amp_max_plot = 5;
amp_min_plot = 0.5;

%% printout
fprintf('Non-linearities included are\ninput:    %s\nfriction: %s\n',...
                               dir_params.inl_names(sut_nl.input_non_linearity+1), ...
                               dir_params.fnl_names(sut_nl.friction_non_linearity+1));
