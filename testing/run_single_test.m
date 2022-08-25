%{
function to run a given test
%}

function test_results = run_single_test(test_file_path, num_periods, sampling_time, settle_time,dir_params)

    if ~isfile(test_file_path) % run test only if it has not been already executed
        % extract test parameters used to define input
        [~,sut_nl,test_case] = scanf_test_file_path(test_file_path,dir_params); %#ok<ASGLU>
        % NOTE: reference, test_duration are used inside the simulink model
        [reference, test_duration] = generate_input_sequence( ...
            test_case, num_periods, sampling_time, settle_time); %#ok<ASGLU>
        options = simset('SrcWorkspace','current'); % use current scope instead of global
                                                    % one because Simulink by
                                                    % default uses that one...!?
        sim_output = sim('DCservo.slx',[],options); % call simulink model
        test_results = [sim_output.data.time, sim_output.data.data]; % output traces extraction
    else
        disp('Test already executed!')
        test_results = readmatrix(test_file_path); % read stored data
    end
end
