classdef Radar3DCartesian
    %Radar3D - models a radar in 3D; i.e., observations are in 3D and are assumed to be obtained in
    % cartesian co-ordinates. The radar returns observations which are within a cuboid.
    
    properties
        detection_probability;
        false_alarm_rate; % is normalized to per unit volume/unit interval
        interval_center;
        interval_x;
        interval_y;
        interval_z;
    end
    
    methods
        function o = Radar1D(parameters)
            o.detection_probability = parameters.detection_probability;
            o.false_alarm_rate = parameters.false_alarm_rate;
            o.interval_center = parameters.interval_center;
            o.interval_x = parameters.interval_x;
            o.interval_y = parameters.interval_y;
            o.interval_z = parameters.interval_z;
        end
        
        function observations = get_observations(o, pointing_information, all_observations)
            observations = [];
            o.interval_center = pointing_information.interval_center;
            % Step 1: if an observation is within the interval and if it is detected then add to the observations
            for i = 1:length(all_observations)
                observation = all_observations{i};
                if (observation(1) >= (o.interval_center(1) - o.interval_x/2)) && (observation(1) <= (o.interval_center(1) + o.interval_x/2))
                    if (observation(2) >= (o.interval_center(2) - o.interval_y/2)) && (observation(2) <= (o.interval_center(2) + o.interval_y/2))
                        if (observation(3) >= (o.interval_center(3) - o.interval_z/2)) && (observation(3) <= (o.interval_center(3) + o.interval_z/2))
                            if rand <= o.detection_probability
                                observations{end + 1} = all_observations{i};
                            end
                        end
                    end
                end
            end
            % Step 2: generate false alarms or false detections
            num_false_alarms = poissrnd(o.false_alarm_rate * (o.interval_length+o.interval_breadth+o.interval_height)/3);
            observation = zeros(3, 1); % have to make sure that this is a row column vector
            for i = 1:num_false_alarms
                observation(1)=(o.interval_center - o.interval_x/2) + rand * o.interval_x;
                observation(2)=(o.interval_center - o.interval_y/2) + rand * o.interval_y;
                observation(3)=(o.interval_center - o.interval_z/2) + rand * o.interval_z;
                observations{end + 1} = observation;
            end
        end
    end
end