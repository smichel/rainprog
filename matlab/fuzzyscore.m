close all;clear;
load('SAL_data1.mat')
A=exist('res');
if ~A
    res=size(prog_data{1,1},1);
end
time=size(prog_data{1,1},3);

rain_threshold=0.02;
r=1; % idx for rain_threshold

max_boxsize=10;
thresholds=[0.0001 0.0002 0.0005 0.001 0.002 0.005 0.01 0.2 0.5 1];
FSS=zeros(10,length(thresholds),time); %Fraction Skill Score
for boxsize=1:max_boxsize
    b=1; % idx for box_size
    for rain_threshold=[0.0001 0.0002 0.0005 0.001 0.002 0.005 0.01 0.2 0.5 1]
        p_box=zeros(ceil(res/boxsize),ceil(res/boxsize));
        r_box=zeros(ceil(res/boxsize),ceil(res/boxsize));
        p_data=prog_data{1,1};
        r_data=real_data{1,1};
        for i=1:time
            for x=1:res-1
                for y=1:res-1
                    if p_data(x,y,i)>rain_threshold
                        p_box(ceil(x/boxsize),ceil(y/boxsize))=p_box(ceil(x/boxsize),ceil(y/boxsize))+1;
                    end
                    if r_data(x,y,i)>rain_threshold
                        r_box(ceil(x/boxsize),ceil(y/boxsize))=r_box(ceil(x/boxsize),ceil(y/boxsize))+1;
                    end
                end
            end
            
            FSS(r,b,i)=1-((1/size(r_box,1)^2)*sqrt(sum(sum(r_box-p_box)).^2)/((1/size(r_box,1)^2)*sum(sum(r_box.^2))+sum(sum(p_box.^2))));
            if isnan(FSS(r,b,i))
                FSS(r,b,i)=0;
            end
        end
        
        b=b+1;
    end
    r=r+1;
end
% figure
% colormap('gray')
% imagesc(box_)
% colormap('gray')
% imagesc(squeeze(p_data(:,:,1)))