This library is for working with stochastic interval matrices. 
An interval stochastic matrix is an interval matrix that contains some stochastic matrices and 
has its entries in [0,1]. They are represented as intval matrices.

Dependencies:
    - Intlab(https://www.tuhh.de/ti3/rump/intlab/): This library is used for representing our 
      stochastic interval matrices as interval matrices. 
    - Optimization Toolbox(https://www.mathworks.com/products/optimization.html): We use the method linprog.
    - Analyze N-dimensional Convex Polyhedra [Matlab 2023](https://www.mathworks.com/matlabcentral/fileexchange/30892-analyze-n-dimensional-convex-polyhedra): 
      This is  used in the method for computing tight enclosures of 
      stationary distributions of all realizations in a given stochastic matrix.

Structure:
    The source code is structured in directories according to their functionality.
    Every directory contains tests for the main functions of the given directory. 
    Every function is documented in its source file. For each directory, I will provide an overview of its main functions,
    but each usually contains more functions.

    Directories:
        - bounds
            - The main method of this directory is "bound_matrix(A)." It bounds a given interval stochastic matrix A such that 
              it returns the upper and lower bounds of the stochastic interval matrix. 
              This ensures it contains the same stochastic realizations as A, 
              whilst having the lower bound with the maximal possible values and 
              the upper bound with the minimal possible values.

        - irreducibility
            - Functions in this directory share a lot of functionality (and a lot of helper functions), 
              so they are implemented in class "irreducibility". 
              For purposes of user friendliness these functions are also declared in their own file.

            - This directory contains functions that determine strong irreducibility and 
              weak irreducibility of a given interval stochastic matrix. A stochastic interval matrix
              is strongly irreducible if all its stochastic realizations are irreducible. A stochastic
              matrix is weakly irreducible if there exists some irreducible stochastic realization.
            
            - The main methods are "is_weakly_irreducible(A)" and "is_strongly_irreducible(A)," 
              which check the strong/weak irreducibility of a given stochastic interval matrix.

        - recurrence_transience
            - This directory contains functions that determine strong recurrence/transience and
              weak recurrence/transience of a given interval stochastic matrix. 
              A state in a stochastic interval matrix is strongly recurrent/transient if 
              it is recurrent/transient in all of its stochastic realizations. 
              We define weak recurrence/transience analogously.

            - The main methods are "is_state_weakly_transient(A)" and "is_state_weakly_recurrent(A)," 
              which check for weak transience/recurrence of a given state, and "is_state_strongly_transient(A)" 
              and "is_state_strongly_recurrent(A)," which check for strong transience/recurrence of a given state.

        - stationary_distribution
            - This directory contains functions that compute enclosures of all stationary distributions in given stochastic interval matrices.
        
        - experiment
            - This directory is mainly for conducting experiments in which 
              we compare enclosures produced by methods from the stationary_distribution directory. 
              It contains methods used for these experiments.
              
Usage:
    To be able to use functions from this library, you must first run the script 'start_stochm'. 
    This adds the necessary paths. After that, you will be able to use functions from this library.
