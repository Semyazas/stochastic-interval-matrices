% This function performs experiments to compare enclosures of stationary 
% distributions obtained using nonparametric, parametric and exact methods.
%
% Inputs:
%   dimensions - An array specifying the dimensions of the matrices to be tested.
%   number_of_iterations - An integer specifying the number of iterations for testing matrices of a given dimension.
%   error - A value indicating how "wide" the generated matrices are in the experiment. 
%           Random irreducible stochastic matrices A are generated, and then 
%           interval stochastic matrices [A] are created as [(1-error)A, (1+error)A].
%
% The function displays the results of the experiments, including the average 
% ratios and times for different methods.

function experiment_with_exact_stationary_distribution(dimensions, ...
                                                number_of_iterations,error, generate_random_IISM)
    options = optimset('linprog');
    options.Display = 'off';

    for i=1:size(dimensions,2)
        disp(dimensions(i));
        small_experiment(dimensions(i),number_of_iterations,error, generate_random_IISM);
        disp("");
        disp("---------------------------------------------------");
        disp("");
    end
end

% This helper function performs a small experiment for a specific dimension.
%
% Inputs:
%   dimension - An integer specifying the dimension of the matrix.
%   number_of_iterations - An integer specifying the number of iterations for testing.
%   error - A value indicating the width of the generated matrices in the experiment.
%
% Outputs:
%   average_ratio - The average ratio of the results from the parametric and non-parametric methods to the exact method.
%   average_time - The average time taken by each method.

function [average_ratio,average_time] = small_experiment(dimension, number_of_iterations,error, generate_random_IISM)
    average_ratio_non_parametric = 0;
    average_ratio_parametric     = 0;
    average_ratio_hybrid         = 0;
    average_ratio_exact          = 0;
 
    average_time_parametric      = 0;
    average_time_non_parametric  = 0;
    average_time_exact           = 0;
    average_time_hybrid          = 0;

    for i=1:number_of_iterations

        was_interval = false;
        while ~was_interval

            [lower,upper] =  generate_random_IISM(dimension,error);
            
          % disp("random generátor vygeneroval");
            tic
    
            x_non_parametric = solve_non_parametric(infsup(lower, upper));
          % disp("NEparametrický program doběhl");
            average_time_non_parametric = average_time_non_parametric + toc;
    
            tic 
            x_parametric = solve_parametric(infsup(lower, upper));
    
          % disp("parametrický program doběhl");
    
            average_time_parametric = average_time_parametric + toc;
    
            tic
    
            x_exact = solve_exact(infsup(lower, upper));
    
            average_time_exact = average_time_exact + toc;
    
            tic 
            x_hybrid = solve_hybrid(infsup(lower,upper));
    
            average_time_hybrid = average_time_hybrid + toc;
     %       disp(ratio(x_parametric,x_exact))

            if  ratio(x_parametric,x_exact) ~= inf
                average_ratio_parametric     = average_ratio_parametric + ratio(x_parametric,x_exact);
                average_ratio_non_parametric = average_ratio_non_parametric + ratio(x_non_parametric,x_exact);
                average_ratio_hybrid         = average_ratio_hybrid + ratio(x_hybrid,x_exact);
                was_interval = true;
            end
            
      %      disp("x_hybrid")
      %      disp(x_hybrid);
      %      disp("x_parametric")
      %      disp(x_parametric);
      %      disp("x_exact")
      %      disp(x_exact)
        end
    end
    average_ratio_parametric = average_ratio_parametric / number_of_iterations;
    average_ratio_non_parametric = average_ratio_non_parametric / number_of_iterations;
    average_ratio_hybrid = average_ratio_hybrid / number_of_iterations;
    

    average_time_parametric = average_time_parametric / number_of_iterations;
    average_time_non_parametric = average_time_non_parametric / number_of_iterations;
    average_time_exact = average_time_exact / number_of_iterations;
    average_time_hybrid = average_time_hybrid / number_of_iterations;

    disp("average ratio hybrid:          " + average_ratio_hybrid);
    disp("average ratio parametric:      " + average_ratio_parametric);
    disp("average ratio non parametric:  " + average_ratio_non_parametric);

    disp("average time hybrid            " + average_time_hybrid)
    disp("average time parametric:       " + average_time_parametric);
    disp("average_time_non_parametric:   " + average_time_non_parametric);
    disp("average time exact:            " + average_time_exact);
end