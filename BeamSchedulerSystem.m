classdef BeamSchedulerSystem
    % Beam Scheduler System - models the complete system for testing of beam scheduler algorithms
    % The beam scheduler system is made up of (i) the environment and object simulator which simulates the environment
    % around the radar, (ii) the radar simulator itself, (iii) the scheduler, and (iv) the MTT system
    properties
        MTT;
        Environment;
        Radar;
        Scheduler;
        simulation_start_time;
        simulation_step_time;
        simulation_end_time;
    end
    
    methods
        function o = BeamSchedulerSystem(configuration_file)
            o.configuration_file = configuration_file;
            
            if exist(o.configuration_file, 'file') == 2
                run(o.configuration_file); % this will populate the local workspace with the configuration variables that we need
            else
                error('%s does not exist!', o.configuration_file);
                return;
            end
            % initialize the Environment with the configuration parameters
            o.Environment = Environment(environment_parameters);
            % initialize the Radar with its configuration_parameters
            o.Radar = Radar(radar_parameters);
            % initialize the Scheduler with its configuration parameters
            o.Scheduler = Scheduler(scheduler_parameters);
            % initialize the Multi Target Tracker object with the configuration parameters
            o.MTT = MultiTargetTracker(filter_type, filter_parameters, gating_method_type, gating_method_parameters, ...
                data_association_type, data_association_parameters, track_maintenance_type, track_maintenance_parameters);
            
            % initialize other variables
            o.simulation_start_time = simulation_start_time;
            o.simulation_step_time = simulation_step_time;
            o.simulation_end_time = simulation_end_time;
        end
        
        % run - simulates the step by step running of the beam scheduler system
        function o = run(o)
            current_time = o.simulation_start_time;
            while current_time <= o.simulation_end_time
                
                % Step 1: simulate the environment and get all observations
                o.Environment = o.Environment.step(current_time);
                all_observations = o.Environment.get_all_observations();
                % Step 2: get the pointing information for the radar from the scheduler
                pointing_information = o.Scheduler.get_pointing_information();
                % Step 3: with the pointing information get the observations from the radar
                observations = o.Radar.get_observations(pointing_information, all_observations);
                % Step 4: run the MTT with one observation
                o.MTT = o.MTT.process_one_observation(current_time, observations);
                
                current_time = current_time + o.simulation_step_time;
            end
            
        end
    end
end 
