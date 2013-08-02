% author: Hannes Van De Vreken
% license: MIT

function [w lambda] = choose_lambda(config, X_train, y_train, X_cv, y_cv, weights)
	
	% look for appropriate lambda
	lambdas = zeros(12, 1);
	J_cv = zeros(size(lambdas));
	J_train = zeros(size(lambdas));
	w_train = zeros(size(lambdas, 1), size(weights, 1));

	lambdas(2) = 0.01;
	for x = 3:size(lambdas,1)
		lambdas(x) = lambdas(x-1) * 2;
	end

	options = optimset('MaxIter', config.max_iterations);
	cf = @(p, lambda, X, y) calculate_cost(X, y, lambda, p, config.layers, config.layer_size);

	printf('Looking for the best λ');

	for idx = 1:size(lambdas,1)

		cost_function = @(p) cf(p, lambdas(idx), X_train, y_train);

		[w j] = fmincg(cost_function, weights, options);

		J_cv(idx) = cf(w, 0, X_cv, y_cv);
		J_train(idx) = j(end);
		w_train(idx, :) = w;

		printf('.');
	end

	% find best Lambda for cross validation
	[lowest idx] = min(J_cv);
	lambda = lambdas(idx);
	printf('\nBest lambda for this model: %3.2f\n', lambda);

	if (config.learning_curve)
		% multiple plots
		hold on;

		% max value
		max_j = max([J_cv ; J_train]);

		% xvals
		xvals = 0:size(lambdas, 1) - 1;
		plot(xvals, J_cv, xvals, J_train, [idx idx],[0 (2 * max_j)]);

		% labels
		xlabel(sprintf('log(%2.2f,2)', lambdas(2)));
		ylabel('J');
		
		printf('\n\nPress enter to continue...\n');
		pause;
	end

	w = w_train(idx, :);
end