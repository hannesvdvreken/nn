% author: Hannes Van De Vreken
% license: MIT

function [w1 w2 w3] = unwind(weights, layers, input_size, layer_size, output_size)

	% pre allocate
	w1 = zeros(input_size + 1, layer_size);
	w2 = zeros(layers - 2, layer_size + 1, layer_size);
	w3 = zeros(layer_size + 1, output_size);

	% separators
	separator_1 = prod(size(w1));
	separator_2 = prod(size(w1)) + prod(size(w2));

	% reshape
	w1 = reshape(weights(1               : separator_1), size(w1, 1), size(w1, 2));
	w2 = reshape(weights(separator_1 + 1 : separator_2), size(w2, 1), size(w2, 2), size(w2, 3));
	w3 = reshape(weights(separator_2 + 1 : end        ), size(w3, 1), size(w3, 2));

end