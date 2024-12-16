% Function for finding reducible partition (U,V).
% 
% Input: 
%       - interval_matrix - interval matrix of size (n x n)
%
% Output: 
%       - If interval_m has reducible partition then function returns 
%         partition of states such that there exists stochastic realization
%         of interval_matrix is no path from states of V to states of U.
%        
%       - Else it returns [[],[]].
%
% for implementation details look into file irreducibility


function [U,V] = reducible_partition(interval_m)
    correct_dimensions(interval_m);
    [U,V] = irreducibility.reducible_partition(inf(interval_m),sup(interval_m));
end        

