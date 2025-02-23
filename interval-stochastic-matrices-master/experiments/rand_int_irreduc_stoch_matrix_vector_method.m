% This function generates an irreducible stochastic matrix and returns the lower
% and upper bounds matrices based on a given error margin.
%
% Inputs:
%   size - An integer representing the size of the matrix (number of rows and columns)
%   error - A float representing the error margin for generating the lower and upper bounds
%
% Outputs:
%   lower - A matrix representing the lower bound of the irreducible stochastic matrix
%   upper - A matrix representing the upper bound of the irreducible stochastic matrix
function [lower, upper] = rand_int_irreduc_stoch_matrix_vector_method(size, error)
    % Initialize a 2x2 identity matrix to start with
    x = [1 0; 0 1];
    mc = dtmc(x);
    
    % Generate an irreducible stochastic matrix
    while isreducible(mc)
        disp("funguju")
        x = rand_stoch_matrix_vec(size);
        mc = dtmc(transpose(x));
    end
    
    % Calculate lower and upper bounds based on the error margin
    lower = (1 - error) * x;
    upper = (1 + error) * x;
end

% This helper function generates a stochastic matrix of a given size
%
% Inputs:
%   size - An integer representing the size of the matrix (number of rows and columns)
%
% Outputs:
%   x - A size-by-size stochastic matrix where each column sums to 1
function x = rand_stoch_matrix_vec(size)
    x = zeros(size);

    % Generate random values for the matrix
    for i = 1:size
        col = rand(size, 1);
        x(:,i) = col;
    end
    disp(x)
    disp("aaa")
    % Normalize each column to make the matrix stochastic
    for j = 1:size
        col_sum = irreducibility.get_column_sum(x, j);
        if col_sum == 0 || isnan(col_sum)
            x = rand_stoch_matrix_vec(size); % Retry if column sum is zero or NaN
        else
            for i = 1:size
                x(i, j) = x(i, j) / col_sum;
            end
        end
    end
end