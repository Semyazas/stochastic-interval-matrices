
% This function generates a random n-by-n stochastic matrix suitable for tests.
% A stochastic matrix is a square matrix used to describe the transitions of a
% Markov chain, where each column sums to 1.
%
% Inputs:
%   n - An integer representing the size of the matrix (number of rows and columns)
%
% Outputs:
%   stochasticMatrix - An n-by-n stochastic matrix where each row sums to 1

function stochasticMatrix = rand_stoch_matrix(n)
    % Initialize an n-by-n matrix of random values
    randomMatrix = rand(n);
    
    % Randomly set some entries to zero to ensure reducibility
    for i = 1:n
        zeroProbCols = randperm(n, randi([1, n-1])); % Choose random columns to be zero
        randomMatrix(i, zeroProbCols) = 0;
    end
    
    % Normalize each row to make the rows sum to 1, avoiding division by zero
    rowSums = sum(randomMatrix, 2);
    rowSums(rowSums == 0) = 1; % To handle rows that are completely zero
    
    % Normalize to make it stochastic
    stochasticMatrix = randomMatrix ./ rowSums;
    stochasticMatrix = transpose(stochasticMatrix); % Transpose the matrix
end