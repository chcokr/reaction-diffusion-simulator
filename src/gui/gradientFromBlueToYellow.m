% Computes the color that is linearly `howFarFromBlue` away from the color
% [0, 0, 1] (blue) toward the color [1, 1, 0] (yellow).
function rgbArray = gradientFromBlueToYellow(howFarFromBlue)

rgbArray = [howFarFromBlue, howFarFromBlue, 1 - howFarFromBlue];
