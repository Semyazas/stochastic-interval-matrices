% Computes the intersection of the given interval matrix with the set of
% stochastic matrices.
% Inputs:
%   - lower: lower bound of the interval matrix (numeric matrix)
%   - upper: upper bound of the interval matrix (numeric matrix)
% Outputs:
%   - V: vertices of the intersection (numeric matrix)
%   - I: indices of the vertices (numeric vector)
function [V,I] = get_intersection3(interval_matrix)
   lower = inf(interval_matrix);
   
   interval_matr = interval_matrix - eye(size(lower,1));
   
   V = [];
   I = [];
   for i=1:size(lower,1)
       [system_bounds,RHS] = get_system_bounds(inf(interval_matr), ...
                                          sup(interval_matr),i);

       inters    = intersectionHull('lcon',system_bounds,RHS,[],[], ...
                                         'lcon',[],[],ones(1,size(lower,1)),0);    
       V = [V; inters.vert];
       if i > 1
           I(end+1) = I(i-1) + size(inters.vert,1);
       else
           I = [size(inters.vert,1)];
       end
   end
   V = transpose(V);
end

% Generates the system bounds for the given column index.
% Inputs:
%   - lower: lower bound of the interval matrix (numeric matrix)
%   - upper: upper bound of the interval matrix (numeric matrix)
%   - column_index: column index (integer)
% Outputs:
%   - system_bounds: system bounds matrix (numeric matrix)
%   - RHS: right-hand side vector (numeric vector)
function [system_bounds,RHS] =  get_system_bounds(lower,upper,column_index)
    system_bounds = [
                       eye(size(lower,1));
                      -eye(size(lower,1))
                    ];
    vec_lower = [lower(:,column_index)];
    vec_upper = [upper(:,column_index)];
    RHS       = [vec_upper ; -1*vec_lower];
end