% This function performs experiments to compare enclosures of stationary 
% distributions obtained using parametric and non-parametric methods.
%
% Inputs:
%   dimensions - An array specifying the dimensions of the matrices to be tested.
%   number_of_iterations - An integer specifying the number of iterations for testing matrices of a given dimension.
%   error - A value indicating how "wide" the generated matrices are in the experiment. 
%           Random irreducible stochastic matrices A are generated, and then 
%           interval stochastic matrices [A] are created as [(1-error)A, (1+error)A].
%
% The function displays the results of the experiments, including the average 
% ratios and times for the parametric and non-parametric methods.
function experiment(dimensions, number_of_iterations,error)
    options = optimset('linprog');
    options.Display = 'off';

    % we test for each dimension

    for i=1:size(dimensions,2)
        disp(dimensions(i));
        small_experiment(dimensions(i),number_of_iterations,error);
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
%   average_ratio - The average ratio of the parametric method to the non-parametric method.
%   average_time - The average time taken by each method.
function [average_ratio] = small_experiment(dimension, number_of_iterations,error)
    average_ratio = 0;
    average_time_parametric = 0;
    average_time_non_parametric = 0;
    average_ratio_intersection_non_par = 0;
    for i=1:number_of_iterations
        [lower,upper] = rand_int_irreduc_stoch_matrix(dimension,error);
       
        tic
        x_non_parametric = solve_non_parametric(...
                                       infsup(lower,upper));
        average_time_non_parametric = average_time_non_parametric + toc;

        tic 
        x_parametric = solve_parametric(        ...
                                       infsup(lower,upper));

        average_time_parametric = average_time_parametric + toc;


        average_ratio = average_ratio + ratio(x_parametric,x_non_parametric);
        average_ratio_intersection_non_par = average_ratio_intersection_non_par + ratio(x_non_parametric,intersect(x_parametric,x_non_parametric));
    end
    average_ratio = average_ratio / number_of_iterations;
    average_time_parametric = average_time_parametric / number_of_iterations;
    average_time_non_parametric = average_time_non_parametric / number_of_iterations;
    average_ratio_intersection_non_par = average_ratio_intersection_non_par / number_of_iterations;

    disp("average ratio:               " + average_ratio);
    disp("average ratio intersection:  " + average_ratio_intersection_non_par);
    disp("average time parametric:     " + average_time_parametric);
    disp("average_time_non_parametric: " + average_time_non_parametric)
end
