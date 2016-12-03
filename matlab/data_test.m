clear;close all;
load('cut_data.mat');
load('prog_data.mat')
Contours=[0.1 0.2 0.5 1 2 5 10 100];

rel_data=cut_data(:,:,47:end);
prog_data=prog_data(:,:,1:end-1);
% colormap(jet);
% for i=1:20
% contourf(log(abs(rel_data(:,200:400,i)-prog_data(:,200:400,i))),log(Contours))
% % hcb=colorbar;
% % set(hcb,'Ytick',0:0.5:5)
% % 
%     colorbar('YTick',log(Contours),'YTickLabel',Contours);
%     colormap(jet);
%     caxis(log([Contours(1) Contours(length(Contours))]));
%     colorbar('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);
%     pause(1)
% end

figure
off=0;
off_t=zeros(size(prog_data,3),1);
for i=1:20000
    X=randi([200 400],1);
    Y=randi([200 400],1);
    %plot(squeeze((rel_data(X,Y,:)-prog_data(X,Y,:))))
    %leg{i}=strcat(num2str(X),',',num2str(Y));
    off=off+sum(rel_data(X,Y,:),'omitnan')-sum(prog_data(X,Y,:),'omitnan');
    for k=1:size(prog_data,3)
        off_t(k)=off_t(k)+sum(rel_data(X,Y,k),'omitnan')-sum(prog_data(X,Y,k),'omitnan');
    end
    hold on
end
off=off/i;
off_t=off_t/i;
plot(off_t)
%legend(leg)
figure
for i=1:60
contourf(log(prog_data(:,:,i)),log(Contours))
colorbar('YTick',log(Contours),'YTickLabel',Contours);
colormap(jet);
caxis(log([Contours(1) Contours(length(Contours))]));
colorbar('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);
title(num2str(i))
pause(1)
hold off
end