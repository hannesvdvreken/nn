% author: Hannes Van De Vreken
% license: MIT

function [J grad] = calculate_cost(X, y, lambda, weights, layers, layer_size)
	
	%------------------------------------------------------------------------------------
	% Prepare
	%------------------------------------------------------------------------------------
	% get sizes
	input_size = size(X, 2);
	output_size = size(y, 2);
	m = size(X, 1); % number of training examples

	% unwind
	[w1 w2 w3] = unwind(weights, layers, input_size, layer_size, output_size);

	% pre-allocate
	w1_grad = zeros(size(w1));
	w2_grad = zeros(size(w2));
	w3_grad = zeros(size(w3));

	%------------------------------------------------------------------------------------
	% feed forward
	%------------------------------------------------------------------------------------

	% initialize (pre-allocating)
	J = 0;
	regularization = zeros(size(w2, 1) + 2, 1);
	a_final = zeros(m, output_size);
	z = struct();
	a = struct();

	% anonymous function
	layer_name = @(i) strcat('l_', num2str(i));

	% add bias ones
	X_bias = [ones(size(X, 1), 1) X];

	z.(layer_name(1)) = X_bias * w1;
	a.(layer_name(1)) = [ones(size(z.(layer_name(1)), 1), 1) sigmoid(z.(layer_name(1)))];
	regularization(1) = sum(sum(w1(2:end, :) .^ 2));

	% pre-allocate
	w = zeros(size(w2, 2), size(w2, 3));
	internal_layers = size(w2,1);

	% loop
	for idx = 1:internal_layers
		% convert from 3d to 2d matrix
		w = reshape(w2(idx,:,:), size(w2, 2), size(w2, 3));
		z.(layer_name(idx + 1)) = a.(layer_name(idx)) * w;
		a.(layer_name(idx + 1)) = [ones(size(z.(layer_name(idx + 1)), 1), 1) sigmoid(z.(layer_name(idx + 1)))];
		regularization(1 + idx) = sum(sum(w(2:end, :) .^ 2));
	end

	% neuron status of last internal layer times weights to output layer
	z.(layer_name(internal_layers + 2)) = a.(layer_name(internal_layers + 1)) * w3;
	a_final = a.(layer_name(internal_layers + 2)) = sigmoid(z.(layer_name(internal_layers + 2)));
	regularization(end) = sum(sum(w3(2:end, :) .^ 2));
	
	% calculate cost (unregularized)
	J = - sum(sum( y .* log(a_final) + (-y + 1) .* log(1 - a_final), 1 ), 2) / m;

	% add regularization to cost
	J = J + (lambda / (2 * m)) * sum(regularization);

	%------------------------------------------------------------------------------------
	% backpropagation
	%------------------------------------------------------------------------------------

	% initialize
	delta = struct();

	% calculate gradients
	delta.(layer_name(internal_layers + 2)) = (a_final - y);
	delta.(layer_name(internal_layers + 1)) = ((delta.(layer_name(internal_layers + 2)) * w3') .* sigmoid_gradient([ones(m, 1) z.(layer_name(internal_layers + 1))]))(:,2:end);

	% loop inner layers
	for idx = internal_layers:-1:1

		w = reshape(w2(idx,:,:), size(w2, 2), size(w2, 3));
		delta.(layer_name(idx)) = (delta.(layer_name(idx + 1)) * w') .* sigmoid_gradient([ones(m, 1) z.(layer_name(idx))]);

	end

	% calculate gradients
	% last inner layer & output layer
	w3_grad = (a.(layer_name(internal_layers + 1))' * delta.(layer_name(internal_layers + 2))) / m;

	% inner layers
	for idx = internal_layers:-1:1

		w2_grad(idx,:,:) = reshape((a.(layer_name(idx))' * delta.(layer_name(idx))) / m, 1, size(w2,2), size(w2,3));

	end

	% input and first inner layer
	w1_grad = (X_bias' * delta.(layer_name(1))) / m;

	% regularize gradients
	w1_grad(2:end,:) = w1_grad(2:end,:) + ((lambda/m) * w1(2:end,:));
	w3_grad(2:end,:) = w3_grad(2:end,:) + ((lambda/m) * w3(2:end,:));

	for idx = 1:internal_layers

		w = reshape(w2_grad(idx, 2:end,:), size(w2, 2) - 1, size(w2, 3));
		w_old =  reshape(w2(idx, 2:end,:), size(w2, 2) - 1, size(w2, 3));
		w2_grad(idx, 2:end,:) = reshape(w + (lambda/m) * w_old, 1, size(w2_grad, 2) - 1, size(w2_grad, 3));
	
	end

	grad = windup(w1_grad, w2_grad, w3_grad);

end