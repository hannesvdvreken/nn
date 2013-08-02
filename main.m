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
input_size = size(X, 2);

fn = strcat(config.input_path, filename, '-out.csv');
y = load_file(fn);
output_size = size(y, 2);

%------------------------------------------------------------------------------------
% DEBUG INFO
%------------------------------------------------------------------------------------

printf('number of samples: %u\n', size(X,1));
printf('number of input layer neurons: %u\n', input_size);
printf('%u internal layers have %u neurons\n', config.layers - 1, config.layer_size);
printf('output layer has %u neurons\n\n', output_size);

%------------------------------------------------------------------------------------
% PREPARE GRADIENTS
%------------------------------------------------------------------------------------

if (config.new_weights)

	printf('generating new random weights...\n');
	weights = init_weights(input_size, config.layers, config.layer_size, output_size);

else
	printf('reading weights from weights.csv file...\n');
	
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
% suppress "possible Matlab-style short-circuit operator" warnings
warning ("off");

if ( ! isfield(config, 'lambda'))
	
	[X_train y_train, X_test, y_test, X_cv, y_cv] = divide(X, y, 1);

	[w config.lambda] = choose_lambda(config, X_train, y_train, X_cv, y_cv, weights);
	
else
	
	% divide input set
	training_size = floor(size(X,1) * 0.7);
	[X_train y_train, X_test, y_test] = divide(X, y);

	% prepare
	options = optimset('MaxIter', config.max_iterations);
	cost_function = @(p) calculate_cost(X_train, y_train, config.lambda, p, config.layers, config.layer_size);

	% learn and plot learning curve
	printf('Learning...');
	[w J] = fmincg(cost_function, weights, options);
	printf('\n');

	if (config.learning_curve)
		plot(1:size(J,1), J);
		pause;
	end

end

%------------------------------------------------------------------------------------
% EVALUATE LEARNING
%------------------------------------------------------------------------------------

% predict output for X_test
activation_levels = predict(X_test, w, config.layers, config.layer_size, output_size);

% threshold 0.5
config.threshold = 0.5;
p = (activation_levels > config.threshold);

% calculate precision & recall
prec = precision(p, y_test);
rec  = recall(p, y_test);
f = (2 * prec * rec) / (prec + rec);

printf('\nPrecision: %2.2f%%, recall: %2.2f%%.\n', prec * 100, rec * 100);
printf('f-score: %2.2f at threshold: %2.2f\n', f, config.threshold);

%------------------------------------------------------------------------------------
% EXPORT
%------------------------------------------------------------------------------------

if (config.new_weights)
	fn = strcat(config.input_path, filename, '-new-weights.csv');
	dlmwrite(fn, w, '\n');
end