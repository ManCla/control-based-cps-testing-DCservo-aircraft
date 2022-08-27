%% moved this to run_single_test function
% % NOTE: this is VERY IMPORTANT to reset static variables of C functions
% %       used by the C-Caller block.
% % NOTE: when simulink model is run via a script this is displayed to
% %       console: which is what you want.
% annoying_cache_file = 'slprj/_slcc/HUH6K2GxVF55s087k61dbD/HUH6K2GxVF55s087k61dbD_cclib.dylib';
% if isfile(annoying_cache_file)
%     delete(annoying_cache_file)
% else
%     disp("Cannot find annoying simulink cached file!")
%     disp("--Either this is a first simulation or it has changed name")
%     disp("--In the latter case YOU HAVE TO UPDATE ITS NAME or")
%     disp("--all tests will have wrong initialization.")
% end

%% sampling time of control loop
% used in ZOH of reference generator and A/D converter
ctrl_loop_sampling_time=0.05; % 50[ms]

%% non-linearities parameters
% quite large for now so that they appear clearly

dead_zone_half_width = 0.3; % this is HALF of the width size
deadband_width = 0.3;       % this is the WHOLE width size

% negative sign of friction parameters is implemented in simulink
linear_friction = 0.12;
quad_friction   = 0.03;
coulomb_static  = 1;
coulomb_linear  = 0.12;

%% A/D and D/A parameters

% number of bits
n_bits=10;
max_int10=2^(n_bits-1);

% volts of the power source
volts=10;

% conversion from int16_t in [+511,-512] to Volt in [+10,-10]
int_to_volt=volts/max_int10;
% conversion from Volt in [+10,-10] to int16_t in [+511,-512] 
volt_to_int=max_int10/volts;

% frequency of triangular wave for PWM
Tpwm=0.05;     %[Hz]
TfilterPWM=140; % time constant of analog filter
fo=[1/TfilterPWM 1];
afDen=conv(fo,fo);

%% DC model parameters

% process matrices
A=[0 0; 1 0]; % matrix element A(1,1) is implemented in simulink to allow
              % non-linear friction model
B=[5*2.25; 0]*max_int10/10;
C=eye(2);
D=[0;0];
