clear;close all;
timesteps=10;
res=400; % Aufloesung im m
grid=40000/res; % Gittergroesse

nested_data=50.*rand(grid*grid,1);
nested_data_2d=reshape(nested_data,[grid,grid]);

sorted=zeros(grid*grid,3);
[sorted(:,1),I]=sort(nested_data);
sorted_2d=reshape(sorted(:,1),[grid, grid]);

sorted(:,2)=mod(I,100);
sorted(:,3)=ceil(I/100);

sorted(sorted(:,3)==0,3)=100;

sorted(end,:)

c_range=20;
num_maxes=10;
maxima=zeros(num_maxes,3);
maxima(1,1:3)=sorted(end,:);
dummy=sorted;
for i=1:num_maxes
    tic
    distance=zeros(size(dummy,1),i);
    for j=1:i
       distance(:,j)= sqrt((maxima(j,2)-dummy(:,2)).^2+(maxima(j,3)-dummy(:,3)).^2);
    end
    pot_points_=(distance(:,1:i)>c_range);
    l=1;
    for k=1:length(pot_points_)
        if sum(pot_points_(k))==i
            pot_points(l)=k;
            l=l+1;
        end
    end
    maxima(i+1,1:3)=sorted(pot_points(end),:);
    dummy=sorted(pot_points,:);
    toc
end