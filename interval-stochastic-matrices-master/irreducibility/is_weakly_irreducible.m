% Function for testing weak irreducibility of stochastic interval matrices
%
% input - interval_matrix - interval matrix of size (n x n)
%
% output - true if at least one stochastic realization of interval_matrix
%          is irreducible, otherwise false
%
% for implementation details look into file irreducibility

function tf = is_weakly_irreducible(interval_m)
    tf = irreducibility.is_weakly_irreducible(inf(interval_m),sup(interval_m));
end
