function CI = cc_ci_som(data, sG, ...
    num_bootstrp, num_resample, norep, mapsize, training)
% [CI,bootScore] = cc_ci_som(data_all, sG_all3, 1000, 38, 1, [8 4], [10 100], name, orig_pointers)
% Carry out CC based on SOM.
% Use "type cc_ci_som" for details.
% Parameters:
%     data: a struct
%         matrix: a [sample x gene_time] matrix
%         nGene:  number of genes
%         nTime:  number of time points
%     sG: Fixed initial seed
%     num_bootstrp: number of bootstrap resampling
%     num_resample: generated sample size for each resampling
%     norep
%         1: without replication; 
%         0 or other number: with replication.
%     map size:

% For explanation of paramters, refer to cc_data_prep
% version: 1.1
% author: Ce Gao
% Created: 2011-10-05 
% Revised: 2011-10-24
%          2015-09-13 => Add to CC application
 
% Reference: Monti, S., P. Tamayo, et al. (2003). Machine Learning 52(1): 91-118.


% mapsize = [8 4];
% training = [10 100];

%% initialize structs and matrices
data_treated = cc_data_prep(data.matrix, data.nGene, data.nTime);

num_sample = data_treated.num_sample;
data       = data_treated.data;
CI         = data_treated.CI;

%% Consensus Loop
for i = num_bootstrp:-1:1
    
    % bootstrapping re-sample
    boot_indx = cc_resamp(num_resample, num_sample, norep);
    data_temp = data(boot_indx,:);
   
    % Create a SOM data struct
    sD = som_data_struct(data_temp);
    
    % Create, initialize and train Self-Organizing Map
    sM = cc_som_make(sD, sG, 'msize', mapsize, 'training', training, ...
        'tracking',0);
    
    % Find the best-matching units from the map for the given vectors
    bmus = som_bmus(sM, sD);
    
    % hierarchical clustering
    sC = som_cllinkage(sM);
    
    T = cluster(sC.tree, 'maxclust', num_sample);
    CI = consensusIndex2(CI, boot_indx, bmus, T, num_sample);
end

%% Summarized all the data into a structure
CI = cc_data_report(CI,...
    'perturbation',   'sample',...
    'sG',             sG,...
    'num_sample',     num_sample,...
    'num_bootstrp',   num_bootstrp,...
    'num_resample',   num_resample,...
    'training',       training,...
    'nonreplication', norep,...
    'mapsize',        mapsize,...
    'date',           date);
end