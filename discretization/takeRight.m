% Returns a new row vector of the rightmost n items of the given row
% vector.
%
% Examples:
%
% takeRight([1 2 3], 2); % [2 3]
% takeRight([1 2], 3); % [1 2]
function right = takeRight(row, n)

arrLen = int32(size(row, 2));
right = row((max(1, arrLen - (n - 1))):arrLen);
