function [Mc, invMc] = testControllability(A, B)
%{
    Takes in a state-space matrix A and B and displays whether the control
    matrix is invertible, and thus if the system is controllable. Errors if
    uncontrollable.
%}

[Mc, invMc] = MC_calc(A, B);

if det(Mc) == 0
    error("Mo is not invertible [determinant = 0]")
else
    disp("Mo is invertible, this system is controllable!")
end
