% Given the time domain size and step, it is important to use good values for
% the spatial domain size and step.
% Read the comments inside the function to find out why.
% Always use this function to set the spatial domain size and step.
function [size, step] = getGoodSpatialDomainSizeAndStep( ...
  timeDomainSize, ...
  timeDomainStep, ...
  tipVelocity)

% It is very important to make the spatial domain so large that the growing
% root never reaches the right end of the domain (i.e. the top end of the root)
% during our simulation.
% MATLAB's built-in PDE solver that we use enforces boundary conditions at the
% left and right ends of the spatial domain.
% While the left-side boundary condition is important and useful, we don't want
% to think about the right-side boundary condition.
% This is because while the plant actually ends on the left side (i.e. the
% bottom tip of the root), on the right side the plant doesn't end - the plant
% continues.
% And we don't know the correct boundary condition at this right end.
% We could spend time and think about what the correct boundary condition would
% be, but if we can just avoid it altogether and still be fine, why even spend
% time thinking about it?
% So we want the right end of the spatial domain to be never reached by the
% growing root.
% And the root can only grow as far as `tipVelocity * timeDomainSize`.
% So we set spatialDomain to be just a tad bit larger than
% `tipVelocity * timeDomainSize`.
% If we make it too large, computation time will increase but we don't get any
% additional value.
size = tipVelocity * timeDomainSize + 10; % micrometers

% It is very important to keep the spatial domain step small enough to maintain
% numerical stability.
% For example, if you make the step too large, you could see negative
% concentrations.
% According to what I (YJ Yang) understand from page 9 of the paper below,
% setting the step to `sqrt(2 * timeDomainStep)` seems like a decent way to
% maintain numerical stability, and this choice has worked well in our
% simulations so far.
% But I cannot tell its mathematical correctness.
% https://www.bsse.ethz.ch/content/dam/ethz/special-interest/bsse/cobi-dam/documents/Spat-Temp_Modelling/Numerics_PDE.pdf
step = sqrt(2 * timeDomainStep); % micrometers
