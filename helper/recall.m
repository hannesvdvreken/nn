% author: Hannes Van De Vreken
% license: MIT

function r = recall(prediction, y)

	% recall = 
	%    # true positives / (# false negatives + # true positives )

	truepos  = sum(sum(prediction & y, 1), 2);
	falseneg = sum(sum((1 - prediction) & y, 1), 2);

	r = truepos / (falseneg + truepos);
	if (isnan(r))
		r = 0;
	end
end