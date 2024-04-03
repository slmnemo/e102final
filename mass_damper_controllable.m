% Variable definitions

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

% Calculate Mc and test for invertibility

[Mc, invMc] = MC_calc(A, B);

if det(Mc) == 0
    error("Mc is not invertible [determinant = 0]")
else
    disp("Mc is invertible, this system is controllable!")
end
