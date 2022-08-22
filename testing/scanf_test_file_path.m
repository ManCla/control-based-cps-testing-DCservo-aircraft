%{
function to parse the path to a test file
%}

function [data_directory,in_nl,fr_nl,test_case] = scanf_test_file_path(test_file_path,dir_params)
    % assumed path formatting is '%s/%s-%s/%s-%g-%g.csv'
    [data_directory,remain] = strtok(test_file_path,'/');
    [tmp,remain] = strtok(remain(2:end),'-');
    in_nl = find(tmp==dir_params.inl_names)-1;
    [tmp,remain] = strtok(remain(2:end),'/');
    fr_nl = find(tmp==dir_params.fnl_names)-1;
    [test_case.shape,remain] = strtok(remain(2:end),'-');
    % next elements need to be formattetd
    [tmp,remain] = strtok(remain(2:end),'-');
    test_case.amplitude = sscanf(tmp,'%f');
    [tmp,remain] = strtok(remain(2:end),'c'); % the dot here creates confusion
    tmp = tmp(1:end-1); % remove the dot of the file extension
    test_case.time_scaling = sscanf(tmp,'%f');
    
    if ~strcmp(remain, 'csv')
        disp('ERROR -- scan_test_file_path: in parsing testfile name')
    end
end
