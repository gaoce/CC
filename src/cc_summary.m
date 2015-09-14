function cc_summary(CI, name)
%% Get output directory
path = uigetdir(pwd);

%% retrive consensus matrix
A = CI.CI;
num_sample = CI.parameters.num_sample;
A(isnan(A)) = 0;
A = A + triu(A)'+eye(num_sample);

%% get distance matrix
B = 1-A;
Dist = [];
for m = 1:(num_sample-1)
    Dist = cat(2,Dist,B(m,(m+1):num_sample));
end
% orig_tree  = seqlinkage(Dist,'average');

%% dendrogram with linkage
Tree = linkage(Dist,'average');
fid1 = figure(1);
% Order = optimalleaforder(Tree, Dist);
[~, ~, perm] = dendrogram(Tree, 0, 'labels', name, 'orientation', 'left');
Order = perm;

C = zeros(num_sample, num_sample);
for m = 1:num_sample
    for n = 1:num_sample
        C(m,n) = A(Order(m),Order(n));
    end
end

fid2 = figure(2);
imagesc(C,[0,1]);
labels = name(Order);
set(gca,'YTick',[1:num_sample]);
set(gca,'YTickLabel',labels);
set(gca,'XTick',[]);
colorbar;

%% Output
saveas(fid1, [path, '/CC_heatmap.png']);
saveas(fid2, [path, '/CC_dendrogram.png']);
waitfor(msgbox('Export Complete!'));
close(fid1);
close(fid2);

end