% Determine if there exists a stochastic realization of an interval matrix
% such that a given state is recurrent.
% Inputs:
%   - interval_matrix: interval matrix of size (n x n)
%   - state: state, an element of {1, 2, ..., n}
% Output:
%   - bool: true if there exists a stochastic realization of the interval
%           matrix such that the state is recurrent, otherwise false
function bool = is_state_weakly_recurrent(interval_matrix, state)
    correct_dimensions(interval_matrix);
    correct_state(inf(interval_matrix),state);
    lower_m = inf(interval_matrix);
    upper_m = sup(interval_matrix);
    G = get_weakly_rec_realization(lower_m, upper_m, state);
    if size(G, 1) > 0
        bool = true;
        return;
    end

    bool = false;
end


% Initialize the list of states which communicate with given state
% in the lower matrix.
% Inputs:
%   - lower_matrix: lower bound for interval matrix (numeric matrix)
%   - state: state, an element of {1, 2, ..., n}
% Output:
%   - R: list of states from which a path leads to the given state in
%        lower_matrix (array of integers)
function R = init_reds(lower_matrix, state)

    % Create a directed graph from the adjacency matrix
    G = digraph(transpose(lower_matrix));
            
    % Find the reverse graph to trace paths back to the target vertex
    G_rev = flipedge(G);
            
    % Find all vertices reachable from the target vertex in the reversed graph
    vertices_reaching_state = reshape(dfsearch(G_rev, state),1,[]);
    vertices_reached_by_state = reshape(dfsearch(G, state),1,[]);
       

    % Return the vertices communicating with state
    R = intersect(vertices_reached_by_state,vertices_reaching_state);
   
    if (size(R,2) == 0)
        R = [];
    end
end

% Determine if there is a path from a vertex to any state in a target set
% in the lower matrix.
% Inputs:
%   - vertex: vertex to check the path from (integer)
%   - target_set: set of target states (array of integers)
%   - lower_m: lower bound for interval matrix (numeric matrix)
% Output:
%   - bool: true if there is a path from the vertex to any state in the
%           target set, otherwise false
function bool = has_path_to_set(vertex, target_set, lower_m)
    bool = false;
    g = digraph(transpose(lower_m)); 

    if isempty(target_set)
        return;
    end

    for i = 1:size(target_set, 2)
        state = target_set(i);
        path1 = shortestpath(g, vertex, state);

        if (~isempty(path1))
            bool = true;
            return;
        end
    end
end

% Perform a single iteration of the process to find weakly recurrent
% states.
% Inputs:
%   - lower_m: lower bound for interval matrix (numeric matrix)
%   - upper_m: upper bound for interval matrix (numeric matrix)
%   - r: current set of states being processed (array of integers)
%   - q: set of states that have been moved out of r (array of integers)
% Outputs:
%   - stop: boolean indicating whether the iteration should stop (boolean)
%   - R: updated set of states being processed (array of integers)
%   - B: updated set of states that have been moved out of r (array of integers)
function [stop, R, B] = single_iteration(lower_m, upper_m, r, q)
    stop = true;
    toDelete = [];
    R = r;
    B = q;

    for i = 1:size(R, 2)
        if ~irreducibility.currently_belongs_to_u(R(i), R, upper_m) || ...
                                        has_path_to_set(R(i), B, lower_m)
           toDelete(end + 1) = R(i);
           B(end + 1) = R(i);
           stop = false;
        end
    end

    R = setdiff(R, toDelete);
end

% Get the weakly recurrent realization of the interval matrix for a given
% state.
% Inputs:
%   - lower_m: lower bound for interval matrix (numeric matrix)
%   - upper_m: upper bound for interval matrix (numeric matrix)
%   - state: state, an element of {1, 2, ..., n}
% Output:
%   - G: weakly recurrent realization of the interval matrix (numeric matrix)
function G = get_weakly_rec_realization(lower_m, upper_m, state)
    largestPosGraph = irreducibility.generate_largest_realization(lower_m, upper_m);
    R = init_reds(largestPosGraph, state);
    B = setdiff(uint32(1):uint32(size(lower_m, 1)), R);
    stop = false;

    while stop == false && size(R, 2) > 0
        [stop, R, B] = single_iteration(lower_m, upper_m, R, B);

        if stop == true
            G = irreducibility.reducible_realization_from_partitions(lower_m, upper_m, R, B);
            return;
        end
    end
    G = [];
end
