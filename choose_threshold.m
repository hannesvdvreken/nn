% author: Hannes Van De Vreken
% license: MIT

function [f t] = choose_threshold(config, w, X, y)
	
	% apply weights
	activation_levels = predict(X, w, config.layers, config.layer_size, size(y, 2));

	% prepare
	highest = 0.00;
	highest_f = 0.00;
	highest_p = 0.00;
	highest_r = 0.00;

	% thresholds
	for t = highest:0.01:1.00

		% output based on threshold
		p = (activation_levels > t);

		% calculate precision & recall
		prec = precision(p, y);
		rec  = recall(p, y);

		f = (2 * prec * rec) / (prec + rec);

		if (f > highest_f)
			highest_r = rec;
			highest_p = prec;
			highest_f = f;
			highest = t;
		end
	end

	f = highest_f;
	printf('Precision: %2.2f%%, recall: %2.2f%%.\n', highest_p * 100, highest_r * 100);

end