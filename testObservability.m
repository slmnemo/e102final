function [Mo, invMo] = testObservability(A, C)
%{
    Takes in a state-space matrix A and C and displays whether the observer
    matrix is invertible, and thus if the system is observable. Errors if
    unobservable.
%}

[Mo, invMo] = MO_calc(A, C);

if det(Mo) == 0
    error("Not Observable! Mo is not invertible [determinant = 0]")
else
    disp("Mo is invertible, this system is observable!")
end
