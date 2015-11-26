% Open up a figure of the given width and height, and center it at the middle of
% the screen.
function centerFigure(width, height)

screenSizeInfo = get(groot, 'ScreenSize'); % `groot` stands for `graphics root`
screenWidth = screenSizeInfo(3);
screenHeight = screenSizeInfo(4);
centerOffsetLeft = (screenWidth - width) / 2;
centerOffsetTop = (screenHeight - height) / 2;
figure('Position', [centerOffsetLeft centerOffsetTop width height]);
