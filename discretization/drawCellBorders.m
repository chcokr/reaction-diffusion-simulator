function drawCellBorders(cellCreationPathToInfoStruct, rootWidth)

info = cellCreationPathToInfoStruct;
paths = fieldnames(info);
pathsSortedBottomToTop = flipud(sort(paths)).';

offsetFromBottomSoFar = 0;
for path = pathsSortedBottomToTop
  pathStr = path{1};

  cellBottomBorderPosFromRootBottom = ...
    offsetFromBottomSoFar + info.(pathStr).height;

  line( ...
    [
      0 ...
      rootWidth
    ], ...
    [
      cellBottomBorderPosFromRootBottom ...
      cellBottomBorderPosFromRootBottom
    ], ...
    'Color', 'black' ...
  );

  offsetFromBottomSoFar = offsetFromBottomSoFar + info.(pathStr).height;
end
rootTotalHeight = offsetFromBottomSoFar;

rectangle('Position', ...
  [0 0 rootWidth rootTotalHeight]);
