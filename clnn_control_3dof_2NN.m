function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1
    sys=mdlDerivatives(t,x,u);
% case 2
%     sys=mdlUpdate(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
global W0_q W0_s hidden_neure_count_q output_dimension_q hidden_neure_count_s output_dimension_s N;
N_wq = output_dimension_q *(hidden_neure_count_q +1);
N_ws = output_dimension_s *(hidden_neure_count_s +1);

sizes = simsizes;
sizes.NumContStates  = N_wq + N_ws; 
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = N_wq + N_ws + 2*(output_dimension_q + output_dimension_s) + 2*N;
sizes.NumInputs      = (14*N + (hidden_neure_count_q +1 ) * (output_dimension_q +1) + (hidden_neure_count_s +1 ) * (output_dimension_s +1));%
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys=simsizes(sizes);

temp = [];
for i = 1:output_dimension_q
    temp =[temp W0_q(i,:)];
end

for i = 1:output_dimension_s
    temp =[temp W0_s(i,:)];
end

x0 = temp;
str=[];
ts=[-1 0];

function sys=mdlDerivatives(t,x,u)

global V0_q V0_s lr_1_q lr_2_q lr_3_q lr_1_s lr_2_s lr_3_s hidden_neure_count_q output_dimension_q hidden_neure_count_s output_dimension_s N is_exp K_1_q K_1_s;

qd = u(1:N);
dqd = u((N+1):(2*N));
dqqd = u((2*N + 1):(3*N));
sd = u((3*N + 1):(4*N));
dsd = u((4*N + 1):(5*N));
q = u((5*N + 1):(6*N));
dq = u((6*N + 1):(7*N));
S = u((7*N + 1):(8*N));
u1 = u((8*N + 1):(9*N));
u2 = u((9*N + 1):(10*N));
dphi1 = u((10*N + 1):(11*N));
dphi2 = u((11*N + 1):(12*N));
w_un_q_filter = u((12*N + 1):(13*N));
w_un_s_filter = u((13*N + 1):(14*N));

N_wq = output_dimension_q *(hidden_neure_count_q +1);
N_ws = output_dimension_s *(hidden_neure_count_s +1);

N_q = (hidden_neure_count_q +1);
N_s = (hidden_neure_count_s +1);

phi_filter_q = u((14*N+1):(14*N + N_q));
Theta_error_vector_q = u((14*N + 1 + N_q):(14*N + N_q + N_wq));
Theta_error_q = reshape(Theta_error_vector_q,(hidden_neure_count_q + 1), output_dimension_q);

phi_filter_s = u((14*N + N_q + N_wq +1):(14*N + N_q + N_wq + N_s));
Theta_error_vector_s = u((14*N + 1 + N_q + N_wq + N_s):(14*N + N_q + N_wq + N_s + N_ws));
Theta_error_s = reshape(Theta_error_vector_s,(hidden_neure_count_s + 1), output_dimension_s);

t0 = clock;

%% W_q  &&  W_s
hat_W_q = zeros(hidden_neure_count_q+1, output_dimension_q);
temp_W_q = x(1:N_wq);
temp_W_matrics_q = reshape(temp_W_q,(hidden_neure_count_q + 1), output_dimension_q);
hat_W_q = temp_W_matrics_q;

hat_W_s = zeros(hidden_neure_count_s+1, output_dimension_s);
temp_W_s = x((1+N_wq):(N_wq + N_ws));
temp_W_matrics_s = reshape(temp_W_s,(hidden_neure_count_s + 1), output_dimension_s);
hat_W_s = temp_W_matrics_s;


%% phi_q  && phi_s
input_x_q = [1 q' dq' u1' u2']';
Vx_q = V0_q' * input_x_q;
phi_q = zeros(hidden_neure_count_q + 1,1);
phi_q(1,:) = 1;
for i=1:hidden_neure_count_q
    phi_q(i + 1,:) = (1 / (1 +exp(- Vx_q(i,:))));
end

input_x_s = [1 u1' u2']';
Vx_s = V0_s' * input_x_s;
phi_s = zeros(hidden_neure_count_s + 1,1);
phi_s(1,:) = 1;
for i=1:hidden_neure_count_s
    phi_s(i + 1,:) = (1 / (1 +exp(- Vx_s(i,:))));
end

%%
w_hat_filter_q = (phi_filter_q' * hat_W_q)';
w_hat_filter_s = (phi_filter_s' * hat_W_s)';

%w_un_filter = [w_un_q_filter; w_un_s_filter];  %w_un_filter = [w_un_q_filter; w_un_s_filter];

epsion_q = w_un_q_filter - w_hat_filter_q;
epsion_s = w_un_s_filter - w_hat_filter_s;

e_s_q = K_1_q *(qd -q) + (dqd - dq);

e_S = sd - S;
% e_s = [e_s_q; e_stiff];  %e_s = [e_s_q; e_stiff];

%% dot W
dot_hat_W_q = zeros(hidden_neure_count_q + 1, output_dimension_q);
% temp_W_q = x(1:output_dimension_q*(hidden_neure_count_q+1));
dot_hat_W_q = (lr_1_q * phi_filter_q * epsion_q' + lr_2_q * Theta_error_q - lr_3_q * phi_q * e_s_q');
dot_hat_W_vector_q = reshape(dot_hat_W_q,output_dimension_q * (hidden_neure_count_q + 1),1);

dot_hat_W_s = zeros(hidden_neure_count_s+1, output_dimension_s);
dot_hat_W_s = (lr_1_s * phi_filter_s * epsion_s' + lr_2_s * Theta_error_s - lr_3_s * phi_s * e_S');
dot_hat_W_vector_s = reshape(dot_hat_W_s, output_dimension_s * (hidden_neure_count_s + 1),1);


%% sys
sys(1:N_wq) = dot_hat_W_vector_q;
sys((N_wq +1):(N_wq + N_ws)) = dot_hat_W_vector_s;


function sys=mdlOutputs(t,x,u)
global V0_q V0_s hidden_neure_count_q output_dimension_q hidden_neure_count_s output_dimension_s N M K_1_q K_c_q K_c_s;

qd = u(1:N);
dqd = u((N+1):(2*N));
dqqd = u((2*N + 1):(3*N));
sd = u((3*N + 1):(4*N));
dsd = u((4*N + 1):(5*N));
q = u((5*N + 1):(6*N));
dq = u((6*N + 1):(7*N));
S = u((7*N + 1):(8*N));
u1 = u((8*N + 1):(9*N));
u2 = u((9*N + 1):(10*N));
dd = u((10*N + 1):(11*N));
dphi2 = u((11*N + 1):(12*N));

w_un_q_filter = u((12*N + 1):(13*N));
w_un_s_filter = u((13*N + 1):(14*N));

N_wq = output_dimension_q *(hidden_neure_count_q +1);
N_ws = output_dimension_s *(hidden_neure_count_s +1);

N_q = (hidden_neure_count_q +1);
N_s = (hidden_neure_count_s +1);

phi_filter_q = u((14*N + 1):(14*N + N_q));
% Theta_error_vector_q = u((12*N + 1 + N_q):(12*N + N_q + N_wq));
% Theta_error_q = reshape(Theta_error_vector_q,(hidden_neure_count_q + 1), output_dimension_q);
% 
phi_filter_s = u((14*N + N_q + N_wq +1):(14*N + N_q + N_wq + N_s));
% Theta_error_vector_s = u((12*N + 1 + N_q + N_wq + N_s):(12*N + N_q + N_wq + N_s + N_ws));
% Theta_error_s = reshape(Theta_error_vector_s,(hidden_neure_count_s + 1), output_dimension_s);

%% W_q  &&  W_s
hat_W_q = zeros(hidden_neure_count_q + 1, output_dimension_q);
temp_W_q = x(1:N_wq);
temp_W_matrics_q = reshape(temp_W_q, (hidden_neure_count_q + 1), output_dimension_q);
hat_W_q = temp_W_matrics_q;
% W_q_end = temp_W_matrics_q;

hat_W_s = zeros(hidden_neure_count_s + 1, output_dimension_s);
temp_W_s = x((1 + N_wq):(N_wq + N_ws));
temp_W_matrics_s = reshape(temp_W_s,(hidden_neure_count_s + 1), output_dimension_s);
hat_W_s = temp_W_matrics_s;
% W_s_end = temp_W_matrics_s;

%% phi_q  && phi_s
input_x_q = [1 q' dq' u1' u2']';
Vx_q = V0_q' * input_x_q;
phi_q = zeros(hidden_neure_count_q + 1,1);
phi_q(1,:) = 1;
for i=1:hidden_neure_count_q
    phi_q(i + 1,:) = (1 / (1 + exp(- Vx_q(i,:))));
end

input_x_s = [1 u1' u2']';
Vx_s = V0_s' * input_x_s;
phi_s = zeros(hidden_neure_count_s + 1,1);
phi_s(1,:) = 1;
for i=1:hidden_neure_count_s
    phi_s(i + 1,:) = (1 / (1 +exp(- Vx_s(i,:))));
end


%%
w_un_hat_q = (phi_q' * hat_W_q)';
w_hat_filter_q = (phi_filter_q' * hat_W_q)';
w_un_hat_s = (phi_s' * hat_W_s)';
w_hat_filter_s = (phi_filter_s' * hat_W_s)';

% w_un_filter = [w_un_q_filter; w_un_s_filter];  %w_un_filter = [w_un_q_filter; w_un_s_filter];
epsion_q = w_un_q_filter - w_hat_filter_q;
epsion_s = w_un_s_filter - w_hat_filter_s;

model_u_q = ( - w_un_hat_q);
model_u_s = ( - w_un_hat_s);


e_S = sd - S;
e_s_q = K_1_q *(qd - q) + (dqd - dq);

d_qr_q = dqqd + K_1_q*(dqd - dq);
  
    %%  paper controller 
G_q = [0;0;0];

controlu_tau = M * (model_u_q + d_qr_q) + K_c_q * e_s_q + G_q;
controlu_s = dsd + model_u_s + K_c_s * e_S;


display('controlu_tau');
display(controlu_tau);

controlu1= [];
controlu2= [];
for i = 1:N
    a = controlu_tau(i,:);
    b = controlu_s(i,:);
    

if u1(i,:) > 0 && u2(i,:) >0
    x_temp1 = -1.5*a - 0.1*b;    
    x_temp2 = 1*a + 0.1*b;  
elseif u1(i,:)>0 && u2(i,:) <0
    x_temp1 = -0.3*a + 0.02*b;    
    x_temp2 = -0.2*a - 0.02*b;  
elseif u1(i,:)<0 && u2(i,:) >0
    x_temp1 = -0.3*a - 0.02*b;    
    x_temp2 = -0.2*a + 0.02*b;  
else
    x_temp1 = -1.5*a + 0.1*b;    
    x_temp2 = 1*a - 0.1*b;  
end

    controlu1 = [controlu1; (x_temp1)];
    controlu2 = [controlu2; (x_temp2)];
end


display('controlu1');
display(controlu1);
display('controlu2');
display(controlu2);

output_dimension = output_dimension_q + output_dimension_s;
sys(1:output_dimension_q) = w_hat_filter_q;   %w_un_hat_q
sys((output_dimension_q +1):(output_dimension)) = w_hat_filter_s;   %w_un_hat_s
sys((output_dimension +1):(2 * output_dimension)) = [epsion_q;epsion_s];

sys((2*output_dimension + 1):(2 * output_dimension + N)) = controlu1;
sys((2*output_dimension + N +1):(2 * output_dimension + 2 * N)) = controlu2;
sys((2*output_dimension + 2*N +1):(N_wq + N_ws + 2*output_dimension + 2*N)) = x(1: (N_wq + N_ws));
