%{
function to run a given test
%}

function test_results = LWaltitude_run_single_test(test_file_path, num_periods, sampling_time, settle_time,dir_params)

    if ~isfile(test_file_path) % run test only if it has not been already executed
        % extract test parameters used to define input
        [~,sut_nl,test_case] = scanf_test_file_path(test_file_path,dir_params); %#ok<ASGLU>
        % NOTE: reference, test_duration are used inside the simulink model
        [reference, test_duration] = generate_input_sequence( ...
            test_case, num_periods, sampling_time, settle_time); %#ok<ASGLU>
        load('asbSkyHoggData.mat')
        options = simset('SrcWorkspace','current'); % use current scope instead of global
                                                    % one because Simulink by
                                                    % default uses that one...!?
        sim_output = sim('asbSkyHogg.slx',[],options); % call simulink model
        % output traces extraction
        test_results = [sim_output.data.time, sim_output.data.data];
        writematrix(test_results,test_file_path) % store test rresults in csv file
    else
        disp('-- Test already executed!')
        test_results = readmatrix(test_file_path); % read stored data
    end
end
