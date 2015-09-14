function CI = consensusIndex2(CI, bootsample,bmus, T, num_sample)
%Determine if two treatments appear in the resampling and same cluster.

%For explanation of paramters, refer to gc_data_prep;
%version: 1.00
%author: Ce Gao
%release date: 2011-10-05 
%reference: Monti, S., P. Tamayo, et al. (2003). Machine Learning 52(1): 91-118.

%% consensus index loop
for m = 1:(num_sample-1)
    for n = (m+1):(num_sample)
        if (ismember(m,bootsample)) && (ismember(n,bootsample))
            CI.indicator(m,n) = CI.indicator(m,n) + 1;
            list_m = T(bmus(bootsample==m));
            list_n = T(bmus(bootsample==n));
            common = intersect(list_m,list_n);
            if ~isempty(common)
                CI.connectivity(m,n) = CI.connectivity(m,n) + 1;
            end
        end
    end
end