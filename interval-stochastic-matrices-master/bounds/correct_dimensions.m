
% Function: correct_dimensions
% Inputs:
%   interval_m - an interval matrix with upper and lower bounds
% Outputs:
%   val - a boolean value, true if the matrix dimensions are correct and 
%         the interval matrix is stochastic, otherwise

function val = correct_dimensions(interval_m)
    upper_matrix = sup(interval_m);
    lower_matrix = inf(interval_m);

    if size(upper_matrix,1) ~= size(upper_matrix,2)
        dimensions_error = MException("myComponent:inputError","incorrect dimensions of input");
        throw(dimensions_error);
    elseif false == checkMatrices(lower_matrix,upper_matrix)
        stochasticity_error = MException("myComponent:inputError","interval matrix is not stochastic");
        throw(stochasticity_error); 
    else    
        val = true;
    end
 end

% Function: checkMatrices
% Inputs:
%   A - a matrix representing the lower bounds
%   B - a matrix representing the upper bounds
% Outputs:
%   result - a boolean value, true if all conditions are met, false otherwise

function result = checkMatrices(A, B)
    % Check if all elements in matrix A are non-negative
    if any(A(:) > 1.0001)
        disp("1");
        result = false;
        return;
    end
    
    % Sum of columns of the first matrix
    columnSumsA = sum(A);
    
    % Check if each column sum is less than or equal to 1
    if ~all(columnSumsA <= 1)
        result = false;
        return;
    end
    
    % Check if all elements in matrix B are at most 1
    if any(B(:) < 0)
        result = false;
        return;
    end
    
    % Sum of columns of the second matrix
    columnSumsB = sum(B);
    
    % Check if each column sum is greater than or equal to 1
    if ~all(columnSumsB >= 1)
        result = false;
        return;
    end
    
    % If all conditions are met, return true
    result = true;
end
