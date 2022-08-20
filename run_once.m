
% path containig the simulink model
addpath('model/');

%% variables for readable naming
% NOTE: the values are actually important as they are used for routing by
%       the Multi-Port Switch simulink block.
inl_none      = 0; % no input non-linearity
inl_dead_zone = 1; % dead-zone input non-linearity
inl_backlash  = 2; % backlash input non-linearity


%% test parameters

input_non_linearity = inl_backlash;

%% test execution

test_results = sim('DCservo.slx').data;

plot(test_results)
