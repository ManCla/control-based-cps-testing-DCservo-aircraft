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
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % NOTE: this is VERY IMPORTANT to reset static variables of C functions
        %       used by the C-Caller block.
        % NOTE: when simulink model is run via a script this is displayed to
        %       console: which is what you want.
        annoying_cache_file = 'slprj/_slcc/HUH6K2GxVF55s087k61dbD/HUH6K2GxVF55s087k61dbD_cclib.dylib';
        if isfile(annoying_cache_file)
            delete(annoying_cache_file)
        else
            disp("Cannot find annoying simulink cached file!")
            disp("--Either this is a first simulation or it has changed name")
            disp("--In the latter case YOU HAVE TO UPDATE ITS NAME or")
            disp("--all tests will have wrong initialization.")
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        options = simset('SrcWorkspace','current'); % use current scope instead of global
                                                    % one because Simulink by
                                                    % default uses that one...!?
        sim_output = sim('DCservo.slx',[],options); % call simulink model
        test_results = [sim_output.data.time, sim_output.data.data]; % output traces extraction
        writematrix(test_results,test_file_path) % store test rresults in csv file
    else
        disp('-- Test already executed!')
        test_results = readmatrix(test_file_path); % read stored data
    end
end
