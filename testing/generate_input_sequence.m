%{
Function that computres the test-case duration and reference matrix for a
given test case.
A test case is defined by:
    - shape
    - amplitude
    - time_scaling
OUTPUT:
    - a 2 column matrix [times, values]
    - duration of test (should be equal to times(end)+sampe_time)

To add a shape:
    - add it to list in get_shapes_list function
    - implement function
    - add shape case to swith statement
Shape functions shall be defined over a unit period and have have an
amplitude range of 1 (i.e. max(shape)-min(shape)==1 ).
They also generate a signal centered around 0.
%}

function [reference, test_duration] = generate_input_sequence(test_case, num_periods, sample_time, settle)

    period_duration = 1 / test_case.time_scaling;
    test_duration   = period_duration * num_periods + settle;
    num_samples     = floor(test_duration/sample_time) + 1;
    time_vector     = linspace(0,test_duration,num_samples);

    scaled_time = test_case.time_scaling*time_vector; % time scaling
    switch test_case.shape
        case 'sinus'
            ref = arrayfun(@sinus, scaled_time);
        case 'steps'
            ref = arrayfun(@steps, scaled_time);
        case 'ramp'
            ref = arrayfun(@ramp, scaled_time);
        case 'trapezoidal'
            ref = arrayfun(@trapezoidal, scaled_time);
        case 'triangular'
            ref = arrayfun(@triangular, scaled_time);
        otherwise
            disp('ERROR: input shape not found')
    end
    ref = test_case.amplitude.*ref; % amplitude scaling
    reference = [time_vector', ref'];

end



%%%%%%%%%%%%%%%%%%%%%%%
%%% SHAPE FUNCTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%

function val = sinus(t)
    val = 0.5*sin(t*(2*pi));
end

function val = steps(t)
    period_percentage = mod(t,1);
    if period_percentage<0.5
        val = 0.5;
    else
        val = -0.5;
    end
end

function val = ramp(t)
    val= mod(t+0.5,1)-0.5;
end

function val = trapezoidal(t)
    t = t+0.125; % time shift to avoid jump at start
    period_percentage = mod(t,1);
    % NOTE trapezoidal defined over 0-1 then shifted down by 0.5
    if period_percentage<0.25         % ramp up
        val = (period_percentage)/0.25;
    elseif period_percentage<0.5      % constant high
        val = 1;
    elseif period_percentage<0.75     % ramp down
        val = 1-(period_percentage-0.5)/0.25;
    else
        val = 0;
    end
    val = val-0.5;
end

function val = triangular(t)
    t = t+0.25; % time shift to avoid jump at start
    period_percentage = mod(t,1);
    % NOTE trapezoidal defined over 0-1 then shifted down by 0.5
    if period_percentage<0.5         % ramp up
        val = (period_percentage)/0.5;
    else
        val = 1-(period_percentage-0.5)/0.5;
    end
    val = val-0.5;
end

