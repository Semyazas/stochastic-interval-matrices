% Class that takes care of functionality for main functions
% is_strongly_irreducible and is_weakly_irreducible.
% It is useful to have them in one class, since they share some
% helper functions.

% We will talk about states of markov chain represented by stochastic
% matrix. States for stochasti matrix of dimenion n are integers from 1 to
% n.

classdef irreducibility

    methods (Static)  

        % Check if all column sums of the given matrix are equal to 1.
        % Input: matrix (numeric matrix)
        % Output: bool (boolean)
        function bool = are_collumn_sums_equal1(matrix)
            bool = true;
            for i = size(matrix,2)
                sum = irreducibility.get_column_sum(matrix,i);
                if sum ~= 1
                    bool = false;
                    return;
                end
            end
        end



        %=================Weak Irreducibility=========================
        
        % We want to check whether is given stochastic interval matrix [A]
        % weakly irreducible. We say that [A] is weakly irreducible if 
        % there is stochastic realization such that it is irreducible.

        % Calculate the sum of a specific column in a matrix.
        % Input: matrix (numeric matrix), column_index (integer)
        % Output: sum (numeric)
        function sum = get_column_sum(matrix,column_index)
            sum = 0;
            for i=1:size(matrix)
                sum = sum + matrix(i,column_index);
            end
        end

        % Calculate the column normalization for a given column and row.
        % Input: matrix (numeric matrix), column_index (integer), row_index (integer)
        % Output: sum (numeric)
        function sum = get_column_normalization(matrix,column_index, ...
                                                              row_index)
            sum = 0;
            for i=1:size(matrix)
                if i ~= row_index
                    sum = sum + matrix(i,column_index);
                end
            end
        end

        % Function returns number of neighbours of given state (states to
        % which we can get with nonzero probability with 1 step)
        % (column_index) such that in function "generate_largest_realization" 
        % can be value on position (neighbour,column_index) made > 0 (within constraints of interval stochastic matrix given to "generate_largest_realization" ).

        % Input:  lower_matrix (numeric matrix), upper_matrix (numeric matrix), column_index (integer)
        % Output: count (integer)
        function count = zero_neighbours(lower_matrix,upper_matrix, ...
                                                            column_index)
            count = 0;
            for i = 1:size(lower_matrix,1)
                if (lower_matrix(i,column_index) == 0 && ...
                            upper_matrix(i,column_index) > 0)
                    count = count + 1;
                end
            end
        end

        % Adjust the column sum of the largest graph to ensure column sum equals 1.
        % Input: largest_graph (numeric matrix), vertex_index (integer), upper_matrix (numeric matrix)
        % Output: largest_graph (numeric matrix)
        function largest_graph = adjust_column_sum( ...
                            largest_graph ,vertex_index,upper_matrix)
            
            for i=1:size(largest_graph)
                column_sum = irreducibility. ...
                                get_column_sum(largest_graph,vertex_index);
                if column_sum == 1
                    break;
                end
                largest_graph(i,vertex_index) = min( ...
                             upper_matrix(i,vertex_index), ...
                             1 - irreducibility. ...
                             get_column_normalization(largest_graph, ...
                                                    vertex_index,i));
            end
        end



        % We find stochastic realization (largest_graph) of interval matrix given by bound 
        % matrices such that value of its entry is nonzero if and only if exists stochastic realization such that 
        % said entry is nonzero.
        % Input:  lower_matrix (numeric matrix), upper_matrix (numeric matrix)
        % Output: largest_graph (numeric matrix)
        function largest_graph = generate_largest_realization(lower_matrix, ...
                                                        upper_matrix)
            correct_dimensions(infsup(lower_matrix,upper_matrix));
            largest_graph = lower_matrix;

            for j=1:size(lower_matrix)        
                column_sum = irreducibility.get_column_sum(lower_matrix,j);
                neigbs_to_improve_count = irreducibility.zero_neighbours( ...
                                            lower_matrix,upper_matrix, j); 
                  
                if column_sum < 1
                    
                    if (neigbs_to_improve_count > 0)
                        % if we can improve some values, then we improve
                        % them (make them nonzero)
                        for i=1:size(lower_matrix)
                                if lower_matrix(i,j) == 0
                                    largest_graph(i,j) = min(upper_matrix(i,j), ...
                                                            (1-column_sum) / ...
                                                            neigbs_to_improve_count);
                                end
                        end
                    end
                    % since we are trying to find stochastic realization,
                    % we have to normalize sum of columns
                    largest_graph = irreducibility. ...
                            adjust_column_sum(largest_graph, ...
                                              j,upper_matrix);            
                end
            end
        end

        

        % Determine if interval stochastic matrix given by bound matrices is weakly irreducible.
        % Input: lower_matrix (numeric matrix), upper_matrix (numeric matrix)
        % Output: tf (boolean)
        function tf = is_weakly_irreducible(lower_matrix, upper_matrix) 
            correct_dimensions(infsup(lower_matrix,upper_matrix));
            
            G = digraph(irreducibility.generate_largest_realization(lower_matrix, ...
                                                             upper_matrix));
            components =  conncomp(G,'OutputForm','cell');

            if size(components,2) == 1
                tf = true;
                return;
            end
            
            tf = false;
        end


        %=================Strong Irreducibility=======================

        % We want to find partition of vertices (U,V), such that there exsits realization, such that from U there
        % is no path to V. We start in some vertex and from that vertex we
        % iteratively build U. 


        % Normalize the state by adjusting the graph such that the column
        % sums equal 1 (or at least the largest possible value lower than
        % one) and edges lead only to given set of neighbors. 
        % Input: vertex (integer), neighbours (array of integers), g (numeric matrix), upper_matrix (numeric matrix)
        % Output: G (numeric matrix) such that matrix representing G is
        % stochastic
        function G = normalize_state(vertex,neighbours,g,upper_matrix)           
            G = g;
            for i = 1:size(neighbours,2)
                neighb = neighbours(i);

                col_sum = irreducibility.get_column_normalization(G,vertex, ...
                                                                  neighb);
                if col_sum == 1
                    return
                end
                G(neighb,vertex) = min(1-col_sum, ...
                                            upper_matrix(neighb,vertex));
            end
        end

        % Return a realization such that there are no edges from set V to set U.
        % Input: g (numeric matrix), upper_graph (numeric matrix), U (array
        % of integers), V (array of integers), where (V,U) form reducible
        % partition.
        % Output: G (numeric matrix) such that it is stochastic and
        % reducible
        function G = reducible_realization_from_partitions(g,upper_graph,U,V)
            G = g;
            % At first we for each vertex in V normalize its edges so that
            % they lead only between other vertices from V
            for i = 1:size(V,2)
                vertex = V(i);
                correct_state(upper_graph,vertex);
                G = irreducibility.normalize_state(vertex,V,G,upper_graph);
            end
            
            % Now we normalize rest.
            for i = 1:size(U,2)
                V_vert = U(i);
                correct_state(upper_graph,V_vert);
                G = irreducibility.normalize_state(V_vert,U,G,upper_graph);

                G = irreducibility.normalize_state(V_vert,V,G,upper_graph);
            end
        end

        % Initialize the sets U and V for the reducible partition.
        % Input: lower_matrix (numeric matrix), start_vert (integer)
        % Output: V (array of integers), U (array of integers)
        %         In V are only vertices such that there is path in lower
        %         matrix from them to given start vertex (start_vert).
        function [V,U] = init_reducible_real(lower_matrix,start_vert)

            % Create a directed graph from the adjacency matrix
            G = digraph(transpose(lower_matrix));
            
            % Find the reverse graph to trace paths back to the target vertex
            G_rev = flipedge(G);
            
            % Find all vertices reachable from the target vertex in the reversed graph
            reachable_vertices = dfsearch(G_rev, start_vert);
            
            % Return the reachable vertices
            V = reachable_vertices;
            V = reshape(V,1,[]);
            U = setdiff(1:size(lower_matrix,2),V);

            if (size(V,2) == size(lower_matrix,2))
                U = [];
            end
        end

        % Function decides whether edges leading from vertex can be buffed so that they
        % are only between nodes in U and sum up to 1
        % Input: vertex (integer), U (array of integers), upper_matrix (numeric matrix)
        % Output: bool (boolean)
        function bool = currently_belongs_to_u(vertex,U,upper_matrix)
            bool = false;
            upper_sum = 0;
            for i=1:size(U,2)       
                 upper_sum = upper_sum + upper_matrix(U(i),vertex); 
                 if upper_sum >= 1
                     bool = true;
                     return;
                 end
            end
        end

        % Function returns reducible partition of vertices from the given start vertex.
        % Input: lower_matrix (numeric matrix), upper_matrix (numeric matrix), start_vertex (integer)
        % Output: U (array of integers), V (array of integers)
        %         - if there is reducible partition (U,V) start vertex is
        %         in V, then function returns it
        %         - otherwise function returns [[],[]]
        function [U,V] = partition_from_vertex(lower_matrix, ...
                                    upper_matrix, start_vertex)
            correct_state(lower_matrix,start_vertex);
            G = lower_matrix;
            [V,U] = irreducibility.init_reducible_real(G,start_vertex);

            while size(V,1) ~= size(lower_matrix,1)
                temp = [];
                should_stop = true;
                % Every iteration we look if our realization can be
                % modified such that all vertices from U have edges only
                % between U.
                for i = 1:size(U,2)
                    vert = U(i);
                    bool = irreducibility.currently_belongs_to_u(vert, ...
                                                         U,upper_matrix);
                    % If some vertex doesnt have edges only between
                    % vertices from U, then it must belong to V.
                    if bool ~= true
                        temp(end+1) = vert;
                        V(end+1)    = vert; 
                        should_stop = false;
                    end
                end
                U = setdiff(U,temp); 
                if should_stop == true
                    return;
                end
            end
            % If we haven't found any valid partition, return empty lists.
            U = [];
            V = [];
        end

        % Find a reducible partition of the graph.
        % Input: lower_matrix (numeric matrix), upper_matrix (numeric matrix)
        % Output: U (array of integers), V (array of integers) 
        %         - if there is reducible partition (U,V) in graph, then we
        %           return it
        %         - otherwise we return empty lists
        function [U,V] = reducible_partition(lower_matrix, ...
                                                upper_matrix)
            correct_dimensions(infsup(lower_matrix,upper_matrix));
            
            for vertex = 1:size(lower_matrix)
                [U,V] = irreducibility.partition_from_vertex(lower_matrix, ...
                                                        upper_matrix,vertex);

                if  size(U,1) > 0
                    return
                end
            end
        end


        % Determine if the interval stochastic matrix is strongly irreducible.
        % Input: lower_matrix (numeric matrix), upper_matrix (numeric matrix)
        % Output: tf (boolean)
        function tf = is_strongly_irreducible(lower_matrix, upper_matrix)
            correct_dimensions(infsup(lower_matrix,upper_matrix));

            [U,V] = irreducibility.reducible_partition(lower_matrix, ...
                                                            upper_matrix);
            if size(U,1) > 0
                tf = false;
                return;
            end
            tf = true;
        end
    end
end