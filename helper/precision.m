% author: Hannes Van De Vreken
% license: MIT

function p = precision(prediction, y)

	% precision = 
	%    # true positives / (# false positives + # true positives )

	truepos  = sum(sum((prediction & y), 1), 2);
	falsepos = sum(sum((prediction & (1 - y)), 1), 2);

	p = truepos / (falsepos + truepos);
	if (isnan(p))
		p = 0;
	end
end