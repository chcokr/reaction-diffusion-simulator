function info = getInitialCellCreationPathToInfoStruct()

info = struct();

% There are 5 cells in the meristem initially.
for i = 1:5
  iStr = strcat('init', num2str(i));

  info.(iStr) = struct();

  % These cells are initialized to a height of 20 units.
  info.(iStr).height = 20;

  info.(iStr).hrUntilSplit = getRandomCellDurationUntilSplit();
end
