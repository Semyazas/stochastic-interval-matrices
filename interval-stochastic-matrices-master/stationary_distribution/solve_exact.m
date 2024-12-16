% Computes a tight bound for all stationary distributions of stochastic
% matrices within the given interval matrix.
% Inputs:
%   - interval_m: interval matrix of size (n x n)
% Outputs:
%   - x: interval vector representing tight bounds for stationary distributions
function x = solve_exact(interval_m)
    correct_dimensions(interval_m);
    lower = inf(interval_m);

    [V, I] = get_intersection3(interval_m);

    x_inf = zeros(1, size(lower, 1));
    x_sup = zeros(1, size(lower, 1));
    options = optimoptions('linprog', 'Display', 'none');
    start = 1;

    for i = 1:size(lower, 1)
        f = zeros(size(V, 2), 1);
        for j = start:I(i)
            f(j) = 1;
        end

        [~, fval_inf] = linprog(f, -1*eye(size(V, 2)), zeros(size(V, 2), 1), ...
                                [V; ones(1, size(V, 2))], [zeros(1, size(V, 1)) 1], [], [], options);

        [~, fval_sup] = linprog(-f, -1*eye(size(V, 2)), zeros(size(V, 2), 1), ...
                                [V; ones(1, size(V, 2))], [zeros(1, size(V, 1)) 1], [], [], options);

        x_inf(i) = fval_inf;
        x_sup(i) = -fval_sup;
        start = I(i) + 1;
    end

    x = infsup(x_inf, x_sup);
end
