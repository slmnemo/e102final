function [overshoot, t_settle, sim_data] = sim_invpendulum(ang_disp, zetaCon, wCon, p)
%{
    Function to simulate a 5th order inverted pendulum using pole
    placement. Takes in a zeta and omega measurement and returns the
    overshoot and settling time.

    Zeta must be >= 1

    Omega must be > 0

    Dist is a disturbance in angular momentum applied at t = 0.

    Written by Pierce Gruber and Kaitlin Lucio
%}

if nargin < 4
    p = 0;
end

% Variable definitions

L = 0.5;
g = 9.8;
pmod = 10;

% Pole calculations

conPolynom = [1 2*zetaCon*wCon wCon^2];
conPoles = roots(conPolynom);
r_con_p = real(min(conPoles));
conPoles = [conPoles', pmod*r_con_p, (pmod+1)*r_con_p];

zetaObs = 1.5;
wObs = 1;
obsPolynom = [1 2*zetaObs*wObs wObs^2];
obsPoles = roots(obsPolynom);
min_obs_pole = max(obsPoles);
r_obs_p = real(min_obs_pole);
i_obs_p = imag(min_obs_pole);
obsPoles = [obsPoles', pmod*(r_obs_p+i_obs_p),pmod*(r_obs_p-i_obs_p)];


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

% Calculate Observer using poles from above

Lo = place(A', C', obsPoles)';

% Calculate Ki_fb and K_fb using integral action state matrices

conPoles = [conPoles, r_con_p*(pmod+0.1)];

Aaf = [
    0, -C(2,:); 
    zeros(4,1), A
    ];
Baf = [
    -D(2); B
];

Ktot = place(Aaf, Baf, conPoles);
Ki = Ktot(1);
K = Ktot(2:end);

% Simulate Simulink model and get stats
disp = ang_disp;
h = load_system("plant.mdl");
hws = get_param('plant','modelworkspace');
list = whos;
N = length(list);
for i = 1:N
    hws.assignin(list(i).name,eval(list(i).name))
end
sim_data = sim("plant.mdl");
if p ~= 0
    plot(sim_data.yout)
end
info = stepinfo(sim_data.yout{2}.Values.Data,sim_data.tout,"SettlingTimeThreshold",0.02);
overshoot = info.Overshoot;
t_settle = info.SettlingTime;