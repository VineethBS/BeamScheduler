function plot_1D(o, tracks, sequence_times, sequence_observations, sequence_pointing_information, radar_parameters)

plot_input = o.visualization_parameters.plot_input;
plot_tracks = o.visualization_parameters.plot_tracks;
plot_radar = o.visualization_parameters.plot_radar;
plottype_input = o.visualization_parameters.plottype_input;
plottype_track = o.visualization_parameters.plottype_track;
plottype_radar = o.visualization_parameters.plottype_radar;

dimension_observations = 1;

figure(1);
hold on;

if plot_input == 1
    for i = 1:length(sequence_times)
        for j = 1:length(sequence_observations{i})
            temp = cell2mat(sequence_observations{i});
            plot(sequence_times(i), temp(j), plottype_input);
        end
    end
end

if plot_radar == 1
    interval_width = radar_parameters.interval_width;
    for i = 1:length(sequence_times)
        errorbar(sequence_times(i), sequence_pointing_information{i}.interval_center, interval_width/2, plottype_radar);
    end
end

if plot_tracks == 1
    for i = 1:length(tracks)
        plot(tracks{i}.sequence_times, cell2mat(tracks{i}.sequence_predicted_observations), plottype_track);
    end
end