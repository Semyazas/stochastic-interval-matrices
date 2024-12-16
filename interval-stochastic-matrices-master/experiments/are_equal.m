%Function compares floats(and matrices) and returns true if they are equal
%(within some error)
% Input:
%       - A,B - matrices to compare
%       - sensitity - error7
% Output:
%       - true if A,B are equal (within error)

function tf = are_equal(A,B,sensitivity)
    tmp = (A == B | abs((A-B)./B) < sensitivity);
    tf = all(tmp(:));

end