close all;
clc
cd ./data

%% load data
imported_data_cl_raw = load("sim_data_cl.mat","imported_data");   %
imported_data_es_raw = load("sim_data_es.mat","imported_data");   %


imported_data_cl = imported_data_cl_raw.imported_data;
imported_data_es = imported_data_es_raw.imported_data;

%% cl 
qd = imported_data_cl.qd(1:2:end,:);
dqd = imported_data_cl.dqd(1:2:end,:);
sd = imported_data_cl.sd(1:2:end,:);
dsd = imported_data_cl.dsd(1:2:end,:);
t = imported_data_cl.t.data(1:2:end,:);

q_cl= imported_data_cl.q(1:2:end,:);
dq_cl = imported_data_cl.dq(1:2:end,:);
e_cl = imported_data_cl.e(1:2:end,:);
W_q_cl = imported_data_cl.hat_W_q(1:2:end,:);
W_s_cl = imported_data_cl.hat_W_s(1:2:end,:);
w_norm_q_cl = imported_data_cl.w_norm_q(1:2:end,:);
w_un_hat_cl = imported_data_cl.w_un_hat(1:2:end,:);
w_un_q_f_cl = imported_data_cl.w_un_q_f(1:2:end,:);
epsion_cl = imported_data_cl.epsion(1:2:end,:);

S_cl= imported_data_cl.S(1:2:end,:);
stiff_cl = imported_data_cl.stiffness(1:2:end,:);
e_stiff_cl = imported_data_cl.e_stiff(1:2:end,:);
e_S_cl = imported_data_cl.e_S(1:2:end,:);
hat_w_s_cl = imported_data_cl.hat_W_s(1:2:end,:);
w_norm_s_cl = imported_data_cl.w_norm_s(1:2:end,:);
w_un_hat_cl = imported_data_cl.w_un_hat(1:2:end,:);
w_un_s_f_cl = imported_data_cl.w_un_s_f(1:2:end,:);

controlu1_cl = imported_data_cl.controlu1(1:2:end,:);
controlu2_cl = imported_data_cl.controlu2(1:2:end,:);
u_theta1_cl = imported_data_cl.u_theta1(1:2:end,:);
u_theta2_cl = imported_data_cl.u_theta2(1:2:end,:);

stiffness_cl = imported_data_cl.stiffness(1:2:end,:);
tau_e_cl = imported_data_cl.tau_e(1:2:end,:);


%% es 
q_es= imported_data_es.q(1:2:end,:);
dq_es = imported_data_es.dq(1:2:end,:);
e_es = imported_data_es.e(1:2:end,:);
W_q_es = imported_data_es.hat_W_q(1:2:end,:);
W_s_es = imported_data_es.hat_W_s(1:2:end,:);
w_norm_q_es = imported_data_es.w_norm_q(1:2:end,:);
w_un_hat_es = imported_data_es.w_un_hat(1:2:end,:);
w_un_q_f_es = imported_data_es.w_un_q_f(1:2:end,:);
epsion_es = imported_data_es.epsion(1:2:end,:);

S_es= imported_data_es.S(1:2:end,:);
stiff_es = imported_data_es.stiffness(1:2:end,:);
e_stiff_es = imported_data_es.e_stiff(1:2:end,:);
e_S_es = imported_data_es.e_S(1:2:end,:);
hat_w_s_es = imported_data_es.hat_W_s(1:2:end,:);
w_norm_s_es = imported_data_es.w_norm_s(1:2:end,:);
% w_un_hat_es = imported_data_es.w_un_hat;
w_un_s_f_s = imported_data_es.w_un_s_f(1:2:end,:);
% epsion_es = imported_data_es.epsion;

controlu1_s = imported_data_es.controlu1(1:2:end,:);
controlu2_es = imported_data_es.controlu2(1:2:end,:);
u_theta1_es = imported_data_es.u_theta1(1:2:end,:);
u_theta2_es = imported_data_es.u_theta2(1:2:end,:);
tau_e_es = imported_data_es.tau_e(1:2:end,:);


figure_height = 300; % 260
%% joint 1 tracking position, tracking error, epsion, W_norm

gcf1=figure("Name", "joint1_tracking",'Position', [280 110 420 figure_height]);
h11 = subplot(2,1,1);
set(h11,'Position',[0.15 0.59 0.81 0.37])
h11.FontName = 'times new roman';

plot(t,q_cl(: ,1),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,q_es(: ,1),'--','Color','#0052FD','LineWidth',1.3);
plot(t,qd(: ,1),':','Color',[0.25 0.25 0.25],'LineWidth',1.3);

set(gca,'xticklabel',[])
ylim([-1.2, 2]) %
L11 = ylabel('$\textit{q}_{\rm{d1}}$ (rad)'); 
pos11 = axis;
set(L11,'Interpreter','Latex','position',[pos11(1) - 10,(pos11(3) + pos11(4))*0.5]);
l31 = legend('CLNNC','ANNC','$\textit{q}_{\rm{d1}}$','NumColumns',3,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');

h12 = subplot(2,1,2);
set(h12,'Position',[0.15 0.17 0.81 0.37])
h12.FontName = 'times new roman'; 

plot(t,e_cl(: ,1),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,e_es(: ,1),'--','Color','#0052FD','LineWidth',1.3);

ylim([-0.4, 0.2])  %case1 [-0.1, 0.2]
pos12 = axis;
L12 = ylabel('$e_1$ (rad)'); 
set(L12,'Interpreter','Latex', 'position',[pos12(1)- 10,(pos12(3) + pos12(4))*0.5]); %60s  6
xlabel('Time (s)', 'Interpreter', 'latex', 'position',[(pos12(1) + pos12(2))*0.5,pos12(3)- 0.15]);   %60s  0.75
legend('CLNNC','ANNC','NumColumns',2,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');

annotation('textbox',[.02 .8 .1 .2], ...
    'String','(a)','EdgeColor','none','FontName','times new roman');

saveas(gcf1,'3DoF_sim_tracking_joint1.png');
saveas(gcf1,'3DoF_sim_tracking_joint1','epsc');

%% joint 2 tracking position, tracking error, epsion, W_norm

gcf2=figure("Name", "joint2_tracking",'Position', [280 110 420 figure_height]);
h21 = subplot(2,1,1);
set(h21,'Position',[0.15 0.59 0.81 0.37])
h21.FontName = 'times new roman';

plot(t,q_cl(: ,2),'Color','#E00000','LineWidth',1.3); 
hold on
plot(t,q_es(: ,2),'--','Color','#0052FD','LineWidth',1.3);

plot(t,qd(: ,2),':','Color',[0.25 0.25 0.25],'LineWidth',1.3);

set(gca,'xticklabel',[])
ylim([-1, 2]) %
L21 = ylabel('$\textit{q}_{\rm{d2}}$ (rad)'); 
pos21 = axis;
set(L21,'Interpreter','Latex','position',[pos21(1) - 10,(pos21(3) + pos21(4))*0.5]); %60s  6
legend('CLNNC','ANNC','$\textit{q}_{\rm{d2}}$','NumColumns',3,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');

h22 = subplot(2,1,2);
set(h22,'Position',[0.15 0.17 0.81 0.38])
h22.FontName = 'times new roman'; 

plot(t,e_cl(: ,2),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,e_es(: ,2),'--','Color','#0052FD','LineWidth',1.3);

ylim([-0.4, 0.2])  % 
pos22 = axis;
L22 = ylabel('$e_2$ (rad)'); 
set(L22,'Interpreter','Latex', 'position',[pos22(1) - 10,(pos22(3) + pos22(4))*0.5]);%60s 6
xlabel('Time (s)', 'Interpreter', 'latex', 'position',[(pos22(1) + pos22(2))*0.5,pos22(3)- 0.15]);  %60s  0.075
legend('CLNNC','ANNC','NumColumns',2,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');
annotation('textbox',[.02 .8 .1 .2], ...
    'String','(b)','EdgeColor','none','FontName','times new roman');

saveas(gcf2,'3DoF_sim_tracking_joint2.png');
saveas(gcf2,'3DoF_sim_tracking_joint2','epsc')

%% joint 3 tracking position, tracking error, epsion, W_norm

gcf3=figure("Name", "joint3_tracking",'Position', [280 110 420 figure_height]);
h31 = subplot(2,1,1);
set(h31,'Position',[0.15 0.59 0.81 0.37])
h31.FontName = 'times new roman';

plot(t,q_cl(: ,3),'Color','#E00000','LineWidth',1.3); 
hold on
plot(t,q_es(: ,3),'--','Color','#0052FD','LineWidth',1.3);

plot(t,qd(: ,3),':','Color',[0.25 0.25 0.25],'LineWidth',1.3);

set(gca,'xticklabel',[])
ylim([-1, 2]) %
L31 = ylabel('$\textit{q}_{\rm{d3}}$ (rad)'); 
pos31 = axis;
set(L31,'Interpreter','Latex','position',[pos31(1) - 10,(pos31(3) + pos31(4))*0.5]); %60s  6
legend('CLNNC','ANNC','$\textit{q}_{\rm{d3}}$','NumColumns',3,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');

h32 = subplot(2,1,2);
set(h32,'Position',[0.15 0.17 0.81 0.38])
h32.FontName = 'times new roman'; 

plot(t,e_cl(: ,3),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,e_es(: ,3),'--','Color','#0052FD','LineWidth',1.3);

ylim([-0.4, 0.2])  %
pos32 = axis;
L32 = ylabel('$e_3$ (rad)'); 
set(L32,'Interpreter','Latex', 'position',[pos32(1) - 10,(pos32(3) + pos32(4))*0.5]);%60s 6
xlabel('Time (s)', 'Interpreter', 'latex', 'position',[(pos32(1) + pos32(2))*0.5,pos32(3)- 0.15]);  %60s  0.075
legend('CLNNC','ANNC','NumColumns',2,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');
annotation('textbox',[.02 .8 .1 .2], ...
    'String','(c)','EdgeColor','none','FontName','times new roman');

saveas(gcf3,'3DoF_sim_tracking_joint3.png');
saveas(gcf3,'3DoF_sim_tracking_joint3','epsc')


%% joint 1 stiffness tracking 

gcf1s=figure("Name", "joint1 stiffness tracking",'Position', [280 110 420 figure_height]);
h11 = subplot(2,1,1);
set(h11,'Position',[0.15 0.59 0.81 0.37])
h11.FontName = 'times new roman';
plot(t,stiff_cl(: ,1),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,stiff_es(: ,1),'--','Color','#0052FD','LineWidth',1.3);
plot(t,dsd(: ,1),':','Color',[0.25 0.25 0.25],'LineWidth',1.3);

set(gca,'xticklabel',[])
ylim([-1.2, 50]) %
L11 = ylabel('${\sigma}_{\rm{d1}}$'); 
pos11 = axis;
set(L11,'Interpreter','Latex','position',[pos11(1) - 6,(pos11(3) + pos11(4))*0.5]);
l31 = legend('CLNNC','ANNC','${\sigma}_{\rm{d1}}$','NumColumns',3,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');

h12 = subplot(2,1,2);
set(h12,'Position',[0.15 0.17 0.81 0.37])
h12.FontName = 'times new roman'; 

plot(t,e_stiff_cl(: ,1),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,e_stiff_es(: ,1),'--','Color','#0052FD','LineWidth',1.3);

ylim([-5, 10])  %case1 [-0.1, 0.2]
pos12 = axis;
L12 = ylabel('$e_{\sigma 1}$'); 
set(L12,'Interpreter','Latex', 'position',[pos12(1)- 6,(pos12(3) + pos12(4))*0.5]); %60s  6
xlabel('Time (s)', 'Interpreter', 'latex', 'position',[(pos12(1) + pos12(2))*0.5,pos12(3)- 4]);   %60s  0.75
legend('CLNNC','ANNC','NumColumns',2,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');
annotation('textbox',[.005 .8 .1 .2], ...
    'String','(d)','EdgeColor','none','FontName','times new roman');

saveas(gcf1s,'3DoF_sim_stiff_tracking_joint1.png');
saveas(gcf1s,'3DoF_sim_stiff_tracking_joint1','epsc');

%% joint 2 stiffness tracking 

gcf2s=figure("Name", "joint2 stiffness tracking",'Position', [280 110 420 figure_height]);
h21 = subplot(2,1,1);
set(h21,'Position',[0.15 0.59 0.81 0.37])
h21.FontName = 'times new roman';
plot(t,stiff_cl(: ,2),'Color','#E00000','LineWidth',1.3); 
hold on
plot(t,stiff_es(: ,2),'--','Color','#0052FD','LineWidth',1.3);

plot(t,dsd(: ,2),':','Color',[0.25 0.25 0.25],'LineWidth',1.3);

set(gca,'xticklabel',[])
ylim([-1, 50]) %
L21 = ylabel('${\sigma}_{\rm{d2}}$'); 
pos21 = axis;
set(L21,'Interpreter','Latex','position',[pos21(1) - 6,(pos21(3) + pos21(4))*0.5]); %60s  6
legend('CLNNC','ANNC','${\sigma}_{\rm{d2}}$','NumColumns',3,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');

h22 = subplot(2,1,2);
set(h22,'Position',[0.15 0.17 0.81 0.38])
h22.FontName = 'times new roman'; 

plot(t,e_stiff_cl(: ,2),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,e_stiff_es(: ,2),'--','Color','#0052FD','LineWidth',1.3);

ylim([-5, 10])  %case1 
pos22 = axis;
L22 = ylabel('$e_{\sigma 2}$'); 
set(L22,'Interpreter','Latex', 'position',[pos22(1) - 6,(pos22(3) + pos22(4))*0.5]);%60s 6
xlabel('Time (s)', 'Interpreter', 'latex', 'position',[(pos22(1) + pos22(2))*0.5,pos22(3)- 4]);  %60s  0.075
legend('CLNNC','ANNC','NumColumns',2,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');
annotation('textbox',[.005 .8 .1 .2], ...
    'String','(e)','EdgeColor','none','FontName','times new roman');

saveas(gcf2s,'3DoF_sim_stiff_tracking_joint2.png');
saveas(gcf2s,'3DoF_sim_stiff_tracking_joint2','epsc')

%% joint 3 stiffness tracking 

gcf3s=figure("Name", "joint3 stiffness tracking",'Position', [280 110 420 figure_height]);
h31 = subplot(2,1,1);
set(h31,'Position',[0.15 0.59 0.81 0.37])
h31.FontName = 'times new roman';
plot(t,stiff_cl(: ,3),'Color','#E00000','LineWidth',1.3); 
hold on
plot(t,stiff_es(: ,3),'--','Color','#0052FD','LineWidth',1.3);

plot(t,dsd(: ,3),':','Color',[0.25 0.25 0.25],'LineWidth',1.3);

set(gca,'xticklabel',[])
ylim([-1, 20]) %
L31 = ylabel('${\sigma}_{\rm{d3}}$'); 
pos31 = axis;
set(L31,'Interpreter','Latex','position',[pos31(1) - 6,(pos31(3) + pos31(4))*0.5]); %60s  6
legend('CLNNC','ANNC','${\sigma}_{\rm{d3}}$','NumColumns',3,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');

h32 = subplot(2,1,2);
set(h32,'Position',[0.15 0.17 0.81 0.38])
h32.FontName = 'times new roman'; 

plot(t,e_stiff_cl(: ,3),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,e_stiff_es(: ,3),'--','Color','#0052FD','LineWidth',1.3);

ylim([-5, 10])  %case1 
pos32 = axis;
L32 = ylabel('$e_{\sigma 3}$'); 
set(L32,'Interpreter','Latex', 'position',[pos32(1) - 6,(pos32(3) + pos32(4))*0.5]);%60s 6
xlabel('Time (s)', 'Interpreter', 'latex', 'position',[(pos32(1) + pos32(2))*0.5,pos32(3)- 4]);  %60s  0.075
legend('CLNNC','ANNC','NumColumns',2,'FontSize',10,'Interpreter','Latex');
set(gca,'FontSize',10,'FontName','times new roman');
annotation('textbox',[.005 .8 .1 .2], ...
    'String','(f)','EdgeColor','none','FontName','times new roman');

saveas(gcf3s,'3DoF_sim_stiff_tracking_joint3.png');
saveas(gcf3s,'3DoF_sim_stiff_tracking_joint3','epsc')

%% norm 
data_len = length(t);
epison_q_cl_norm = [];
epison_q_es_norm = [];
epison_s_cl_norm = [];
epison_s_es_norm = [];

epsion_q_cl1 = epsion_cl(: ,1);
epsion_q_cl2 = epsion_cl(: ,2);
epsion_q_cl3 = epsion_cl(: ,3);
epsion_q_es1 = epsion_es(: ,1);
epsion_q_es2 = epsion_es(: ,2);
epsion_q_es3 = epsion_es(: ,3);

epsion_s_cl1 = epsion_cl(: ,4);
epsion_s_cl2 = epsion_cl(: ,5);
epsion_s_cl3 = epsion_cl(: ,6);
epsion_s_es1 = epsion_es(: ,4);
epsion_s_es2 = epsion_es(: ,5);
epsion_s_es3 = epsion_es(: ,6);

w_norm_q_cl_ = w_norm_q_cl(: ,1);
w_norm_q_es_ = w_norm_q_es(: ,1);
w_norm_s_cl_ = w_norm_s_cl(: ,1);
w_norm_s_es_ = w_norm_s_es(: ,1);

w_norm_q_cl_sqrt = [];
w_norm_q_es_sqrt = [];

w_norm_s_cl_sqrt = [];
w_norm_s_es_sqrt = [];

for i = 1:data_len
    %q
    temp_q_cl1 = epsion_q_cl1(i,:);
    temp_q_cl2 = epsion_q_cl2(i,:);
     temp_q_cl3 = epsion_q_cl3(i,:);
    
    temp_q_es1 = epsion_q_es1(i,:);
    temp_q_es2 = epsion_q_es2(i,:);
    temp_q_es3 = epsion_q_es3(i,:);
    
    temp_w_norm_q_cl = w_norm_q_cl_(i,:);
    temp_w_norm_q_es = w_norm_q_es_(i,:);
    
    temp_norm_q_cl = temp_q_cl1^2 + temp_q_cl2^2 + temp_q_cl3^2;
    temp_norm_q_es = temp_q_es1^2 + temp_q_es2^2 + temp_q_es3^2;
    epison_q_cl_norm = [epison_q_cl_norm;sqrt(temp_norm_q_cl)];
    epison_q_es_norm = [epison_q_es_norm;sqrt(temp_norm_q_es)];
    
    w_norm_q_cl_sqrt = [w_norm_q_cl_sqrt;sqrt(temp_w_norm_q_cl)];
    w_norm_q_es_sqrt = [w_norm_q_es_sqrt;sqrt(temp_w_norm_q_es)];
    
    %stiffness
    temp_s_cl1 = epsion_s_cl1(i,:);
    temp_s_cl2 = epsion_s_cl2(i,:);
    temp_s_cl3 = epsion_s_cl3(i,:);

    temp_s_es1 = epsion_s_es1(i,:);
    temp_s_es2 = epsion_s_es2(i,:);
    temp_s_es3 = epsion_s_es3(i,:);
    
    temp_w_norm_s_cl = w_norm_s_cl_(i,:);
    temp_w_norm_s_es = w_norm_s_es_(i,:);
    
    temp_norm_s_cl = temp_s_cl1^2 + temp_s_cl2^2 + temp_s_cl3^2;
    temp_norm_s_es = temp_s_es1^2 + temp_s_es2^2 + temp_s_es3^2;
    epison_s_cl_norm = [epison_s_cl_norm;sqrt(temp_norm_s_cl)];
    epison_s_es_norm = [epison_s_es_norm;sqrt(temp_norm_s_es)];
    
    w_norm_s_cl_sqrt = [w_norm_s_cl_sqrt;sqrt(temp_w_norm_s_cl)];
    w_norm_s_es_sqrt = [w_norm_s_es_sqrt;sqrt(temp_w_norm_s_es)];
end



%% W q
gcf4=figure("Name", "sim_W_q",'Position', [280 110 420 260]);
h41 = subplot(2,1,1);
set(h41,'Position',[0.15 0.59 0.81 0.37])
h41.FontName = 'times new roman';

plot(t,epison_q_cl_norm(: ,1),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,epison_q_es_norm(: ,1),'--','Color','#0052FD','LineWidth',1.3); 

set(gca,'xticklabel',[])
ylim([0, 500]) %
pos41 = axis;
L41 = ylabel('$\Vert {\epsilon}_{\rm q} \Vert$'); 
set(L41,'Interpreter','Latex','position',[pos41(1) - 9,(pos41(3) + pos41(4))*0.5]);
legend('CLNNC','ANNC','NumColumns',2,'FontSize',8,'Interpreter','Latex');
set(gca,'FontSize',8,'FontName','times new roman');

h42 = subplot(2,1,2);
set(h42,'Position',[0.15 0.17 0.81 0.37])
h42.FontName = 'times new roman'; 

plot(t,w_norm_q_cl_sqrt(: ,1),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,w_norm_q_es_sqrt(: ,1),'--','Color','#0052FD','LineWidth',1.3); 

ylim([0, 350])  % 
pos42 = axis;
L42 = ylabel('$\Vert \hat W_{\rm q} \Vert$'); 
set(L42,'Interpreter','Latex', 'position',[pos42(1)- 9,(pos42(3) + pos42(4))*0.5]);  %60s
xlabel('Time (s)', 'Interpreter', 'latex', 'position',[(pos42(1) + pos42(2))*0.5,pos42(3)- 82]);  %60s  125
legend('CLNNC','ANNC','NumColumns',2,'FontSize',8,'Interpreter','Latex');
set(gca,'FontSize',8,'FontName','times new roman');

annotation('textbox',[.012 .8 .1 .2], ...
    'String','(a)','EdgeColor','none','FontName','times new roman');

saveas(gcf4,'3DoF_sim_W_q.png');
saveas(gcf4,'3DoF_sim_W_q','epsc')

%% W stiffness
gcf5=figure("Name", "sim_W_s",'Position', [280 110 420 260]);
h41 = subplot(2,1,1);
set(h41,'Position',[0.15 0.59 0.81 0.37])
h41.FontName = 'times new roman';

plot(t,epison_s_cl_norm(: ,1),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,epison_s_es_norm(: ,1),'--','Color','#0052FD','LineWidth',1.3); 

set(gca,'xticklabel',[])
ylim([0, 40]) %
pos41 = axis;
L41 = ylabel('$\Vert \epsilon _{\sigma}\Vert$'); 
set(L41,'Interpreter','Latex','position',[pos41(1) - 8,(pos41(3) + pos41(4))*0.5]);
legend('CLNNC','ANNC','NumColumns',2,'FontSize',8,'Interpreter','Latex');
set(gca,'FontSize',8,'FontName','times new roman');

h42 = subplot(2,1,2);
set(h42,'Position',[0.15 0.17 0.81 0.37])
h42.FontName = 'times new roman'; 

plot(t,w_norm_s_cl_sqrt(: ,1),'Color','#E00000','LineWidth',1.3); 
hold on;
plot(t,w_norm_s_es_sqrt(: ,1),'--','Color','#0052FD','LineWidth',1.3); 

ylim([0, 30])  %case1 
pos42 = axis;
L42 = ylabel('$\Vert \hat W _{\sigma} \Vert$'); 
set(L42,'Interpreter','Latex', 'position',[pos42(1)- 8,(pos42(3) + pos42(4))*0.5]);  %60s
xlabel('Time (s)', 'Interpreter', 'latex', 'position',[(pos42(1) + pos42(2))*0.5,pos42(3)- 8]);  %60s  125
legend('CLNNC','ANNC','NumColumns',2,'FontSize',8,'Interpreter','Latex');
set(gca,'FontSize',8,'FontName','times new roman');

annotation('textbox',[.012 .8 .1 .2], ...
    'String','(b)','EdgeColor','none','FontName','times new roman');

saveas(gcf5,'3DoF_sim_W_s.png');
saveas(gcf5,'3DoF_sim_W_s','epsc')

%save paper_sim_cl_data.mat qd dqd sd dsd t q_cl dq_cl stiff_cl e_cl W_q_cl W_s_cl epison_q_cl_norm w_norm_q_cl_sqrt epison_s_cl_norm w_norm_s_cl_sqrt
%save paper_sim_es_data.mat qd dqd sd dsd t q_es dq_es stiff_es e_es W_q_es W_s_es epison_q_es_norm w_norm_q_es_sqrt epison_s_es_norm w_norm_s_es_sqrt
cd ..
%=============================================================================================================================%

