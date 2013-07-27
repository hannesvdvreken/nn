% author: Hannes Van De Vreken
% license: MIT

function cfg = config()
	
	% check file
	if (exist('config/config.csv', 'file') != 2)
		puts "Please provide a 'config.csv' file in the config folder. Try copying the sample config file.";
		exit;
	end

	% read file
	config = textread('config/config.csv', '%s', 'delimiter', ',');
	s = size(config, 1);

	% make struct out of input values
	cfg = struct();

	for idx = 1:s
		if (mod(idx, 2) == 1)
			name = config{idx};
		else
			% try integer conversion
			[intval state] = str2num(config{idx});
			if (state == 1)
				% assign
				cfg.(name) = intval;
			else
				% assign
				cfg.(name) = config{idx};
			end
		end
	end

	% return value: cfg
end