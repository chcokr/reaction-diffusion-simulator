% Inside this function, you can specify the rest of the inhibitor equation.
% Whatever you define here will result in forming the following differential
% equation:
% dh/dt = inh_eq_rest(a, h) + param_D_h() * d^2 h / dx^2
%
% The return value must be a constant number.
%
% Unit of the arguments a and h is co (the imaginary unit of concentration).
% Unit of return value must be co per second.

function rtn = inh_eq_rest(a, h)

  rtn = param_rho_h() * a ^ 2 - param_nu() * h;

end
