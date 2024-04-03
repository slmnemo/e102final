function [T, invT] = T_calc(A, invMc);
%{
    Function that calculates the Mc matrix and its inverse for control
    canonical form

    Inputs: A is an nxn matrix and invMc is an nxn matrix
    Outputs: T and invT are nxn matrices
%}

% Preallocate tn and T
tn = [zeros(1,length(A)-1) 1]*invMc;
T = zeros(size(A));


% Calculate Mc
for i = 1:length(A)
    T(i,:) = tn*A^(length(A)-i);
end

invT = inv(T);
