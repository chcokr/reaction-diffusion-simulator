function hr = getRandomCellDurationUntilSplit()

% A cell will split 18-22 hours after its creation, if it is currently
% within the meristem.
hr = 18 + 4 * rand;
