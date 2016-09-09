close all;clear;

filepath='C:/Users/Uni/Desktop/m4t_BKM_wrx00_l2_dbz_v00_20130426190000.nc';
data=ncread(filepath,'dbz_ac1');
azi=ncread(filepath,'azi');
range=ncread(filepath,'range');

% 
% for i=1:size(data,3)
%     figure
%     contourf(data(:,:,i))
%     pause(0.5)
%     close all
% end
%range=linspace(0,20000,360);
%[x,y]=pol2cart(range',azi);
x=zeros(333,360);
y=zeros(333,360);
dataRain=zeros(333,360,120);
R=333;
phi=360;
dampeningdist_R_up=20;
dampeningdist_R_down=dampeningdist_R_up;
dampeningdist_phi_up=5;
dampeningdist_phi_down=dampeningdist_phi_up;
dampeningfactor=0.5;

for theta=1:360
    for r=1:333     
        x(r,theta)=range(r)*cos(azi(theta)*pi/180);
        y(r,theta)=range(r)*sin(azi(theta)*pi/180);
        for i=1:120
            dataRain(r,theta,i)=0.0364633*(10^(data(r,theta,i)/10))^0.625;
        end
    end
end



datadummy=dataRain;
max_num=3;
max_x=zeros(max_num,120);
max_y=zeros(max_num,120);

% for o=1:max_num
%     for i=1:120
%         [val, azi_]=max(max(datadummy(:,:,i)));
%         [val, range_]=max(datadummy(:,azi_,i));
%         max_x(o,i)=x(range_,azi_);
%         max_y(o,i)=y(range_,azi_);
%         datadummy(range_,azi_,i)=-32.5;
%         deltaR=R-range_;
%         deltaphi=phi-azi_;
%         
%         if dampeningdist_R_up >= deltaR
%             dampeningdist_R_up=deltaR;
%         end
%         if range_-dampeningdist_R_down <= 0
%             dampeningdist_R_down=range_-1;
%         end            
%         if dampeningdist_phi_up >= deltaphi
%             dampeningdist_phi_up=deltaphi;
%         end
%         
%         if azi_-dampeningdist_phi_down <= 0
%             dampeningdist_phi_down =azi_-1;
%         end
%             
%         datadummy(range_-dampeningdist_R_down:range_+dampeningdist_R_up,azi_-dampeningdist_phi_down:azi_+dampeningdist_phi_up,i)=datadummy(range_-dampeningdist_R_down:range_+dampeningdist_R_up,azi_-dampeningdist_phi_down:azi_+dampeningdist_phi_up,i)*dampeningfactor;
%     end
% end
i=1;

max_=max(max(max(dataRain(:,:,:))));

% 
% for i=1:120
%     contourf(x,y,dataRain(:,:,i),20)
%     hold on
%     for o=1:size(max_x,1)
%         plot(max_x(o,i),max_y(o,i),'color',[i/120 0 i/120],'.','LineWidth',2)
%     end
% %    plot(mean(max_x(:,i)),mean(max_y(:,i)),'o','LineWidth',5)
%     caxis([0 max_])
%     hold off
%     colorbar
%     pause(0.5)
% 
% end
% 
% 
% for i=1:120
%     hold on
%     for o=1:size(max_x,1)
%         plot(max_x(o,i),max_y(o,i),'.','LineWidth',2,'Color',[i/120 0 1-i/120])
%     end
% end
% out=sortrows(reflec{:}',1');

% for i=1:120
%     plot(mean(max_x(:,i)),mean(max_y(:,i)),'o','LineWidth',5)
% end
% set(h,'LineColor','none')
%%%%%%%%%%%%%%%%%%%%

x_car = -20000:100:20000;
y_car = -20000:100:20000;
[X,Y]= meshgrid(x_car,y_car);
timesteps=50;
data_car=cell(timesteps,1);
maxima=cell(timesteps,1);
c_max=cell(timesteps,1);

for i=1:timesteps
    tic
    data_car{i}= griddata(x,y,data(:,:,i),X,Y);
    toc
    [val, max_x]=max(max(data_car{i}(:,:)));
	[val, max_y]=max(data_car{i}(:,max_x));
    maxima{i}(1)=max_x;
    maxima{i}(2)=max_y;
end
for i=1:timesteps
    for j=1:length(data_car{i})
        for o=1:length(data_car{i})
            if isnan(data_car{i}(j,o))
                data_car{i}(j,o)=0;
            end
        end
    end
end
c_range=30;
c_range_bottom=c_range;
c_range_top=c_range;
c_range_right=c_range;
c_range_left=c_range;
c_max{1}=maxima{1};
dim=length(data_car{1});

for i=1:timesteps-1
    %corr_area=(data_car{i}((c_max{i}(2)-c_range):(c_max{i}(2)+c_range),(c_max{i}(1)-c_range):(c_max{i}(1)+c_range)));
    if c_max{i}(1)+c_range > dim
        c_range_right = c_range-(c_max{i}(1)+c_range-dim);
    end
    if c_max{i}(2)+c_range> dim
        c_range_top = c_range-(c_max{i}(2)+c_range-dim);
    end
    if c_max{i}(1)-c_range<1
        c_range_left = c_range-abs(c_max{i}(1)-c_range);
    end
    if c_max{i}(2)-c_range<1
        c_range_bottom = c_range-abs(c_max{i}(2)-c_range);
    end
    corr_area=(data_car{i}((c_max{i}(2)-c_range_bottom):(c_max{i}(2)+c_range_top),(c_max{i}(1)-c_range_left):(c_max{i}(1)+c_range_right)));
    
    size(corr_area)
    C=xcorr2(data_car{i+1},corr_area);
    [ssr,snd]=max(C(:));
    [y_,x_]=ind2sub(size(C),snd);
    c_max{i+1}(1)=x_-c_range_right;
    c_max{i+1}(2)=y_-c_range_top;
    contourf(data_car{i})
    hold on
    plot(c_max{i}(1),c_max{i}(2),'m*','MarkerSize',20)
    plot(c_max{i+1}(1),c_max{i+1}(2),'b*','MarkerSize',20)
    pause(2)
    hold off
end

