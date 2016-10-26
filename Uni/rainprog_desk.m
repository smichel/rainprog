close all;clear;

filepath='D:/Programmieren/Rain/m4t_BKM_wrx00_l2_dbz_v00_20130511160000.nc';
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

%cartesian coordinatesystem
x_car = -20000:200:20000;
y_car = -20000:200:20000;
[X,Y]= meshgrid(x_car,y_car);



timesteps=120;
c_range=30;
d_s=length(X);

%preallocating
data_car=cell(timesteps,1);
maxima=cell(timesteps,1);
c_max=cell(timesteps,1);
nested_data= zeros(d_s+2*c_range,d_s+2*c_range,timesteps);

%transformation from polar to cartesian
for i=1:timesteps
    tic
    data(:,:,i)=0.0364633*(10.^(data(:,:,i)/10)).^0.625;
    data_car{i}= griddata(x,y,data(:,:,i),X,Y);
    %data_car{i}=0.0364633*(10^(data_car{i}/10))^0.625;
    toc

end
    %setting nans to 0
for i=1:timesteps
    for j=1:length(data_car{i})
        for o=1:length(data_car{i})
            if isnan(data_car{i}(j,o))
                data_car{i}(j,o)=0;
            end
        end
    end

    nested_data(c_range+1:c_range+d_s,c_range+1:c_range+d_s,i)= data_car{i};
    [val, max_y]=max(max(nested_data(:,:,i)));
	[val, max_x]=max(nested_data(:,max_y,i));
    maxima{i}(1)=max_x;
    maxima{i}(2)=max_y;
    maxima{i}(3)=mean([nested_data(max_x,max_y,i),nested_data(max_x+1,max_y,i),nested_data(max_x+1,max_y+1,i),nested_data(max_x-1,max_y,i),nested_data(max_x-1,max_y-1,i)]);
end

%nesting the array into a bigger array




c_max{1}=maxima{1}(2:-1:1);
o=0;
Contours=[0.1 0.2 0.5 1 2 5 10 100];

for i=1:timesteps-1
    if i ~=1
        if c_max{i}(1) == c_max{i-1}(1) & c_max{i}(2) == c_max{i-1}(2) | ...
            nested_data(c_max{i}(1),c_max{i}(2),i) - mean([nested_data(c_max{i}(1),c_max{i}(2),i),nested_data(c_max{i}(1)+1,c_max{i}(2),i),nested_data(c_max{i}(1)+1,c_max{i}(2)+1,i),nested_data(c_max{i}(1)-1,c_max{i}(2),i),nested_data(c_max{i}(1)-1,c_max{i}(2)-1,i)]) > 0.1 ...%& nested_data(c_max{i}(1),c_max{i}(2),i) - mean([nested_data(c_max{i}(1),c_max{i}(2),i),nested_data(c_max{i}(1)+1,c_max{i}(2),i),nested_data(c_max{i}(1)+1,c_max{i}(2)+1,i),nested_data(c_max{i}(1)-1,c_max{i}(2),i),nested_data(c_max{i}(1)-1,c_max{i}(2)-1,i)]) < 0.01
            | nested_data(c_max{i}(1),c_max{i}(2),i) == 0
            c_max{i}=maxima{i}(2:-1:1); 
            warning('chose new maximum')
            o=o+1;
        end
    end
    corr_area=nested_data((c_max{i}(2)-c_range):(c_max{i}(2)+c_range),(c_max{i}(1)-c_range):(c_max{i}(1)+c_range),i);
%     C=xcorr2(nested_data(:,:,i+1),corr_area);
    C=LeastSquareCorr(nested_data(:,:,i+1),corr_area);
    [ssr,snd]=min(C(:));
    [y_,x_]=ind2sub(size(C),snd);
    c_max{i+1}(1)=x_-c_range;
    c_max{i+1}(2)=y_-c_range;
    contourf(log(nested_data(:,:,i)),log(Contours))
    colorbar('YTick',log(Contours),'YTickLabel',Contours);
    colormap(jet);
    caxis(log([Contours(1) Contours(length(Contours))]));
    colorbar('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);
    hold on
    plot(c_max{i}(1),c_max{i}(2),'go','MarkerSize',20,'MarkerFaceColor','g')
    plot(c_max{i+1}(1),c_max{i+1}(2),'bo','MarkerSize',20,'MarkerFaceColor','b')
    line([c_max{i+1}(1) c_max{i}(1) ],[c_max{i+1}(2) c_max{i}(2)],'LineWidth',5,'Color','k')
    plot(maxima{i}(2),maxima{i}(1),'ko','MarkerSize',20,'MarkerFaceColor','k')
    pause(0.1)
    hold off

end

function[c_d]=LeastSquareCorr(d,c)
%Calculates a leastsquare correlation between 2 matrices c and d

c_l=length(c);
d_l=length(d);

c_d=zeros(d_l+c_l-1,d_l+c_l-1);
corr=ones(d_l+2*c_l-2,d_l+2*c_l-2)*999999;
corr(c_l:d_l+c_l-1,c_l:d_l+c_l-1)=d;


k=1;m=1;
for i=1:d_l+c_l-1
    for j=1:d_l+c_l-1
        c_d(k,m)=sum(sum((corr(i:i+c_l-1,j:j+c_l-1)-c).^2));
        m=m+1;
    end
    m=1;
    k=k+1;
end

end