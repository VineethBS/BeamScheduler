classdef Radar1D
    %Radar1D - models a radar in 1D; i.e., it observes a single dimension and returns observations which are in an
    %interval
    %
    
    properties
        detection_probability;
        false_alarm_rate; % is normalized to per unit volume/unit interval
        interval_width;
        interval_center;
    end
    
    methods
        function o = Radar1D(parameters)
            o.detection_probability = parameters.detection_probability;
            o.false_alarm_rate = parameters.false_alarm_rate;
            o.interval_width = parameters.interval_width;
            o.interval_center = parameters.interval_center;
        end

        function observations = get_observations(o, pointing_information, all_observations)
            observations = [];
            o.interval_center = pointing_information.interval_center;
            % Step 1: if an observation is within the interval and if it is detected then add to the observations
            for i = 1:length(all_observations)
                if (all_observations{i} >= (o.interval_center - o.interval_width/2)) && (all_observations{i} <= (o.interval_center + o.interval_width/2))
                    if rand <= o.detection_probability
                        observations{end + 1} = all_observations{i};
                    end
                end
            end
            % Step 2: generate false alarms or false detections
            num_false_alarms = poissrnd(o.false_alarm_rate * o.interval_width);
            for i = 1:num_false_alarms
                observations{end + 1} = (o.interval_center - o.interval_width/2) + rand * o.interval_width;
            end
        end
    end
end