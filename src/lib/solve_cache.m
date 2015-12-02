function [a_sol, h_sol, t_mesh, x_mesh] = solve_cache( ...
  t_step, ...
  y_step)

  solver_id = 'f2248';
  
  settings_files = dir('./settings');
  settings_files_content = '';
  for i = 1 : length(settings_files)
    if settings_files(i).isdir == 1
      continue;
    end
    file_name = settings_files(i).name;
    file_content = fileread(file_name);
    settings_files_content = sprintf('%s%%%%%% %s %%%%%%\n\n%s\n\n', ...
      settings_files_content, ...
      file_name, ...
      file_content ...
    );
  end
  
  hash_engine = java.security.MessageDigest.getInstance('SHA-1');
  hash_engine.update(typecast(uint16(settings_files_content(:)), 'uint8'));
  settings_files_hash_all = ...
    sprintf('%.2x', double(typecast(hash_engine.digest, 'uint8')));
  settings_files_hash_short = settings_files_hash_all(1:5);

  filename = strjoin({
    solver_id
    settings_files_hash_short
    num2str(t_step)
    num2str(y_step)
  }, '_');

  filename_with_path_and_ext = strcat('../cache/', filename, '.mat');
  
  if exist(filename_with_path_and_ext, 'file') == 2
    load(filename_with_path_and_ext)
    return;
  end
  
  [a_sol, h_sol, t_mesh, x_mesh] = solve_cacheless(t_step, y_step);

  save(filename_with_path_and_ext, ...
    'a_sol', ...
    'h_sol', ...
    'settings_files_content', ...
    't_mesh', ...
    'x_mesh');  

end
