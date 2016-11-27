classdef RoundRobinScheduler1D
    %RoundRobinScheduler1D - 1D implementation of a round robin scheduler
    %   The round robin scheduler schedules the radar to point at the current tracks in turn
    
    properties
        radar_volume;
        current_track;
    end
    
    methods
        function o = RandomScheduler1D(parameters)
            o.radar_volume = parameters.radar_volume;
            o.current_track = -1;
        end

        function pointing_information = get_pointing_information(o, all_tracks)
            if ~isempty(all_tracks)
                if o.current_track == -1
                    o.current_track = 1;
                end
                if o.current_track <= length(all_tracks)
                    pointing_information.interval_center = all_tracks{o.current_track}.get_observation();
                else
                    o.current_track=1;
                    pointing_information.interval_center = all_tracks{o.current_track}.get_observation();
                end
                o.current_track=o.current_track+1;
            end
        end
    end
end

