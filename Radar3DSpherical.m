classdef Radar3DSpherical
    %Radar3DSpherical - models a radar in 3D which takes observations in 3D spherical co-ordinates
    %and returns observations which are within the observation cone.
    
    properties
        detection_probability;
        false_alarm_rate; % is normalized to per unit volume/unit interval
        interval_center;
        interval_range;
        interval_azimuth;
        interval_elevation;
    end
    
    methods
        function o = Radar3DSpherical(parameters)
            o.detection_probability = parameters.detection_probability;
            o.false_alarm_rate = parameters.false_alarm_rate;
            o.interval_center = parameters.interval_center;
            o.interval_range = parameters.interval_range;
            o.interval_azimuth = parameters.interval_azimuth;
            o.interval_elevation = parameters.interval_elevation;
        end

        function observations = get_observations(o, pointing_information, all_observations)
            observations = [];
            o.interval_center = pointing_information.interval_center;
            % Step 1: if an observation is within the interval and if it is detected then add to the observations
            for i = 1:length(all_observations)
                observation = all_observations{i};
                if (observation(1) >= (o.interval_center(1) - o.interval_range/2)) && (observation(1) <= (o.interval_center(1) + o.interval_range/2))
                    if (observation(2) >= (o.interval_center(2) - o.interval_azimuth/2)) && (observation(2) <= (o.interval_center(2) + o.interval_azimuth/2))
                        if (observation(3) >= (o.interval_center(3) - o.interval_elevation/2)) && (observation(3) <= (o.interval_center(3) + o.interval_elevation/2))
                            if rand <= o.detection_probability
                                observations{end + 1} = all_observations{i};
                            end
                        end
                    end
                end
            end
            % Step 2: generate false alarms or false detections
            num_false_alarms = poissrnd(o.false_alarm_rate * (o.interval_length+o.interval_breadth+o.interval_height)/3);
            for i = 1:num_false_alarms
                observation(1)=(o.interval_center - o.interval_range/2) + rand * o.interval_range;
                observation(2)=(o.interval_center - o.interval_azimuth/2) + rand * o.interval_azimuth;
                observation(3)=(o.interval_center - o.interval_elevation/2) + rand * o.interval_elevation;
                observations{end + 1} = observation;
            end
        end
    end
end