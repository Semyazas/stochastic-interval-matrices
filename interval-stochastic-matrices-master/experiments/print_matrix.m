% This function takes a matrix and an index as inputs and prints the matrix in a
% specified format. The matrix is printed with each row on a new line, separated
% by a semicolon, and enclosed within square brackets. The index is not used in
% this function but is included as an input parameter.
%
% Inputs:
%   matrix - A 2D array of numerical values to be printed
%
% Outputs:
%   This function does not return any outputs but prints the formatted matrix to the console.

% Iterate through each row of the matrix

function print_matrix(matrix)
    for i=1:size(matrix,1)
        if i == 1   
            fprintf("[");
        end
        fprintf('%d ', matrix(i, :));
        if i ~= size(matrix,1)
            fprintf(';\n');
        end
    end
    fprintf("], ...\n");
end
