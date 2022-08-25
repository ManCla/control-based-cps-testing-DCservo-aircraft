%{
function to generate the file path of the data of a given test
%}

function test_file_path = printf_test_file_path(sut_nl, test_case, dir_params)

    directory = sprintf('%s/%s-%s/',dir_params.data_directory, ...
                                    dir_params.inl_names(sut_nl.input_non_linearity+1), ...
                                    dir_params.fnl_names(sut_nl.friction_non_linearity+1));
    % check if directory exists, if not, create it
    if not(isfolder(directory))
        mkdir(directory)
    end
    test_file_path = sprintf('%s%s-%g-%g.csv',directory,test_case.shape, ...
                                                        test_case.amplitude, ...
                                                        test_case.time_scaling);
end
