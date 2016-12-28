classdef Visualization
    % Visualization - block for visualization (and saving) experiment output
    
    properties
        visualization_parameters;
    end
    
    methods
        function o = Visualization(parameters)
            o.visualization_parameters = parameters;
        end
        
        plot_1D(o, tracks, sequence_times, sequence_observations, sequence_pointing_information, radar_parameters);
        plot_3D(o, tracks);
    end
    
end

