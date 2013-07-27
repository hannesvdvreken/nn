% author: Hannes Van De Vreken
% license: MIT

function g = sigmoid_gradient(z)
	g = sigmoid(z) .* (1 - sigmoid(z));
end