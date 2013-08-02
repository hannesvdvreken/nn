% author: Hannes Van De Vreken
% license: MIT
% description:
%     divides the samples in a training set, a test set and optionally 
%     into a cross validation set. If cv = 0, the cross validation set
%     will remain empty. The training set and test set will be bigger.

function [X_train y_train X_test y_test X_cv y_cv] = divide(X, y, cv = 0)

	% some numbers
	m = size(X, 1); % number of training examples

	if (cv)
		training_size = ceil(m * (3/5));
		cv_size = ceil((m - training_size) / 2);
	else
		training_size = ceil(m * 0.7);
		cv_size = 0;
	end
	% finally
	test_size = m - training_size - cv_size;

	% permutate rows randomly
	p = randperm(m);

	% training
	X_train = X(p(1:training_size), :);
	y_train = y(p(1:training_size), :);

	% cross validation
	X_cv = X(p(training_size + 1:training_size + cv_size), :);
	y_cv = y(p(training_size + 1:training_size + cv_size), :);

	% test
	X_test = X(p(training_size + cv_size + 1:end), :); 
	y_test = y(p(training_size + cv_size + 1:end), :);