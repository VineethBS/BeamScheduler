classdef Radar
    %Radar - models the radar with inbuilt beam scheduling. Allows for different kinds of radars and schedulers

    properties
        radar_type;
        radar;
        radar_parameters;
        
        scheduler_type;
        scheduler;
        
        sequence_times;
        sequence_pointing_information;
    end
    
    methods
        function o = Radar(parameters)
            o.radar_type = parameters.radar_type;
            o.radar_parameters = parameters.radar_parameters;
            if strcmp(o.radar_type, '1D')
                o.radar = Radar1D(parameters.radar_parameters);
            elseif strcmp(o.radar_type, '3DCartesian')
                o.radar = Radar3DCartesian(parameters.radar_parameters);
            elseif strcmp(o.radar_type, '3DSpherical')
                o.radar = Radar3DSpherical(parameters.radar_parameters);
            end

            o.scheduler_type = parameters.scheduler_type;
            if strcmp(o.scheduler_type, 'random1D')
                o.scheduler = RandomScheduler1D(parameters.scheduler_parameters);
            elseif strcmp(o.scheduler_type, 'roundrobin1D')
                o.scheduler = RoundRobinScheduler1D(parameters.scheduler_parameters);
            elseif strcmp(o.scheduler_type, 'scalamoran1D')
                o.scheduler = ScalaMoranScheduler1D(parameters.scheduler_parameters);
            end
        end

        function [o, observations] = get_observations(o, time, all_observations, all_tracks)
            pointing_information = o.scheduler.get_pointing_information(all_tracks);
            o = o.record_pointing_information(time, pointing_information);
            observations = o.radar.get_observations(pointing_information, all_observations);
        end
        
        function o = record_pointing_information(o, time, pointing_information)
            o.sequence_times(end + 1) = time;
            o.sequence_pointing_information{end + 1} = pointing_information;
        end
        
        function [sequence_times, sequence_pointing_information] = get_sequence_pointing_information(o)
            sequence_times = o.sequence_times;
            sequence_pointing_information = o.sequence_pointing_information;
        end
        
        function radar_parameters = get_radar_parameters(o)
            radar_parameters = o.radar_parameters;
        end
    end
end