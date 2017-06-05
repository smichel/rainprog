clear;close all;
timesteps=10;
%load('nested_data.mat');
res=100; % Aufloesung im m
%nested_data=nested_data(33:size(nested_data,1)-33,33:size(nested_data,1)-33,:);
%grid=size(nested_data,1);
grid=40000/res; % Gittergroesse
c_range=50;
num_maxes=4;

N=grid;
alpha = 1.7;
x = meshgrid(-N/2:N/2-1);
d = hypot(x,x')+1e-5;
Z = d.^(-alpha) .* exp(rand(N)*j*2*pi); % |Z(w)| = |w|^-a, phase(Z(w))=rand
Z = ifftn(ifftshift(Z));
Z=abs(Z);
%Z=peaks(grid);
%nested_data=50.*rand(grid*grid,1);
%Z=peaks(grid);
nested_data=reshape(Z,[grid*grid 1]);
nested_data_2d=reshape(nested_data,[grid,grid]);

sorted=zeros(grid*grid,3);
[sorted(:,1),I]=sort(nested_data);
sorted_2d=reshape(sorted(:,1),[grid, grid]);

sorted(:,2)=mod(I,grid);
sorted(:,3)=ceil(I/grid);

sorted(sorted(:,2)==0,2)=grid;
sorted(sorted(:,3)==0,3)=grid;

maxima=zeros(num_maxes,3);
maxima(1,1:3)=sorted(end,:);
dummy=sorted;
for i=1:num_maxes
    tic
    distance=zeros(size(dummy,1),i);
    for j=1:i
       distance(:,j)= sqrt((maxima(j,2)-dummy(:,2)).^2+(maxima(j,3)-dummy(:,3)).^2);
    end
    pot_points_=distance>=(c_range);
    l=1;
    for k=1:size(pot_points_,1)
        if prod(pot_points_(k,:))==1
            pot_points(l)=k;
            l=l+1;
        end
    end
    maxima(i+1,1:3)=dummy(pot_points(end),:);
    dummy=dummy(pot_points,:);
    toc
    pot_points_b{i}=pot_points';
    distance_b{i}=distance;
    dummy_b{i}=dummy;
    pot_points_b_{i}=pot_points_';
    clear pot_points
%     figure
imagesc(nested_data_2d)
hold on

for i=1:size(maxima,1)
    for j=1:size(maxima,1)
       maxima(i,j+3)=sqrt((maxima(i,2)-maxima(j,2)).^2+(maxima(i,3)-maxima(j,3)).^2);
    end
    plot(maxima(i,3),maxima(i,2),'rx','MarkerSize',20)
    circle(maxima(i,3),maxima(i,2),c_range);
end
hold off
end


