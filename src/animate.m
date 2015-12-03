function animate()

  addpath('./lib');
  addpath('./settings');

  t_size_per_mesh = 5;
  y_size_per_mesh = 0.001;
  [a_sol, h_sol, t_mesh_secs, x_mesh] = ...
    solve_cache(t_size_per_mesh, y_size_per_mesh);

  center_figure(500, 700); % Open up a figure of width 500, height 700, and
                           % center it at the middle of the screen.

  fig = gcf;

  root_width = 10; % Unimportant width of the root, for visual purposes.
  gap_between_roots = 5; % Similarly unimportant, for visual purposes.

  max_act_concen = max(a_sol(:));
  min_act_concen = min(a_sol(:));
  max_inh_concen = max(h_sol(:));
  min_inh_concen = min(h_sol(:));

  % The inside of the following `while` loop produces each frame of the
  % animation.
  prev_msg_len = 0; % This helps delete the previous line of console output.
  for t_index = 1 : size(t_mesh_secs, 2)
    cur_time = t_mesh_secs(t_index);

    % Delete the previous line of console output, and write a new one.
    fprintf(repmat('\b', 1, prev_msg_len));
    prev_msg_len = fprintf('Movie: creating frame %d of %d \n', ...
      t_index, ...
      size(t_mesh_secs, 2));

    % If the user is watching any other figure window, make sure this new frame
    % gets drawn to this desired figure.
    figure(fig);

    % Erase everything that is in the previous frame, so that a new frame can be
    % painted.
    clf;

    % Prepare a new frame.
    axis tight;
    axes = gca; % `gca` returns the current axes handle.
    axes.Color = 'none'; % We don't want any color on the back pane.
    axes.XColor = 'none'; % We don't want the x-axis to appear.
    axes.YLabel.String = 'Distance from x=0 (micro-m)';
    axes.YDir = 'reverse'; % Since the label is 'distance from the *open end*,
                           % we want 0 to be at the top of the Y-axis.
    [act_eq, inh_eq, growth_eq] = get_eq_latex();
    fig_title = title({
      [
        'Activator (left) and inhibitor (right) concentrations at', ...
        sprintf(' %.1f hrs\n', cur_time / 60 / 60)
      ]
      [
        'under the following equations: ', ...
        growth_eq
      ]
      strjoin({act_eq; inh_eq},  '\\ \\ \\ \\ \\ \\ ')
    });
    set(fig_title, 'Interpreter', 'Latex');
    a_sol_at_cur_time = a_sol(t_index, :);
    x_step = x_mesh(2) - x_mesh(1);
    draw_concens_at_fixed_time( ...
      a_sol_at_cur_time, ...
      max_act_concen, ...
      min_act_concen, ...
      x_step, ...
      size(x_mesh, 2), ...
      root_width, ...
      0);

    h_sol_at_cur_time = h_sol(t_index, :);
    draw_concens_at_fixed_time( ...
      h_sol_at_cur_time, ...
      max_inh_concen, ...
      min_inh_concen, ...
      x_step, ...
      size(x_mesh, 2), ...
      root_width, ...
      root_width + gap_between_roots);

    % Queue this frame so it can be played later.
    movie_frames(t_index) = getframe(fig);

  end

%   movieSavePath = ...
%     fullfile( ...
%       fileparts(fileparts(mfilename('fullpath'))), ...
%       strcat('movie-', datestr(datetime('now'), 'mm-dd-HH:MM:SS'), '.avi') ...
%     );
%   fprintf('Saving the movie at %s \n', movieSavePath);
%   fprintf('Done! \n');
%   movie2avi(movieFrames, movieSavePath, ...
%     'fps', 2);

end

% Paints each spatial step across the root with a color between blue and yellow
% representing how high the concentration there is compared to
% `max_concen_across_the_root` and `min_concen_across_the_root`.
% Yellow means highest, and blue means lowest.
% Recall that every spatial step is best described by a rectangle taking up a
% height defined by `how_high_is_each_step`.
function draw_concens_at_fixed_time( ...
  concens_at_each_step_from_top_of_root_to_bottom, ...
  max_concen_across_the_root, ...
  min_concen_across_the_root, ...
  how_high_is_each_step, ...
  how_many_spatial_steps_are_there_across_the_root, ...
  root_width, ...
  root_lower_left_offset_from_lower_left_of_figure)

  for pos_idx_from_top = 1 : how_many_spatial_steps_are_there_across_the_root

    concen = concens_at_each_step_from_top_of_root_to_bottom(pos_idx_from_top);

    if isnan(concen)
      fill_color = 'White';
    else
      how_far_from_blue_toward_yellow = ...
        (concen - min_concen_across_the_root) / ...
          (max_concen_across_the_root - min_concen_across_the_root);
      fill_color = ...
        gradient_from_blue_to_yellow(how_far_from_blue_toward_yellow);
    end

    rect_lower_left_x = root_lower_left_offset_from_lower_left_of_figure;
    rect_lower_left_y = (pos_idx_from_top - 1) * how_high_is_each_step;
    rectangle( ...
      'Position', [rect_lower_left_x rect_lower_left_y ...
        root_width how_high_is_each_step], ...
      'EdgeColor', fill_color, ...
      'FaceColor', fill_color);

  end

end

% Computes the color that is linearly `how_far_from_blue` away from the color
% [0, 0, 1] (blue) toward the color [1, 1, 0] (yellow).
function rtn = gradient_from_blue_to_yellow(how_far_from_blue)

  rtn = [how_far_from_blue, how_far_from_blue, 1 - how_far_from_blue];

end
