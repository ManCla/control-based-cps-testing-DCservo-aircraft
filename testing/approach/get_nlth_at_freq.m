%{
Function that given a nonlinear threshold upper bound and a frequency
evaluates the upper bound at said frequency according to the nonlinear
thresold.
The nonlinear threshold is a [num_samples X 3] matrix where each row
corresponds to one frequency that has been explored and the three columns
are:
    [frequency, a_upper_bound, a_lower_bound]
Note that here the amplitude upper and lower bounds are bound around the
upper bound of the nonlinear threshold generated by the binary search made
with sinusoidal inputs.
%}

function a_bound = get_nlth_at_freq(nlth,freq)
    i=1;
    while nlth(i,1)<freq
        i=i+1;
    end
    if i==size(nlth,1)
        a_bound = nlth(i,3);
    else
        a_bound = min(nlth(i+1,3),nlth(i,3));
    end
end
