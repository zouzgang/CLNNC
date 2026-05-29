function [sys,x0,str,ts]=plant(t,x,u,flag)
switch flag
    case 0
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 1
        sys=mdlDerivatives(t,x,u);
    case 3
        sys=mdlOutputs(t,x,u);
    case{2,4,9}
        sys=[];
    otherwise
        error(['Unhandled flag']);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes=simsizes;
sizes.NumContStates = 6;
sizes.NumDiscStates = 0;
sizes.NumInputs = 3;
sizes.NumOutputs = 9;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);

x0=[0,0,0,0,0,0];
% x0=[qd1,qd2,0,0]';
str=[];ts=[];

str=[];ts=[];

function sys=mdlDerivatives(t,x,u)

global m1 m2 m3 l1 l2 l3 lc1 lc2 lc3 I1 I2 I3;


% m1=0.45;m2=0.45;m3=0.45;
% l1=0.1;l2=0.1;l3=0.1;r2 = 0.5 * l2;r3 = 0.5 * l3;
% lc1=0.05;lc2=0.05;lc3=0.05;
% I1=0.0045;I2=0.0045;I3=0.0045;

g = 9.8;

q1=x(1);q2=x(2);q3=x(3);
dq1=x(4);dq2=x(5);dq3=x(6);
q=[q1;q2;q3];dq=[dq1;dq2;dq3];


a1 = m1 * lc1^2 + I1 + (m2 + m3) * l1^2;
a2 = I2 + m2 * lc2^2 + m3 * l2^2;
a3 = (m2 * lc2 + m3 * l2) * l1;
a4 = I3 + m3 * lc3^ 2;
a5 = m3 * lc3 * l1;
a6 = m3 * lc3 * l2;

C1 = -a3 * (2 * dq1 + dq2) * dq2 * sin(q2) - a5 * (2 * dq1 + dq2 + dq3) *(dq2 + dq3) * sin(q2 + q3) - a6 * (2 * dq1 + 2 * dq2 + dq3) * dq3 * sin(q3);
C2 = a3 * dq1^2 * sin(q2) + a5 * dq1^2 * sin(q2 + q3) - a6 * (2 * dq1 + 2 * dq2 + dq3) * dq3 * sin(q3);
C3 = a5 * dq1^2 * sin(q2 + q3) + a6 * (dq1 + dq2)^2 * sin(q3);

G1 = 0; G2 = 0; G3 = 0;

M11 = a1 + a2 + a4 + 2 * a3 * cos(q2) + 2 * a5 * cos(q2 + q3) + 2 * a6 * cos(q3);
M12 = a2 + a4 + a3 * cos(q2) + a5 * cos(q2 + q3) + 2 * a6 * cos(q3);
M13 = a4 + a5 * cos(q2 + q3) + a6 * cos(q3);
M21 = M12;
M22 = a2 + a4 + 2 * a6 * cos(q3);
M23 = a4  + a6 * cos(q3);
M31 = M13;
M32 = M23;
M33 = a4;

% Mq=[m1*lc1^2+I1+I2+m2*(l1^2+lc2^2+2*l1*lc2*cos(q2)),m2*lc2^2+I2+m2*l1*lc2*cos(q2);
%     m2*lc2^2+I2+m2*l1*lc2*cos(q2),m2*lc2^2+I2];
% Cq=[-m2*l1*lc2*sin(q2)*dq2,-m2*l1*lc2*sin(q2)*(dq1+dq2);
%     m2*l1*lc2*sin(q2)*dq1,0];
% Gq=[m1*lc1*g*cos(q1)+m2*g*(lc2*cos(q1+q2)+l1*cos(q1));
%     m2*lc2*g*cos(q1+q2)];
% Gq = [0;0];
% D=diag([kv1,kv2]);
Mq = [M11 M12 M13; 
    M21 M22 M23;
    M31 M32 M33];
Cq = [C1 C2 C3]'; 
Gq = [0;0;0];

temp = Mq^(-1);
ddq=Mq^(-1)*(u-Cq-Gq);

sys=[dq;ddq];


function sys=mdlOutputs(t,x,u)

sys=[x;[0;0;0]];


















