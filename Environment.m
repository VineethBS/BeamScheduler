classdef Environment
    %Environment - models the environment around the radar, simulates the objects that the radar is supposed to track
    %   The environment models/simulates the volume around the radar and the objects that are in the vicinity of the
    %   radar.
    
    properties
        simulator_type;
        simulator_parameters;
        simulator;
    end
    
    methods
        function o = Environment(parameters)
            o.simulator_type = parameters.simulator_type;
            o.simulator_parameters = parameters.simulator_parameters;
            
            if strcmp(o.simulator_type, 'dynamicmodelenv')
                o.simulator = DynamicModelEnvironment(o.simulator_parameters);
            end
        end

        function o = step(o, time)
            o.simulator.step(time);
        end
        
        function observations = get_all_observations(o)
            observations = o.simulator.get_all_observations();
        end
    end
    
end

