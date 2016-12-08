% A sample configuration file

%% Parameters for the Beam Scheduler System
simulation_start_time = 0;
simulation_step_time = 1;
simulation_end_time = 100;


%% Parameters for the Multitarget tracker
dt = 0.05;

dimension_observations = 1;
field_separator = ',';

filter_type = 'Kalman';

filter_parameters.A = [1 dt dt^2
                       0 1 dt
                       0 0 1];
                   
filter_parameters.C = [1 0 0];

filter_parameters.Q = [1 0 0;
                       0 1 0;
                       0 0 1];
                   
filter_parameters.R = 1;

filter_parameters.rest_of_initial_state = [0
                                           0];

gating_method_type = 'Rectangular';
gating_method_parameters.gate_width = 1;

% parameters for GNN
data_association_type = 'GNN';
data_association_parameters = 0;

track_maintenance_type = 'NOutOfM';
track_maintenance_parameters.N = 2;
track_maintenance_parameters.M = 5;
track_maintenance_parameters.confirm_threshold = 3;
track_maintenance_parameters.confirm_M = 3;
track_maintenance_parameters.confirm_N = 1;

%% parameters for the Radar
radar_parameters.radar_type = '1D';
radar_parameters.scheduler_type = 'random1D';
radar_parameters.radar_parameters.detection_probability = 0.9;
radar_parameters.radar_parameters.false_alarm_rate = 0.01;
radar_parameters.radar_parameters.interval_width = 1;
radar_parameters.radar_parameters.interval_center = 1;
radar_parameters.scheduler_parameters.radar_volume.lower = 0;
radar_parameters.scheduler_parameters.radar_volume.upper = 10;

%% parameters for the Environment
environment_parameters.simulator_type = 'dynamicmodelenv';
environment_parameters.simulator_parameters.initial_number_of_objects = 10;
environment_parameters.simulator_parameters.death_probability = 0;
environment_parameters.simulator_parameters.splitting_probability = 0;
environment_parameters.simulator_parameters.birth_rate = 0;
environment_parameters.simulator_parameters.dynamic_model_object_parameters.A = [1 0;0 1];
environment_parameters.simulator_parameters.dynamic_model_object_parameters.C = [1 0];
environment_parameters.simulator_parameters.dynamic_model_object_parameters.R = 1;
environment_parameters.simulator_parameters.dynamic_model_object_parameters.initial_state = [0;1];

%% parameters for the Visualizer
visualization1D_parameters.plot_input = 1;
visualization1D_parameters.plot_tracks = 1;
visualization1D_parameters.plot_radar = 1;
visualization1D_parameters.plottype_input = 'ro';
visualization1D_parameters.plottype_track = 'k';
visualization1D_parameters.plottype_radar = 'c';

post_MTT_run_sequence = {'plot1D'};
post_MTT_run_parameters{1} = visualization1D_parameters;