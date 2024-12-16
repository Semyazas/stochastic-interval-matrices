% Function for finding reducible partition (U,V), such that given vertex is
% in V.
%
% inputs: 
%         interval_matrix:  interval matrix of size (n x n)
%
%         start_vertex: vertex which is included in subset of V
%         such that (V,[n] \ V) there exists stochastic realization of 
%         interval_matrix such that (that is if such V exists)
%
% output: Function returns partition of states such that there exists stochastic realization
%         of interval_matrix is no path from states of V to states of U
%         and start_vertex is contained in V if it exists, else function
%         returns [[],[]].
%
% for implementation details look into file irreducibility

function [U,V] = partition_from_vertex(interval_matrix, start_vertex)
    [U,V] = irreducibility.partition_from_vertex(inf(interval_matrix),sup(interval_matrix),start_vertex);
end
