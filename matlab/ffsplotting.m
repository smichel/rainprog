clear;close all;
load('SAL+FSS.mat');
FFS=FSS{9,1};
res=40000/200;
figure
imagesc(squeeze(flipud(FFS(1:10,:,1))))
colormap('hot')
set(gca,'Xtick',(1:length(rain_thresholds{1,1})))
set(gca,'Xticklabels',rain_thresholds{1,1})
xlabel('Threshold in mm')
set(gca,'Ytick',(1:10))
set(gca,'Yticklabels',(((10:-1:1)*(res)).^2)/1000000)
ylabel('Spatial scale in km^2')
title(strcat('Progtime ',num2str(1/2),' Minutes'))
hcb=colorbar;
hcb.Label.String = 'Fraction Skill Score';
caxis([0 1])
for i=5:10:25
    figure
    imagesc(squeeze(flipud(FFS(1:10,:,i))))
    colormap('hot')
    set(gca,'Xtick',(1:length(rain_thresholds{1,1})))
    set(gca,'Xticklabels',rain_thresholds{1,1})
    xlabel('Threshold in mm')
    set(gca,'Ytick',(1:10))
    set(gca,'Yticklabels',(((10:-1:1)*(res)).^2)/1000000)
    ylabel('Spatial scale in km^2')
    hcb=colorbar;
    hcb.Label.String = 'Fraction Skill Score';
    title(strcat('Progtime ',num2str(i/2),' Minutes'))
    caxis([0 1])
end