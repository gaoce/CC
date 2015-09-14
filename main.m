function main()
[data, ~, sampleNames] = cc_import_data;

% Get parameter
nBootstrp = 1000;
norep     = 0;
mapSize   = cc_get_mapsize;
nResample = floor(round(size(data, 1)*0.8));
training  = [10 100];

% Create a random seed
sG  = som_randinit(data.matrix, 'msize', mapSize);

% conduct 
CI = cc_ci_som(data, sG, nBootstrp, nResample, norep, mapSize, training);

cc_summary(CI, sampleNames);

end