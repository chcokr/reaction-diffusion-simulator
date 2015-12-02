function preview()

  addpath('./lib');

  t_size_per_mesh = 5;
  y_size_per_mesh = 0.001;
  [a_sol, h_sol, t_mesh_secs, x_mesh] = ...
    solve_cache(t_size_per_mesh, y_size_per_mesh);

  plot3d(a_sol, t_mesh_secs, x_mesh);
  plot3d(h_sol, t_mesh_secs, x_mesh);

end
