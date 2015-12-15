function refine()

  addpath('./lib');

  t_size_per_mesh = 5;
  y_size_per_mesh = 0.001;
  [a_sol, h_sol, t_mesh_secs, x_mesh] = ...
    solve_cache(t_size_per_mesh, y_size_per_mesh);
  
  % The results of solve_cache are often high-resolution data.
  % If we plot every single point in this data set, the plot3d function ends up
  % taking too long.
  % So we only plot a sublattice of the solution data.
  
  [a_sol_sub, t_mesh_sub, x_mesh_sub] = ...
    sublattice(3, a_sol, t_mesh_secs, x_mesh);
  a_fig = plot3d(a_sol_sub, t_mesh_sub, x_mesh_sub, ...
    'Simulation of $a(x,t)$ under the following equations:');

  [h_sol_sub, t_mesh_sub, x_mesh_sub] = ...
    sublattice(3, h_sol, t_mesh_secs, x_mesh);
  h_fig = plot3d(h_sol_sub, t_mesh_sub, x_mesh_sub, ...
    'Simulation of $h(x,t)$ under the following equations:');

  if exist('../history', 'dir') ~= 7
    mkdir('../history');
  end
  time_now_str = datestr(datetime('now'), 'yyyymmdd-HHMMSS');  
  saveas( ...
    a_fig, ...
    strcat('../history/', time_now_str, '-act') ...
  );
  saveas( ...
    h_fig, ...
    strcat('../history/', time_now_str, '-inh') ...
  );

end

function [s, t, x] = sublattice(every, sol, t_mesh, x_mesh)

  dim1 = 1:every:size(sol, 1);
  dim2 = 1:every:size(sol, 2);
 
  s = sol(dim1, dim2);
  
  t = t_mesh( ...
    1:int32(length(t_mesh) / length(dim1)):length(t_mesh) ...
  );
  
  x = x_mesh( ...
    1:int32(length(x_mesh) / length(dim2)):length(x_mesh) ...
  );

end
