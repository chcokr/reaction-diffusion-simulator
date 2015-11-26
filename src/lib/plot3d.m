function plot3d(sol, t_mesh_secs, x_mesh)

  figure;
  t_mesh_hours = t_mesh_secs / 60 / 60; % y-axis unit is hours, not seconds
  surf(x_mesh, t_mesh_hours, sol, ...
    'EdgeColor', 'none'); % Turn off the meshes on the graph.
  title('Title: TODO');
  xlabel('Distance from the open end (micro-m)');
  ylabel('Time (hours)');
  zlabel('Concentration (whatever unit)');
  view([0 90]); % Look at the 3D plot from atop (i.e. from z=infinity)
  axis tight; % Without this, there'll be some blank space around y-axis
  colorbar; % This adds a color legend.

end