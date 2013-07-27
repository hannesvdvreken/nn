% author: Hannes Van De Vreken
% license: MIT

function weights = init_weights(input_size, layers, layer_size, output_size)

	% https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2001-6.pdf
	% http://www.stanford.edu/class/ee373b/nninitialization.pdf
	
	% anonymous function
	% fill weights matrix with random small values
	randomize = @(w) ((rand(size(w)) * 2) - 1) * (sqrt(6) / sqrt(sum(size(w)((size(size(w))-1)(end):end))));

	% initialize weights between input layer and first layer
	w1 = zeros(input_size + 1, layer_size);
	w1 = randomize(w1);

	% initialize weights between all internal layers
	w2 = zeros(layers - 2, layer_size + 1, layer_size); % 3 dimensional
	w2 = randomize(w2);

	% initialize weights between last two layers
	w3 = zeros(layer_size + 1, output_size);
	w3 = randomize(w3);

	% make weights sequence
	weights = zeros(prod(size(w1)) + prod(size(w2)) + prod(size(w3)), 1);

	% separators
	separator_1 = prod(size(w1));
	separator_2 = prod(size(w1)) + prod(size(w2));

	% fill
	weights(1              : separator_1) = reshape(w1, prod(size(w1)), 1);
	weights(separator_1 + 1: separator_2) = reshape(w2, prod(size(w2)), 1);
	weights(separator_2 + 1: end        ) = reshape(w3, prod(size(w3)), 1);
	
end