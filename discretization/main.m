function main

%%% Environment variables %%%
rootWidthMicrometer = 10; % micrometers
timeStepAfterFirstAiCellAppearsSec = 0.1; % seconds
timeStepBeforeFirstAiCellAppearsSec = 10000; % seconds
renderUntilSec = 60 * 60 * 24 * 5; % seconds - 5 days
%%% Differential equations constants %%%
actDecayCoeff = 0.00019; % the mu in the differential equations
actDiffuCoeff = 1; % the D_a
inhDecayCoeff = 0.00025; % the nu
inhDiffuCoeff = 250; % the D_h
sourceDensity = 0.00018; % the rho

animationFig = figure; % Open up a window where animation will be drawn.
animationFig.Position = [0 0 300 700]; % Set its offset and size.

% Initial states
actConcensRow = [];
cellCreationPathToInfoStruct = getInitialCellCreationPathToInfoStruct();
curTimeSec = 0;
hasFirstAiCellAppeared = 0;
inhConcensRow = [];

while curTimeSec <= renderUntilSec

  % Paint the current states.
  curRootHeight = getRootTotalHeight(cellCreationPathToInfoStruct);
  drawCellBorders(cellCreationPathToInfoStruct, rootWidthMicrometer);
  drawConcens(inhConcensRow, curRootHeight, rootWidthMicrometer);

  titleStr = sprintf('Inhibitor concentrations at time %d sec\n', ...
    curTimeSec);
  title(titleStr);
  xlabel('Width of root (�m)');
  ylabel('Height of root (�m)');

  % Comptute the next states for the next frame.

  if hasFirstAiCellAppeared
    timeStepSec = timeStepAfterFirstAiCellAppearsSec;
  else
    timeStepSec = timeStepBeforeFirstAiCellAppearsSec;
  end

  nextCellCreationPathToInfoStruct = ...
    getNextCellCreationPathToInfoStruct( ...
      cellCreationPathToInfoStruct, ...
      timeStepSec / 60 / 60 ...
    );

  nextRootHeight = getRootTotalHeight(nextCellCreationPathToInfoStruct);

  nextConcensArgs = struct();
  nextConcensArgs.actConcensRow = actConcensRow;
  nextConcensArgs.cellCreationPathToInfoStruct = ...
    cellCreationPathToInfoStruct;
  nextConcensArgs.consts = struct();
  nextConcensArgs.consts.actDecayCoeff = actDecayCoeff;
  nextConcensArgs.consts.actDiffuCoeff = actDiffuCoeff;
  nextConcensArgs.consts.inhDecayCoeff = inhDecayCoeff;
  nextConcensArgs.consts.inhDiffuCoeff = inhDiffuCoeff;
  nextConcensArgs.consts.sourceDensity = sourceDensity;
  nextConcensArgs.hasFirstAiCellAppeared = hasFirstAiCellAppeared;
  nextConcensArgs.inhConcensRow = inhConcensRow;
  nextConcensArgs.nextRootHeight = nextRootHeight;
  nextConcensArgs.secElapsedSinceCur = timeStepSec;
  nextConcensResults = getNextConcensRows(nextConcensArgs);

  % Update states
  actConcensRow = nextConcensResults.actConcensRow;
  cellCreationPathToInfoStruct = nextCellCreationPathToInfoStruct;
  curTimeSec = curTimeSec + timeStepSec;
  hasFirstAiCellAppeared = nextConcensResults.hasFirstAiCellAppeared;
  inhConcensRow = nextConcensResults.inhConcensRow;

  % Delay between animation frames.
  % Without this small delay, the loop runs too fast without leaving room
  % for animation to appear.
  pause(0.001);

  % Erase everything that is in the current frame, so that a new frame can
  % painted.
  clf;

end
