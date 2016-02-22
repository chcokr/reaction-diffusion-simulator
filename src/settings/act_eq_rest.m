% Inside this function, you can specify the rest of the activator equation.
% Whatever you define here will result in forming the following differential
% equation:
% da/dt = act_eq_rest(a, h) + param_D_a() * d^2 a / dx^2
%
% The return value must be a constant number.
%
% Unit of the arguments a and h is co (the imaginary unit of concentration).
% Unit of return value must be co per second.

function rtn = act_eq_rest(a, h)

  rtn = param_rho_a() * a ^ 2 / h - param_mu() * a + param_c();

end
