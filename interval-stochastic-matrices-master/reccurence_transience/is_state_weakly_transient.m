% Function for deciding weak transience of interval stochastic matrix
% Inputs:
%        interval_matrix - interval matrix of size (n x n)
%        state - state is element of {1,2, ... n}
%
% Outputs 
%        if there exists stochastic realization of interval_matrix such that state
%        is in it transient then true, else false

function bool = is_state_weakly_transient(interval_matrix, state)
    correct_dimensions(interval_matrix);
    correct_state(inf(interval_matrix),state);
    bool = false;

    largest_realization = generate_largest_realization(interval_matrix);
    largest_graph = digraph(transpose(largest_realization));

    if is_strongly_irreducible(interval_matrix)
        bool = false;
        return;
    end

    [U, ~] = partition_from_vertex(interval_matrix, state);
    
    visited = dfsearch(largest_graph,state);
        
    if (size(intersect(visited,U),1) ~= 0 && size(intersect(visited,U),2) ~= 0)
        bool = true;
        return;
    end
end
