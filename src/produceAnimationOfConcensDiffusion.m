% Generates a figure, and produces a 2D animation of how the concentrations
% diffuse, both activator and inhibitor, across the root at a fixed moment.
function produceAnimationOfConcensDiffusion( ...
  actConcenSolutionsFromPdepe, ...
  inhConcenSolutionsFromPdepe, ...
  timeDomainSize, ...
  timeDomainStep, ...
  spatialDomainSize, ...
  spatialDomainStep)

centerFigure(500, 700); % Open up a figure of width 500, height 700, and center
                        % it at the middle of the screen.

fig = gcf;

rootWidth = 10; % unimportant width of the root, for visual purposes
gapBetweenRoots = 5; % similarly unimportant, for visual purposes

maxActConcen = max(actConcenSolutionsFromPdepe(:));
minActConcen = min(actConcenSolutionsFromPdepe(:));
maxInhConcen = max(inhConcenSolutionsFromPdepe(:));
minInhConcen = min(inhConcenSolutionsFromPdepe(:));

% The inside of the following `while` loop produces each frame of the animation.
curTime = 0;
while curTime <= timeDomainSize
  % If the user is watching any other figure window, make sure this new frame
  % gets drawn to this desired figure.
  figure(fig);
  
  % Erase everything that is in the previous frame, so that a new frame can be
  % painted.
  clf;

  % Prepare a new frame.
  axes = gca; % `gca` returns the current axes handle.
  axes.Color = 'none'; % We don't want any color on the back pane.
  axes.XColor = 'none'; % We don't want the x-axis to appear.
  axes.YLabel.String = 'Offset from the bottom of the initial bump (micro-m)';
  title(sprintf( ...
    'Activator (left) and inhibitor (right) concentrations at %d sec\n', ...
    curTime));

  timeIdx = int32((curTime - 0) / timeDomainStep + 1);
  howManySpatialStepsAreThere = int32(spatialDomainSize / spatialDomainStep);

  actConcensAtCurTime = actConcenSolutionsFromPdepe(timeIdx, :);
  drawConcensAtFixedTime( ...
    actConcensAtCurTime, ...
    maxActConcen, ...
    minActConcen, ...
    spatialDomainStep, ...
    howManySpatialStepsAreThere, ...
    rootWidth, ...
    0);

  inhConcensAtCurTime = inhConcenSolutionsFromPdepe(timeIdx, :);
  drawConcensAtFixedTime( ...
    inhConcensAtCurTime, ...
    maxInhConcen, ...
    minInhConcen, ...
    spatialDomainStep, ...
    howManySpatialStepsAreThere, ...
    rootWidth, ...
    rootWidth + gapBetweenRoots);

  % Delay between animation frames.
  % Without this small delay, the loop runs too fast without leaving room
  % for animation to appear.
  pause(0.001);

  % Move on to the next frame.
  curTime = curTime + timeDomainStep;
end
