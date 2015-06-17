function main

spatialDomainSize = 1000; % micrometers
spatialDomainStep = 10; % micrometers
timeDomainSize = 1000; % seconds
timeDomainStep = 10; % seconds

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

inhConcenSolutions = pdeSolutions(:,:,2);

figure;
surf(xMesh, tMesh, inhConcenSolutions);
title('h(x,t)');
xlabel('Distance x');
ylabel('Time t');

% This function is meant to be passed into pdepe as a function handle
% defining our system of PDEs.
% The intended meanings of the parameters and the returned values are
% explained at
% mathworks.com/help/matlab/math/partial-differential-equations.html
function [c,f,s] = pdeSystemFn(~, ~, colOfVar, colOfDuDx)

actDecayCoeff = 0.00019; % the mu in the differential equations
actDiffuCoeff = 1; % the D_a
inhDecayCoeff = 0.00025; % the nu
inhDiffuCoeff = 250; % the D_h
sourceDensity = 0.00018; % the rho

actConcen = colOfVar(1);
inhConcen = colOfVar(2);

c = [1; 1];
f = [actDiffuCoeff; inhDiffuCoeff] .* colOfDuDx;
s = [
  sourceDensity * actConcen * actConcen / inhConcen - ...
    actDecayCoeff * actConcen; ...
  sourceDensity * actConcen * actConcen - ...
    inhDecayCoeff * inhConcen
];

% This function is meant to be passed into pdepe as a function handle
% defining the intial conditions of our system of PDEs.
% The intended meanings of the parameters and the returned values are
% explained at
% mathworks.com/help/matlab/math/partial-differential-equations.html
function colInitValForEachVar = initConditionsFn(posFromTopInroot)

if posFromTopInroot < 200
  % The top 200 positions of the root start with activator and inhibitor
  % concetrations of 1.
  colInitValForEachVar = [1; 1];
else
  % All other positions of the root start with very small activator and
  % inhibitor concetrations.
  % We can't simply set the inhibitor concentrations to 0 because the activator
  % PDE involves a division by the inhibitor concentration.
  % So instead we set it to a tiny value.
  colInitValForEachVar = [0.001; 0.001];
end

% This function is meant to be passed into pdepe as a function handle
% defining the boundary conditions of our system of PDEs.
% The intended meanings of the parameters and the returned values are
% explained at
% mathworks.com/help/matlab/math/partial-differential-equations.html
function [pl,ql,pr,qr] = boundaryConditionsFn(~,~,~,~,~)

% Enforce da/dx = dh/dx = 0 at the top of the root.
pl = [0; 0];
ql = [1; 1];

% Enforce da/dx = dh/dx = 0 at the bottom of the root.
pr = [0; 0];
qr = [1; 1];
