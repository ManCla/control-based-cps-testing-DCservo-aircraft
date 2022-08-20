
% path containig the simulink model
addpath('model/');

%% variables for readable naming
% NOTE: the values are actually important as they are used for routing by
%       the Multi-Port Switch simulink block.
inl_none      = 0; % no input non-linearity
inl_dead_zone = 1; % dead-zone input non-linearity
inl_backlash  = 2; % backlash input non-linearity

fnl_linear    = 0; % linear friction
fnl_quadratic = 1; % quadratic friction
fnl_coulomb   = 2; % coulomb friction (static+linear)

%% test parameters

input_non_linearity = inl_none;
friction_non_linearity = fnl_linear;

% check if we have both input and friction non-linearities
if input_non_linearity~=0 && friction_non_linearity~=0
    disp('Are you sure you want to apply two non-linearities at once?')
end

%% test execution

test_results = sim('DCservo.slx').data;

plot(test_results)
