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
            o = o.object_death();
            % Step 2: split the objects which are left
            o = o.object_split();
            % Step 3: update the positions/state of the objects
            o = o.object_update();
            % Step 4: birth of new objects
            o = o.object_birth();
        end
        
        function o = object_death(o)
            temp_list_of_objects = [];
            for i = 1:length(o.list_of_objects)
                if rand > o.death_probability
                    temp_list_of_objects{end + 1} = o.list_of_objects{i};
                end
            end
            o.list_of_objects = temp_list_of_objects;
        end
        
        function o = object_birth(o)
            number_new_objects = poissrnd(o.birth_rate);
            for i = 1:number_new_objects
                o.list_of_objects{end + 1} = DynamicModelObject(o.dynamic_model_object_parameters);
            end
        end
        
        function  o = object_split(o)
            temp_list_of_objects = [];
            for i = 1:length(o.list_of_objects)
                if rand > o.splitting_probability
                    temp_list_of_objects{end + 1} = o.list_of_objects{i};
                else
                    temp_list_of_objects{end + 1} = o.list_of_objects{i};
                    split_parameters = o.dynamic_model_object_parameters;
                    split_parameters.state = o.list_of_objects{i}.get_state();
                    temp_list_of_objects{end + 1} = DynamicModelObject(split_parameters);
                end
            end
            o.list_of_objects = temp_list_of_objects;
        end
        
        function  o = object_update(o)
            for i = 1:length(o.list_of_objects)
                o.list_of_objects{i}.step();
            end
        end
        
        function all_observations = get_all_observations(o)
            % return a cell array of observations from the set of objects
            all_observations = [];
            for i = 1:length(o.list_of_objects)
                all_observations{i} = o.list_of_objects{i}.get_observation();
            end
        end
    end    
end