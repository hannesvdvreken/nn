% author: Hannes Van De Vreken
% license: MIT

function input = load_file(fn)

	% check file
	if (exist(fn, 'file') != 2)
		printf("%s is not a valid file.\nPlease provide a file, or change the config.csv file.\n", fn);
		exit;
	end

	% get file
	input = csvread(fn);

end