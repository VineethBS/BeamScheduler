classdef DynamicModelEnvironment
    %DynamicModelEnvironment - models a set of objects according to the object model in Vo and Ma  
    
    properties
        initial_number_of_objects;
        list_of_objects;
        dynamic_model_object_parameters;
        death_probability;
        splitting_probability;
        birth_rate;
    end
    
    methods
        function o = DynamicModelEnvironment(parameters)
            o.initial_number_of_objects = parameters.initial_number_of_objects;
            o.list_of_objects = [];
            o.dynamic_model_object_parameters = parameters.dynamic_model_object_parameters;
            o.death_probability = parameters.death_probability;
            o.splitting_probability = parameters.splitting_probability;
            o.birth_rate = parameters.birth_rate;
            
            for i = 1:o.initial_number_of_objects
                o.list_of_objects{i} = DynamicModelObject(o.dynamic_model_object_parameters);
            end
        end
        
        function o = step(o, time)
            % Step 1: remove the objects which die
            % Step 2: split the objects which are left
            % Step 3: update the positions/state of the objects
            % Step 4: birth of new objects
        end
        
        function observations = get_all_observations(o)
            % return a cell array of observations from the set of objects
        end
    end
    
end