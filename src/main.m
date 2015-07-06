function main

spatialDomainSize = 10000; % micrometers
spatialDomainStep = 100; % micrometers
timeDomainSize = 100000; % seconds
timeDomainStep = 50; % seconds

xMesh = 0:spatialDomainStep:spatialDomainSize;
tMesh = 0:timeDomainStep:timeDomainSize;

% According to http://www.mathworks.com/help/matlab/ref/pdepe.html,
% pdepe can handle three categories of PDEs: slab, cylindrical, spherical.
% I (YJ Yang) don't know what each of these means, but I went with slab.
pdeTypeIsSlab = 0;
pdeSolutions = pdepe( ...
  pdeTypeIsSlab, ...
  @pdeSystemFn, ...
  @initConditionsFn, ...
  @boundaryConditionsFn, ...
  xMesh, ...
  tMesh);

actConcenSolutions = pdeSolutions(:,:,1);
inhConcenSolutions = pdeSolutions(:,:,2);

figure;
surf(xMesh, tMesh, actConcenSolutions, ...
  'EdgeColor', 'none'); % Turn off the meshes on the graph.
title('a(x,t)');
xlabel('Distance x (micro-m)');
ylabel('Time t (sec)');

figure;
surf(xMesh, tMesh, inhConcenSolutions, ...
  'EdgeColor', 'none');
title('h(x,t)');
xlabel('Distance x (micro-m)');
ylabel('Time t (sec)');

% Produce a 2D animation of how the concentrations diffuse, both activator and
% inhibitor, across the root at a fixed moment.
produceAnimationOfConcensDiffusion( ...
  actConcenSolutions, ...
  inhConcenSolutions, ...
  timeDomainSize, ...
  timeDomainStep, ...
  spatialDomainSize, ...
  spatialDomainStep);

% This function is meant to be passed into pdepe as a function handle
% defining our system of PDEs.
% The intended meanings of the parameters and the returned values are
% explained at
% mathworks.com/help/matlab/math/partial-differential-equations.html
function [c,f,s] = pdeSystemFn(x, t, colOfVar, colOfDaDxAndDhDx)

driftVelocity = 0.2;

actBaseProd = 0.0033;
actDecayCoeff = 0.00019; % the mu in the differential equations
actDenominatorDefault = 1;
actDiffuCoeff = 0.001; % the D_a
actSourceDensity = 0.00018; % the rho_a
inhDecayCoeff = 0.00025; % the nu
inhDiffuCoeff = 20; % the D_h
inhSourceDensity = 0.00001; % the rho_h

actConcen = colOfVar(1);
inhConcen = colOfVar(2);

DaDx = colOfDaDxAndDhDx(1);
DhDx = colOfDaDxAndDhDx(2);

sizeOfInitialTopmostRegionCarryingActivators = 200;
if x > driftVelocity * t + sizeOfInitialTopmostRegionCarryingActivators

  % In order to understand this part of the IF statement well, we need to remind
  % ourselves of how we defined our coordinate system in the README.
  % Recall that x = 0 points to the bottom of the initial topmost region
  % carrying activators.
  % That is, at any moment, the top of the region always aligns with the top of
  % the root.
  % So it makes no sense to have new activators generated beyond the top of this
  % region, and thus we're trying to enforce da/dt = 0 there.

  f_a = 0;
  s_a = 0;

else

  f_a = actDiffuCoeff * DaDx;
  s_a = ...
    actSourceDensity * actConcen * actConcen / ...
      (inhConcen + actDenominatorDefault) - ...
    actDecayCoeff * actConcen + ...
    actBaseProd - ...
    driftVelocity * DaDx; ...

end

% For inhibitor concentrations, an IF statement is unnecessary.
% We want them to rely on activator concentrations.
f_h = inhDiffuCoeff * DhDx;
s_h = ...
  inhSourceDensity * actConcen * actConcen - ...
    inhDecayCoeff * inhConcen - ...
    driftVelocity * DhDx;

c = [1; 1];
f = [f_a; f_h];
s = [s_a; s_h];

% This function is meant to be passed into pdepe as a function handle
% defining the intial conditions of our system of PDEs.
% The intended meanings of the parameters and the returned values are
% explained at
% mathworks.com/help/matlab/math/partial-differential-equations.html
function colInitValForEachVar = initConditionsFn(posFromTopInroot)

sizeOfInitialTopmostRegionCarryingActivators = 200;
if posFromTopInroot < sizeOfInitialTopmostRegionCarryingActivators

  % In order to understand this IF statement well, we need to remind ourselves
  % of how we defined our coordinate system in the README.
  % Recall that x = 0 points to the bottom of the initial topmost region
  % carrying activators.
  % That is, at any moment, the top of the region always aligns with the top of
  % the root.

  colInitValForEachVar = [1; 0];

else

  % Now, this part of the IF statement describes the imaginary area *above* the
  % top of the root.
  % It doesn't make sense to have concentrations in this non-existent area.

  colInitValForEachVar = [0; 0];

end

% This function is meant to be passed into pdepe as a function handle
% defining the boundary conditions of our system of PDEs.
% The intended meanings of the parameters and the returned values are
% explained at
% mathworks.com/help/matlab/math/partial-differential-equations.html
function [pl,ql,pr,qr] = boundaryConditionsFn(~,~,~,~,~)

% Enforce da/dx = dh/dx = 0 at the bottom of the root.
pl = [0; 0];
ql = [1; 1];

% Enforce da/dx = dh/dx = 0 at the top of the root.
pr = [0; 0];
qr = [1; 1];
