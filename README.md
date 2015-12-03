This project belongs to Duke University's [Benfey
Laboratory](http://sites.duke.edu/benfey/).

This project contains tools that help you simulate a [reaction-diffusion
system](https://en.wikipedia.org/wiki/Reaction–diffusion_system) over a growing
spatial domain.

**Note:** We've tested this project only on MATLAB R2015b on OS X Yosemite.

## Mathematical formulation of the problem

Given a spatial domain growth function
![l(t) = l_0 + vt](http://latex.codecogs.com/svg.latex?l%28t%29%20%3D%20l_0%20&plus;%20vt),
solve the following system of PDEs over the time domain
![0 \leq t \leq T](http://latex.codecogs.com/svg.latex?0%20%5Cleq%20t%20%5Cleq%20T).

### PDEs

- ![a_t = A(a, h) + D_a a_{xx}](http://latex.codecogs.com/svg.latex?a_t%20%3D%20A%28a%2C%20h%29%20&plus;%20D_a%20a_%7Bxx%7D)
- ![h_t = H(a, h) + D_h h_{xx}](http://latex.codecogs.com/svg.latex?h_t%20%3D%20H%28a%2C%20h%29%20&plus;%20D_h%20h_%7Bxx%7D)

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

