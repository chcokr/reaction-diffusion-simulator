% Inside this function, you can define the initial distribution of activators
% across the root.
%
% Think of it like this: "In the very beginning of the simulation, at a certain
% position away from the open end, there is this much activator."
%
% The return value must be a constant number.
%
% Unit of pos_from_open_end is micrometers.
% Unit of return value must be co (the imaginary unit of concentration).

function rtn = act_init(pos_from_open_end)

  if pos_from_open_end < 50 % micrometers

    % For all spots in the root <50 micrometers away from the open end, there is
    % an initial activator concentration of 1 co.
    rtn = 1; % co

  else

    % Everywhere else, there is none.
    rtn = 0; % co

  end

end
