close all;clear;

filepath='D:/Programmieren/Rain/m4t_BKM_wrx00_l2_dbz_v00_20130511160000.nc';
data=ncread(filepath,'dbz_ac1');
azi=ncread(filepath,'azi');
range=ncread(filepath,'range');


res=100; % horizontal resolution for the cartesian grid
timesteps=120; % Number of timesteps
small_val=0.1; % small value for the mean - TO BE DISCUSSED
rain_threshold=0.1; % rain threshold
gif=0; % boolean for gif 
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
nested_data= zeros(d_s+4*c_range,d_s+4*c_range,timesteps);
for i = 1:timesteps
    maxima{i}=zeros(1,3);
end
max_x=zeros(1,3);
max_y=zeros(1,3);

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
    
    nested_data(2*c_range+1:2*c_range+d_s,2*c_range+1:2*c_range+d_s,i)= data_car{i};
    d_n=length(nested_data);
    for q = 1:4
        if q == 1
            x_q_s=((d_n-1)/2)+1;
            x_q_e=d_n;
            y_q_s=((d_n-1)/2)+1;
            y_q_e=d_n;
        elseif q==2
            x_q_s=((d_n-1)/2)+1;
            x_q_e=d_n;
            y_q_s=1;
            y_q_e=((d_n-1)/2);
        elseif q==3
            x_q_s=1;
            x_q_e=((d_n-1)/2);
            y_q_s=1;
            y_q_e=((d_n-1)/2);
        elseif q==4
            x_q_s=1;
            x_q_e=((d_n-1)/2);
            y_q_s=((d_n-1)/2)+1;
            y_q_e=d_n;
        end
        [~, max_y(q)]=max(max(nested_data(x_q_s:x_q_e,y_q_s:y_q_e,i)));
        if q == 1 | q == 4
            max_y(q)=max_y(q)+((d_n-1)/2);
        end
        [~, max_x(q)]=max(nested_data(x_q_s:x_q_e,max_y(q),i));
        if q == 1 | q == 2
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
l_len=zeros(120,1);
l_alpha=zeros(120,1);



for i=1:timesteps-1
    contourf(log(nested_data(:,:,i)),log(Contours))
    colorbar('YTick',log(Contours),'YTickLabel',Contours);
    colormap(jet);
    caxis(log([Contours(1) Contours(length(Contours))]));
    colorbar('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);
    hold on
    tic
    
    for q=1:4
        try
            if i ~=1
                try
                    if nested_data(c_max{i}(q,2),c_max{i}(q,1),i) == 0  ...% when c_max rans out of the circle of data
                            | ((c_max{i}(q,1) == c_max{i-1}(q,1)) & (c_max{i}(q,2) == c_max{i-1}(q,2))) ... % when the position of c_max doesnt change after one timestep
                            | nested_data(c_max{i}(q,2),c_max{i}(q,1),i) < rain_threshold ...% when the value is too small
                            | nested_data(c_max{i}(q,2),c_max{i}(q,1),i) - mean([nested_data(c_max{i}(q,2),c_max{i}(q,1),i),nested_data(c_max{i}(q,2)+1, ...
                            c_max{i}(q,1),i),nested_data(c_max{i}(q,2)+1,c_max{i}(q,1)+1,i),nested_data(c_max{i}(q,2)-1,c_max{i}(q,1),i), ...
                            nested_data(c_max{i}(q,2)-1,c_max{i}(q,1)-1,i)]) > small_val ... % when the mean around c_max is low - there is a high chance its scatter or some bullshit
                            & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) < rain_threshold % if maximum is too small in quadrant q
                        
                        c_max{i}(q,1:1:2)=NaN;
                        
                    elseif nested_data(c_max{i}(q,2),c_max{i}(q,1),i) == 0  ...% when c_max rans out of the circle of data
                            | ((c_max{i}(q,1) == c_max{i-1}(q,1)) & (c_max{i}(q,2) == c_max{i-1}(q,2))) ... % when the position of c_max doesnt change after one timestep
                            | nested_data(c_max{i}(q,2),c_max{i}(q,1),i) < rain_threshold ...% when the value is too small
                            | nested_data(c_max{i}(q,2),c_max{i}(q,1),i) - mean([nested_data(c_max{i}(q,2),c_max{i}(q,1),i),nested_data(c_max{i}(q,2)+1, ...
                            c_max{i}(q,1),i),nested_data(c_max{i}(q,2)+1,c_max{i}(q,1)+1,i),nested_data(c_max{i}(q,2)-1,c_max{i}(q,1),i), ...
                            nested_data(c_max{i}(q,2)-1,c_max{i}(q,1)-1,i)]) > small_val ... % when the mean around c_max is low - there is a high chance its scatter or some bullshit
                            & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) > rain_threshold % if maximum is too small in quadrant q
                        
                        c_max{i}(q,1:1:2)=maxima{i}(q,2:-1:1);
                        display(sprintf('Chose a new maximum in quadrant %d at timestep %d',q,i));
                    end
                    
                catch
                    if isnan(c_max{i}(q,1)) & isnan(c_max{i}(q,2)) & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) > rain_threshold
                        c_max{i}(q,1:1:2)=maxima{i}(q,2:-1:1);
                        display(sprintf('Chose a new maximum in quadrant %d at timestep %d',q,i));
                    elseif ~isnan(c_max{i}(q,1)) & ~isnan(c_max{i}(q,2)) & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) < rain_threshold
                        c_max{i+1}(q,1:1:2)=NaN;
                        display(sprintf('Couldnt find a new valid maximum in quadrant %d at timestep %d',q,i));
                    end
                end
                
            end
            
            
            corr_area=nested_data((c_max{i}(q,2)-c_range):(c_max{i}(q,2)+c_range),(c_max{i}(q,1)-c_range):(c_max{i}(q,1)+c_range),i);
            
            data_area=nested_data((c_max{i}(q,2)-c_range*2):(c_max{i}(q,2)+c_range*2),(c_max{i}(q,1)-c_range*2):(c_max{i}(q,1)+c_range*2),i+1);
            
            C=LeastSquareCorr(data_area,corr_area);
            clear data_area; clear corr_area;
            [ssr,snd]=min(C(:));
            [y_,x_]=ind2sub(size(C),snd);
            
            c_max{i+1}(q,1)=c_max{i}(q,1)-3*c_range+x_-1;
            c_max{i+1}(q,2)=c_max{i}(q,2)-3*c_range+y_-1;
            
            plot(c_max{i}(q,1),c_max{i}(q,2),'go','MarkerSize',20,'MarkerFaceColor','g')
            plot(c_max{i+1}(q,1),c_max{i+1}(q,2),'bo','MarkerSize',20,'MarkerFaceColor','b')
            
            l_len(i,q)=sqrt((c_max{i}(q,1)-c_max{i+1}(q,1))^2+(c_max{i}(q,2)-c_max{i+1}(q,2))^2);
            l_alpha(i,q)=atan2((c_max{i+1}(q,2)-c_max{i}(q,2)),(c_max{i+1}(q,1)-c_max{i}(q,1)))*180/pi;
            
            line([c_max{i+1}(q,1) c_max{i}(q,1) ],[c_max{i+1}(q,2) c_max{i}(q,2)],'LineWidth',5,'Color','k')
            line([ 50 + 40 * cosd(l_alpha(i,q)) 50] , [ 50 + 40 * sind(l_alpha(i,q)) 50],'LineWidth',5,'Color','k')
            %plot(maxima{i}(2),maxima{i}(1),'ko','MarkerSize',20,'MarkerFaceColor','k')
        catch
            display(sprintf('Couldnt calculate the correlation for the quadrant %d dat timestep %d',q,i));
            c_max{i+1}(q,1:1:2)=NaN;

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
    pause(0.5)
    toc
end
