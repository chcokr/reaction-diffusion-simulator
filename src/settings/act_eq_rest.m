% Inside this function, you can specify the rest of the activator equation.
% Whatever you define here will result in forming the following differential
% equation:
% da/dt = act_eq_rest(a, h) + act_eq_diffu() * d^2 a / dx^2
%
% The return value must be a constant number.
%
% Unit of the arguments a and h is co (the imaginary unit of concentration).
% Unit of return value must be co per second.

function rtn = act_eq_rest(a, h)

  rtn = 0.02 * a ^ 2 / (h + 1) - 0.0002 * a + 0.003;

end
