% This function generates a reducible stochastic matrix with a specific 
% Markov chain structure.
%
% Inputs:
%   n - An integer representing the dimension of the matrix (number of rows and columns)
%
% Outputs:
%   A - An n-by-n reducible stochastic matrix where the underlying Markov chain
%       follows the pattern: 1->2, 2->3, ..., n-1->n, and n->n.

function A = int_reducible_stochastic_matrix(n)
    B = createGraph(n);
    
    A = infsup(1/(n^2) * B, B);
    
    G = digraph(transpose(B));
  %  plot(G);
end

% This helper function creates an adjacency matrix representing the graph 
% structure of the Markov chain.
%
% Inputs:
%   n - An integer representing the dimension of the matrix (number of rows and columns)
%
% Outputs:
%   adjMatrix - An n-by-n adjacency matrix representing the graph

function adjMatrix = createGraph(n)
    adjMatrix = zeros(n);

    % Set the edges 1->2, 2->3, ..., n-1->n
    for i = 1:n-1
        adjMatrix(i, i+1) = 1;
    end
    
    % Set the edge n->n
    adjMatrix(n, n) = 1;
    
    adjMatrix = transpose(adjMatrix);
end
