function [Ac, Bc, Cc, Dc] = CCF_calc(A, B, C, D)
%{
    Calculates the CCF matrices for a state space system
    
    Inputs: A [nxn Matrix], B [nx1]
    Outputs: Ac, Bc, Cc, Dc
%}
[Mc, invMc] = MC_calc(A,B);
[T, invT] = T_calc(A,invMc);

Ac = invT*A*T;
Bc = invT*B;
Cc = C*T;
Dc = D;

