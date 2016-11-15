classdef Radar
    %Radar - models the radar. Is a wrapper class for different kinds of radars

    properties
        radar_type;
        radar;
        
        scheduler_type;
        scheduler;
    end
    
    methods
        function o = Radar(parameters)
            o.radar_type = parameters.radar_type;
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
            end
        end

        function observations = get_observations(o, all_observations, all_tracks)
            pointing_information = o.scheduler.get_pointing_information(all_tracks);
            observations = o.radar.get_observations(o, pointing_information, all_observations);
        end
    end
end

