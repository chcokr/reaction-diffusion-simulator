% Inside this function, you can define the initial distribution of inhibitors
% across the root.
%
% Think of it like this: "In the very beginning of the simulation, at a certain
% position away from the open end, there is this much inhibitor."
%
% The return value must be a constant number.
%
% Unit of pos_from_open_end is micrometers.
% Unit of return value must be co (the imaginary unit of concentration).

function rtn = inh_init(pos_from_open_end)

  % No inhibitor at all in the beginning.
  rtn = 0; % co

end
