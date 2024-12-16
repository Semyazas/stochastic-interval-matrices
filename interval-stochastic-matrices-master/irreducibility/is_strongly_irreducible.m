% input - interval_matrix - interval matrix
%
% output - true if all stochastic realizations of interval_matrix are
%           irreducible, otherwise false
%
% for implementation details look into file irreducibility
function tf = is_strongly_irreducible(interval_matrix)
    tf = irreducibility.is_strongly_irreducible(inf(interval_matrix),sup(interval_matrix));
end

