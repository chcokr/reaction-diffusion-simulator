function fig = getActOrInhConcens3DFigure( ...
  titleStr, ...
  concenSolutions, ...
  spatialDomainSize, ...
  spatialDomainStep, ...
  timeDomainSize, ...
  timeDomainStep)

fig = figure;

xMesh = 0:spatialDomainStep:spatialDomainSize;

% On our 3D plots, we want the unit of the y-axis to be hours, not seconds,
% for better visualization
tMeshSeconds = 0:timeDomainStep:timeDomainSize;
tMeshHours = linspace(0, timeDomainSize / 60 / 60, length(tMeshSeconds));

surf(xMesh, tMeshHours, concenSolutions, ...
  'EdgeColor', 'none'); % Turn off the meshes on the graph.
title(titleStr);
xlabel('Distance x (micro-m)');
ylabel('Time t (hours)');
view([0 90]); % Look at the 3D plot from atop (i.e. z=infty)
axis tight; % Without this, there'll be some blank space near top end of y-axis
