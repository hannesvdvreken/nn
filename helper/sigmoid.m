% author: Hannes Van De Vreken
% license: MIT

function a = sigmoid(z)
	a = 1.0 ./ (1.0 + exp(-z));
end