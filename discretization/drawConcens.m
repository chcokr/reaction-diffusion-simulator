function drawConcens(concensRowTopToBottom, rootTotalHeight, rootWidth)

for posFromBottom = 1:rootTotalHeight

  posFromTopInt = int32(rootTotalHeight - posFromBottom + 1);

  if posFromTopInt > size(concensRowTopToBottom, 2)
    return;
  end

  redDepth = concensRowTopToBottom(posFromTopInt);

  patchline([0 rootWidth], ...
    [posFromBottom posFromBottom], ...
    'edgecolor', 'red', ...
    'edgealpha', redDepth);

end
