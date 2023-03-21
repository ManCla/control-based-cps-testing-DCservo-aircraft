close all
clear all

%{
Initialization script for the LWaircraft altitude control case of study.
Only assignments and small input sanity checks can go in here.
It initializes:
 - paths
 - non linearites namings
 - SUT non linearities
 - testing approach parameters
 - data directories
%}

%% initialize paths

addpath('models/LWaltitude/')  % path containig the simulink model
addpath('testing')          % paths for implementation of testing approach
addpath('testing/analysis')
addpath('testing/utils')
addpath('testing/approach/')

%% variables for readable naming
% we do not inject nonlinearities in the lightweight aircraft altitude
% control case of study, hence here the only options are to keep the model
% as is it. The functionality is kept for consistency with the other case
% of studies (and in case we want to add them in future instances of the
% exprimental evaluation).
% NOTE: the actual values are important as they are used for routing by
%       the Multi-Port Switch simulink block. Alsu ised for indexing to the
%       vectors od strings above-used for directories storing test data.
inl_as_model = 0; %
fnl_as_model = 0; %

%% test case for preliminary evaluation
preliminary_test_case_shape = 'sinus';
preliminary_test_case_amplitude = 750;
preliminary_test_case_time_scaling = 0.5;

%% testing apporach parameters

num_periods = 10;      % number of input periods included in test
sampling_time = 0.05;  % used for logging
settle_time = 50;      % extra time in test for allowing for transients

nl_threshold = 0.15;  % threshold on dnl above which we consider the teest
                      % to behave non-linearly

% when true 0Hz are excluded from the input amp normalization used for the
% main frequnecy components and the dnl. this is usefull when inputs
% require a large offset (e.g. hovering altitude) that would exclude 
% practically all components and always reduce the dnl to very small values 
exclude_zeroHz_in_normalization = true;

% struct containing the parameters that trigger the different types of
% non-linearity. Not used in the LWaltitude as of now.
sut_nl.input_non_linearity = inl_as_model;
sut_nl.friction_non_linearity = fnl_as_model;
% check if we have both input and friction non-linearities
if sut_nl.input_non_linearity~=0 && sut_nl.friction_non_linearity~=0
    disp('Are you sure you want to apply two non-linearities at once?')
end

% shapes list (note that it excludes the sinus shape as that is always necessary)
shapes = ["steps", "ramp", "trapezoidal", "triangular"];

f_min = 0.005;           % frequency range min
f_max = 0.5;             % frequency range max
freq_resolution = 0.01;  % freq resolution to uniformly sample in test case generation
amplitude_max = 750;     % ampliltude bound
delta_amp = 5;           % amplitude resolution

%% subdirectory name for given type of non-linearity

dir_params.data_directory = sprintf('lwAltitude_test_data_%dperiods',num_periods);
% string names of non linearities to separate data of different instances
% of the SUT.
% used also (only?) for directory generation
dir_params.inl_names = ["inl_as_model"];
dir_params.fnl_names = ["fnl_as_model"];
% Name of Function to execute one test
% while this seems totally unnecessary, it is due to the mess that Simulink
% does when executing C code that forced us to implement a custom
% run_single_test function for the DC servo (and hence for each case of
% study). More in general a given case of study might require specific
% initializations.
dir_params.run_single_test_fcn = 'LWaltitude_run_single_test';

directory = sprintf('%s/%s-%s/',dir_params.data_directory, ...
                                dir_params.inl_names(sut_nl.input_non_linearity+1), ...
                                dir_params.fnl_names(sut_nl.friction_non_linearity+1));

%% printout
fprintf('Initialized LightWeight aicraft altitude control case of study\n');
