%{
Function that given one signal and two bounds computes the percentage of
samples in the signal trace that the signal is hitting the bounds
%}

function percentage = saturation_percentage(signal)

    % Function parameters: saturation bounds
    actuation_min = -10;
    actuation_max = 10;
    resolution = 0.01;

    samples_number = length(signal);
    min_sat_samples = sum(signal<actuation_min+resolution);
    max_sat_samples = sum(signal>actuation_max-resolution);
    percentage = (min_sat_samples+max_sat_samples)/samples_number;
end