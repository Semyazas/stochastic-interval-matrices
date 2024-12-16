% Computes bounds for all stationary distributions of realizations if given
% interval stochastic matrix
% within the given interval matrix.
% Inputs:
%   - interval_m: interval stochastic matrix of size (n x n)
% Outputs:
%   - x: interval vector representing bounds for stationary distributions
function x = solve_non_parametric(interval_m)
    correct_dimensions(interval_m);

    [center, mg] = generate_system_matrix_non_parametric(interval_m);
    vars_count = size(inf(interval_m), 1);

    b = zeros(1, vars_count);
    b = [b 1];
    b = [b -b zeros(1, vars_count)];
    x = solve(vars_count, center, mg, b, false);
end

% Solves the linear programming problem to find bounds on stationary distributions.
% Inputs:
%   - vars_count: number of variables (integer)
%   - center: center matrix from the generated system (numeric matrix)
%   - mg: system matrix from the generated system (numeric matrix)
%   - b: constraint vector (numeric vector)
%   - parametric: flag indicating if the problem is parametric (boolean)
% Outputs:
%   - x: interval vector with lower and upper bounds (infsup object)
function x = solve(vars_count, center, mg, b, parametric)
    options = optimoptions('linprog', 'Display', 'none');

    x_inf = zeros(1, vars_count);
    x_sup = ones(1, vars_count);

    A = -eye(vars_count);

    for i = 1:vars_count                   % we bound every entry in distribution
        f1 = zeros(1, size(center, 2));
        f1(i) = 1;

        constraints_ineq = [center - mg;   % constraints
                            -center - mg; 
                            A];
        if parametric
            constraints_ineq = sparse(constraints_ineq);
        end

        [a, fval_inf] = linprog(f1, ...
                                constraints_ineq, ...
                                b, [], [], [], [], options);

        [~, fval_sup] = linprog(-f1, ...  
                                constraints_ineq, ...
                                b, [], [], [], [], options);
        x_sup(i) = -fval_sup;
        x_inf(i) = fval_inf;
    end

    x = infsup(x_inf, x_sup);
end


