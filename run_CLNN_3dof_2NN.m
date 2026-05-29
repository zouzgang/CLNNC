%% 
close all 
clear all
clc

%% Initalize Environment

setting_3dof_2NN;

global V0_q lr_1_q lr_2_q lr_3_q K_1_q K_c_q W0_q hidden_neure_count_q input_dimension_q output_dimension_q;
global V0_s lr_1_s lr_2_s lr_3_s K_c_s W0_s hidden_neure_count_s input_dimension_s output_dimension_s;
global N M T_sample lamda lamda_cl lamda_cl_s is_exp qd0 qd20 use_Tqr cl_tf1 cl_tf2  T_all learn_time is_noise;
input_dimension_q = 4*N; 
output_dimension_q = 1*N;

input_dimension_s = 2*N; 
output_dimension_s = 1*N;

if is_exp ==1
    hidden_neure_count_q = 50;  %
    hidden_neure_count_s = 30;  %
else
    hidden_neure_count_q = 50;  %
    hidden_neure_count_s = 30;  %
end

%% W0_q W0_s  
W0_q =  0 .* rand(output_dimension_q, hidden_neure_count_q + 1);
W0_s =  0 .* rand(output_dimension_s, hidden_neure_count_s + 1);

qd0 = zeros(1,N);


%% V0_q  V0_s
if is_noise
    V0_q_temp = importdata('V0_q_sim1.mat'); %
    V0_s_temp = importdata('V0_s_sim1.mat'); %
else
    V0_q_temp = importdata('V0_q_sim.mat'); %
    V0_s_temp = importdata('V0_s_sim.mat'); %
end
if V0_q_temp
    V0_q = V0_q_temp;
    V0_s = V0_s_temp;
else
    V0_q = 1 - 2 .* rand(input_dimension_q+1,hidden_neure_count_q);  %
    V0_s = 1 - 2 .* rand(input_dimension_s+1,hidden_neure_count_s);  %
end

%% para
if is_exp ==1  
    %% exp   
    lr_1_q = 1*0.3;  %paper 0.3
    lr_2_q = 1*0.3;  %paper 0.3
    lr_3_q = 1*0.2;  %paper 0.2
    
    lr_1_s = 1*0.12;  %
    lr_2_s = 1*0.12;  %
    lr_3_s = 1*0.08;  %
    
    cl_tf = 600;  
    cl_tf1 = 0;   %
    cl_tf2 = 200;   %
    T_all = 80;   %
    learn_time = 50;  %

    lamda = 4;         %
    lamda_cl = 0.4;    %
    lamda_cl_s = 0.6;  %
    use_Tqr = 0;
                                                                                                                                                             
    K_1_q = diag([20, 20, 20]);        %
    K_c_q = diag([0.1, 0.1, 0.1]);    %
    K_c_s = diag([2.6, 2.6, 3.6]);     %
    M=[0.001 0 0;
       0 0.001 0;
       0 0 0.001]; % 
else
    %% sim
    lr_1_q = is_cl*0.36;  %
    lr_2_q = is_cl*0.36;  %
    lr_3_q = 1*0.3;  %
    
    lr_1_s = is_cl*0.05;  %
    lr_2_s = is_cl*0.05;  %
    lr_3_s = 1*0.05;  %
    
    cl_tf = 300;     %
    cl_tf1 = 0;      %
    cl_tf2 = 1050;  %
    T_all = 100;     %
    learn_time =100;

    lamda = 5;         %
    lamda_cl = 0.2;    %
    lamda_cl_s = 0.2;  %
    use_Tqr = 0;
    K_1_q = diag([8, 8, 12]);            % 

    K_c_q = diag([0.08, 0.08, 0.08]);       % 
    K_c_s = diag([2.2, 2.8, 8.8]);    % 
    M=[0.001 0 0;
       0 0.001 0;
       0 0 0.001];       % M=[0.001 0 0;0 0.001 0;0 0 0.001]; 
end
qd20 = 0;
% qd20 = 0.5*pi;

T_sample = 0.005;  %

                                                                                                                                                                                                                                                                                                                                                              
pause on;
pause(2);
pause off;
    
if is_exp == 1
    imported_data = sim('CLNN_exp_3dof_2NN');
else
    imported_data = sim('CLNN_sim_3dof_2NN');
end

%%
qd = imported_data.qd;
dqd = imported_data.dqd;
sd = imported_data.sd;
dsd = imported_data.dsd;

q= imported_data.q;
dq = imported_data.dq;
stiff = imported_data.stiffness;
dstiff = imported_data.dstiff;
S = imported_data.S;
e = imported_data.e;
e_stiff = imported_data.e_stiff;
dd = imported_data.d;

W_V = imported_data.hat_W_q;
w_norm = imported_data.w_norm_q;

W_V_s = imported_data.hat_W_s;
w_norm_s = imported_data.w_norm_s;

w_un_hat = imported_data.w_un_hat;
w_un_q_f = imported_data.w_un_q_f;
w_un_s_f = imported_data.w_un_s_f;
epsion = imported_data.epsion;
t = imported_data.t.data;
controlu1 = imported_data.controlu1;
controlu2 = imported_data.controlu2;
u_theta1 = imported_data.u_theta1;
u_theta2 = imported_data.u_theta2;
pd_u = imported_data.pd_u;
model_u = imported_data.model_u;
stiffness = imported_data.stiffness;
tau_e = imported_data.tau_e;

% Theta_error = imported_data.Theta_error;
% Theta_W = imported_data.Theta_W;
% Theta = imported_data.Theta;

% error1 = imported_data.error1;
% error2 = imported_data.error2;
% error3 = imported_data.error3;
% dot_hat_W = imported_data.dot_hat_W;
%%  q tracking

cd ./data
if is_exp == 1
    if lr_2_q > 0
        save("exp_data_cl.mat","-v7.3")
    else
        save("exp_data_es.mat","-v7.3")
    end
else
    if lr_2_q > 0
        save("sim_data_cl.mat","-v7.3")
    else
        save("sim_data_es.mat","-v7.3")
    end
end



gcf1=figure('Name','tracking q1');
set(gcf1,'Position',[280 110 500 600])

subplot(4,1,1);
plot(t, q(: ,1),'b',t, qd(: ,1),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('state-q1');
legend('q1','qd1');

subplot(4,1,2);
plot(t, e(: ,1),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('error-e1');
legend('e');

subplot(4,1,3);
plot(t,e(: ,4),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('error-e1-Integrator');
legend('ei');

subplot(4,1,4);
plot(t,dq(: ,1), t, dqd(: ,1),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('error-de-dq');
legend('dq1','dqd1');
saveas(gcf1,'tracking-q1.png');
saveas(gcf1,'tracking-q1','epsc')

gcf2=figure('Name','tracking q2');
set(gcf2,'Position',[280 110 500 600])
subplot(4,1,1);
plot(t, q(: ,2),'b',t, qd(: ,2),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('state-q2');
legend('q2','qd2');

subplot(4,1,2);
plot(t, e(: ,2),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('error-e2');
legend('e');

subplot(4,1,3);
plot(t,e(: ,5),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('error-e2-Integrator');
legend('ei');

subplot(4,1,4);
plot(t,dq(: ,2), t, dqd(: ,2), '--');
xlabel('Time (s)'); grid; ylabel('rad'); title('error-de-dq2');
legend('dq2','dqd2');

saveas(gcf2,'tracking-q2.png');
saveas(gcf2,'tracking-q2','epsc')

gcf3=figure('Name','tracking q3');
set(gcf3,'Position',[280 110 500 600])
subplot(4,1,1);
plot(t, q(: ,3),'b',t, qd(: ,3),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('state-q3');
legend('q3','qd3');

subplot(4,1,2);
plot(t, e(: ,3),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('error-e3');
legend('e');

subplot(4,1,3);
plot(t,e(: ,6),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('error-e3-Integrator');
legend('ei');

subplot(4,1,4);
plot(t,dq(: ,3), t, dqd(: ,3), '--');
xlabel('Time (s)'); grid; ylabel('rad'); title('error-de-dq3');
legend('dq3','dqd3');

saveas(gcf3,'tracking-q3.png');
saveas(gcf3,'tracking-q3','epsc')

%% s tracking
gcf11=figure('Name','tracking s1');
set(gcf11,'Position',[280 110 500 500])

subplot(4,1,1);
plot(t,S(: ,1), t, sd(: ,1),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('sd');
legend('S1','sd1');

subplot(4,1,2);
plot(t, stiff(: ,1),'b',t, dsd(: ,1),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('dsd');
legend('stiff1','dsd1');

subplot(4,1,3);
plot(t, e_stiff(: ,1),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('e-s 1');
legend('e-s');

subplot(4,1,4);
plot(t, e_stiff(: ,3),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('e-s inf 1');
legend('e-s inf 1');

saveas(gcf11,'tracking-s1.png');
saveas(gcf11,'tracking-s1','epsc')

gcf21=figure('Name','tracking s2');
set(gcf21,'Position',[280 110 500 500])

subplot(4,1,1);
plot(t,S(: ,2), t, sd(: ,2),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('sd');
legend('S2','sd2');

subplot(4,1,2);
plot(t, stiff(: ,2),'b',t, dsd(: ,2),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('dsd');
legend('stiff2','dsd2');

subplot(4,1,3);
plot(t, e_stiff(: ,2),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('e-s');
legend('e-s');

subplot(4,1,4);
plot(t, e_stiff(: ,5),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('e-s inf 2');
legend('e-s inf 2');

saveas(gcf21,'tracking-s2.png');
saveas(gcf21,'tracking-s2','epsc')

gcf23=figure('Name','tracking s3');
set(gcf23,'Position',[280 110 500 500])

subplot(4,1,1);
plot(t,S(: ,3), t, sd(: ,3),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('sd');
legend('S3','sd3');

subplot(4,1,2);
plot(t, stiff(: ,3),'b',t, dsd(: ,3),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('dsd');
legend('stiff3','dsd3');

subplot(4,1,3);
plot(t, e_stiff(: ,3),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('e-s');
legend('e-s');

subplot(4,1,4);
plot(t, e_stiff(: ,6),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('e-s inf 3');
legend('e-s inf 3');

saveas(gcf23,'tracking-s3.png');
saveas(gcf23,'tracking-s3','epsc')


gcf13=figure('Name','tracking s1 & d');
set(gcf13,'Position',[280 110 500 500])

subplot(2,1,1);
plot(t, stiff(: ,1),'b',t, dd(: ,1),t, dsd(: ,1),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('sd');
legend('S1','sd1');

subplot(2,1,2);
plot(t, stiff(: ,2),'b',t, dd(: ,2),t, dsd(: ,2),'--');
xlabel('Time (s)'); grid; ylabel('Nm/rad'); title('dsd');
legend('stiff1','dsd1');

saveas(gcf13,'tracking-s-d.png');
saveas(gcf13,'tracking-s-d','epsc')

%% 部分跟踪数据
if is_exp == 1
    t_begin = 1000;
    t_end = floor(T_all / T_sample);
else
    t_begin = 10;
    T_all = 0.7;
    t_end = floor(T_all / T_sample);
end


%% W
% gcf_W = figure('Name','W');
% subplot(2,1,1);
% plot(t, W_V(: ,1),'b',t,W_V(: ,9),t,W_V(: ,3),t,W_V(: ,1),t,W_V(: ,2),t,W_V(: ,5),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('Partial parameter W');
% 
% subplot(2,1,2);
% plot(t, w_norm(: ,1),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('W-norm');
% legend('W-norm');
% 
% saveas(gcf_W,'W.png');
% saveas(gcf_W,'W','epsc')

gcf_W2 = figure('Name','W');
subplot(2,1,1);
plot(t, W_V);
xlabel('Time (s)'); grid; ylabel('rad'); title('Partial parameter W q');

subplot(2,1,2);
plot(t, w_norm(: ,1),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('W-norm');
legend('W-norm');

saveas(gcf_W2,'W2.png');
saveas(gcf_W2,'W2','epsc')

gcf_Ws = figure('Name','W s');
subplot(2,1,1);
plot(t, W_V_s);
xlabel('Time (s)'); grid; ylabel('rad'); title('Partial parameter W s');

subplot(2,1,2);
plot(t, w_norm_s(: ,1),'--');
xlabel('Time (s)'); grid; ylabel('rad'); title('W-norm-s');
legend('W-norm-s');

saveas(gcf_Ws,'Ws.png');
saveas(gcf_Ws,'Ws','epsc')

% %% uncertainty 
% gcf_un=figure('Name','uncertainty');
% set(gcf_un,'Position',[280 110 500 1000])
% 
% subplot(6,1,1);
% plot(t, w_un_q_f(: ,1),'b',t,w_un_hat(: ,1),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty1');
% legend('w-un-f1','w-un-hat1');
% 
% subplot(6,1,2);
% plot(t, epsion(: ,1),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty prediction error 1');
% legend('uncertainty prediction error `1');
% 
% subplot(6,1,3);
% plot(t, w_un_q_f(: ,2),'b',t,w_un_hat(: ,2),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty2');
% legend('w-un-f2','w-un-hat2');
% 
% subplot(6,1,4);
% plot(t, epsion(: ,2),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty prediction error 2');
% legend('uncertainty prediction error 2');
% 
% subplot(6,1,5);
% plot(t, w_un_q_f(: ,3),'b',t,w_un_hat(: ,3),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty3');
% legend('w-un-f3','w-un-hat3');
% 
% subplot(6,1,6);
% plot(t, epsion(: ,3),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty prediction error 3');
% legend('uncertainty prediction error 3');
% 
% saveas(gcf_un,'un.png');
% saveas(gcf_un,'un','epsc')
% 
% %% uncertainty s
% gcf_un12=figure('Name','uncertainty s');
% set(gcf_un12,'Position',[280 110 500 1000])
% 
% subplot(6,1,1);
% plot(t, w_un_s_f(: ,1),'b',t,w_un_hat(: ,4),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty1 s');
% legend('w-un-s-f1','w-un-s-hat1');
% 
% subplot(6,1,2);
% plot(t, epsion(: ,4),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty prediction error 1 s');
% legend('uncertainty prediction error `1 s');
% 
% subplot(6,1,3);
% plot(t, w_un_s_f(: ,2),'b',t,w_un_hat(: ,5),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty2 s');
% legend('w-un-s-f2','w-un-s-hat2');
% 
% subplot(6,1,4);
% plot(t, epsion(: ,5),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty prediction error 2 s');
% legend('uncertainty prediction error 2 s');
% 
% subplot(6,1,5);
% plot(t, w_un_s_f(: ,3),'b',t,w_un_hat(: ,6),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty3 s');
% legend('w-un-s-f3','w-un-s-hat3');
% 
% subplot(6,1,6);
% plot(t, epsion(: ,6),'--');
% xlabel('Time (s)'); grid; ylabel('rad'); title('uncertainty prediction error 3 s');
% legend('uncertainty prediction error 3 s');
% 
% saveas(gcf_un12,'uns.png');
% saveas(gcf_un12,'uns','epsc')
% 
% %% controlu q - theta
% gcf_u=figure('Name','controlu q - theta');
% subplot(3,1,1);
% plot(t, controlu1(: ,1),t, controlu2(: ,1));
% xlabel('Time (s)'); grid; ylabel('rad'); title('control u1');
% legend('control u1', 'control u2');
% 
% subplot(3,1,2);
% plot(t, controlu1(: ,2),t, controlu2(: ,2));
% xlabel('Time (s)'); grid; ylabel('rad'); title('control u2');
% legend('control u1', 'control u2');
% 
% subplot(3,1,3);
% plot(t, controlu1(: ,3),t, controlu2(: ,3));
% xlabel('Time (s)'); grid; ylabel('rad'); title('control u3');
% legend('control u1', 'control u2');
% 
% 
% saveas(gcf_u,'u.png');
% saveas(gcf_u,'u','epsc')
% 
% %% real control theta
% gcf_u2=figure('Name','real control theta');
% subplot(3,1,1);
% plot(t, u_theta1(: ,1),t, u_theta2(: ,1));
% xlabel('Time (s)'); grid; ylabel('rad'); title('control u theta1');
% legend('control u theta1','control u theta2' );
% 
% subplot(3,1,2);
% plot(t, u_theta1(: ,2),t, u_theta2(: ,2));
% xlabel('Time (s)'); grid; ylabel('rad'); title('control u theta2');
% legend('control u theta1', 'control u theta2');
% 
% subplot(3,1,3);
% plot(t, u_theta1(: ,3),t, u_theta2(: ,3));
% xlabel('Time (s)'); grid; ylabel('rad'); title('control u theta3');
% legend('control u theta1', 'control u theta2');
% 
% 
% saveas(gcf_u2,'real-u.png');
% saveas(gcf_u2,'real-u','epsc')
% 
% %% stiffness
% gcf_stiffness = figure('Name','stiffness');
% subplot(3,1,1);
% plot(t, stiffness(: ,1));
% xlabel('Time (s)'); grid; ylabel('Nm / s'); title('stiffness 1');
% legend('stiffness 1');
% 
% subplot(3,1,2);
% plot(t, stiffness(: ,2));
% xlabel('Time (s)'); grid; ylabel('Nm / s'); title('stiffness 2');
% legend('stiffness 2');
% 
% subplot(3,1,3);
% plot(t, stiffness(: ,3));
% xlabel('Time (s)'); grid; ylabel('Nm / s'); title('stiffness 3');
% legend('stiffness 3');
% 
% saveas(gcf_stiffness,'stiffness.png');
% saveas(gcf_stiffness,'stiffness','epsc')
% %% tau_e
% gcf_tau_e = figure('Name','tau e');
% subplot(3,1,1);
% plot(t, tau_e(: ,1));
% xlabel('Time (s)'); grid; ylabel('Nm'); title('tau-e 1');
% legend('tau-e 1');
% 
% subplot(3,1,2);
% plot(t, tau_e(: ,2));
% xlabel('Time (s)'); grid; ylabel('Nm'); title('tau-e 2');
% legend('tau-e 2');
% 
% subplot(3,1,3);
% plot(t, tau_e(: ,3));
% xlabel('Time (s)'); grid; ylabel('Nm'); title('tau-e 3');
% legend('tau-e 3');
% 
% saveas(gcf_tau_e,'tau_e.png');
% saveas(gcf_tau_e,'tau_e','epsc')
% %% activation_vec
% if is_exp == 1
%     activation_vec = imported_data.activation_vec;
%     gcf_activation = figure('Name','activation');
%     subplot(3,1,1);
%     plot(t, activation_vec(: ,1));
%     xlabel('Time (s)'); grid; ylabel(''); title('activation 1');
%     legend('activation 1');
% 
%     subplot(3,1,2);
%     plot(t, activation_vec(: ,2));
%     xlabel('Time (s)'); grid; ylabel(''); title('activation 2');
%     legend('activation 2');
% 
%     subplot(3,1,3);
%     plot(t, activation_vec(: ,3));
%     xlabel('Time (s)'); grid; ylabel(''); title('activation 3');
%     legend('activation 3');
% end

cd ..


