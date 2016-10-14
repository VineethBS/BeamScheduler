function o = update_and_make_newtracks(o, observations, data_association_matrix)

new_tracks = {};
num_of_observations = length(observations);
num_of_tracks = length(o.list_of_tracks);

for i = 1:num_of_observations
    if data_association_matrix(i, end) == 1
        current_observation = observations{i};
        initial_state = [current_observation', o.filter_parameters.rest_of_initial_state']';
        t = Track(o.filter_parameters.A,  o.filter_parameters.C, o.filter_parameters.Q, o.filter_parameters.R, initial_state);
        new_tracks{end + 1} = t;
    else
        for j = 1:num_of_tracks
            if data_association_matrix(i, j) == 1
                o.list_of_tracks{j} = o.list_of_tracks{j}.update(current_observation);
            end 
        end
    end

    o.list_of_tracks = [o.list_of_tracks, new_tracks];
end