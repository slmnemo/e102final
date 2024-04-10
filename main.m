% Written by Pierce Gruber and Kaitlin Lucio
clear

% Variable definitions

L = 0.5;
g = 9.8;

% Pole calculations

zetaCon = 2;
wCon = 3;
conPolynom = [1 2*zetaCon*wCon wCon^2];
conPoles = roots(conPolynom);
conPoles = [conPoles', 15*max(conPoles), 20*max(conPoles)];
sys = tf(wCon^2, conPolynom);
step(sys)

zetaObs = 1;
wObs = 13.2;
obsPolynom = [1 2*zetaObs*wObs wObs^2];
obsPoles = roots(obsPolynom);
% sys = tf(wObs^2, obsPolynom);
% step(sys)

obsPoles = [obsPoles', 15*max(obsPoles), 20*max(obsPoles)];


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
