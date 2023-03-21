%{
Function that implements the search along the frequency axis.
It takes the current state of the upperbound thereshold and looks for gaps
larger than delta_amp. If found it samples between the twoi samples (in the
middle). Otherwise it returns zero.
%}

function freq_to_sample = sample_frequency(nlth_upper_bound, delta_amp,freq_resolution)
    i = 1;
    freq_to_sample  = 0;
    while i<length(nlth_upper_bound(:,1)) % iterate over frequencies that have already been sampled
        % if frequency gap larger than maximum frequency resolution
        if (nlth_upper_bound(i+1,1)-nlth_upper_bound(i,1))>freq_resolution
            % use middle of upper and lower bounds of estimated upper bound
            a_avg_prev = (nlth_upper_bound(i  ,3) + nlth_upper_bound(i  ,2))/2;
            a_avg_next = (nlth_upper_bound(i+1,3) + nlth_upper_bound(i+1,2))/2;
            if abs(a_avg_prev-a_avg_next)>delta_amp % if you found a large enough gap return middle freq
                freq_to_sample  = (nlth_upper_bound(i+1,1) + nlth_upper_bound(i,1))/2;
                return
            end
        end
        i=i+1;
    end
    % if you get here it means that there are no gaps larger than delta_amp
    % and you want to return 0 
end
