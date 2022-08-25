%{
Initialization script.
%}

close all
clear all

%% initialize and define paths

addpath('model')   % path containig the simulink model
addpath('testing')  % path for implementation of testing approach

dir_params.data_directory = 'dcServo_test_data';
% string names of non linearities to separate data of different SUTs
% (where the different SUTs in this case are always the DC-servo but with
% different types of non-linearities)
% used also (only?) for directory generation
dir_params.inl_names = ["inl_none", "inl_dead_zone", "inl_backlash"];
dir_params.fnl_names = ["fnl_linear", "fnl_quadratic", "fnl_coulomb"];

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

%% testing parameters

num_periods = 5;      % number of input periods included in test
sampling_time = 0.05; % should be taken from SUT
settle_time = 5;      % extra time in test for allowing for transients

% struct containing the parameters that trigger the different types of
% non-linearity in the DCservo simulink model
sut_nl.input_non_linearity = inl_none;
sut_nl.friction_non_linearity = fnl_linear;

% check if we have both input and friction non-linearities
if sut_nl.input_non_linearity~=0 && sut_nl.friction_non_linearity~=0
    disp('Are you sure you want to apply two non-linearities at once?')
end
