function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
global hidden_neure_count_s N;
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = hidden_neure_count_s+1;
sizes.NumInputs      = 5*N;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys=simsizes(sizes);

x0 = [];
str=[];
ts=[-1 0];


function sys=mdlOutputs(t,x,u)
global  V0_s hidden_neure_count_s N;

dtheta1 = u(1:(N));
dtheta2 = u((N + 1):(2*N));
controlu1 = u((2*N + 1):(3*N));
controlu2 = u((3*N + 1):(4*N));
dq = u((4*N + 1):(5*N));

input_x = [1 controlu1' controlu2']'; %

Vx = V0_s' * input_x;

phi = zeros(hidden_neure_count_s + 1,1);
phi(1,:) = 1;
for i=1:hidden_neure_count_s
    phi(i + 1,:) = (1 / (1 + exp(- Vx(i,:))));
end

sys(1:(hidden_neure_count_s+1)) = phi;


