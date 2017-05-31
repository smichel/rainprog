clear;
close all;
progtime=20;
Contours=[0.1 0.2 0.5 1 2 5 10 100];

timesteps=progtime;
prog=1;
res=400;
U=5.7; % speed of the blob
V=5.3; % speed of the blob
x0=60; % startposition of the blob
y0=60; % startposition of the blob
x_car = -20000:res:20000;
y_car = -20000:res:20000;
[X,Y]= meshgrid(x_car,y_car);
cut_data=zeros(40000/res+1,40000/res+1,timesteps);
%function [ data_car ] = blobmaker(u,v,x0,y0,res,amp,sigma,timesteps)
data_car=blobmaker(U,V,50,50,res,10,5,timesteps);
for i=1:length(data_car)
    cut_data(:,:,i)=data_car{i};
end
delta_x=0;
delta_y=0;
delta_v=200/30;
dir_bar=0;
delta_dir=22.5;
v_bar=400;
v_bar_s=15;
prog_data=zeros(40000/res+1,40000/res+1,progtime);
for k=1:progtime
    tic
    prog_data(:,:,k)= griddata((x_car+delta_x*k)+delta_v*30*k*cosd(dir_bar+delta_dir*k),...
    (y_car+delta_y*k)+delta_v*30*k*sind(dir_bar+delta_dir*k),...
    cut_data(:,:,1),X,Y,'natural');
    toc
end
gif=0;
filename='test.gif';
for k=1:progtime*10
imagesc(prog_data(:,:,k))
%xlim([200 80])
%ylim([20 60])
colormap(jet);
    if gif == 1
        drawnow
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if k == 1
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append');
        end
    end
end