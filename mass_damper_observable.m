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

% Calculate Mo and test for invertibility

[Mo, invMo] = MO_calc(A, C);

if det(Mo) == 0
    error("Not Observable! Mo is not invertible [determinant = 0]")
else
    disp("Mo is invertible, this system is observable!")
end
