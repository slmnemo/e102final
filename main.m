% Written by Pierce Gruber and Kaitlin Lucio
clear
clf

% Variable definitions

L = 0.5;
g = 9.8;
alpha = 0.5;
pmod = 10;
dist = 0;
testmode = true;

% Pole calculations

zetaCon = 1.2;
wCon = 0.5;
conPolynom = [1 2*zetaCon*wCon wCon^2];
conPoles = roots(conPolynom);
r_con_p = real(min(conPoles));
i_con_p = imag(min(conPoles));
conPoles = [conPoles', pmod*r_con_p, (pmod+1)*r_con_p];

zetaObs = 1.5;
wObs = 1;
obsPolynom = [1 2*zetaObs*wObs wObs^2];
obsPoles = roots(obsPolynom);
% sys = tf(wObs^2, obsPolynom);
% step(sys)

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

[Mc, invMc] = testControllability(A, B);
[Mo, invMo] = testObservability(A, C);

% Calculate Observer and Controller using poles

K_old = place(A, B, conPoles);
Lo = place(A', C', obsPoles)';

% Calculate Ki for the system

Ki_old = pmod*r_con_p;


% Calculate Ki_fb and K_fb using integral action state matrices

conPoles = [conPoles(end)+0.1, conPoles];

Aaf = [
    0, -C(2,:); 
    zeros(4,1), A
    ];
Baf = [
    -D(2); B
];

Ktot = place(Aaf, Baf, conPoles);
Ki = Ktot(1)
K = Ktot(2:end)

% Simulate Simulink model
if testmode
    sim_run = sim("plant.mdl");
    plot(sim_run.yout)
else
    distvec = 0:0.1:0.5;
    
    i = 1;
    
    figurefolder = "figures/";
    figprefix = "sim_displacement_";
    
    for dist=distvec
        figure(i)
        sim_run = sim("plant.mdl");
        s = sim_run.yout{2}.Values.Data;
        theta = sim_run.yout{3}.Values.Data;
        a = sim_run.yout{4}.Values.Data;
        time = sim_run.tout;
        hold on
        plot(time, s)
        plot(time, theta)
        plot(time, a)
        xlabel("Time (s)")
        ylabel("Magnitude of output")
        legend("Displacement [m]", "Angle of Pendulum [rad]", "Acceleration [$m/s^2$]")
        title("System response to disturbance of "+num2str(dist)+" in rad/s")
        saveas(i,figurefolder+num2str(dist)+".png")
        close(i)
        i = i + 1;
    end
end