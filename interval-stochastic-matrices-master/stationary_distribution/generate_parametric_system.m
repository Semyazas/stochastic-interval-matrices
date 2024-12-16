% Generates the parametric system matrix for the given interval matrix.
% This system will be used in computation of stationary distribution.
% Inputs:
%   - interval_m: interval matrix of size (n x n)
% Outputs:
%   - A: parametric system matrix (numeric matrix)
%   - A is made from matrices B,D,N where B,D,N are matrices, such that
%     interval_m = B*D*N
%           - D = [[(interval_m)_{1,1} 0 ...                    0           ]
%                  [0                  (interval_m)_{2,1} 0 ... 0           ]
%                   .                                           .
%                   .                                           .
%                   .                                           .
%                  [                                      (interval_m)_{n,m}]]
%           - B is matrix [B_1,B_2 ... ,B_n]
%               - B_i = [[1 0 ... 0]
%                         . .     .
%                         .   0   . ---- ith row
%                        [1   1   1]]
%
%           - N = [[1 0.. 0]
%                  [1 0.. 0]
%                   . .   . 
%                   . .   . 
%                  [1 0   0]
%                  [0 1   0]
%                   . .   . 
%                   . .   . 
%%                 [0 0   1]]

function [A] = generate_parametric_system(interval_m)
    lower_m = inf(interval_m);
    upper_m = sup(interval_m);

    N = generate_matrix_N(lower_m);
    D = generate_matrix_D(lower_m, upper_m);
    B = generate_matrix_B(lower_m);
    x_count = size(lower_m, 1);
    variable_count = size(D, 2);
    A = [B; D; N; infsup([ones(1, x_count), zeros(1, variable_count - x_count)], ...
                         [ones(1, x_count), zeros(1, variable_count - x_count)])];
end

% Generates the matrix N used in the parametric system.
% Inputs:
%   - lower_m: lower bound of the interval matrix (numeric matrix)
% Outputs:
%   - N: matrix N for the parametric system (numeric matrix)
function N = generate_matrix_N(lower_m)
    N = zeros(size(lower_m, 1) * size(lower_m, 1), size(lower_m, 1));
    for sector = 1:size(lower_m, 1)
        for j = 1:size(lower_m, 1)
            row = (sector - 1) * size(lower_m, 1) + j;
            N(row, sector) = 1;
        end
    end
    N = transpose(N);
    N = [N; -1 * eye((size(lower_m, 1)) * (size(lower_m, 1)));
         zeros((size(lower_m, 1)) * (size(lower_m, 1)))];
    N = transpose(N);
end

% Appends correct columns for matrix D.
% Inputs:
%   - matrix: matrix to append columns to (numeric matrix)
%   - row_count: number of rows in the resulting matrix (integer)
%   - cols_count: number of columns in the resulting matrix (integer)
%   - to_subtract: boolean flag indicating whether to subtract identity matrix
% Outputs:
%   - res: resulting matrix after appending columns (numeric matrix)
function res = append_correct_columns_for_D(matrix, row_count, cols_count, to_subtract)
    if to_subtract
        A = zeros(cols_count);
    else
        A = -eye(cols_count);
    end
    res = [zeros(row_count, cols_count); matrix; A];
    res = transpose(res);
end

% Generates the matrix D used in the parametric system. This matrix is 
% Inputs:
%   - lower_m: lower bound of the interval matrix (numeric matrix)
%   - upper_m: upper bound of the interval matrix (numeric matrix)
% Outputs:
%   - D_param: matrix D for the parametric system (interval matrix)
function D_param = generate_matrix_D(lower_m, upper_m)
    lower_size = size(lower_m, 1);
    D_size = size(lower_m, 1) * size(lower_m, 1);
    D_param_inf = zeros(D_size);
    D_param_sup = zeros(D_size);
    to_subtract = zeros(D_size);
    int_stoch = infsup(lower_m, upper_m);
    for sector = 0:(size(lower_m, 1)) - 1
        for i = 1:size(lower_m, 1)
            row_col = sector * size(lower_m, 1) + i;
            if i <= size(lower_m, 1) - 1
                D_param_inf(row_col, row_col) = inf(int_stoch(i, sector + 1));
                D_param_sup(row_col, row_col) = sup(int_stoch(i, sector + 1));
            else
                D_param_inf(row_col, row_col) = 0;
                D_param_sup(row_col, row_col) = 0;
            end
            if i == sector + 1 && sector ~= size(lower_m, 1) - 1
                to_subtract(row_col, row_col) = 1;
            end
        end
    end
    D_param_sup = append_correct_columns_for_D(D_param_sup, lower_size, D_size, false);
    D_param_inf = append_correct_columns_for_D(D_param_inf, lower_size, D_size, false);
    to_subtract = append_correct_columns_for_D(to_subtract, lower_size, D_size, true);
    D_param = infsup(D_param_inf, D_param_sup) - to_subtract;
end

% Generates the section B of the matrix used in the parametric system.
% Inputs:
%   - lower_m: lower bound of the interval matrix (numeric matrix)
% Outputs:
%   - B: section B of the matrix (numeric matrix)
function B = generate_section_B(lower_m)
    B = eye(size(lower_m, 1));
    for i = 1:((size(lower_m, 1)) - 1)
        B(i, size(lower_m, 1)) = -1;
    end
end

% Generates the matrix B used in the parametric system.
% Inputs:
%   - lower_m: lower bound of the interval matrix (numeric matrix)
% Outputs:
%   - B: matrix B for the parametric system (interval matrix)
function B = generate_matrix_B(lower_m)
    B = [];
    for i = 1:(size(lower_m, 1))
        B = [B; generate_section_B(lower_m)];
    end
    B = [transpose( ...
                    zeros( ...
                          size(lower_m, 1), ...
                          size(lower_m, 1) * size(lower_m, 1) + ... % this one is for y
                          size(lower_m, 1) ...                   % ---||---    for x
                          ) ...
                   );                    
         B];
    B = transpose(B);
    B = infsup(B, B);
end
