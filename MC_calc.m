function [Mc, invMc] = MC_calc(A, B);
%{
    Function that calculates the Mc matrix and its inverse for control
    canonical form

    Inputs: A is an nxn matrix and B is a column vector
    Outputs: Mc and invMc are nxn matrices
%}

% Preallocate Mc
Mc = zeros(size(A));

% Calculate Mc
for i = 1:length(A)
    Mc(:,i) = A^(i-1)*B;
end

invMc = inv(Mc);
