function animate()

  addpath('./lib');
  addpath('./settings');

  t_size_per_mesh = 5;
  y_size_per_mesh = 0.001;
  [a_sol, h_sol, t_mesh_secs, x_mesh] = ...
    solve_cache(t_size_per_mesh, y_size_per_mesh);

  center_figure(500, 700, 0); % Open up a figure of width 500, height 700, and
                              % center it at the middle of the screen.

  fig = gcf;

  root_width = 10; % Unimportant width of the root, for visual purposes.
  gap_between_roots = 5; % Similarly unimportant, for visual purposes.

  max_act_concen = max(a_sol(:));
  min_act_concen = min(a_sol(:));
  max_inh_concen = max(h_sol(:));
  min_inh_concen = min(h_sol(:));

  animate_results_dir_path = ...
    fullfile( ...
      fileparts(fileparts(mfilename('fullpath'))), ...
      'animate_results' ...
    );
  if exist(animate_results_dir_path, 'dir') ~= 7
    mkdir(animate_results_dir_path);
  end
  movie_save_path = ...
    fullfile( ...
      animate_results_dir_path, ...
      [datestr(datetime('now'), 'yyyymmdd-HHMMSS') '.avi'] ...
    );
  video = VideoWriter(movie_save_path);
  video.FrameRate = 10;
  open(video);
  fprintf('\n');
  display(['Movie is being saved at ', movie_save_path]);
  display(['If you quit in the middle, ', ...
    'you can find the movie generated so far there.']);
  fprintf('\n');

  % The inside of the following `while` loop produces each frame of the
  % animation.
  prev_msg_len = 0; % This helps delete the previous line of console output.
  itr_index = 1;

  % If we draw at every t_mesh, there are way too many frames to draw, so we
  % only draw every 20th frame.
  t_indices_to_paint = 1:20:size(t_mesh_secs, 2);

  for t_index = t_indices_to_paint
    cur_time = t_mesh_secs(t_index);

    % Delete the previous line of console output, and write a new one.
    fprintf(repmat('\b', 1, prev_msg_len));
    prev_msg_len = fprintf('Movie: creating frame %d of %d \n', ...
      itr_index, ...
      length(t_indices_to_paint));
    itr_index = itr_index + 1;

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
        '$a(x,t)$ (left) and $h(x,t)$ (right) at $t=$', ...
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
    writeVideo(video, getframe(fig));

  end

  close(video);

  fprintf('Done! \n');

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

function rtn = gradient_from_blue_to_yellow(how_far_from_blue)

  fast_growth_toward_yellow = 0.2167 * log(how_far_from_blue + 0.01) + 0.9979;

  if fast_growth_toward_yellow < 0
    force_to_be_within_0_to_1_range = 0;
  elseif fast_growth_toward_yellow > 1
    force_to_be_within_0_to_1_range = 1;
  else
    force_to_be_within_0_to_1_range = fast_growth_toward_yellow;
  end

  rtn = [ ...
    force_to_be_within_0_to_1_range, ...
    force_to_be_within_0_to_1_range, ...
    1 - force_to_be_within_0_to_1_range ...
  ];

end
