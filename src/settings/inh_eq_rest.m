% Inside this function, you can specify the rest of the inhibitor equation.
% Whatever you define here will result in forming the following differential
% equation:
% dh/dt = inh_eq_rest(a, h) + inh_eq_diffu() * d^2 h / dx^2
%
% The return value must be a constant number.
%
% Unit of the arguments a and h is co (the imaginary unit of concentration).
% Unit of return value must be co per second.

function rtn = inh_eq_rest(a, h)

  rtn = 0.0006 * a ^ 2 - 0.0015 * h;

end
