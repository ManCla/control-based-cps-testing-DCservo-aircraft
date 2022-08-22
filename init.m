%{
Initialization script.
%}

close all
clear all


%% initialize and define paths

addpath('model')   % path containig the simulink model
addpath('testing')  % path for implementation of testing approach

dir_params.data_directory = 'dcServo_test_data';

%% variables for readable naming
% NOTE: the actual values are important as they are used for routing by
%       the Multi-Port Switch simulink block.
inl_none      = 0; % no input non-linearity
inl_dead_zone = 1; % dead-zone input non-linearity
inl_backlash  = 2; % backlash input non-linearity

fnl_linear    = 0; % linear friction
fnl_quadratic = 1; % quadratic friction
fnl_coulomb   = 2; % coulomb friction (static+linear)

% string names of non linearities to separate data of different SUTs
% (where the different SUTs in this case are always the DC-servo but with
% different types of non-linearities)
% used also (only?) for directory generation
dir_params.inl_names = ["inl_none", "inl_dead_zone", "inl_backlash"];
dir_params.fnl_names = ["fnl_linear", "fnl_quadratic", "fnl_coulomb"];
