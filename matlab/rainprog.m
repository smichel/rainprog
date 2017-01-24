function [ co1,co2 ] = rainprog(res,timesteps,prog,progtime,uk,filepath )
data=ncread(filepath,'dbz_ac1');
azi=ncread(filepath,'azi');
range=ncread(filepath,'range');

%Variables
%Gridvars:
% timesteps=30; % Number of timesteps
% prog=10; % starttime of the prognosis
% progtime=15; % how many timesteps for the prognosis
% uk=5; % Number of interpolation points
%res=100; % horizontal resolution for the cartesian grid

small_val=2; % small value for the mean - TO BE DISCUSSED
rain_threshold=0.1; % rain threshold
gif=0; % boolean for gif
time=1;

U=5.7; % speed of the blob
V=5.3; % speed of the blob
x0=60; % startposition of the blob
y0=60; % startposition of the blob
filename='1st_prog.gif';

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
%scatteredinterpolant wurde als schei�e considered
for i=1:timesteps
    data(:,:,i)=0.0364633*(10.^(data(:,:,i)/10)).^0.625;
    data_car{i}= griddata(x,y,data(:,:,i),X,Y);
    %data_car{i}=0.0364633*(10^(data_car{i}/10))^0.625;
end
%setting nans to 0

% data_car=blobmaker(U,V,60,60,res,10,5,timesteps);

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
%figure
l_len=nan(120,4);
l_alpha=nan(120,4);
l_alpha360=nan(120,4);
alpha_flag=nan(120,4);
v=nan(120,1);
dist=nan(4,1);
dir=nan(120,1);
pause(5)
for i=1:timesteps-1
%    contourf(log(nested_data(:,:,i)),log(Contours))
%    colorbar('YTick',log(Contours),'YTickLabel',Contours);
%    colormap(jet);
%    caxis(log([Contours(1) Contours(length(Contours))]));
%    colorbar('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);
%    hold on
    for q=1:4
        try
            if i ~=1
                try
                    if nested_data(c_max{i}(q,2),c_max{i}(q,1),i) == 0  ...% when c_max rans out of the circle of data
                            | nested_data(c_max{i}(q,2),c_max{i}(q,1),i) < rain_threshold ...% when the value is too small
                            | nested_data(c_max{i}(q,2),c_max{i}(q,1),i) / mean([nested_data(c_max{i}(q,2),c_max{i}(q,1),i),nested_data(c_max{i}(q,2)+1, ...
                            c_max{i}(q,1),i),nested_data(c_max{i}(q,2)+1,c_max{i}(q,1)+1,i),nested_data(c_max{i}(q,2)-1,c_max{i}(q,1),i), ...
                            nested_data(c_max{i}(q,2)-1,c_max{i}(q,1)-1,i)]) > small_val ... % when the mean around c_max is low - there is a high chance its scatter or some bullshit
                            & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) < rain_threshold % if maximum is too small in quadrant q
                        
                        c_max{i}(q,1:1:2)=NaN;
                        alpha_flag(i,q)=NaN;
                        
                    elseif nested_data(c_max{i}(q,2),c_max{i}(q,1),i) == 0  ...% when c_max rans out of the circle of data
                            | nested_data(c_max{i}(q,2),c_max{i}(q,1),i) < rain_threshold ...% when the value is too small
                            | nested_data(c_max{i}(q,2),c_max{i}(q,1),i) / mean([nested_data(c_max{i}(q,2),c_max{i}(q,1),i),nested_data(c_max{i}(q,2)+1, ...
                            c_max{i}(q,1),i),nested_data(c_max{i}(q,2)+1,c_max{i}(q,1)+1,i),nested_data(c_max{i}(q,2)-1,c_max{i}(q,1),i), ...
                            nested_data(c_max{i}(q,2)-1,c_max{i}(q,1)-1,i)]) > small_val ... % when the mean around c_max is low - there is a high chance its scatter or some bullshit
                            & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) > rain_threshold % if maximum is too small in quadrant q
                        
                        c_max{i}(q,1:1:2)=maxima{i}(q,2:-1:1);
                        alpha_flag(i,q)=3; % chose new maximum
 %                       display(sprintf('Chose a new maximum in quadrant %d at timestep %d',q,i));
                    end
                    
                catch
                    if isnan(c_max{i}(q,1)) & isnan(c_max{i}(q,2)) & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) > rain_threshold
                        c_max{i}(q,1:1:2)=maxima{i}(q,2:-1:1);
 %                       display(sprintf('Chose a new maximum in quadrant %d dat timestep %d',q,i));
                        alpha_flag(i,q)=3; % chose new maximum
                        
                    elseif ~isnan(c_max{i}(q,1)) & ~isnan(c_max{i}(q,2)) & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) < rain_threshold
                        c_max{i+1}(q,1:1:2)=NaN;
 %                       display(sprintf('Couldnt find a new valid maximum in quadrant %d at timestep %d',q,i));
                        alpha_flag(i,q)=NaN;
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
            
            if alpha_flag(i,q)~=3
                alpha_flag(i,q)=0;
            end
            if ((c_max{i}(q,1) == c_max{i+1}(q,1)) & (c_max{i}(q,2) == c_max{i+1}(q,2))) % when the position of c_max doesnt change after one timestep
                c_max{i+1}(q,1:1:2)=NaN;
                alpha_flag(i+1,q)=NaN;
            end
%             plot(c_max{i}(q,1),c_max{i}(q,2),'go','MarkerSize',20,'MarkerFaceColor','g')
%             plot(c_max{i+1}(q,1),c_max{i+1}(q,2),'bo','MarkerSize',20,'MarkerFaceColor','b')
            

            
            l_len(i,q)=sqrt((c_max{i}(q,1)-c_max{i+1}(q,1))^2+(c_max{i}(q,2)-c_max{i+1}(q,2))^2);
            l_alpha(i,q)=atan2((c_max{i+1}(q,2)-c_max{i}(q,2)),(c_max{i+1}(q,1)-c_max{i}(q,1)))*180/pi;
            
%             line([c_max{i+1}(q,1) c_max{i}(q,1) ],[c_max{i+1}(q,2) c_max{i}(q,2)],'LineWidth',5,'Color','k')
%             line([ 50 + 40 * cosd(l_alpha(i,q)) 50] , [ 50 + 40 * sind(l_alpha(i,q)) 50],'LineWidth',5,'Color','k')
            %plot(maxima{i}(2),maxima{i}(1),'ko','MarkerSize',20,'MarkerFaceColor','k')
        catch
            %display(sprintf('Couldnt calculate the correlation for the quadrant %d dat timestep %d',q,i));
            c_max{i+1}(q,1:1:2)=NaN;
        end
    end
    % anglechecking
    l_alpha360(i,:)=l_alpha(i,:);
    % 360� conversion for critical values
    if (sum(l_alpha360(i,:) < -90) > 0) & (sum(l_alpha360(i,:) > 90) > 0)
        beh=l_alpha360(i,:) < -90;
        idx=find(beh==1);
        l_alpha360(i,idx)=360+l_alpha360(i,idx);
    end
    
    
    for q=1:4
        
        
        if l_alpha360(i,q) < 0 & (sum(l_alpha360(i,:),'omitnan')-l_alpha360(i,q)) < 0
            alpha = abs(l_alpha360(i,q)) - abs((sum(l_alpha360(i,:),'omitnan')-l_alpha360(i,q))/(3-sum(isnan(l_alpha360(i,:)))));
        else
            alpha = l_alpha360(i,q) - (sum((l_alpha360(i,:)),'omitnan')-l_alpha360(i,q))/(3-sum(isnan(l_alpha360(i,:))));
        end
        if abs(alpha) > 67.5 & alpha_flag(i,q) ~=3
            alpha_flag(i,q)=1;
        elseif abs(alpha) <= 67.5 & alpha_flag(i,q) ~=3
            alpha_flag(i,q)=0;
        end
        
        
        dist(q)=sqrt((c_max{i}(q,1)-ceil(d_n/2))^2+(c_max{i}(q,2)-ceil(d_n/2))^2)*res;
        if dist(q) > 19000 & alpha_flag(i,q)==0
                
                if (l_beta(i,q)-better_beta_parameter)>=0
                    
                    if (l_beta(i,q) - better_beta_parameter) -l_alpha360(i,q) >= 0
                        alpha_flag(i,q)=2; % EDGE
                    end
                    
                elseif (l_beta(i,q) -l_alpha360(i,q) + better_beta_parameter) >= 0
                    alpha_flag(i,q)=2; % EDGE
                end
                
                if (l_beta(i,q) + better_beta_parameter)<=360
                    
                    if (l_beta(i,q) + better_beta_parameter) -l_alpha360(i,q) < 0
                        alpha_flag(i,q)=2; % EDGE
                    end
                    
                elseif (l_beta(i,q) +l_alpha360(i,q) - better_beta_parameter) > 360
                        alpha_flag(i,q)=2; % EDGE
                end
        
        end

    end
    
%     if sum(~isnan(alpha_flag(i,:)),'omitnan')==1 & sum(alpha_flag(i,:),'omitnan')~=3
%         alpha_flag(i,find(~isnan(alpha_flag(i,:))))=0;
%     end
    


    if sum(l_alpha360(i,:) < 270 & l_alpha360(i,:) > 90) ~= 0
        dir(i)=sum(l_alpha360(i,:).*(alpha_flag(i,:)==0),'omitnan')/sum(alpha_flag(i,:)==0,'omitnan');
    else
        
        for q=1:4
            if l_alpha360(i,q) > 180
                l_alpha360(i,q)= l_alpha360(i,q)-360;
            end
        end
        
        if sum(alpha_flag(i,:)==0)>=1
            dir(i)=sum(l_alpha360(i,:).*(alpha_flag(i,:)==0),'omitnan')/sum(alpha_flag(i,:)==0,'omitnan');
        end

    end
    v(i)=sum(l_len(i,:).*(alpha_flag(i,:)==0),'omitnan')/sum(alpha_flag(i,:)==0,'omitnan');
    
    if dir(i)<0
        dir(i)=dir(i)+360;
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
%    hold off
end
%%
v_bar=nan(prog,1);
dir_bar=nan(prog,1);
delta_dir=nan(prog,1);
delta_v=nan(prog,1);
dir_=dir;
for k=1+uk:prog
    v_bar(k)=mean(v(k-uk:k),'omitnan')*res;
    dir_bar(k)=mean(dir(k-uk:k),'omitnan');
    if (sum(dir(k-uk:k)>0 & dir(k-uk:k) < 90)~= 0) & (sum(dir(k-uk:k)>270 & dir(k-uk:k)<360) ~=0)
        for l=-uk:1:0
            if dir(k+l)>180
                dir_(k+l)=dir(k+l)-360;
            end
        end
        dir_bar(k)=mean(dir_(k-uk:k),'omitnan');
    end
    if dir_bar(k)<0
        dir_bar(k) = dir_bar(k)+360;
    end
end
v_bar_s=v_bar/30;

for k=1+uk:prog
    delta_v(k)=v_bar_s(k)-v_bar_s(k-1);
    delta_dir(k)=dir_bar(k)-dir_bar(k-1);
end

cut_data=nested_data(2*c_range+1:2*c_range+d_s,2*c_range+1:2*c_range+d_s,:);


delta_x=v_bar(prog)*cosd(dir_bar(prog));
delta_y=v_bar(prog)*sind(dir_bar(prog));



X_prog=NaN(d_s,d_s,progtime);
Y_prog=NaN(d_s,d_s,progtime);
prog_data=NaN(d_s,d_s,progtime);
if ~isnan(delta_x) || ~isnan(delta_y)
    for k=1:progtime
    prog_data(:,:,k)= griddata((x_car+delta_x*k)+delta_v(prog)*30*k*cosd(dir_bar(prog)+delta_dir(prog)*k),...
    (y_car+delta_y*k)+delta_v(prog)*30*k*sind(dir_bar(prog)+delta_dir(prog)*k),...
    cut_data(:,:,prog+1),X,Y,'natural');
    cut_data(:,:,prog+1+k)=cut_data(:,:,prog+1+k)+NaNmask(prog_data(:,:,k),cut_data(:,:,prog+1+k));
%    contourf(log(prog_data(:,:,k)),log(Contours))
%    hold on
%    contour(log(cut_data(:,:,prog+1+k)),log(Contours))
    
%    colorbar('YTick',log(Contours),'YTickLabel',Contours);
%    colormap(jet);
%    caxis(log([Contours(1) Contours(length(Contours))]));
%    colorbar('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);
%    hold on
    if k== timesteps-prog-1
        break
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
    end
end
%% data evaluation

real_data=cut_data(:,:,prog:end);
prognosis_data=prog_data(:,:,1:end-1);

for i=1:size(prognosis_data,3)
    real_data(:,:,i)=real_data(:,:,i)+NaNmask(real_data(:,:,i),prognosis_data(:,:,i));
end

 for i=1:size(prognosis_data,3)
    co1(i)=NaNcorr(real_data(:,:,i),prognosis_data(:,:,i));
    real_ones_data=real_data(:,:,i);
    real_ones_data=real_ones_data(:);
    real_ones_data(real_ones_data>0.1)=1;
    real_ones_data(real_ones_data<=0.1)=0;
    
    prognosis_ones_data=prognosis_data(:,:,i);
    prognosis_ones_data=prognosis_ones_data(:);
    prognosis_ones_data(prognosis_ones_data>0.1)=1;
    prognosis_ones_data(prognosis_ones_data<=0.1)=0;
    co2(i)=NaNcorr(real_ones_data,prognosis_ones_data);
 end

end

