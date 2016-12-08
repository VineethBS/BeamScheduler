classdef BeamSchedulerSystem
    % Beam Scheduler System - models the complete system for testing of beam scheduler algorithms
    % The beam scheduler system is made up of (i) the environment and object simulator which simulates the environment
    % around the radar, (ii) the radar simulator itself, (iii) the scheduler, and (iv) the MTT system.
    % The scheduler is considered to be part of the radar simulator.s
    properties
        MTT;
        Environment;
        Radar;

        simulation_start_time;
        simulation_step_time;
        simulation_end_time;
        
        configuration_file;
        
        post_run_sequence;
        post_run_parameters;
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
            % initialize the Multi Target Tracker object with the configuration parameters
            o.MTT = MultiTargetTracker(filter_type, filter_parameters, gating_method_type, gating_method_parameters, ...
                data_association_type, data_association_parameters, track_maintenance_type, track_maintenance_parameters);
            % initialize the Radar with its configuration_parameters
            o.Radar = Radar(radar_parameters);

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
                all_observations = o.Environment.get_all_observations();
                o.Environment = o.Environment.step(current_time);
                
                % Step 2: get the actual observations from the radar
                [active_tracks, ~] = o.MTT.get_all_tracks(); % for illustration - only active tracks
                all_tracks = active_tracks;
                observations = o.Radar.get_observations(all_observations, all_tracks);
                
                % Step 3: run the MTT with one set of observations
                o.MTT = o.MTT.process_one_observation(current_time, observations);
                
                current_time = current_time + o.simulation_step_time;
            end
            
        end
        
        function o = post_run(o)
            tracks = [o.MTT.list_of_tracks, o.MTT.list_of_inactive_tracks];
            for i = 1:length(o.post_MTT_run_sequence)
                instruction = o.post_MTT_run_sequence{i};
                if strcmp(instruction, 'atleastN')
                    temp = PostProcessing(o.post_MTT_run_parameters{i});
                    tracks = temp.find_tracks_atleast_N_detections(tracks); % tracks change here
                elseif strcmp(instruction, 'velocitythreshold')
                    temp = PostProcessing(o.post_MTT_run_parameters{i});
                    tracks = temp.find_tracks_velocity_threshold(tracks); % tracks change here
                elseif strcmp(instruction, 'plot1D')
                    temp = Visualization(o.post_MTT_run_parameters{i});
                    temp.plot_1D(tracks);
                elseif strcmp(instruction, 'plot3D')
                    temp = Visualization(o.post_MTT_run_parameters{i});
                    temp.plot_3D(tracks);
                elseif strcmp(instruction, 'savetracks')
                    temp = Reporting(o.post_MTT_run_parameters{i});
                    temp.save_tracks(tracks);
                end
            end
        end

    end
end 
