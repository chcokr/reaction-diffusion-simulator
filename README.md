This project belongs to Duke University's [Benfey
Laboratory](http://sites.duke.edu/benfey/).

This project contains tools that help you simulate a [reaction-diffusion
system](https://en.wikipedia.org/wiki/Reaction–diffusion_system) over a growing
spatial domain.

## Mathematical formulation of the problem

Given a spatial domain growth function
![l(t) = l_0 + vt](http://latex.codecogs.com/svg.latex?l%28t%29%20%3D%20l_0%20&plus;%20vt),
solve the following system of PDEs for
![a(t,x)](http://latex.codecogs.com/svg.latex?a%28t%2Cx%29)
and
![h(t,x)](http://latex.codecogs.com/svg.latex?h%28t%2Cx%29)
over the time domain
![0 \leq t \leq T](http://latex.codecogs.com/svg.latex?0%20%5Cleq%20t%20%5Cleq%20T)
and over the spatial domain
![x\in \{0\leq x \leq l(t) \ | \ 0 \leq t \leq T\}](http://latex.codecogs.com/svg.latex?x%5Cin%20%5C%7B0%5Cleq%20x%20%5Cleq%20l%28t%29%20%5C%20%7C%20%5C%200%20%5Cleq%20t%20%5Cleq%20T%5C%7D).

### PDEs

- ![a_t = A(a, h) + D_a a_{xx}](http://latex.codecogs.com/svg.latex?a_t%20%3D%20A%28a%2C%20h%29%20&plus;%20D_a%20a_%7Bxx%7D)
- ![h_t = H(a, h) + D_h h_{xx}](http://latex.codecogs.com/svg.latex?h_t%20%3D%20H%28a%2C%20h%29%20&plus;%20D_h%20h_%7Bxx%7D)

for some functions
![A](http://latex.codecogs.com/svg.latex?A)
and
![H](http://latex.codecogs.com/svg.latex?H),
and some constants
![D_a](http://latex.codecogs.com/svg.latex?D_a)
and
![D_h](http://latex.codecogs.com/svg.latex?D_h).

### Initial conditions

At any position ![x](http://latex.codecogs.com/svg.latex?x) such that ![0 \leq x \leq l(0)](http://latex.codecogs.com/svg.latex?0%20%5Cleq%20x%20%5Cleq%20l%280%29),

- ![a(0, x) = a_0(x)](http://latex.codecogs.com/svg.latex?a%280%2C%20x%29%20%3D%20a_0%28x%29)
for some function ![a_0(x)](http://latex.codecogs.com/svg.latex?a_0%28x%29)
- ![h(0, x) = h_0(x)](http://latex.codecogs.com/svg.latex?h%280%2C%20x%29%20%3D%20h_0%28x%29)
for some function ![h_0(x)](http://latex.codecogs.com/svg.latex?h_0%28x%29)

### Boundary conditions

At any time ![t](http://latex.codecogs.com/svg.latex?t),

- ![a_x = h_x = 0](http://latex.codecogs.com/svg.latex?a_x%20%3D%20h_x%20%3D%200)
at ![x = 0](http://latex.codecogs.com/svg.latex?x%20%3D%200)
- ![a_x = h_x = 0](http://latex.codecogs.com/svg.latex?a_x%20%3D%20h_x%20%3D%200)
at ![x = l(t)](http://latex.codecogs.com/svg.latex?x%20%3D%20l%28t%29)

## Mathematical rigor

This project implements a mathematically rigorous solver for the aforementioned
system of PDEs.
Since the spatial domain of this PDE system keeps growing, a theoretically
sound treatment of these PDEs requires a mathematical trick underneath.
For more information, please see [the dedicated documentation](./math.md).

## How to use this software

### [Step 0] Setup

**Important note:** We've tested this project only on MATLAB R2015b on OS X
Yosemite.
Everything from here on assumes you're following on the same setup.

Alright, of course the very first thing you have to do is downloading this
project.
If you know what `git clone` is, do it.
If you don't, look for a `Download ZIP` button somewhere on this page (use
`cmd+F`) - click on it and unzip the downloaded file.

Now open up MATLAB.
Click on this icon:
<img width="534" alt="screen shot 2015-12-03 at 6 07 45 am" src="https://cloud.githubusercontent.com/assets/3670967/11559096/75543d3a-9984-11e5-9f92-b22e59c9adff.png">
Navigate to the cloned/unzipped folder you downloaded.
There should be a directory called `src`.
Go inside `src`.
There, click `Open` in the bottom right corner of the window.
