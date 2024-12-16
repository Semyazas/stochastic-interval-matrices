
% input - interval_m - interval matrix of size (n x n)
% 
% output - Enclosure for all stationary distributions of stochastic
%          matrices in interval_m. 

function x = solve_hybrid(interval_m)
    correct_dimensions(interval_m);

    parametric_system = generate_parametric_system(interval_m);

    system_temp = interval_m - eye(size(inf(interval_m),1));
    non_parametric_system = [ system_temp ; 
               ones(1,size(inf(interval_m),1))
             ];

    % Pad the non-parametric system with zeros to match the number of columns in the parametric system
    [rows_p, cols_p] = size(parametric_system);
    [rows_np, ~] = size(non_parametric_system);   

    
    padded_non_parametric_system = [non_parametric_system, zeros(rows_np, cols_p)];
    
    % Concatenate parametric and padded non-parametric systems

    print(padded_non_parametric_system)
    print(parametric_system)
    system = [padded_non_parametric_system;
              parametric_system];

    upper_m1 = sup(parametric_system);

    % Calculate the center and radius of the interval system
    radius = rad(system);
    center = mid(system);

    b1 = [zeros(1, size(upper_m1, 1)), ...
         zeros(1, size(upper_m1, 1) * size(upper_m1, 1)), ... % right hand side for D
         zeros(1, size(upper_m1, 1) * size(upper_m1, 1)), ... % right hand side for N
         1];
   
    b1 = [b1, -b1, zeros(1, size(upper_m1, 1))];

    vars_count = size(inf(interval_m), 1);
    b2 = zeros(1, vars_count);
    b2 = [b2 1];
    b2 = [b2 -b2 zeros(1, vars_count)];
    

    % Solve the system
    x = solve(size(lower_m, 1), center, radius, [b1 b2]);
end

function x = solve(vars_count, center, mg, b)
    options = optimoptions('linprog', 'Display', 'none');
    x_inf = zeros(1, vars_count);
    x_sup = ones(1, vars_count);

    B = -eye(vars_count*vars_count);
    for i=1:vars_count
       B((vars_count)*(i-1) + i,vars_count*(i-1) + i) = 1;
    end

    A = [-eye(vars_count), zeros(vars_count, size(mg, 2) - vars_count);
             zeros(vars_count*vars_count,vars_count),zeros(vars_count*vars_count),B;
             zeros(vars_count*vars_count,vars_count),-eye(vars_count*vars_count),zeros(vars_count*vars_count)];
        
    b = [b , zeros(1,vars_count*vars_count+vars_count*vars_count)];

    for i = 1:vars_count
        f1 = zeros(1, size(center, 2));
        f1(i) = 1;  
        constraints_ineq = [center - mg; -center - mg; A];

        constraints_ineq = sparse(constraints_ineq);

        [~, fval_inf] = linprog(f1, constraints_ineq, b, [], [], [], [], options);
        [~, fval_sup] = linprog(-f1, constraints_ineq, b, [], [], [], [], options);
    %    disp(a);
    %    disp(b);
        x_sup(i) = -fval_sup;
        x_inf(i) = fval_inf;
    end
    x = infsup(x_inf, x_sup);
   % disp(x);
end