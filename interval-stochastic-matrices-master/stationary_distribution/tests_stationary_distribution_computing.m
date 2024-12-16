%  In this file we test only generating correct systems, that go after that
%  into linear program. This is OK since we know that linprog is correct.


lower1 = [1/2 1/2; 
          1/4 1/4];
upper1 = ones(2);

lower2 = [1/3 1/3 1/3;
          1/3 1/3 1/3;
          1/4 1/4 1/4];
upper2 = ones(3);


parametric_system_inf  = ...
[      
        [ 0         0         0         0         0         0    1.0000         0    1.0000         0 ];
        [ 0         0         0         0         0         0   -1.0000    1.0000   -1.0000    1.0000 ];
        [ 0         0   -0.5000         0         0         0   -1.0000         0         0         0 ];
        [ 0         0         0         0         0         0         0   -1.0000         0         0 ];
        [ 0         0         0         0    0.5000         0         0         0   -1.0000         0 ];
        [ 0         0         0         0         0         0         0         0         0   -1.0000 ];
        [ 1.0000    0   -1.0000         0         0         0         0         0         0         0 ];
        [ 1.0000    0         0   -1.0000         0         0         0         0         0         0 ];
        [ 0    1.0000         0         0   -1.0000         0         0         0         0         0 ];
        [ 0    1.0000         0         0         0   -1.0000         0         0         0         0 ];
        [1.0000    1.0000     0         0         0         0         0         0         0         0 ]
 ];

parametric_system_sup = ...
[         0     0     0     0     0     0     1     0     1     0;
          0     0     0     0     0     0    -1     1    -1     1;
          0     0     0     0     0     0    -1     0     0     0;
          0     0     0     0     0     0     0    -1     0     0;
          0     0     0     0     1     0     0     0    -1     0;
          0     0     0     0     0     0     0     0     0    -1;
          1     0    -1     0     0     0     0     0     0     0;
          1     0     0    -1     0     0     0     0     0     0;
          0     1     0     0    -1     0     0     0     0     0;
          0     1     0     0     0    -1     0     0     0     0;
          1     1     0     0     0     0     0     0     0     0
];

%disp("aaaa:");
%disp(size(parametric_system_inf2));
%disp(parametric_system_inf2);

parametric_system_sup2 = ...
[   
             0     0     0     0     0     0     0     0     0     0     0     0     1     0     0     1     0     0     1     0     0;
             0     0     0     0     0     0     0     0     0     0     0     0     0     1     0     0     1     0     0     1     0;
             0     0     0     0     0     0     0     0     0     0     0     0    -1    -1     1    -1    -1     1    -1    -1     1;
             0     0     0     0     0     0     0     0     0     0     0     0    -1     0     0     0     0     0     0     0     0;
             0     0     0     0     1     0     0     0     0     0     0     0     0    -1     0     0     0     0     0     0     0;
             0     0     0     0     0     0     0     0     0     0     0     0     0     0    -1     0     0     0     0     0     0;
             0     0     0     0     0     0     1     0     0     0     0     0     0     0     0    -1     0     0     0     0     0;
             0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0    -1     0     0     0     0;
             0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0    -1     0     0     0;
             0     0     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0     0    -1     0     0;
             0     0     0     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0     0    -1     0;
             0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0    -1;
             1     0     0    -1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0;
             1     0     0     0    -1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0;
             1     0     0     0     0    -1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0;
             0     1     0     0     0     0    -1     0     0     0     0     0     0     0     0     0     0     0     0     0     0;
             0     1     0     0     0     0     0    -1     0     0     0     0     0     0     0     0     0     0     0     0     0;
             0     1     0     0     0     0     0     0    -1     0     0     0     0     0     0     0     0     0     0     0     0;
             0     0     1     0     0     0     0     0     0    -1     0     0     0     0     0     0     0     0     0     0     0;
             0     0     1     0     0     0     0     0     0     0    -1     0     0     0     0     0     0     0     0     0     0;
             0     0     1     0     0     0     0     0     0     0     0    -1     0     0     0     0     0     0     0     0     0;
             1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0;
 ];



exact_inters = [         0   -1.0000    1.0000         0;
                         0    1.0000   -1.0000         0;];
%disp(size(parametric_system_sup2));

%disp(inf(stationary_distribution.generate_parametric_system(lower2,upper2)));


assert(are_equal(parametric_system_inf, inf(generate_parametric_system(infsup(lower1,upper1))),0.0001));

assert(are_equal(parametric_system_sup, sup(generate_parametric_system(infsup(lower1,upper1))),0.0001));

assert(are_equal(parametric_system_sup2,sup(generate_parametric_system(infsup(lower2,upper2))),0.0001));


[a,b] = get_intersection3(infsup(zeros(2),ones(2)));

%disp(a);

assert(are_equal(exact_inters,a,0.0001));

[center,rad] = generate_system_matrix_non_parametric(infsup(lower2,upper2));

assert(are_equal(center,   [-0.3333    0.6667    0.6667;
    0.6667   -0.3333    0.6667;
    0.6250    0.6250   -0.3750;
    1.0000    1.0000    1.0000],0.001));

assert(are_equal(rad,   [    0.3333    0.3333    0.3333;
    0.3333    0.3333    0.3333;
    0.3750    0.3750    0.3750;
         0         0         0],0.001));

%disp("njkafjkanfkjnakjfnjaknf");
%disp("njkafjkanfkjnakjfnjaknf");
%disp(sup(stationary_distribution.generate_parametric_system(lower2,upper2)));





