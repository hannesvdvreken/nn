function weights = init_weights(input_size, layers, layer_size, output_size)

	% anonymous function
	% fill weights matrix with random small values
	randomize = @(w) ((rand(size(w)) * 2) - 1) * (sqrt(6) / sqrt(sum(size(w)((size(size(w))-1)(end):end))));

	% initialize weights between input layer and first layer
	w1 = zeros(input_size + 1, layer_size);
	w1 = randomize(w1);

	% initialize weights between all internal layers
	w2 = zeros(layers - 2, layer_size + 1, layer_size); % 3 dimensional
	w2 = randomize(w2);

	size(w2)

	% initialize weights between last two layers
	w3 = zeros(layer_size + 1, output_size);
	w3 = randomize(w3);

	% make weights sequence
	weights = zeros(prod(size(w1)) + prod(size(w2)) + prod(size(w3)), 1);

	% fill
	weights(1: prod(size(w1)))                                   = reshape(w1, prod(size(w1)), 1);
	weights(prod(size(w1)) + 1: prod(size(w1)) + prod(size(w2))) = reshape(w2, prod(size(w2)), 1);
	weights(prod(size(w1)) + prod(size(w2)) + 1: end)            = reshape(w3, prod(size(w3)), 1);
end