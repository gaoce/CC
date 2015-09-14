function out = cc_data_prep(data_in, nGene, nTime)
% Organze and filter data; initialize data struct.
% Use "type cc_data_prep" for details.

% Detailed Description
% 1.data_in: a matrix [treatment (sample) x gene_time]
%    line:   treatment(a specific material at a specific concentration);
%    column: expression value of a specific gene at a specific time point;
% 2.out: a struct containing info for further analysis, its fields include
%    data_in:    a copy of input data 
%    data:       treated matrices;
%    num_sample: number of treatments
%    num_gene:   number of genes
%    num_time:   number of time points
%    mat:        
%    ini:
%    CI: struct for consensus clustering, its fields include
%         CI:           initial consensus matrix
%         connectivity: initial connectivity matrix
%         indicator:    initialized indicator matrix
%         parameters: struct for consensus clustering, its fields include
%             filter: filtered (1) or not (0);
%             perturbation: type of disturbance-'sample' or 'gene'
%             sG: Fixed initial seed;
%             num_sample: number of original sample;
%             num_gene:   number of genes
%             num_bootstrp: number of bootstrping;
%             num_resample: number of samples in new group;
%             nonreplication: EXclude replicates(1) or not(0)for resampling
%             mapsize: geometry of self-organizing map;
%             date: date of study;
%             training: [rough fine], a matrix setting training time;

% Version: 1.00
% Authors: Ce Gao
% Created: 2011-10-05 
% Revised: 2015-09-13

% Reference: Monti, S., P. Tamayo, et al. (2003). Machine Learning 52(1): 91-118.

%% construct output struct
out =  struct(...  
    'data_in',    data_in, ...
    'data',       data_in, ...
    'num_sample', size(data_in, 1), ...
    'num_gene',   nGene, ...
    'num_time',   nTime, ...
    'mat',        '', ...
    'CI',         '', ...
    'ini',        '');

%% filter: get out the low expression value (noise)
% filter = 1 means filter has been applied, 0 not applied.
% filter = 1;
% while filter
%     out.data_in = data_in; % give back original data
%     out.data = data_in;
%     filter = logical((data_in>-0.4) .* (data_in<0.4));
%     out.data(filter) = 0;
% end

filter = 0;

%% CI matrix construction
mat_ini = zeros(out.num_sample, out.num_sample);

out.CI = struct(...
    'CI',           mat_ini,...
    'connectivity', mat_ini,...
    'indicator',    mat_ini,...
    'parameters',   '');

out.CI.parameters = struct(...
    'filter',         '',...
    'perturbation',   '',...
    'sG',             '',...
    'num_sample',     '', ...
    'num_bootstrp',   '',...
    'num_resample',   '',...
    'nonreplication', '',...
    'mapsize',        '',...
    'date',           '',...
    'training',       '');

out.CI.parameters.filter = filter; 
