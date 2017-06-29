function [prog_data] = rainprog_live(res,progtime,rain_threshold,indata,num_maxes)
data=indata;
timesteps=size(data,3);
azi=(0:359)';
range=[59.958488 119.91698 179.87546 239.83395 299.79245 359.75095 419.70944 479.66794 539.62640 599.58490 659.54340 719.50189 779.46039 839.41888 899.37738 959.33588 1019.2944 1079.2528 1139.2113 1199.1698 1259.1283 1319.0868 1379.0453 1439.0038 1498.9623 1558.9208 1618.8793 1678.8378 1738.7963 1798.7548 1858.7133 1918.6718 1978.6302 2038.5887 2098.5471 2158.5056 2218.4641 2278.4226 2338.3811 2398.3396 2458.2981 2518.2566 2578.2151 2638.1736 2698.1321 2758.0906 2818.0491 2878.0076 2937.9661 2997.9246 3057.8831 3117.8416 3177.8000 3237.7585 3297.7170 3357.6755 3417.6340 3477.5925 3537.5510 3597.5095 3657.4680 3717.4265 3777.3850 3837.3435 3897.3020 3957.2605 4017.2190 4077.1775 4137.1357 4197.0942 4257.0527 4317.0112 4376.9697 4436.9282 4496.8867 4556.8452 4616.8037 4676.7622 4736.7207 4796.6792 4856.6377 4916.5962 4976.5547 5036.5132 5096.4717 5156.4302 5216.3887 5276.3472 5336.3057 5396.2642 5456.2227 5516.1812 5576.1396 5636.0981 5696.0566 5756.0151 5815.9736 5875.9321 5935.8906 5995.8491 6055.8076 6115.7661 6175.7246 6235.6831 6295.6416 6355.6001 6415.5586 6475.5171 6535.4756 6595.4341 6655.3926 6715.3511 6775.3096 6835.2681 6895.2266 6955.1851 7015.1436 7075.1021 7135.0605 7195.0190 7254.9775 7314.9360 7374.8945 7434.8530 7494.8115 7554.7700 7614.7285 7674.6870 7734.6455 7794.6040 7854.5625 7914.5210 7974.4795 8034.4380 8094.3965 8154.3550 8214.3135 8274.2715 8334.2295 8394.1875 8454.1455 8514.1035 8574.0615 8634.0195 8693.9775 8753.9355 8813.8936 8873.8516 8933.8096 8993.7676 9053.7256 9113.6836 9173.6416 9233.5996 9293.5576 9353.5156 9413.4736 9473.4316 9533.3896 9593.3477 9653.3057 9713.2637 9773.2217 9833.1797 9893.1377 9953.0957 10013.054 10073.012 10132.970 10192.928 10252.886 10312.844 10372.802 10432.760 10492.718 10552.676 10612.634 10672.592 10732.550 10792.508 10852.466 10912.424 10972.382 11032.340 11092.298 11152.256 11212.214 11272.172 11332.130 11392.088 11452.046 11512.004 11571.962 11631.920 11691.878 11751.836 11811.794 11871.752 11931.710 11991.668 12051.626 12111.584 12171.542 12231.500 12291.458 12351.416 12411.374 12471.332 12531.290 12591.248 12651.206 12711.164 12771.122 12831.080 12891.038 12950.996 13010.954 13070.912 13130.870 13190.828 13250.786 13310.744 13370.702 13430.660 13490.618 13550.576 13610.534 13670.492 13730.450 13790.408 13850.366 13910.324 13970.282 14030.240 14090.198 14150.156 14210.114 14270.072 14330.030 14389.988 14449.946 14509.904 14569.862 14629.820 14689.778 14749.736 14809.694 14869.652 14929.610 14989.568 15049.526 15109.484 15169.442 15229.400 15289.358 15349.316 15409.274 15469.232 15529.190 15589.148 15649.106 15709.064 15769.022 15828.980 15888.938 15948.896 16008.854 16068.813 16128.771 16188.729 16248.687 16308.645 16368.603 16428.561 16488.520 16548.479 16608.438 16668.396 16728.355 16788.314 16848.273 16908.232 16968.191 17028.150 17088.109 17148.068 17208.027 17267.986 17327.945 17387.904 17447.863 17507.822 17567.781 17627.740 17687.699 17747.658 17807.617 17867.576 17927.535 17987.494 18047.453 18107.412 18167.371 18227.330 18287.289 18347.248 18407.207 18467.166 18527.125 18587.084 18647.043 18707.002 18766.961 18826.920 18886.879 18946.838 19006.797 19066.756 19126.715 19186.674 19246.633 19306.592 19366.551 19426.510 19486.469 19546.428 19606.387 19666.346 19726.305 19786.264 19846.223 19906.182 19966.141];
%Variables
%Gridvars:
% timesteps=30; % Number of timesteps
% prog=10; % starttime of the prognosis
% progtime=15; % how many timesteps for the prognosis
% uk=5; % Number of interpolation points
% res=100; % horizontal resolution for the cartesian grid
% rain_threshold=0.1; % rain threshold

small_val=2; % small value for the mean - TO BE DISCUSSED

gif=0; % boolean for gif
filename='1st_prog.gif';

x=zeros(333,360);
y=zeros(333,360);

meta=size(data);
dataRain=zeros(333,360,meta(3));


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
nested_data= zeros(d_s+4*c_range,d_s+4*c_range,timesteps);
z=zeros(333,360,timesteps);
R=zeros(333,360,timesteps);

%transformation from polar to cartesian
%scatteredinterpolant was rejected
for i=1:timesteps
    if min(min(data(:,:,i)))<0
        z(:,:,i)=10.^(data(:,:,i)/10);
        for theta=1:360
            for r=1:333
                if data(r,theta,i)<=36.5
                    a=320;b=1.4;
                    R(r,theta,i)=(z(r,theta,i)/a)^(1/b);
                elseif data(r,theta,i)> 36.5 & data(r,theta,i) <= 44.0
                    a=200;b=1.6;
                    R(r,theta,i)=(z(r,theta,i)/a)^(1/b);
                else
                    a=77;b=1.9;
                    R(r,theta,i)=(z(r,theta,i)/a)^(1/b);
                end
                
            end
        end
    end
    R(:,:,i)=data(:,:,i);
    %data(:,:,i)=0.0364633*(10.^(data(:,:,i)/10)).^0.625;
    data_car{i}= griddata(x,y,R(:,:,i),X,Y);
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
%     if i == prog & max(max(nested_data(:,:,prog)))<rain_threshold*2
%         co1=NaN(progtime-1,1);
%         co2=NaN(progtime-1,1);
%         return 
%     end
    d_n=length(nested_data);
end
%nesting the array into a bigger array

maxima(1,1)=max(max(nested_data(:,:,1)));
[~,maxima(1,3)]=max(max(nested_data(:,:,1)));
[~,maxima(1,2)]=max(nested_data(:,maxima(1,3),1));
maxima=findMaxima(maxima,nested_data(:,:,1), c_range, num_maxes,rain_threshold);
maxima(isnan(maxima(:,1)),:)=[];

%figure
l_len=nan(timesteps,num_maxes);
l_alpha=nan(timesteps,num_maxes);
l_beta=nan(timesteps,num_maxes);
l_alpha360=nan(timesteps,num_maxes);
alpha_flag=nan(timesteps,num_maxes);
better_beta_parameter=80;
v=nan(timesteps,1);
dist=nan(num_maxes,1);
dir=nan(timesteps,1);
for i=1:timesteps-1
     for q=1:size(maxima,1)
        try
            if i ~=1
                try
                    if nested_data(maxima(q,2),maxima(q,3),i) == 0  ...% when c_max rans out of the circle of data
                            | nested_data(maxima(q,2),maxima(q,3),i) < rain_threshold ...% when the value is too small
                            | nested_data(maxima(q,2),maxima(q,3),i) / mean([nested_data(maxima(q,2),maxima(q,3),i),nested_data(maxima(q,2)+1, ...
                            maxima(q,3),i),nested_data(maxima(q,2)+1,maxima(q,3)+1,i),nested_data(maxima(q,2)-1,maxima(q,3),i), ...
                            nested_data(maxima(q,2)-1,maxima(q,3)-1,i)]) > small_val ... % when the mean around c_max is low - there is a high chance its scatter or some bullshit
                            & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) < rain_threshold % if maximum is too small in quadrant q
                        
                        maxima(q,2:1:3)=NaN;
                        alpha_flag(i,q)=NaN;
                        
                    elseif nested_data(maxima(q,2),maxima(q,3),i) == 0  ...% when c_max rans out of the circle of data
                            | nested_data(maxima(q,2),maxima(q,3),i) < rain_threshold ...% when the value is too small
                            | nested_data(maxima(q,2),maxima(q,3),i) / mean([nested_data(maxima(q,2),maxima(q,3),i),nested_data(maxima(q,2)+1, ...
                            maxima(q,3),i),nested_data(maxima(q,2)+1,maxima(q,3)+1,i),nested_data(maxima(q,2)-1,maxima(q,3),i), ...
                            nested_data(maxima(q,2)-1,maxima(q,3)-1,i)]) > small_val ... % when the mean around c_max is low - there is a high chance its scatter or some bullshit
                            & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) > rain_threshold % if maximum is too small in quadrant q
                        
                        maxima(q,:)=[];
                        maxima=findMaxima(maxima,nested_data(:,:,i),c_range,num_maxes);
                        alpha_flag(i,q)=3; % chose new maximum
                        %display(sprintf('Chose a new maximum in quadrant %d at timestep %d',q,i));
                    end
                    
                catch
                    if isnan(maxima(q,3)) & isnan(maxima(q,2)) & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) > rain_threshold
                        %c_max{i}(q,1:1:2)=maxima{i}(q,2:-1:1);
                        maxima(q,:)=[];
                        maxima=findMaxima(maxima,nested_data(:,:,i),c_range,num_maxes);
                        %display(sprintf('Chose a new maximum in quadrant %d dat timestep %d',q,i));
                        alpha_flag(i,q)=3; % chose new maximum
                        
                    elseif ~isnan(maxima(q,3)) & ~isnan(maxima(q,2)) & nested_data(maxima{i}(q,1),maxima{i}(q,2),i) < rain_threshold
                        
                        maxima(q,:)=[];
                        maxima=findMaxima(maxima,nested_data(:,:,i),c_range,num_maxes);
                        %c_max{i+1}(q,1:1:2)=NaN;
                        %display(sprintf('Couldnt find a new valid maximum in quadrant %d at timestep %d',q,i));
                        alpha_flag(i,q)=NaN;
                    end
                end
                
            end
            
            
            corr_area=nested_data((maxima(q,2)-c_range):(maxima(q,2)+c_range),(maxima(q,3)-c_range):(maxima(q,3)+c_range),i);
            
            data_area=nested_data((maxima(q,2)-c_range*2):(maxima(q,2)+c_range*2),(maxima(q,3)-c_range*2):(maxima(q,3)+c_range*2),i+1);
            
            C=LeastSquareCorr(data_area,corr_area);
            [ssr,snd]=min(C(:));
            [y_,x_]=ind2sub(size(C),snd);
            
%             c_max{i+1}(q,1)=maxima(q,3)-3*c_range+x_-1;
%             c_max{i+1}(q,2)=maxima(q,2)-3*c_range+y_-1;
            
            new_maxima(q,1)=nested_data(maxima(q,2)-3*c_range+y_-1,maxima(q,3)-3*c_range+x_-1,i);
            new_maxima(q,2)=maxima(q,2)-3*c_range+y_-1;
            new_maxima(q,3)=maxima(q,3)-3*c_range+x_-1;
            
            
            
            if alpha_flag(i,q)~=3
                alpha_flag(i,q)=0;
            end
%             if ((maxima(q,3) == new_maxima(q,3)) & (maxima(q,2) == new_maxima(q,2))) % when the position of c_max doesnt change after one timestep
%                 new_maxima(q,1:3)=NaN;
%                 alpha_flag(i+1,q)=NaN;
%             end
            %plot(maxima(q,3),maxima(q,2),'go','MarkerSize',20,'MarkerFaceColor','g')
            %plot(new_maxima(q,3),new_maxima(q,2),'bo','MarkerSize',20,'MarkerFaceColor','b')
            

            
            l_len(i,q)=sqrt((maxima(q,3)-new_maxima(q,3))^2+(maxima(q,2)-new_maxima(q,2))^2);
            l_alpha(i,q)=atan2((new_maxima(q,3)-maxima(q,3)),(new_maxima(q,2)-maxima(q,2)))*180/pi;
            l_beta(i,q)=(atan2((new_maxima(q,3)-(size(nested_data(:,:,1),1))/2)-1,(new_maxima(q,2)-(size(nested_data(:,:,1),1))/2)-1)*180/pi)+180;
            
            %line([new_maxima(q,3) maxima(q,3) ],[new_maxima(q,2) maxima(q,2)],'LineWidth',5,'Color','k')
            %line([ 50 + 40 * cosd(l_alpha(i,q)) 50] , [ 50 + 40 * sind(l_alpha(i,q)) 50],'LineWidth',5,'Color','k')
            
        catch
            %display(sprintf('Couldnt calculate the correlation for the quadrant %d at timestep %d',q,i));
            new_maxima(q,1:3)=NaN;
        end
        
    end
    maxima=new_maxima;
    maxima(isnan(maxima(:,1)),:)=[];
    maxima=findMaxima(maxima,nested_data(:,:,i+1),c_range,num_maxes,rain_threshold);
    maxima(isnan(maxima(:,1)),:)=[];

     % anglechecking
    l_alpha360(i,:)=l_alpha(i,:);
    % 360� conversion for critical values
    if (sum(l_alpha360(i,:) < -90) > 0) & (sum(l_alpha360(i,:) > 90) > 0)
        beh=l_alpha360(i,:) < -90;
        idx=find(beh==1);
        l_alpha360(i,idx)=360+l_alpha360(i,idx);
    end
    
    
    for q=1:size(maxima,1)
        
        
        if l_alpha360(i,q) < 0 & (sum(l_alpha360(i,:),'omitnan')-l_alpha360(i,q)) < 0
            alpha = abs(l_alpha360(i,q)) - abs((sum(l_alpha360(i,:),'omitnan')-l_alpha360(i,q))/((size(maxima,1)-1)-sum(isnan(l_alpha360(i,:)))));
        else
            alpha = l_alpha360(i,q) - (sum((l_alpha360(i,:)),'omitnan')-l_alpha360(i,q))/((size(maxima,1)-1)-sum(isnan(l_alpha360(i,:))));
        end
        if abs(alpha) > 67.5 & alpha_flag(i,q) ~=3
            alpha_flag(i,q)=1;
        elseif abs(alpha) <= 67.5 & alpha_flag(i,q) ~=3
            alpha_flag(i,q)=0;
        end
        
        dist(q)=sqrt((maxima(q,3)-ceil(d_n/2))^2+(maxima(q,2)-ceil(d_n/2))^2)*res;
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
        
        for q=1:size(maxima,1)
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
    
end
%%
dir_bar=nan(progtime,1);
delta_dir=nan(progtime,1);
delta_v=nan(progtime,1);
dir_=dir;
v_bar=mean((v),'omitnan')*res;
if (sum(dir(:)>0 & dir(:) < 90)~= 0) & (sum(dir(:)>270 & dir(:)<360) ~=0)
     for l=1:length(dir)
         if dir(l)>180
             dir_(l)=dir(l)-360;
         end
     end
end

dir_bar=mean(dir_,'omitnan');

if dir_bar<0
    dir_bar = dir_bar+360;
end

[vfit,~]=polyfit(1:length(v)-1,v(1:end-1)',1);
[dirfit,~]=polyfit(1:length(dir)-1,dir(1:end-1)',1);

delta_v=vfit(1)*res;
delta_dir=dirfit(1);


cut_data=nested_data(2*c_range+1:2*c_range+d_s,2*c_range+1:2*c_range+d_s,:);


delta_x=v_bar*cosd(dir_bar);
delta_y=v_bar*sind(dir_bar);
prog_data=NaN(d_s,d_s,progtime);
if ~isnan(delta_x) || ~isnan(delta_y)
    parfor k=1:progtime
    prog_data(:,:,k)= griddata((x_car+delta_x*k)+delta_v*k*cosd(dir_bar+delta_dir*k),...
    (y_car+delta_y*k)+delta_v*k*sind(dir_bar+delta_dir*k),...
    cut_data(:,:,end),X,Y,'natural');

%    cut_data(:,:,prog+1+k)=cut_data(:,:,prog+1+k)+NaNmask(prog_data(:,:,k),cut_data(:,:,prog+1+k));
%    contourf(log(prog_data(:,:,k)),log(Contours))
%    hold on
%    contour(log(cut_data(:,:,prog+1+k)),log(Contours))
    
%    colorbar('YTick',log(Contours),'YTickLabel',Contours);
%    colormap(jet);
%    caxis(log([Contours(1) Contours(length(Contours))]));
%    colorbar('FontSize',12,'YTick',log(Contours),'YTickLabel',Contours);
%    hold on

%     if gif == 1
%         drawnow
%         frame = getframe(1);
%         im = frame2im(frame);
%         [imind,cm] = rgb2ind(im,256);
%         if i == 1
%             imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%         else
%             imwrite(imind,cm,filename,'gif','WriteMode','append');
%         end
%     end
%     end
    end
end

