classdef DynamicModelObject
    %DynamicModelObject - models the motion of an object described by a linear dynamic model
    % The state is modelled by
    % x_{k + 1} = Ax_{k} - here x_{k} is the underlying state
    % y_{k} = C x_{k} + v_{k} - here y_{k} is the observation
    
    properties
        A;
        C;
        R;
        state;
    end
    
    methods
        function o = DynamicModelObject(parameters)
            o.A = parameters.A;
            o.C = parameters.C;
            o.R = parameters.R;
            o.state = parameters.initial_state;
        end
        
        function o = step(o)
            o.state = o.A * o.state;
        end
        
        function observation = get_observation(o)
            num_dimensions = size(o.R, 1);
            observation = o.C * o.state + mvnrnd(zeros(num_dimensions,1), o.R);
        end
        
        function state = get_state(o)
            state = o.state;
        end
    end
end

