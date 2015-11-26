% Inside this function, you can define the initial distribution of activators
% across the root.
% Think of it like this: "In the very beginning of the simulation, at a certain
% position away from the open end, there is this much activator."

function rtn = act_init(pos_from_open_end)

  if pos_from_open_end < 50

    % For all spots in the root <200 units away from the open end, there is an
    % activator concentration of 1 unit.
    rtn = 1;

  else

    % Everywhere else, there is none.
    rtn = 0;

  end

end
