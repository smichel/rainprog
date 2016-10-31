close all;clear;
%Variables
%Gridvars:
res=200;%horizontal resolution - e.g. 200m
timesteps=120;



filepath='E:/Rainprog/m4t_BKM_wrx00_l2_dbz_v00_20130511160000.nc';
data=ncread(filepath,'dbz_ac1');
azi=ncread(filepath,'azi');
range=ncread(filepath,'range');

x=zeros(333,360);
y=zeros(333,360);
dataRain=zeros(333,360,120);
R=333;
phi=360;

for theta=1:360
    for r=1:333     
        x(r,theta)=range(r)*cos(azi(theta)*pi/180);
        y(r,theta)=range(r)*sin(azi(theta)*pi/180);
    end
end


%cartesian coordinatesystem
x_car = -20000:res:20000;
y_car = -20000:res:20000;
[X,Y]= meshgrid(x_car,y_car);


c_range=floor((length(X)-1)/12);
d_s=length(X);

%preallocating
data_car=cell(timesteps,1);
maxima=cell(timesteps,1);
c_max=cell(timesteps,1);
nested_data= zeros(d_s+2*c_range,d_s+2*c_range,timesteps);
for i = 1:timesteps
    maxima{i}=zeros(1,3);
end
max_x=zeros(1,4);
max_y=zeros(1,4);

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
    d_n=length(nested_data);
    for q = 1:4
        if q == 1
            x_q_s=((d_n-1)/2)+1;
            x_q_e=d_n;
            y_q_s=((d_n-1)/2)+1;
            y_q_e=d_n;
        elseif q==2
            x_q_s=1;
            x_q_e=((d_n-1)/2);
            y_q_s=((d_n-1)/2)+1;
            y_q_e=d_n;
        elseif q==3
            x_q_s=1;
            x_q_e=((d_n-1)/2);
            y_q_s=1;
            y_q_e=((d_n-1)/2);
        elseif q==4
            x_q_s=((d_n-1)/2)+1;
            x_q_e=d_n;
            y_q_s=1;
            y_q_e=((d_n-1)/2);
        end
        [~, max_y(q)]=max(max(nested_data(x_q_s:x_q_e,y_q_s:y_q_e,i)));
        if q == 1 | q == 2
            max_y(q)=max_y(q)+((d_n-1)/2);
        end
        [~, max_x(q)]=max(nested_data(x_q_s:x_q_e,max_y(q),i));
        if q == 1 | q == 4
            max_x(q)=max_x(q)+((d_n-1)/2);
        end
    end
    maxima{i}(1:4,1)=max_x;
    maxima{i}(1:4,2)=max_y;
    for q=1:4
        maxima{i}(q,3)=mean([nested_data(max_x(q),max_y(q),i),nested_data(max_x(q)+1,max_y(q),i),nested_data(max_x(q)+1,max_y(q)+1,i),nested_data(max_x(q)-1,max_y(q),i),nested_data(max_x(q)-1,max_y(q)-1,i)]);
    end
end

%nesting the array into a bigger array



for q=1:4
    c_max{1}(q,1:1:2)=maxima{1}(q,2:-1:1);
end
o=0;
Contours=[0.1 0.2 0.5 1 2 5 10 100];
figure(1)
filename='lqcorr2_4q.gif';
gif=0;
l_len=zeros(120,1);
l_alpha=zeros(120,1);
for i=1:timesteps-1
    
    % contourplot of the precipitation
    contourf(log(nested_data(:,:,i)),log(Contours))
    colorbar('YTick',log(Contours),'YTickLabel',Contours);
    colormap(jet);
    caxis(log([Contours(1) Contours(length(Contours))]));
    colorbar('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);
    hold on
    
    
    
    for q=1:4
        try
            tic
            if i ~=1
                if c_max{i}(q,1) == c_max{i-1}(q,1) & c_max{i}(q,2) == c_max{i-1}(q,2) ...
                        | nested_data(c_max{i}(q,1),c_max{i}(q,2),i) - mean([nested_data(c_max{i}(q,1),c_max{i}(q,2),i),nested_data(c_max{i}(q,1)+1,c_max{i}(q,2),i),nested_data(c_max{i}(q,1)+1,c_max{i}(q,2)+1,i),nested_data(c_max{i}(q,1)-1,c_max{i}(q,2),i),nested_data(c_max{i}(q,1)-1,c_max{i}(q,2)-1,i)]) > 0.1 ...%& nested_data(c_max{i}(1),c_max{i}(2),i) - mean([nested_data(c_max{i}(1),c_max{i}(2),i),nested_data(c_max{i}(1)+1,c_max{i}(2),i),nested_data(c_max{i}(1)+1,c_max{i}(2)+1,i),nested_data(c_max{i}(1)-1,c_max{i}(2),i),nested_data(c_max{i}(1)-1,c_max{i}(2)-1,i)]) < 0.01
                        | nested_data(c_max{i}(q,1),c_max{i}(q,2),i) == 0 ...
                        | nested_data(maxima{i}(q,2),maxima{i}(q,1),i)<0.1
                        
                    c_max{i}(q,1:1:2)=maxima{i}(q,2:-1:1);
                    warning('chose new maximum')
                    o=o+1;
                end
            end
            corr_area=nested_data((c_max{i}(q,2)-c_range):(c_max{i}(q,2)+c_range),(c_max{i}(q,1)-c_range):(c_max{i}(q,1)+c_range),i);
            %C=xcorr2(nested_data(:,:,i+1),corr_area);
            C=LeastSquareCorr(nested_data(:,:,i+1),corr_area);
            [ssr,snd]=min(C(:));
            [y_,x_]=ind2sub(size(C),snd);
            c_max{i+1}(q,1)=x_-c_range;
            c_max{i+1}(q,2)=y_-c_range;
            
            plot(c_max{i}(q,1),c_max{i}(q,2),'go','MarkerSize',20,'MarkerFaceColor','g')
            plot(c_max{i+1}(q,1),c_max{i+1}(q,2),'bo','MarkerSize',20,'MarkerFaceColor','b')
            
            l_len(i,q)=sqrt((c_max{i}(q,1)-c_max{i+1}(q,1))^2+(c_max{i}(q,2)-c_max{i+1}(q,2))^2);
            l_alpha(i,q)=atan2((c_max{i+1}(q,2)-c_max{i}(q,2)),(c_max{i+1}(q,1)-c_max{i}(q,1)))*180/pi;
            
            line([c_max{i+1}(q,1) c_max{i}(q,1) ],[c_max{i+1}(q,2) c_max{i}(q,2)],'LineWidth',5,'Color','k')
            line([ c_range + c_range * cosd(l_alpha(i,q)) c_range] , [ c_range + c_range * sind(l_alpha(i,q)) c_range],'LineWidth',5,'Color','k')
            %plot(maxima{i}(2),maxima{i}(1),'ko','MarkerSize',20,'MarkerFaceColor','k')
        catch
            warning(strcat('Could not find a valid maximum in quadrant',q))
        end
    end
    
    if gif == 1
        drawnow
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if i == 1
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append');
        end
    end
    hold off
    toc
    pause(0.3)
end