%Function for generating left side of parametric system used in
%solve_non_parametric
%
%Input: 
%       - interval stochastic matrix
%Outpus:
%       - numeric matrices center and radius which are used in
%         solve_non_parametric

function [center,radius] = generate_system_matrix_non_parametric(interval_m)
   
    system_temp = interval_m - eye(size(inf(interval_m),1));

    system = [ system_temp ; 
               ones(1,size(inf(interval_m),1))
             ];
    center = mid(system);
    radius = rad(system);
end
