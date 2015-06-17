function next = getNextCellCreationPathToInfoStruct(cur, hrElapsedSinceCur)

paths = fieldnames(cur);
pathsSortedTopToBottomRow = sort(paths).';
bottom20 = takeRight(pathsSortedTopToBottomRow, 20);

next = struct();

for path = pathsSortedTopToBottomRow
  pathStr = path{1};

  if any(strcmp(pathStr, bottom20)) && cur.(pathStr).hrUntilSplit <= 0

    % A cell in the bottom 20 gets to split after a certain duration
    % defined at the time of its creation.

    higherPathAfterSplit = strcat(pathStr, 'x1');
    lowerPathAfterSplit = strcat(pathStr, 'x2');

    next.(higherPathAfterSplit) = struct();
    next.(higherPathAfterSplit).height = cur.(pathStr).height / 2;
    next.(higherPathAfterSplit).hrUntilSplit = ...
      getRandomCellDurationUntilSplit();

    next.(lowerPathAfterSplit) = struct();
    next.(lowerPathAfterSplit).height = cur.(pathStr).height / 2;
    next.(lowerPathAfterSplit).hrUntilSplit = ...
      getRandomCellDurationUntilSplit();

  else

    % If not in the bottom 20, just continue growing.

    if ~isfield(next, pathStr)
      next.(pathStr) = struct();
    end

    % Rate of growth is 10 per hour.
    next.(pathStr).height = cur.(pathStr).height + hrElapsedSinceCur * 10;
    % Time has elapsed, so this cell is getting closer to a split.
    next.(pathStr).hrUntilSplit = ...
      cur.(pathStr).hrUntilSplit - hrElapsedSinceCur;

  end

end
