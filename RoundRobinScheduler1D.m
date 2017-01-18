classdef RoundRobinScheduler1D
    %RoundRobinScheduler1D - 1D implementation of a round robin scheduler
    %   The round robin scheduler schedules the radar to point at the current tracks in turn
    
    properties
        radar_volume;
        current_track;
         random_search_probability;
    end
    
    methods
        function o = RoundRobinScheduler1D(parameters)
            o.radar_volume = parameters.radar_volume;
            o.current_track = -1;
            o.random_search_probability=parameters.random_search_probability;
        end

        function [o,pointing_information] = get_pointing_information(o, all_tracks)
            if ~isempty(all_tracks)
               if rand>(o.random_search_probability/length(all_tracks))
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
               else
                pointing_information.interval_center = o.radar_volume.lower + rand * (o.radar_volume.upper - o.radar_volume.lower);
               end
            else
%                 pointing_information.interval_center = (o.radar_volume.upper + o.radar_volume.lower)/2;
               pointing_information.interval_center = o.radar_volume.lower + rand * (o.radar_volume.upper - o.radar_volume.lower);
            end
        end
    end
end

