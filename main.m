% Written by Pierce Gruber and Kaitlin Lucio
clear
clf

% Variable definitions
zeta = 1.005;
wn = 0.7;
testmode = false;
dis_start = 0.5;
dis_step = 0.001;
dis_stop = 0.71;
dis = dis_start;
distvec = dis_start:dis_step:dis_stop;


% Pole modifiers
conPmod = 10;
obsPmod = 50;
KiPmod = 10.2;

% Simulate Simulink model
if testmode
    sim_run = sim("plant.mdl");
    plot(sim_run.yout)
else
    i = 1;

    figurefolder = "figures/";
    figprefix = "sim_displacement_";

    for dim=distvec
        dis = dim;
        [os, t_settle, sim_run] = sim_invpendulum(dis,zeta,wn,conPmod,obsPmod,KiPmod);
        s = sim_run.yout{2}.Values.Data;
        theta = sim_run.yout{3}.Values.Data;
        a = sim_run.yout{1}.Values.Data;
        time = sim_run.tout;
        figure(i)
        hold on
        plot(time, s)
        plot(time, theta)
        plot(time, a)
        xlabel("Time (s)")
        ylabel("Magnitude of output")
        legend("Displacement [m]", "Angle of Pendulum [rad]", "Acceleration [$m/s^2$]")
        title("System response to disturbance of "+num2str(dis)+" with settling time "+num2str(t_settle)+" in rad/s")
        saveas(i,figurefolder+figprefix+num2str(dis)+".png")
        close(i)
        i = i + 1;
    end
end
