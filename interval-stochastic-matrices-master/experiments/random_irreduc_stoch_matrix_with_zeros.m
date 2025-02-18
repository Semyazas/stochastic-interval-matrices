function [lower_m,upper_m] = random_irreduc_stoch_matrix_with_zeros(size,p,error)

    % Ensure irreducibility by checking if the matrix forms a strongly connected graph
    int_M = generate_random_graph(p,size);
    while (int_M == 0 | ~is_irreducible(int_M))
        int_M = generate_random_graph(p,size);
    end
    lower_m = int_M * (1-error);
    upper_m = int_M * (1 + error);
end

function G = generate_random_graph(p, size)
    G = zeros(size); % Initialize adjacency matrix
    for j = 1:size 
        col = rand(size, 1); % Generate random column values
        for i = 1:size
            if rand() < p  % Fixing the probability check
                col(i) = 0; % Set to zero with probability p
            end
        end
        % Ensure at least one nonzero entry per column to avoid division by zero
        if all(col == 0)
            G = 0;
            return
        end
        
        col = col / sum(col); % Normalize to make column stochastic
        G(:, j) = col; 
    end
end


function flag = is_irreducible(M)
    % Check if matrix M is irreducible using graph theory
    G = digraph(M > 0); % Create a directed graph based on nonzero elements
    flag = all(reachability(G)); % Check strong connectivity
end

function r = reachability(G)
    % Compute reachability from every node to every other node
    r = all(arrayfun(@(n) numel(reachable_nodes(G, n)) == numnodes(G), 1:numnodes(G)));
end

function nodes = reachable_nodes(G, startNode)
    % Find all reachable nodes from startNode
    nodes = bfsearch(G, startNode); 
end
