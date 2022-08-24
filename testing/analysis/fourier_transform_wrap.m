%{
Wrapper function for the fast fourier transform that returns directly the
amplitudes and the frequencies.
%}
function [frequencies, amplitudes] = fourier_transform_wrap(signal, dt)

    num_samples   = length(signal); % number of samples in signal and fft is equal
    test_duration = num_samples*dt; % test duration in seconds
    % compute frequencies vector (half since transform is symmetric)
    frequencies = (1/test_duration)*(0:(num_samples/2));
    % compute fft
    amplitudes = abs(fft(signal)/num_samples); % compute abs of fft and normalize over numb of samples
    % spectrum is symmetric, transpose for consistency with freqs
    amplitudes = amplitudes(1:floor(num_samples/2)+1)';

end