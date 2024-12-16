
% input - interval_m - interval matrix of size (n x n)
%
% output - largest_realization - realization that contains edge if and only if
%          some stochastic realization of interval_m contains it
%
% for implementation details look into file irreducibility
function largest_realization = generate_largest_realization(interval_m)
    largest_realization = irreducibility.generate_largest_realization(inf(interval_m),sup(interval_m));
end