% author: Hannes Van De Vreken
% license: MIT

% add paths for other functions
addpath("helper");

%------------------------------------------------------------------------------------
% SETUP
%------------------------------------------------------------------------------------
% clear console
clear; close all; clc;

% load config
config = config();
if (config.layers < 2)
	printf('The `layers` option must be `2` or higher. Current value: %u\n', config.layers);
	exit;
end

% command line arguments
arguments = argv();

% check
if (prod(size(arguments)) < 1)
	puts "please provide a filename (without .csv).\n\n\t$ octave main.m FILENAME\n";
	exit;
end

% retrieve filename
filename = arguments{[1,1]};

%------------------------------------------------------------------------------------
% READ INPUT
%------------------------------------------------------------------------------------

fn = strcat(config.input_path, filename, '.csv');
X = load_file(fn);
input_size = size(X,2);

fn = strcat(config.input_path, filename, '-out.csv');
y = load_file(fn);
output_size = size(y,2);

%------------------------------------------------------------------------------------
% DEBUG INFO
%------------------------------------------------------------------------------------

printf('the number of training examples is %u\n', size(X, 1));
printf('the input layer has %u neurons\n', input_size);
printf('the %u internal layers have %u neurons\n', config.layers - 1, config.layer_size);
printf('the output layer has %u neurons\n', output_size);

%------------------------------------------------------------------------------------
% PREPARE GRADIENTS
%------------------------------------------------------------------------------------

if (config.new_weights)

	printf('generating new random weights\n');
	weights = init_weights(input_size, config.layers, config.layer_size, output_size);

else
	printf('reading weights from weights.csv file\n');
	
	weights = init_weights(input_size, config.layers, config.layer_size, output_size);
	file_weights = load_file(strcat(config.input_path, filename, '-weights.csv'));

	% check
	if (size(file_weights, 1) != size(weights, 1))
		printf('the %s-weights.csv has to contain %u weights.\n', filename, size(weights, 1));
		exit;
	end
	
	weights = file_weights;
end

%------------------------------------------------------------------------------------
% START LEARNING
%------------------------------------------------------------------------------------

printf('\nThe neural network will now learn. Iterating %u times over the training set.\n--------------------------------------\n', config.max_iterations);
options = optimset('MaxIter', config.max_iterations);

% suppress "possible Matlab-style short-circuit operator" warnings
warning ("off");
cost_function = @(p) calculate_cost(X, y, config.lambda, p, config.layers, config.layer_size);

[weights, J] = fmincg(cost_function, weights, options);

p = predict(X, weights, config.layers, input_size, config.layer_size, output_size);

printf('learning accuracy: %2.2f%%\n',mean(mean(double(p == y) * 100)));