% Function for finding reducible partition given interval matrix and
% reducible parition (U,V).
%
% Input:
%       - interval_matrix - interval matrix of size (n x n)
%       - U ... subset of {1,2, ... ,n}
%       - V subset of {1,2, ... ,n}, (U,V) form partition of {1,2, ... ,n},
%         partition of states such that there exists stochastic realization
%         of interval_matrix is no path from states of V to states of U
%
% Output: 
%       - G - stochastic realization of interval_matrix such that it is
%             reducible (if it exists)

function G = reducible_realization_from_partitions(interval_matrix,U,V)
    correct_dimensions(interval_matrix);
    g = inf(interval_matrix);
    upper_graph = sup(interval_matrix);
    G = irreducibility.reducible_realization_from_partitions(g,upper_graph,U,V);
end

      