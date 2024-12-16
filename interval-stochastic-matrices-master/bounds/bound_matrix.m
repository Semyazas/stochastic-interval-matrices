% This function adjusts the interval matrix to have the largest possible lower bound and
% smallest possible upper bound that contains all stochastic realizations of given interval matrix.
% Inputs:
%   - interval_m: interval matrix of size (n x n)
% Outputs:
%   - updated_m: interval matrix with adjusted bounds
function updated_m = bound_matrix(interval_m)
    correct_dimensions(interval_m);
    upper_matrix = sup(interval_m);
    lower_matrix = inf(interval_m);

    [lower_matrix, upper_matrix] = triv_update_int_matrix(lower_matrix, upper_matrix);

    updated_lower_matrix = bound_lower_matrix(lower_matrix, upper_matrix);
    updated_upper_matrix = bound_upper_matrix(lower_matrix, upper_matrix); 

    updated_m = infsup(updated_lower_matrix, updated_upper_matrix);
end

% Ensure the value is within the stochastic interval bounds [0, 1].
% Inputs:
%   - val: value to be bounded (numeric)
% Outputs:
%   - res: bounded value (numeric)
function res = triv_bound_val(val)
    if val > 1
        res = 1;
    elseif val < 0
        res = 0;
    else 
        res = val;
    end
end

% Update the interval matrix with trivial bounds applied to each element.
% Inputs:
%   - lower_matrix: lower bound matrix (numeric matrix)
%   - upper_matrix: upper bound matrix (numeric matrix)
% Outputs:
%   - updated_lower_m: updated lower bound matrix (numeric matrix)
%   - updated_upper_m: updated upper bound matrix (numeric matrix)
function [updated_lower_m, updated_upper_m] = ...
    triv_update_int_matrix(lower_matrix, upper_matrix)

    updated_lower_m = zeros(size(lower_matrix));
    updated_upper_m = zeros(size(upper_matrix));

    for i = 1:size(lower_matrix, 1)
        for j = 1:size(lower_matrix, 2)
            updated_upper_m(i, j) = triv_bound_val(upper_matrix(i, j));
            updated_lower_m(i, j) = triv_bound_val(lower_matrix(i, j));
        end
    end
end

% Calculate the updated entry for the lower bound of a column.
% Inputs:
%   - this_index: index of the current row (integer)
%   - column_index: index of the current column (integer)
%   - lower_matrix: lower bound matrix (numeric matrix)
%   - upper_matrix: upper bound matrix (numeric matrix)
% Outputs:
%   - updated_entry: updated entry for the lower bound (numeric)
function updated_entry = lower_bound_column(this_index, column_index, ...
                                            lower_matrix, upper_matrix)
    sum_of_column = 0;

    for i = 1:size(lower_matrix, 1)
        if i ~= this_index % we want to update this index, so we dont consider its current value
            sum_of_column = sum_of_column + upper_matrix(i, column_index);
        end
    end
    updated_entry = max(1 - sum_of_column, lower_matrix(this_index, column_index));
end

% Adjust the lower bound matrix by ensuring each column meets stochastic constraints.
% Inputs:
%   - lower_matrix: lower bound matrix (numeric matrix)
%   - upper_matrix: upper bound matrix (numeric matrix)
% Outputs:
%   - updated_matrix: adjusted lower bound matrix (numeric matrix)
function updated_matrix = bound_lower_matrix(lower_matrix, upper_matrix)
    updated_matrix = zeros(size(lower_matrix));
    
    for i = 1:size(lower_matrix, 1)     % for each row index
        for j = 1:size(lower_matrix, 2) % for each column index
            updated_matrix(i, j) = lower_bound_column(i, j, ...
                                                lower_matrix, upper_matrix);
        end
    end
end

% Calculate the updated entry for the upper bound of a column.
% Inputs:
%   - this_index: index of the current row (integer)
%   - column_index: index of the current column (integer)
%   - lower_matrix: lower bound matrix (numeric matrix)
%   - upper_matrix: upper bound matrix (numeric matrix)
% Outputs:
%   - updated_entry: updated entry for the upper bound (numeric)
function updated_entry = upper_bound_update(this_index, column_index, ...
                                            lower_matrix, upper_matrix)
    sum_of_lower_column = 0;

    for i = 1:size(upper_matrix, 1)
        if i ~= this_index % we want to update this index, so we dont consider its current value
            sum_of_lower_column = sum_of_lower_column + lower_matrix(i, column_index);
        end
    end
    updated_entry = min(1 - sum_of_lower_column, upper_matrix(this_index, column_index)); 
end

% Adjust the upper bound matrix by ensuring each column meets stochastic constraints.
% Inputs:
%   - lower_matrix: lower bound matrix (numeric matrix)
%   - upper_matrix: upper bound matrix (numeric matrix)
% Outputs:
%   - updated_matrix: adjusted upper bound matrix (numeric matrix)
function updated_matrix = bound_upper_matrix(lower_matrix, upper_matrix)

    updated_matrix = zeros(size(lower_matrix));
    
    for i = 1:size(lower_matrix, 1)     % for each row index
        for j = 1:size(lower_matrix, 2) % for each column index
            updated_matrix(i, j) = upper_bound_update(i, j, ...
                                                lower_matrix, upper_matrix);
        end
    end
end
