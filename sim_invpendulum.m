function [overshoot, t_settle, sim_data] = sim_invpendulum(ang_dis, zeta, wn, conPmod, obsPmod, KiPmod, p)
%{
    Function to simulate a 5th order inverted pendulum using pole
    placement. Takes in a zeta and omega measurement and returns the
    overshoot and settling time.

    Zeta must be >= 1

    Omega must be > 0

    dis is a disurbance in angular momentum applied at t = 0.

    Written by Pierce Gruber and Kaitlin Lucio
%}

% Variable definitions

L = 0.5;
g = 9.8;

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

% Pole calculations
% 2nd order dominant system
domPolynom = [1 2*zeta*wn wn^2];
domPoles = roots(domPolynom);
conPoles = [domPoles' min(domPoles)*conPmod min(domPoles)*1.2*(conPmod)];

% The observer poles are just the controller poles but made to be 
% faster.
obsPoles = obsPmod*conPoles;
Lo = place(A', C', obsPoles)';

% Calculate Ki_fb and K_fb using integral action state matrices

% Add the fifth pole, the integral control pole.
KiPole = domPoles(1)*KiPmod;
allPoles = [conPoles KiPole]; 

% Define full integral action poles and calculate Ki and K.

Aa = [
    0, -C(2,:); 
    zeros(4,1), A
    ];
Ba = [
    -D(2); B
];

Ktot = acker(Aa, Ba, allPoles);
Ki = Ktot(1);
K = Ktot(2:end);

% Calculate Observer using poles from above

Lo = place(A', C', obsPoles)';

% Simulate Simulink model and get stats
dis = ang_dis;
h = load_system("plant.mdl");
hws = get_param(bdroot,'modelworkspace');
hws.assignin('dis',dis)
hws = get_param('plant','modelworkspace');
list = whos;
N = length(list);
for i = 1:N
    hws.assignin(list(i).name,eval(list(i).name))
end
sim_data = sim("plant.mdl");
info = stepinfo(sim_data.yout{2}.Values.Data,sim_data.tout,"SettlingTimeThreshold",0.02);
overshoot = info.Overshoot;
t_settle = info.SettlingTime;