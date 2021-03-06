function [states_dot] = dyn_complete(states, controls)
% model interface created by falcon.m

% Extract states
V = states(1);
q0 = states(2);
q1 = states(3);
q2 = states(4);
q3 = states(5);

% Extract controls
alpha = controls(1);
T = controls(2);
p = controls(3);

% Constants
m = 750;
g = 9.8056;
rho = 1.225;
S = 9.84;
Clalpha = 5.7;
K = 0.18;
Cd0 = 0.0054;
Cl0 = 0.1205;
Cdp = 0.05;

% Dynamic model
Cl = Clalpha.*alpha + Cl0;
L = 0.5.*rho.*V.^2.*S.*Cl;
D = 0.5.*rho.*V.^2.*S.*(Cd0+K.*Cl.^2+Cdp*abs(p));
q = (T.*sin(alpha)+L-m.*g.*(q0.^2-q1.^2-q2.^2+q3.^2))./(m.*V);
r = (2.*m.*g.*(q0.*q1+q2.*q3))./(m.*V);
V_dot = (T.*cos(alpha)-D+2.*m.*g.*(q1.*q3-q0.*q2))./m;
q0_dot = -0.5.*(q1.*p+q2.*q+q3.*r);
q1_dot =  0.5.*(q0.*p+q2.*r-q3.*q);
q2_dot =  0.5.*(q0.*q+q3.*p-q1.*r);
q3_dot =  0.5.*(q0.*r+q1.*q-q2.*p);
x_dot = V.*(q0.^2+q1.^2-q2.^2-q3.^2);
y_dot = 2.*V.*(q0.*q3+q1.*q2);
h_dot = 2.*V.*(q0.*q2-q1.*q3);
states_dot = [T_dot; V_dot; alpha_dot; q0_dot; q1_dot; q2_dot; q3_dot; x_dot; y_dot; h_dot];

end