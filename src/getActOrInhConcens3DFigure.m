function fig = getActOrInhConcens3DFigure( ...
  titleStr, ...
  concenSolutions, ...
  spatialDomainSize, ...
  spatialDomainStep, ...
  timeDomainSize, ...
  timeDomainStep, ...
  tipVelocity, ...
  fixPerspectiveAt)

fig = figure;

xMesh = 0:spatialDomainStep:spatialDomainSize;

% On our 3D plots, we want the unit of the y-axis to be hours, not seconds,
% for better visualization
tMeshSeconds = 0:timeDomainStep:timeDomainSize;
tMeshHours = linspace(0, timeDomainSize / 60 / 60, length(tMeshSeconds));

if strcmp(fixPerspectiveAt, 'tip')
  numOfElemsInTMesh = size(concenSolutions, 1);
  numOfElemsInXMesh = size(concenSolutions, 2);
  transformedConcenSols = zeros(numOfElemsInTMesh, numOfElemsInXMesh);
  for tIdx = 1:numOfElemsInTMesh
    for xIdx = 1:numOfElemsInXMesh
      xIdxBeforeTransform = int32( ...
        (tipVelocity * tIdx * timeDomainStep - xIdx * spatialDomainStep) / ...
          spatialDomainStep ...
      );
      if 0 < xIdxBeforeTransform && xIdxBeforeTransform <= numOfElemsInXMesh
        transformedConcenSols(tIdx, xIdx) = ...
          concenSolutions(tIdx, xIdxBeforeTransform);
      end
    end
  end
end

if strcmp(fixPerspectiveAt, 'tip')
  surf(xMesh, tMeshHours, transformedConcenSols, ...
    'EdgeColor', 'none'); % Turn off the meshes on the graph.
else
  surf(xMesh, tMeshHours, concenSolutions, ...
    'EdgeColor', 'none'); % Turn off the meshes on the graph.
end  
title(titleStr);
xlabel('Distance from top of root (micro-m)');
ylabel('Time (hours)');
view([0 90]); % Look at the 3D plot from atop (i.e. z=infty)
axis tight; % Without this, there'll be some blank space near top end of y-axis
colorbar;
