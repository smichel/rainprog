clear;
close all;
na='online_HHG.txt';
data=zeros(333,360);
for i=1:7
    data=cat(3, dlmread(na,',',5,0),data);
    if i == 2
        data(20:100,20:100,i)=20;
    end
    if size(data,3)>5
        data(:,:,end)=[];
    end
end