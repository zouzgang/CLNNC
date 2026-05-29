%% Initalize Environment+

%% 
global is_exp is_cl;

global N D M Mr j jr B b;
global a1 a2 kq1 kq2;

global m1 m2 m3 l1 l2 l3 r1 r2 r3 lc1 lc2 lc3 I1 I2 I3 noise_cov is_noise;

N = 3; %DOF

is_exp = 0; %0:simulation;1:experiment

is_cl = 1;  %0:es;1:cl
is_noise=0; %0:no noise;1:has noise

%% plant 
m1=0.45;m2=0.45;m3=0.45;
l1=0.1;l2=0.1;l3=0.1;r2 = 0.5 * l2;r3 = 0.5 * l3;
lc1=0.05;lc2=0.05;lc3=0.05;
I1=0.0045;I2=0.0045;I3=0.0045;

% motor
j=0.0243;  %0.0243
jr=0.02187;% jr=0.0243;
B=0.01;
b = 0.01;

% elastic parameter the same with plant
a1=8.9995;%8.9995
kq1=0.0026;
a2=8.9989;%8.9989
kq2=0.0011;

if is_noise ==1
    noise_cov = 1e-4; %1e-4  Changing the noise_cov requires modifying the corresponding V0_q V0_s
else
    noise_cov = 0; %
end