function [Mo, invMo] = MO_calc(A, C)
%{
    Function that calculates the Mc matrix and its inverse for control
    canonical form

    Inputs: A is an nxn matrix and B is a column vector
    Outputs: Mc and invMc are nxn matrices
%}

% Preallocate Mc
Mo = zeros(size(A));

% Calculate Mc
for i = 1:size(C,1):length(A)
    Mo(i:i-1+size(C,1),:) = C*A^((i-1)/(size(C,1)));
end

invMo = inv(Mo);
