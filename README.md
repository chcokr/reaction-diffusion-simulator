This project belongs to Duke University's [Benfey
Laboratory](http://sites.duke.edu/benfey/).

This project contains tools that help you simulate a [two-component
reaction-diffusion
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

### [step 0] Setup

**Important note:** We've tested this project only on MATLAB R2015b on OS X
El Capitan.
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
Open up `src`.

You're ready to start generating some figures!

### [step 1] `preview`

In the MATLAB Command Window, type `preview`.
Wait 5-10 seconds.
You'll get two nice 3D figures.
These are rough sketches of the solutions of
![a(t,x)](http://latex.codecogs.com/svg.latex?a%28t%2Cx%29)
and
![h(t,x)](http://latex.codecogs.com/svg.latex?h%28t%2Cx%29)
given the configuration in the `src/settings` directory (we'll go over how to
customize these settings later).

What do we mean by "rough sketches"?
The `preview` command's goal is to ***quickly*** return a low-resolution
solution using big mesh steps (as you can see in the resulting 3D figures).
So don't be surprised if you notice some nonsense - for example, negative
concentration values.
Such erroneous outcomes are because of the big mesh steps.
Keep in mind that we're sacrificing precision for speed.
So with the `preview` command, you can quickly prototype how your new PDEs might
turn out.

If the results of `preview` seem interesting and you want to more thoroughly
simulate your current configuration, you should move on to the next command:
`refine`.

### [step 2] `refine`

In the MATLAB Command Window, type `refine`.
Wait ~1 min.
Yes, `refine` takes longer than `preview` - this time, we're sacrificing speed
for precision.
So always try to strike a mental balance between how often you use `preview` and
how often you use `refine`.

**Caching:** Another thing about `refine`, in comparison to `preview`, is that
the results of `refine` given the current configuration in `src/settings` are
***cached***.
Since the `refine` command is slow, it would get really annoying if you have to
wait a couple of minutes every time, right?

Whenever it is detected that the content of any file in the `settings` directory
has changed, `refine` will start a fresh computation and not read from the
cache.
Otherwise, it will try to read from the cache.
This means that, when you run `refine` twice in a row without changing a thing
in `settings`, the second run will be much faster.

In contrast, `preview` doesn't cache.
It runs so fast that there is no point caching the results.

Enough about caching...
So say you look at the resulting 3D figures and you like them.
You're pretty confident that your current configuration in `settings` is good.
But what if you want an animated visualization of how
![a](http://latex.codecogs.com/svg.latex?a)
and
![h](http://latex.codecogs.com/svg.latex?h)
diffuse across the spatial domain over time?
That's where the next command comes in: `animate`.

### [step 3] `animate`

In the MATLAB Command Window, type `animate`.
This command will read in the current solutions from the cache, and will start
generating a movie.
You can watch the frames being generated on the go.
Also, in the Command Window, there will be a message telling you how many more
frames need to be generated.

As you can sense, `animate` is a ***really slow*** command.
So only run it when you're absolutely confident about the results of `refine` -
don't waste your time :)

When the whole generation is done, a movie file will be saved to the parent
directory of `src`.
Go there and find it!
The file should be marked with a timestamp.

### [step 4] Oh no, I want to go back to a previous setting!

What if, after all the fun of steps 1-3, you want to go back to a setting you
were working with an hour ago and no longer have in `src/settings`?
In this case, the directory `history` in the project root is your friend.
Every time you run `preview` or `refine`, the resulting 3D plots get stored in
`history`.
Try it yourself - run `preview` and `refine` a few times, and then go to
`history`.
There you'll see file names with timestamps and a flag indicating whether the
figure is describing activators or inhibitors.
Open the figure up in MATLAB and check out the figure title to recall the
settings you used to use.

## Settings

The whole point of this project is to allow you as much freedom as possible
within the aforementioned mathematical formulation.
So let's learn about how to customize the files in `src/settings` so you can
explore around.

`src/settings` is best understood if you map each file to something in the
mathematical formulation.
Here is the mapping:

File name | Corresponding math
---- | ----
act_eq_diffu.m | ![D_a](http://latex.codecogs.com/svg.latex?D_a)
act_eq_rest.m | ![A(a,h)](http://latex.codecogs.com/svg.latex?A%28a%2Ch%29)
act_init.m | ![a_0(x)](http://latex.codecogs.com/svg.latex?a_0%28x%29)
growth_velocity.m | ![v_0](http://latex.codecogs.com/svg.latex?v_0)
inh_eq_diffu.m | ![D_h](http://latex.codecogs.com/svg.latex?D_h)
inh_eq_rest.m | ![H(a,h)](http://latex.codecogs.com/svg.latex?H%28a%2Ch%29)
inh_init.m | ![h_0(x)](http://latex.codecogs.com/svg.latex?h_0%28x%29)
init_length.m | ![l_0](http://latex.codecogs.com/svg.latex?l_0)
time_max.m | ![T](http://latex.codecogs.com/svg.latex?T)

So whatever you want to customize in the mathematical formulation, look up the
corresponding file, go there and read the well-documented comments in the file.

### A note on units

As you go through the comments in each file in `src/settings` (and also as you
go through the 3D figures, etc.), you'll notice that very specific physical
units (e.g. micrometers, seconds) are being used.

Why did we choose to use such concrete units, when the mathematical formulation
doesn't specify any units?
According to our experience, it minimizes confusion down the line that could be
caused by unit-unaware parameter choices.
By requiring the use of certain units upfront, the room for error across
parameter choices and visualization is kept small.

The following are the official units of choice across this project.

- The unit of length is micrometers.
- The unit of time is seconds (although the visualizations prefer hours).
- The unit of concentration is an imaginary unit called `co`.
We considered using something like molarity, but we weren't too sure about a
good choice across different situations.
So, `1 co` is whatever concentration you want it to mean!
