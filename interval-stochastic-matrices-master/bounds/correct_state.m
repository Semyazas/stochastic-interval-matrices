% This function checks if the given state is valid for a matrix A.
% If the state is invalid (either greater than the number of rows in A or less than or equal to 0),
% the function throws an exception.
%
% Inputs:
%   A - A matrix for which the state needs to be checked.
%   state - An integer representing the state (index) to be checked.
%
% The function does not return any output but throws an exception if the state is invalid.


function correct_state(A,state)
    if (state > size(A,1) || state <= 0 )
        state_error = MException("myComponent:inputError","given state doesnt exist," + ...
                                 "states are indices of columns");
        throw(state_error);
    end
end