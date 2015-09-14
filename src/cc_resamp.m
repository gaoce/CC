function indx = cc_resamp(nSamples, nTotalSamples, noReplacement)
% Resampling
% Parameters:
%     nSamples: the number of resamples to take
%     nTotalSamples: total sample number
%     noReplacement: 1-samples WITHOUT REPLACEMENT
% Returns
%     indx: indices in the original samples

if noReplacement == 1
    % Randomly permutate original indices
    indxPerm = randperm(nTotalSamples);
    % Take the first nSamples
    indx = indxPerm(1:nSamples);
else
    % Random sampling with replacement
    indx = ceil(nTotalSamples * rand(nSamples, 1));
end

% Make it a column vector
indx = indx(:);

