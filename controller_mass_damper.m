% Variable definitions

gain = 1;
poles = [-8, -1, -2+0.1j, -2-0.1j];
m = 1.2;
K = 9;
B = 0.1;
md = m/10;
Kd = 0.1;
Bd = 0.1;

% Define A, B, C, and D

A = [
    0, 1, 0, 0;
    -(Kd+K)/m, -(Bd+B)/m, Kd/m, Bd/m;
    0, 0, 0, 1;
    Kd/md, Bd/md, -Kd/md, -Bd/md
];

B = [0; 1/m; 0; 0];

C = [1, 0, 0, 0];

D = 0;

p = poles;

% Calculate K and Kr

K = place(A, B, p);
Kr = gain*(1/(-(C-D*K)*inv(A-B*K)*B+D));

% Calculate feedback form of system

Af = A - B*K;
Bf = B*Kr;
Cf = C - D*K;
Df = D*Kr;

% Calculate system step response for open and closed loop system

% Open loop system
sys = ss(A, B, C, D);
Pol = pole(sys);
figure(1)
step(sys)
stepinfo(sys)
xlabel("Time [s]")
ylabel("Displacement [m]")
title("open-loop system")

% Closed loop system
sys = ss(Af, Bf, Cf, Df);
Pcl = pole(sys);
figure(2)
step(sys)
stepinfo(sys)
xlabel("Time [s]")
ylabel("Displacement [m]")
title("closed-loop system")
hold off
