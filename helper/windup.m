% author: Hannes Van De Vreken
% license: MIT

function weights = windup(w1, w2, w3)

	% pre-allocate weights
	weights = zeros(prod(size(w1)) + prod(size(w2)) + prod(size(w3)), 1);

	% separators
	separator_1 = prod(size(w1));
	separator_2 = prod(size(w1)) + prod(size(w2));

	% wind up
	weights(1              : separator_1) = reshape(w1, prod(size(w1)), 1);
	weights(separator_1 + 1: separator_2) = reshape(w2, prod(size(w2)), 1);
	weights(separator_2 + 1: end        ) = reshape(w3, prod(size(w3)), 1);

end