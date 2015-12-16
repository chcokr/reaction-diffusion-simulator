% Open up a figure of the given width and height, and center it at the middle of
% the screen.
function fig = center_figure(width, height, offset_left)

  screen_size_info = get(groot, 'ScreenSize'); % `groot` stands for `graphics root`
  screen_width = screen_size_info(3);
  screen_height = screen_size_info(4);
  center_offset_left = (screen_width - width) / 2 + offset_left;
  center_offset_top = (screen_height - height) / 2;
  fig = figure('Position', [center_offset_left center_offset_top width height]);

end
