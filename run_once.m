
addpath('model/')   % path containig the simulink model
addpath('testing')  % path for implementation of testing approach

%% variables for readable naming
% NOTE: the actual values are important as they are used for routing by
%       the Multi-Port Switch simulink block.
inl_none      = 0; % no input non-linearity
inl_dead_zone = 1; % dead-zone input non-linearity
inl_backlash  = 2; % backlash input non-linearity

fnl_linear    = 0; % linear friction
fnl_quadratic = 1; % quadratic friction
fnl_coulomb   = 2; % coulomb friction (static+linear)

%% test parameters

num_periods = 5;      % number of input periods included in test
sampling_time = 0.05; % should be taken from SUT
settle_time = 5;      % extra time in test for allowing for transients

input_non_linearity = inl_none;
friction_non_linearity = fnl_linear;

% check if we have both input and friction non-linearities
if input_non_linearity~=0 && friction_non_linearity~=0
    disp('Are you sure you want to apply two non-linearities at once?')
end

% reference definition
shape = 'steps';
amplitude = 5;
time_scaling = 0.1;
[reference, test_duration] = test_case(shape, amplitude, time_scaling,...
                                       num_periods, sampling_time, settle_time);

%% test execution

sim_output = sim('DCservo.slx');
test_results = sim_output.data; % output traces extraction

% plot results
figure(2)
plot(test_results)
