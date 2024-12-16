% input - interval_matrix - interval matrix of size (n x n)
% input - state - state is element of {1,2, ... n}
%
% output - if in all realizations of interval_matrix is state reccurent,
%          then returns true, otherwise false

function bool = is_state_strongly_reccurent(interval_m,state)
    bool = not(is_state_weakly_transient(interval_m,state));
end