% A sample configuration file

dt = 0.05;

dimension_observations = 1;
num_of_observations = 100;

filter_type = 'Kalman';

filter_parameters.A = [1 dt dt^2
                       0 1 dt
                       0 0 1];
                   
filter_parameters.C = [1 0 0];
filter_parameters.Q = [1 0 0;
                       0 1 0;
                       0 0 1];
                   
filter_parameters.R = 1;

gating_method_type = 'Rectangular';
gating_method_parameters.gate_width = 1;

data_association_type = 'Heuristic';
data_association_parameters.epsilon = 0.1;