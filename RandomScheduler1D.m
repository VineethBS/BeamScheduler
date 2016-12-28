classdef RandomScheduler1D
    %RandomScheduler1D - 1D implementation of a random scheduler
    %   The random scheduler picks a radar center location (since it is 1D the center of the interval) uniformly from
    %   the radar volume
    
    properties
        radar_volume;
    end
    
    methods
        function o = RandomScheduler1D(parameters)
            o.radar_volume = parameters.radar_volume;
        end

        function pointing_information = get_pointing_information(o, all_tracks)
            % pointing_information.interval_center = (o.radar_volume.lower + o.radar_volume.upper)/2;
            pointing_information.interval_center = o.radar_volume.lower + rand * (o.radar_volume.upper - o.radar_volume.lower);
        end
    end
end

