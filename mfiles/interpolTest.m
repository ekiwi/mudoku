function [A] = interpolTest (A)
nan_locations = find(isnan(A));
A(nan_locations) = 0;
A = filter2(ones(3,3), A);
