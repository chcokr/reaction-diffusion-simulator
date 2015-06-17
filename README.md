# root-growth-matlab

## What is this?

This repository hosts a temporary MATLAB version of the JavaScript application
hosted at https://github.com/chcokr/root-growth.
There is a strange problem with the JavaScript application that needs to be
debugged.
In order to make communication with scientists easier and to thereby identify
the issue more quickly, this MATLAB port has been created.

## What am I trying to do?

This project is being developed as part of a research project at Duke
University's [Benfey Laboratory](http://sites.duke.edu/benfey/).
While the summary of this research project is meant to be maintained at
https://github.com/chcokr/root-growth, the bits that are pertinent to this
specific repository are explained below.

Please keep in mind I'm not a biologist/physicist/mathematician at all.
I just produce software at the lab's request.
I don't know the biological/physical/mathematical details behind what I explain
below.
Please consult the lab for such details.

We are trying to simulate cell growth and diffusion of certain chemicals across
a plant root.

Initially there are 5 cells of height `20µm`, aligned vertically, like a column
of bricks.
Assume no width for now; that is, the root is being assumed to be
one-dimensional.

Each of these cells grows in height at the rate of `10µm/hr`.
Furthermore, it splits into half after 18-22 hours after.
So, by the end of the 22nd hour, there are 10 cells in the root.

Each of these 10 cells then repeats the same division cycle: split into half
18-22 hours after creation.
So, by the end of the 44th hour, there are 20 cells in the root.

Once there are more than 20 cells in the root, the topmost cells stop dividing.
Say there are 24 cells currently.
The top 4 cells have stopped dividing.
They do continue to grow at `10µm/hr`, though.
This zone of top 4 cells, which have stopped dividing but do continue to grow,
is called the *elongation zone*.
Meanwhile, a cell among the bottom 20 **does** split, as long as its 18-22-hour
duration has lived out while the cell is still in the bottom 20.

Time goes by, and say we've reached a moment where there are at least 10 cells
in the elongation zone.
As soon as there are at least 10 cells in the elongation zone, the topmost cell
turns into a special cell called an *A-I cell*.
A-I stands for activator-inhibitor.
This cell contains special liquid substances called *activator substances* and
*inhibitor substances*.
Since these substances are liquids, they have a concentration.
When the A-I cell first appears, both the activator concentration and the
inhibitor concentration are initialized to a concentration of `1co`, where `co`
is an imaginary unit of concentration that I've made up.

What about all the other cells? Let's assume they all carry very small
activator and inhibitor concentrations of `0.001co`.

Now that substances have initialized across the root, what happens?
Since they're liquids, they diffuse!
We conjecture they diffuse according to the following partial differential
equations, which are borrowed from [Meinhardt
2008](http://www.ncbi.nlm.nih.gov/pubmed/18023723).

![\frac{\partial a}{\partial t} = \rho_h \frac{a^2}{h} - \mu a + D_a
\frac{\partial^2 a}{\partial x^2}](http://latex.codecogs.com/gif.latex?%5Cfrac%7B%5Cpartial%20a%7D%7B%5Cpartial%20t%7D%20%3D%20%5Crho_h%20%5Cfrac%7Ba%5E2%7D%7Bh%7D%20-%20%5Cmu%20a%20&plus;%20D_a%20%5Cfrac%7B%5Cpartial%5E2%20a%7D%7B%5Cpartial%20x%5E2%7D "The activator PDE")
![\frac{\partial h}{\partial t} = \rho_h a^2 - \nu h + D_h 
\frac{\partial^2 h}{\partial x^2}](http://latex.codecogs.com/gif.latex?%5Cfrac%7B%5Cpartial%20h%7D%7B%5Cpartial%20t%7D%20%3D%20%5Crho_h%20a%5E2%20-%20%5Cnu%20h%20&plus;%20D_h%20%5Cfrac%7B%5Cpartial%5E2%20h%7D%7B%5Cpartial%20x%5E2%7D)

Explanation of the variables/constants:
- `x` represents the position from the top end of the root.
Unit is `µm`.
- `t` represents the time elapsed since the moment the A-I cell appears.
Unit is `sec`.
- `a(x,t)` is the function of activator concentrations.
Unit is `co`.
- `h(x,t)` is the function of activator concentrations.
Unit is `co`.
- `rho_a` is what's called the *activator source density* according to
[Meinhardt 2008](http://www.ncbi.nlm.nih.gov/pubmed/18023723).
Unit is `/sec`.
- `mu` is what I call the *activator decay coefficient*.
Unit is `/sec`.
- `D_a` is what I call the *activator diffusion coefficient*.
Unit is `µm^2/sec`.
- `rho_h` is the *inhibitor source density*.
Unit is `/co/sec`.
- `nu` is what I call the *inhibitor decay coefficient*.
Unit is `/sec`.
- `D_h` is what I call the *inhibitor diffusion coefficient*.
Unit is `µm^2/sec`.

Also, since this is a system of PDEs, we need boundary conditions.
Let's assume for now `da/dx = dh/dx = 0` at both the top end and the bottom end
of the root.

As for initial conditions, we already discussed what they should be: the top
few positions of the root are initialized to concentrations of `1co`; all others
are initialized to concentrations of `0.001co`.

To make better sense of this system of PDEs, let's simulate them.
If you look to the right side of the main page of this repository (which you're
likely on right now), there is a `Download ZIP` button.
Unzip, go to the directory `pdesolver`, and run `main.m`.
This file runs simulation of our system of PDEs using MATLAB's built-in PDE
solver.
This simulation doesn't assume a continuously growing root, since the built-in
PDE solver can't handle complicated situations like that.
Instead, it just assumes that the root is fixed at size `1000µm`.
It also assumes the following values for the aforementioned constants:
- `rho_a = 0.00018/sec`
- `mu = 0.00019/sec`
- `D_a = 1µm^2/sec`
- `rho_h = 0.00018/co/sec`
- `nu = 0.00025/sec`
- `D_h = 250µm^2/sec`

These values were obtained by consulting two sources:
- [Meinhardt
1972](http://jxshix.people.wm.edu/2009-harbin-course/classic/gierer-meinhardt-1972.pdf)
- [Meinhardt's BASIC source code simulating similar
PDEs](http://www.eb.tuebingen.mpg.de/research/emeriti/hans-meinhardt/biuprog.html)

In the 3D graph resulting from running the simulation, do you see how, as `t`
goes by, `h(x,t)` flattens out across `x`?
That is, the inhibitor substance diffuses from the topmost cell to the rest of
the root.
So our system of PDEs, with the right constants, decently describes a diffusion
process.

*TODO:* explain where this research is headed from here on - I don't have time
to explain more right now.
It's more important to jump straight into what the software bug is.

## So what's the matter?

As I explained earlier, MATLAB's built-in PDE solver can't handle complex
situations like a continuously growing root.
In addition, we plan to add a lot more complexity than just cell growth to our
simulation.
So it is inevitable that we write a customized simulation software.
This repository's directory `discretization` (or the [JavaScript
application](https://github.com/chcokr/root-growth)) is an attempt at such
customized simulation.
It tries to simulate both the cell growth process and the diffusion of
the activator/inhibitor substances.

The general idea of the animation produced by the simulation is as follows:
1. At a fixed moment, draw the current heights of each cell and the
inhibitor concentration at each position across the root.
2. Compute the `da/dt` and `dh/dt` at that moment.
Also, predict whether each cell will split or will just continue to grow in
height.
3. Imagine a small `dt` has now elapsed since that moment.
Then the new concentrations are obtained by computing `a_1 = a_0 + da/dt * dt`.
Update the concentrations and the cell configuration to these new values.
4. Repeat Step 1.

[Meinhardt's BASIC
program](http://www.eb.tuebingen.mpg.de/research/emeriti/hans-meinhardt/biuprog.html)
is evidence that this finite-difference numerical method is a valid approach to
simulating these PDEs.
Also see his [PowerPoint
presentation](http://www.eb.tuebingen.mpg.de/fileadmin/uploads/images/Research/emeriti/Hans_Meinhardt/ppt/How_to_write_a_program.ppt)
where he describes his program and explains an essentially identical
finite-difference method.

But for some reason, running the `main.m` in the `discretization` directory
quickly crashes because the concentrations computed using my approach grow too
large, beyond a concentration of 1, at certain positions.
We know this is nonsense because MATLAB's built-in PDE solver demonstrated such
is not the case.

Suspecting the large value of `D_h = 250µm^2/sec`, I changed it down to
`5µm^2/sec` and at least it doesn't crash any more.
But the concentrations being computed don't seem quite right.
Plus, the simulation should work with `D_h = 250µm^2/sec`, just like how
MATLAB's built-in PDE solver managed to solve the equations with that `D_h`.

I looked up some pertinent literature, and apparently a system of PDEs like this
one needs to ensure that the time step should be sufficiently small.
Specifically, `D_a Δt / Δx^2 < 1/2` or something like that.
But even after adjusting the time step to be sufficiently small, I still run
into the same trouble.
**TODO**: I need to find a source for this mathematical condition.
I had it but lost it.
Will come back to this later.

I am aware there are superior numerical methods for this problem, such as the
[Crank-Nicolson method](https://en.wikipedia.org/wiki/Crank–Nicolson_method).
But as far as I know, the simple Euler-style finite-difference method of mine
should at least *work*.

I've spent days trying to figure out the core of the issue - to no avail.
I may as well be doing something fundamentally incorrect.
So if you could help me out, your advice would be very much appreciated.
