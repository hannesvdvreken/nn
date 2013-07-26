% Learn from csv input
% author: Hannes Van De Vreken
% license: MIT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fn = strcat(config.input_path, filename, '.csv');
X = load_file(fn);

input_size = size(X,2);

fn = strcat(config.input_path, filename, '-out.csv');
y = load_file(fn);

output_size = size(y,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEBUG INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printf('the input layer has %u neurons\n', input_size);
printf('the %u internal layers have %u neurons\n', config.layers - 1, config.layer_size);
printf('the output layer has %u neurons\n\n', output_size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREPARE GRADIENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

weights = init_weights(input_size, config.layers, config.layer_size, output_size);

size(weights)