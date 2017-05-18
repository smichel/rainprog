clear;
close all;
progtime=50;
Contours=[0.1 0.2 0.5 1 2 5 10 100];

timesteps=50;
prog=1;
res=200;
x_car = -20000:res:20000;
y_car = -20000:res:20000;
[X,Y]= meshgrid(x_car,y_car);

cut_data=zeros(201,201,timesteps);
cut_data(50:50,50:50,1)=10;
delta_x=100;
delta_y=100;
delta_v=2;
dir_bar=45;
delta_dir=0;
v_bar=400;
v_bar_s=15;
for k=1:progtime
    prog_data(:,:,k)= griddata((x_car+delta_x*k)+delta_v*30*k*cosd(dir_bar+delta_dir*k),...
    (y_car+delta_y*k)+delta_v*30*k*sind(dir_bar+delta_dir*k),...
    cut_data(:,:,prog+1),X,Y,'natural');
end