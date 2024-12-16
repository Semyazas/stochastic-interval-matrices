% At first we test some matrices of small dimension.

lower_3x3_1 = [0 1/4 0; 
               1/4 0 0;
               0   0 0];

upper_3x3_1 = [0 1 1;
                 1 0 0;
                 1 0 1];


lower_3x3_2 = [0     0   0; 
               1/4   0   0;
               1/4  1/4  0];

upper_3x3_2 =   [1 1 0;
                 1 1 0;
                 1 1 1];

lower_3x3_3 = [0 1 1; 
               1 0 0;
               0   0 0];

upper_3x3_3 = [0 1 1;
                 1 0 0;
                 1 0 1];

lower_3x3_4 = [0 1/4 1/4; 
               1/4 0 0;
               0   0 0];

upper_3x3_4 = [0 1 1;
                 1 0 0;
                 1 0 1];

%plot(digraph(transpose(lower_3x3_3)));  

inp_test1 = infsup(lower_3x3_1, ...
                                                      upper_3x3_1);
inp_test2 = infsup(lower_3x3_2, ...
                                                      upper_3x3_2);
inp_test3 = infsup(lower_3x3_3, ...
                                                      upper_3x3_3);


%=========================weak recurrence============================

assert(true == is_state_weakly_recurrent(inp_test1,1));

assert(true == is_state_weakly_recurrent(inp_test2,3));

assert(false == is_state_weakly_recurrent(inp_test3,3));


%=========================weak transience============================

assert(false == is_state_weakly_transient(inp_test2,3));

assert(true == is_state_weakly_transient(inp_test2,2));

assert(true == is_state_weakly_transient(inp_test3,3))

assert(false == is_state_weakly_transient(inp_test3,2))

% Number of nodes in each cycle
n1 = 5; % Number of nodes in the first cycle
n2 = 6; % Number of nodes in the second cycle

% Adjacency matrix for the first cycle
A1 = diag(ones(1,n1-1),1);
A1(n1,1) = 1; % Closing the cycle

% Adjacency matrix for the second cycle
A2 = diag(ones(1,n2-1),1);
A2(n2,1) = 1; % Closing the cycle

% Combine the two adjacency matrices into a block diagonal matrix
A = blkdiag(A1, A2);

% Create the graph
%G = digraph(A);


% We test cycle
assert(false== is_state_weakly_transient(infsup(transpose(1/50*A),transpose(A)),1));


for i = 2:10

    % Initialize an n-by-n matrix of zeros
    adjMatrix = zeros(i);

    % Set the edges 1->2, 2->3, ..., n-1->n
    for j = 1:i-1
        adjMatrix(j, j+1) = 1;
    end
    
    % Set the edge n->n
    adjMatrix(i, i) = 1;

    
    assert(false== is_state_weakly_transient(infsup(transpose(adjMatrix*1/(i+i)),transpose(adjMatrix)),i));

    assert(true == is_state_weakly_transient(infsup(transpose(adjMatrix*1/(i+i)),transpose(adjMatrix)),i-1));

    assert(true == is_state_weakly_recurrent(infsup(transpose(adjMatrix*1/(i+i)),transpose(adjMatrix)),i));

    assert(false == is_state_weakly_recurrent(infsup(transpose(adjMatrix*1/(i+i)),transpose(adjMatrix)),1));

    %Cliques are always reccurent.
    assert(false == is_state_weakly_transient(infsup(ones(i)*1/(i+i),ones(i)),1));
   
    assert(true == is_state_weakly_recurrent(infsup(ones(i)*1/(i+i),ones(i)),1));
    
    %Loops are always reccurent.
    assert(false == is_state_weakly_transient(infsup(eye(i),eye(i)),1));

    assert(true == is_state_weakly_recurrent(infsup(eye(i),eye(i)),1));
end



