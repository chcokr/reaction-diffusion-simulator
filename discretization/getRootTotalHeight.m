function height = getRootTotalHeight(cellCreationPathToInfoStruct)

info = cellCreationPathToInfoStruct;
paths = fieldnames(info);
pathsCount = size(paths, 1);

heightSoFar = 0;
for pathIdx = 1:pathsCount
  pathStr = paths{pathIdx, 1};
  heightSoFar = heightSoFar + info.(pathStr).height;
end

height = heightSoFar;
