function [data, geneNames, sampleNames] = cc_import_data()

% Get input file names and path through user input
[fileNames, pathName, ~] = uigetfile([pwd, '/.gct'], ...
    'Select GCT Files', 'MultiSelect', 'on');

% mat is a matrix [nSample x nGene_Time]
geneNames = {};
sampleNames = cell(length(fileNames), 1);

for i = 1:length(fileNames(:))
    fileName = fileNames{i};
    path = [pathName, fileName];
    [newGeneList, nGene, nTime, mat(i, :)] = gctReader(path); %#ok<AGROW>
    sampleNames{i} = fileName(1:end-4);
    
    % Test if gene names are consistent
    if ~isempty(geneNames)
        if ~all(strcmp(geneNames, newGeneList))
            errordlg('Gene names are not consistent');
            error('Gene names are not consistent');
        else
            continue
        end
    else
        geneNames = newGeneList;
    end
end

data = struct('matrix', mat, 'nGene',  nGene, 'nTime',  nTime);
end


function [geneNames, nGene, nTime, exp] = gctReader(path)
% Read .gct file, get gene expression matrix (gene x time)
% Returns
%     geneNames: a cell arrays of gene list 
%     exp:  matrix,(time x gene)

fd = fopen(path);

% Skip version line
fgetl(fd);

% Get gene number and time point number
C = textscan(fd, '%d\t%d');
nGene = C{1};
nTime = C{2};

% Gene expression matrix
exp = zeros(nGene, nTime);

% gene name cells
geneNames = cell(nGene, 1);

% Skip the header line of the table
fgetl(fd);

% Count the number of tabs in title line, numEx = numTab - 1 + 1
fmtStr = ['%s\t%s\t', repmat('%f\t', 1, nTime-1), '%f\n'];

for i = 1:nGene
    C = textscan(fd, fmtStr);
    
    % Assign gene name
    geneNames{i} = C{1}{1};
    
    % Assign expression values
    exp(i, :) = [C{3:end}];
end

% Transpose the matrix into a vector
exp = exp';
exp = exp(:)';

end