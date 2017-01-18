classdef ScalaMoranScheduler1D
    % Scala Moran Scheduler - implementation of the scheduler in Scala Moran -
    %   The random scheduler picks a radar center location according to the trace of the covariance matrix
    
    properties
        radar_volume;
        random_search_probability;
    end
    
    methods
        function o = ScalaMoranScheduler1D(parameters)
            o.radar_volume = parameters.radar_volume;
            o.random_search_probability=parameters.random_search_probability;
        end
        
        function [o,pointing_information] = get_pointing_information(o, all_tracks)
            all_tracks_covariances=[];
            if ~isempty(all_tracks)
               if length(all_tracks)==2
                   a=2;
               end
               if rand>(o.random_search_probability/length(all_tracks))
                for i=1:size(all_tracks,2)
                    all_tracks_covariances(i)=trace(all_tracks{i}.filter.get_covariance());
                end
                [~ , current_track] = max(all_tracks_covariances);
                pointing_information.interval_center = all_tracks{current_track}.get_observation();
               else
                pointing_information.interval_center = o.radar_volume.lower + rand * (o.radar_volume.upper - o.radar_volume.lower);
               end
            else
                pointing_information.interval_center = o.radar_volume.lower + rand * (o.radar_volume.upper - o.radar_volume.lower);
            end
        end
    end
end

