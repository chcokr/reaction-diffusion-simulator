function next = getNextConcensRows(argsStruct)

% Arguments that need to be passed in as part of argsStruct.
actConcensRow = argsStruct.actConcensRow;
cellCreationPathToInfoStruct = argsStruct.cellCreationPathToInfoStruct;
actDecayCoeff = argsStruct.consts.actDecayCoeff;
actDiffuCoeff = argsStruct.consts.actDiffuCoeff;
inhDecayCoeff = argsStruct.consts.inhDecayCoeff;
inhDiffuCoeff = argsStruct.consts.inhDiffuCoeff;
sourceDensity = argsStruct.consts.sourceDensity;
hasFirstAiCellAppeared = argsStruct.hasFirstAiCellAppeared;
inhConcensRow = argsStruct.inhConcensRow;
nextRootHeight = argsStruct.nextRootHeight;
secElapsedSinceCur = argsStruct.secElapsedSinceCur;

% Whenever a position in the root is involved in a concentration
% computation but the current concentration values there are unknown, the
% concentrations there are assumed to be this value.
defaultActInhConcen = 0.001;

actConcensRowLen = size(actConcensRow, 2);
inhConcensRowLen = size(inhConcensRow, 2);

next = struct();

cellInfo = cellCreationPathToInfoStruct;
cellPathsSortedTopToBottomRow = sort(fieldnames(cellInfo)).';
cellCount = int32(size(cellPathsSortedTopToBottomRow, 2));

% The first AI cell will be the topmost cell of the root as soon as there
% are at least 10 cells in the elongation zone.
% And there are always a fixed number, 20, of cells in the division zone).
% So, if there are less than 20 + 10 cells in the root right now, this
% function shouldn't do anything.
if (cellCount < 20 + 10)
  next.actConcensRow = [];
  next.hasFirstAiCellAppeared = 0;
  next.inhConcensRow = [];
  return;
end

% If there are at least 10 cells in the elongation zone but the first AI
% cell hasn't yet appeared, we need to create the first AI cell.
% It will be the current topmost cell of the root.
if ~hasFirstAiCellAppeared
  topCellPath = cellPathsSortedTopToBottomRow{1};
  topCellHeightInt = int32(cellInfo.(topCellPath).height);

  % The activator and inhibitor concentrations across this first AI cell
  % are set to 1.
  next.actConcensRow = arrayfun(@(~) 1, 1:topCellHeightInt);
  next.hasFirstAiCellAppeared = 1;
  next.inhConcensRow = arrayfun(@(~) 1, 1:topCellHeightInt);

  return;
end

% Since the first AI cell has appeared, we now let the PDEs take control
% of the diffusion process.

nextActConcensRow = [];
nextInhConcensRow = [];

nextRootHeightInt = int32(nextRootHeight);

% Concentrations are computed for each position across the root.
for posFromTop = 1: nextRootHeightInt

  % We need to be very careful with the border conditions, because they
  % play an important role in the progress of the PDE solutions.

  if posFromTop == 1
    % Enforce da/dx = 0 at the top of the root.
    actConcenOneBefore = actConcensRow(posFromTop);
  elseif 1 <= posFromTop && posFromTop <= actConcensRowLen + 1
    actConcenOneBefore = actConcensRow(posFromTop - 1);
  else
    actConcenOneBefore = defaultActInhConcen;
  end

  if posFromTop == 1 && posFromTop <= actConcensRowLen
    actConcen = actConcensRow(posFromTop);
  else
    actConcen = defaultActInhConcen;
  end

  if 1 <= posFromTop && posFromTop <= actConcensRowLen - 1
    actConcenOneNext = actConcensRow(posFromTop + 1);
  elseif posFromTop == actConcensRowLen
    if posFromTop == nextRootHeightInt - 1;
      % Enforce da/dx = 0 at the bottom of the root.
      actConcenOneNext = actConcensRow(posFromTop);
    else
      actConcenOneNext = defaultActInhConcen;
    end
  else
    actConcenOneNext = defaultActInhConcen;
  end

  if posFromTop == 1
    % Enforce dh/dx = 0 at the top of the root.
    inhConcenOneBefore = inhConcensRow(posFromTop);
  elseif 1 <= posFromTop && posFromTop <= inhConcensRowLen + 1
    inhConcenOneBefore = inhConcensRow(posFromTop - 1);
  else
    inhConcenOneBefore = defaultActInhConcen;
  end

  if posFromTop == 1 && posFromTop <= inhConcensRowLen
    inhConcen = inhConcensRow(posFromTop);
  else
    inhConcen = defaultActInhConcen;
  end

  if 1 <= posFromTop && posFromTop <= inhConcensRowLen - 1
    inhConcenOneNext = inhConcensRow(posFromTop + 1);
  elseif posFromTop == inhConcensRowLen
    if posFromTop == nextRootHeightInt - 1;
      % Enforce dh/dx = 0 at the bottom of the root.
      inhConcenOneNext = inhConcensRow(posFromTop);
    else
      inhConcenOneNext = defaultActInhConcen;
    end
  else
    inhConcenOneNext = defaultActInhConcen;
  end

  % Now it's time to compute concentrations on the next frame of the
  % animation.

  % This variable exists just to make code more legible below where
  % derivatives are defined.
  dx = 1;

  % The activator PDE (wrt stands for "with respect to"):
  actRateOfChangeWrtPos1 = (actConcen - actConcenOneBefore) / dx;
  actRateOfChangeWrtPos2 = (actConcenOneNext - actConcen) / dx;
  actSecondDerivWrtPos = ...
    (actRateOfChangeWrtPos2 - actRateOfChangeWrtPos1) / dx;
  actRateOfChangeWrtTime = ...
    sourceDensity * actConcen * actConcen / inhConcen - ...
      actDecayCoeff * actConcen + ...
      actDiffuCoeff * actSecondDerivWrtPos;
  % Use the rate of change w.r.t. time to compute what activator
  % concentration value this position of the root will have on the next
  % frame.
  nextActConcen = actConcen + actRateOfChangeWrtTime * secElapsedSinceCur;

  % The inhibitor PDE (wrt stands for "with respect to"):
  inhRateOfChangeWrtPos1 = (inhConcen - inhConcenOneBefore) / dx;
  inhRateOfChangeWrtPos2 = (inhConcenOneNext - inhConcen) / dx;
  inhSecondDerivWrtPos = ...
    (inhRateOfChangeWrtPos2 - inhRateOfChangeWrtPos1) / dx;
  inhRateOfChangeWrtTime = ...
    sourceDensity * actConcen * actConcen - ...
      inhDecayCoeff * inhConcen + ...
      inhDiffuCoeff * inhSecondDerivWrtPos;
  % Use the rate of change w.r.t. time to compute what inhibitor
  % concentration value this position of the root will have on the next
  % frame.
  nextInhConcen = actConcen + inhRateOfChangeWrtTime * secElapsedSinceCur;

  nextActConcensRow(posFromTop) = nextActConcen;
  nextInhConcensRow(posFromTop) = nextInhConcen;

end

next.actConcensRow = nextActConcensRow;
next.hasFirstAiCellAppeared = 1;
next.inhConcensRow = nextInhConcensRow;
