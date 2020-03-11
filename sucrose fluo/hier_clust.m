function [C_sorted, cellIdx_sorted] = hier_clust(input,params)
% % hier_clust %
%PURPOSE:   Clustering using hierarchical clustering method
%AUTHORS:   AC Kwan 171107
%
%INPUT ARGUMENTS
%   input:        The matrix to be clustered, [signal x cells]
%   params.numClust:     Number of cluster
%
%OUTPUT ARGUMENTS
%   C_sorted:           A vector denoting the cluster membership [cell x 1], sorted by cluster size
%   cellIdx_sorted:     A vector with cell index sorted based on cluster size and membership

colors=cbrewer('div','RdYlBu',256);
colors=flipud(colors);

%% hierarchical clustering based on correlation
D=pdist(input,'euclidean');   %find pairwise distances between all pairs of cells
Z=linkage(D,'average');

%Z=linkage(D,'centroid');   %3 clusters, increase,steady,decrease, none stat sig
%Z=linkage(D,'complete');   %clusters do not look correct based on corr matrix
%Z=linkage(D,'median');     %clusters do not look correct based on corr matrix, but also mostly increase,steady,decrease
%Z=linkage(D,'single');     %clusters do not look correct based on corr matrix
%Z=linkage(D,'ward');       %somewhat similar to 'average'
%Z=linkage(D,'weighted');   %clusters do not look correct based on corr matrix

%--- cluster based on an a predetermined number of clusters
C=cluster(Z,'maxclust',params.numClust);

%% plot dendrogram to see how well the clustering went
color = Z(end-params.numClust+2,3)-eps;

figure;
subplot(2,5,[4 9]);
[H,T,CIdx]=dendrogram(Z,0,'Orientation','top','colorthreshold', color);  
set(H,'LineWidth',1);
set(gca,'XTick',[]); 
set(gca,'YTick',[]);
title('Dendrogram');
view(90,90);

%% sort the cluster by size
clustID_sorted=[1:params.numClust];
clusterSize=[];
for kk=1:params.numClust
    clusterSize(kk)=sum(C==kk);
end
[~,idx]=sort(clusterSize,'descend');
clustID_sorted=clustID_sorted(idx);

% re-name the cluster based on size
%e.g., what used to cluster 6, if it's largest, make that cluster 1
C_sorted = [];
for j = 1:params.numClust
    C_sorted(C==clustID_sorted(j),1) = j;
end

% based on the cluster size and membership, sort the cells
cellIdx_sorted=[];
for j = 1:params.numClust   %for each cluster
    idx=find(C_sorted==j); %which cell belongs to this cluster?
    idx=idx(randperm(numel(idx)));   %shuffle
    cellIdx_sorted=[cellIdx_sorted; idx];
end

%% plot similarity matrix

%simMat=corr(input(CIdx,:)');   %the correlation matrix
simMat=squareform(pdist(input(CIdx,:),'euclidean'));  %the similarity / distance matrix

subplot(2,5,[1 2 3 6 7 8]);
clims=[min(simMat(:)) max(simMat(:))];
imagesc(simMat,clims); hold on;
for jj=2:numel(CIdx)    %draw lines to delineate different clusters
    if C(CIdx(jj))~=C(CIdx(jj-1))    %if cluster index changes from cell n to cell n+1
        plot((jj-0.5)*[1 1],[0.5 numel(CIdx)+0.5],'k');
        plot([0.5 numel(CIdx)+0.5],(jj-0.5)*[1 1],'k');
    end
end
title('Hierarchical clustering - similarity matrix');
colormap(colors);
xlabel('Cell');
ylabel('Cell');
axis square;

%plot a color bar legend
subplot(3,20,60);
image([0],linspace(clims(1),clims(end),100),linspace(clims(1),clims(end),100)','CDataMapping','scaled');
colormap(colors);
caxis([clims(1),clims(end)]);
title('Distance');
set(gca,'YDir','normal');
set(gca, 'XTick', []);

%%
print(gcf,'-dpng','HierClust');    %png format
saveas(gcf,'HierClust', 'fig');

end
