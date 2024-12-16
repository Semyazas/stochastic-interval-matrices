% Function ratio(a, b) calculates the average ratio of rad(a(i)) / rad(b(i)) 
% for all corresponding elements in vectors a and b.
% Input: a - vector
%        b - vector of the same length as a
% Output: r - average ratio of rad(a(i)) / rad(b(i))

function r = ratio(a, b)
    % Initialize the result to 0
    r = 0;
    
    % For each element in vector a (assuming a and b have the same size)
    for i = 1:size(a,2)
        % Add the ratio rad(a(i)) / rad(b(i)) to the total sum
        r = r + rad(a(i)) / rad(b(i));
    end
    
    % Calculate the average ratio by dividing the sum by the number of elements
    r = r / size(a,2);
end
