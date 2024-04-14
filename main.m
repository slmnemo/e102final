% Written by Pierce Gruber and Kaitlin Lucio
clear

% Variable definitions

L = 0.5;
g = 9.8;
alpha = 0.5;
pmod = 7;

% Pole calculations

zetaCon = 1.00;
wCon = 2.3;
conPolynom = [1 2*zetaCon*wCon wCon^2];
conPoles = roots(conPolynom);
r_con_p = real(min(conPoles));
i_con_p = imag(min(conPoles));
conPoles = [conPoles', pmod*r_con_p, (pmod+0.1)*r_con_p];

obsPoles = pmod*conPoles; % This is easier and works just as well. 

% zetaObs = 1;
% wObs = 1;
% obsPolynom = [1 2*zetaObs*wObs wObs^2];
% obsPoles = roots(obsPolynom);
% % sys = tf(wObs^2, obsPolynom);
% % step(sys)
% 
% min_obs_pole = max(obsPoles);
% r_obs_p = real(min_obs_pole);
% i_obs_p = imag(min_obs_pole);
% [obsPoles', pmod*(r_obs_p+i_obs_p),pmod*(r_obs_p-i_obs_p)];


% Define A, B, C, and D

A = [
    0, 1, 0, 0;
    g/L, 0, 0, 0;
    0, 0, 0, 1;
    0, 0, 0, 0
];

B = [0; -1/L; 0; 1];

C = [
    1, 0, 0, 0;
    0, 0, 1, 0
    ];

D = [
    0;
    0
    ];

[Mc, invMc] = testControllability(A, B);
[Mo, invMo] = testObservability(A, C);

% Calculate Observer and Controller using poles

K = acker(A, B, conPoles);
Lo = place(A', C', obsPoles)';

% Calculate Ki for the system
syms Ki
Aaf = [-D*Ki -C+D*K; B*Ki A-B*K];
Baf = [1; 1; 0; 0; 0; 0];
Caf = [D*Ki C-D*K];
Daf = [0; 0];

% eig(Aaf)????

Ki = pmod*r_con_p;

% Simulate Simulink model

sim_run = sim("plant.mdl");
plot(sim_run.yout)

