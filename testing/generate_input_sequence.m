%{
Function that computres the test-case duration and reference matrix for a
given test case.
A test case is defined by:
    - shape
    - amplitude
    - time_scale
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

function [reference, test_duration] = generate_input_sequence( ...
            shape, amplitude, time_scale, num_periods, sample_time, settle)

    period_duration = 1 / time_scale;
    test_duration   = period_duration * num_periods + settle;
    num_samples     = floor(test_duration/sample_time) + 1;
    time_vector     = linspace(0,test_duration,num_samples);

    switch shape
        case 'sinus'
            ref = amplitude.*arrayfun(@sinus, time_scale*time_vector);
        case 'steps'
            ref = amplitude.*arrayfun(@steps, time_scale*time_vector);
        case 'ramp'
            ref = amplitude.*arrayfun(@ramp, time_scale*time_vector);
        case 'trapezoidal'
            ref = amplitude.*arrayfun(@trapezoidal, time_scale*time_vector);
        case 'triangular'
            ref = amplitude.*arrayfun(@triangular, time_scale*time_vector);
        otherwise
            disp('ERROR: input shape not found')
    end

    reference = [time_vector', ref'];

end



%%%%%%%%%%%%%%%%%%%%%%%
%%% SHAPE FUNCTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%

function shapes = get_shapes_list()
    shapes = ['steps', 'ramp', 'trapezoidal', 'triangular', 'sinus'];
end

function val = sinus(t)
    val = sin(t*(2*pi));
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

