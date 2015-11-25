function sol = getPdeSolutions( ...
  actDecayCoeff, ... % the mu
  actDenominatorDefault, ... % the h_0
  actDiffuCoeff, ... % the D_a
  actSourceDensity, ... % the rho_a
  tipVelocity, ... % the s
  inhDecayCoeff, ... % the nu
  inhDiffuCoeff, ... % the D_h
  inhSourceDensity, ... % the rho_h
  spatialDomainSize, ...
  spatialDomainStep, ...
  timeDomainSize, ...
  timeDomainStep, ...
  initLength)

xMesh = 0:spatialDomainStep:spatialDomainSize;
tMeshSeconds = 0:timeDomainStep:timeDomainSize;

pdeSystemFn = getPdeSystemFn( ...
  actDecayCoeff, ...
  actDenominatorDefault, ...
  actDiffuCoeff, ...
  actSourceDensity, ...
  tipVelocity, ...
  inhDecayCoeff, ...
  inhDiffuCoeff, ...
  inhSourceDensity, ...
  initLength);

% According to http://www.mathworks.com/help/matlab/ref/pdepe.html,
% pdepe can handle three categories of PDEs: slab, cylindrical, spherical.
% I (YJ Yang) don't know what each of these means, but I went with slab.
pdeTypeIsSlab = 0;
sol = pdepe( ...
  pdeTypeIsSlab, ...
  pdeSystemFn, ...
  @initConditionsFn, ...
  @boundaryConditionsFn, ...
  xMesh, ...
  tMeshSeconds);
end

% This function is meant to be passed into pdepe as a function handle
% defining our system of PDEs.
% The intended meanings of the parameters and the returned values are
% explained at
% mathworks.com/help/matlab/math/partial-differential-equations.html
function fn = getPdeSystemFn( ...
  actDecayCoeff, ...
  actDenominatorDefault, ...
  actDiffuCoeff, ...
  actSourceDensity, ...
  tipVelocity, ...
  inhDecayCoeff, ...
  inhDiffuCoeff, ...
  inhSourceDensity, ...
  initLength)

  function [c, f, s] = pdeSystemFn(...
    x, ...
    t, ...
    colOfVar, ...
    colOfDaDxAndDhDx)

  actConcen = colOfVar(1);
  inhConcen = colOfVar(2);

  DaDx = colOfDaDxAndDhDx(1);
  DhDx = colOfDaDxAndDhDx(2);

  f_a = (actDiffuCoeff * DaDx) / ((initLength + tipVelocity * t) ^ 2) ;
  s_a = ...
    actSourceDensity * actConcen * actConcen / ...
      (inhConcen + actDenominatorDefault) - ...
    actDecayCoeff * actConcen - ...
    (tipVelocity * x * DaDx) / (initLength + tipVelocity * t);

  % For inhibitor concentrations, an IF statement is unnecessary.
  % We want them to rely on activator concentrations.
  f_h = (inhDiffuCoeff * DhDx) / ((initLength + tipVelocity * t) ^ 2);
  s_h = ...
    inhSourceDensity * actConcen * actConcen - ...
      inhDecayCoeff * inhConcen - ...
      (tipVelocity * x * DhDx) / (initLength + tipVelocity * t);

  c = [1; 1];
  f = [f_a; f_h];
  s = [s_a; s_h];

  end

fn = @pdeSystemFn;
end

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

end
