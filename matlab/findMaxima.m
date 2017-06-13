function [ maxima ] = findMaxima(maxima, nested_data,c_range,num_maxes)
%nested_data=nested_data(33:size(nested_data,1)-33,33:size(nested_data,1)-33,:);
grid=size(nested_data,1);
nested_data=reshape(nested_data,[grid*grid 1]);

sorted=zeros(grid*grid,3);
[sorted(:,1),I]=sort(nested_data);
sorted(:,2)=mod(I,grid);
sorted(:,3)=ceil(I/grid);
sorted(sorted(:,2)==0,2)=grid;
sorted(sorted(:,3)==0,3)=grid;

%maxima=zeros(num_maxes,3);
%maxima(1,1:3)=sorted(end,:);
dummy=sorted;
for i=1:num_maxes-size(maxima,1)
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
    %maxima(i+1,1:3)=dummy(pot_points(end),:);
    maxima=vertcat(maxima, dummy(pot_points(end),:));
    dummy=dummy(pot_points,:);
    clear pot_points
end

