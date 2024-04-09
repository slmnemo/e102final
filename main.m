% Written by Pierce Gruber and Kaitlin Lucio
clear

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

D = 0;

[Mc, invMc] = testControllability(A, B);
[Mo, invMo] = testObservability(A, C);
