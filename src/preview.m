function preview()

  addpath('./lib');

  t_size_per_mesh = 200;
  y_size_per_mesh = 0.01;
  [a_sol, h_sol, t_mesh_secs, x_mesh] = ...
    solve_cacheless(t_size_per_mesh, y_size_per_mesh);

  plot3d(a_sol, t_mesh_secs, x_mesh, ...
    'Simulation of $a(x,t)$ under the following equations:');
  plot3d(h_sol, t_mesh_secs, x_mesh, ...
    'Simulation of $h(x,t)$ under the following equations:');

end
