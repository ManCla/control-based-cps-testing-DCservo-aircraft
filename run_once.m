%{
Script to run run one specific test. Results are stored in csv file in
target directory and can be displayed with the plotting script.
%}

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

%% test case definition
shape = 'steps';
amplitude = 5;
time_scaling = 0.1;
[reference, test_duration] = generate_input_sequence( ...
        shape, amplitude, time_scaling,num_periods, sampling_time, settle_time);

%% test execution

sim_output = sim('DCservo.slx');
test_results = [sim_output.data.time, sim_output.data.data]; % output traces extraction

%% write traces to csv
file_path = sprintf('%s%s-%g-%g.csv',data_directory,shape,amplitude,time_scaling);
writematrix(test_results,file_path)
