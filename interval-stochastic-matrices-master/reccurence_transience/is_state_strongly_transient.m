% Function for deeciding strong transience of interval stochastic matrix
% input - interval_matrix - interval matrix of size (n x n)
% input - state - state is element of {1,2, ... n}
%
% output - if in all realizations of interval_matrix is state transient,
%          then returns true, otherwise false
function bool = is_state_strongly_transient(interval_matrix,state)
    bool = not(is_state_weakly_recurrent(interval_matrix,state));
end 