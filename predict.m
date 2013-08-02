% author: Hannes Van De Vreken
% license: MIT

function p = predict(X, weights, layers, layer_size, output_size)

	%------------------------------------------------------------------------------------
	% Prepare
	%------------------------------------------------------------------------------------
	input_size = size(X, 2);

	% unwind
	[w1 w2 w3] = unwind(weights, layers, input_size, layer_size, output_size);

	%------------------------------------------------------------------------------------
	% feed forward
	%------------------------------------------------------------------------------------

	% add bias ones
	X_bias = [ones(size(X, 1), 1) X];

	% feed forward
	z = X_bias * w1;
	a = [ones(size(z, 1), 1) sigmoid(z)];

	% pre-allocate
	w = zeros(size(w2, 2), size(w2, 3));
	internal_layers = size(w2,1);

	% loop
	for idx = 1:internal_layers
		% convert from 3d to 2d matrix
		w = reshape(w2(idx,:,:), size(w2, 2), size(w2, 3));
		z = a * w;
		a = [ones(size(z, 1), 1) sigmoid(z)];
	end

	% neuron status of last internal layer times weights to output layer
	z = a * w3;
	p = sigmoid(z);

end