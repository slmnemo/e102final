% Written by Pierce Gruber and Kaitlin Lucio
clear
clf

% Variable definitions
L = 0.5;
g = 9.8;
zeta = 1.005;
wn = 0.7;
testmode = false;
dis = 0.5;

% Pole modifiers
conPmod = 10;
obsPmod = 50;
KiPmod = 10.2;

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
% Below shows the ideal system response for a step input, perfect
% observation, and no disturbances. 
% Later, we need to tune these poles because of our observer and
% disturbances.

% 2nd order dominant system
domPolynom = [1 2*zeta*wn wn^2];
domPoles = roots(domPolynom);
conPoles = [domPoles' min(domPoles)*conPmod min(domPoles)*1.2*(conPmod)];

% The observer poles are just the controller poles but made to be 
% decently faster.
obsPoles = obsPmod*conPoles;
Lo = place(A', C', obsPoles)';

% Calculate Ki_fb and K_fb using integral action state matrices

% Add the fifth pole, the integral control pole.
KiPole = domPoles(1)*KiPmod;
allPoles = [conPoles KiPole]; 


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

disp(['allPoles: ' num2str(allPoles)]);

% Simulate Simulink model
if testmode
    sim_run = sim("plant.mdl");
    plot(sim_run.yout)
else
    distvec = 0:0.05:0.8;
    
    i = 1;
    
    figurefolder = "figures/";
    figprefix = "sim_displacement_";
    
    for dim=distvec
        dis = dim;
        hws = get_param(bdroot,'modelworkspace');
        hws.assignin('dis',dis)
        sim_run = sim("plant.mdl");
        s = sim_run.yout{2}.Values.Data;
        theta = sim_run.yout{3}.Values.Data;
        a = sim_run.yout{1}.Values.Data;
        dis_act = sim_run.yout{4}.Values.Data;
        time = sim_run.tout;
        figure(i)
        hold on
        plot(time, s)
        plot(time, theta)
        plot(time, a)
        plot(time,dis_act)
        xlabel("Time (s)")
        ylabel("Magnitude of output")
        legend("Displacement [m]", "Angle of Pendulum [rad]", "Acceleration [$m/s^2$]")
        title("System response to disturbance of "+num2str(dis)+" in rad/s")
        saveas(i,figurefolder+figprefix+num2str(dis)+".png")
        close(i)
        i = i + 1;
    end
end