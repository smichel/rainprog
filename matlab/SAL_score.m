clear;close all;
load('SAL_data.mat');

timesteps=size(prognosis_data,3);
real_data=real_data(:,:,1:timesteps);
res=40000/(size(prognosis_data,1)-1);

p_data=reshape(prognosis_data,size(prognosis_data,1)*size(prognosis_data,2),timesteps);
p_data_vals=p_data;
p_data(isnan(p_data))=0;
p_data(p_data<0.01)=0;
p_data(p_data>=0.01)=1;
p_data=reshape(p_data,size(prognosis_data,1),size(prognosis_data,2),timesteps);

p_CC=cell(timesteps,1);
p_RR_sum=zeros(timesteps,1);

r_data=reshape(real_data,size(real_data,1)*size(real_data,2),timesteps);
r_data_vals=r_data;
r_data(isnan(r_data))=0;
r_data(r_data<0.01)=0;
r_data(r_data>=0.01)=1;
r_data=reshape(r_data,size(real_data,1),size(real_data,2),timesteps);

r_CC=cell(timesteps,1);
r_RR_sum=zeros(timesteps,1);

img=real_data(:,:,1);
[x, y] = meshgrid(1:size(img, 2), 1:size(img, 1));
r_xcenter=zeros(timesteps,1);
r_ycenter=zeros(timesteps,1);
p_xcenter=zeros(timesteps,1);
p_ycenter=zeros(timesteps,1);

r_V=zeros(30,1);
p_V=zeros(30,1);

for i=1:timesteps
    r_CC{i}=bwconncomp(r_data(:,:,i));
    if(length(r_CC{i}.PixelIdxList)~=0)
        for j=1:length(r_CC{i}.PixelIdxList)
            if numel(r_CC{i}.PixelIdxList{j})<3
                r_CC{i}.PixelIdxList{j}=[];
            else
                r_RR{i,j}=r_data_vals(r_CC{i}.PixelIdxList{j},i);%raterates in each cell
                r_RR_max{i,j}=max(r_RR{i,j});%max rainrate of each cell
                r_RR_cellsum{i,j}=sum(r_RR{i,j});%total rainrate in each cell
                r_RR_sum(i)=r_RR_sum(i)+sum(r_RR{i,j});%total rainrate in the field
                r_Vs{i,j}=sum(r_RR{i,j})/r_RR_max{i,j};%scaled volume of each cell
                r_V(i)=r_V(i)+((r_Vs{i,j}*r_RR_cellsum{i,j})/r_RR_cellsum{i,j});
                r_cell_x{i,j}=ceil(r_CC{i}.PixelIdxList{j}/(res+1));
                r_cell_y{i,j}=mod(r_CC{i}.PixelIdxList{j},res+1);
                img=zeros(201);
                for cell_size=1:length(r_cell_x{i,j})
                    img(r_cell_x{i,j}(cell_size),r_cell_y{i,j}(cell_size))=real_data(r_cell_x{i,j}(cell_size),r_cell_y{i,j}(cell_size),i);
                end
                weightedx = x .* img;
                weightedy = y .* img;
                r_cell_xcenter{i,j} = sum(weightedx(:),'omitnan') / sum(img(:),'omitnan');
                r_cell_ycenter{i,j} = sum(weightedy(:),'omitnan') / sum(img(:),'omitnan');
                
            end
        end
        img=real_data(:,:,i);
        weightedx = x .* img;
        weightedy = y .* img;
        r_xcenter(i) = sum(weightedx(:),'omitnan') / sum(img(:),'omitnan');
        r_ycenter(i) = sum(weightedy(:),'omitnan') / sum(img(:),'omitnan');
    end
end

for i=1:timesteps
    p_CC{i}=bwconncomp(p_data(:,:,i));
    if(length(p_CC{i}.PixelIdxList)~=0)
        for j=1:length(p_CC{i}.PixelIdxList)
            if numel(p_CC{i}.PixelIdxList{j})<3
                p_CC{i}.PixelIdxList{j}=[];
            else
                p_RR{i,j}=p_data_vals(p_CC{i}.PixelIdxList{j},i);%raterates in each cell
                p_RR_max{i,j}=max(p_RR{i,j});%max rainrate of each cell
                p_RR_cellsum{i,j}=sum(p_RR{i,j});%total rainrate in each cell
                p_RR_sum(i)=p_RR_sum(i)+sum(p_RR{i,j});%total rainrate in the field
                p_Vs{i,j}=sum(p_RR{i,j})/p_RR_max{i,j};%scaled volume of each cell
                p_V(i)=p_V(i)+((p_Vs{i,j}*p_RR_cellsum{i,j})/p_RR_cellsum{i,j});
                p_cell_x{i,j}=ceil(p_CC{i}.PixelIdxList{j}/(res+1));
                p_cell_y{i,j}=mod(p_CC{i}.PixelIdxList{j},res+1);
                img=zeros(201);
                for cell_size=1:length(p_cell_x{i,j})
                    img(p_cell_x{i,j}(cell_size),p_cell_y{i,j}(cell_size))=prognosis_data(p_cell_x{i,j}(cell_size),p_cell_y{i,j}(cell_size),i);
                end
                weightedx = x .* img;
                weightedy = y .* img;
                p_cell_xcenter{i,j} = sum(weightedx(:),'omitnan') / sum(img(:),'omitnan');
                p_cell_ycenter{i,j} = sum(weightedy(:),'omitnan') / sum(img(:),'omitnan');
            end
        end
        
    end
    img=prognosis_data(:,:,i);
    weightedx = x .* img;
    weightedy = y .* img;
    p_xcenter(i) = sum(weightedx(:),'omitnan') / sum(img(:),'omitnan');
    p_ycenter(i) = sum(weightedy(:),'omitnan') / sum(img(:),'omitnan');
    
end






S=zeros(timesteps,1);
A=zeros(timesteps,1);
L_1=zeros(timesteps,1);
L_2=zeros(timesteps,1);
L=zeros(timesteps,1);
r_R=zeros(timesteps,1);
p_R=zeros(timesteps,1);

for i=1:timesteps
    S(i)=(p_V(i)-r_V(i))/(0.5*(p_V(i)+r_V(i)));
    A(i)=(p_RR_sum(i)-r_RR_sum(i))/(0.5*(p_RR_sum(i)+r_RR_sum(i)));
    L_1(i)=abs(sqrt((p_xcenter(i)-r_xcenter(i))^2+(p_ycenter(i)-r_ycenter(i))^2))/res;
    for j=1:size(r_cell_xcenter,2)
        if ~isempty(r_cell_xcenter{i,j})
            r_x_xn{i,j}=abs(sqrt((r_xcenter(i)-r_cell_xcenter{i,j})^2+(r_ycenter(i)-r_cell_ycenter{i,j})^2));
            if ~isnan(r_x_xn{i,j})
                r_R(i)=r_R(i)+(r_RR_cellsum{i,j}*r_x_xn{i,j});
            end
        end
    end
    r_R(i)=r_R(i)/r_RR_sum(i);
    
    for j=1:size(p_cell_xcenter,2)
        if ~isempty(p_cell_xcenter{i,j})
            p_x_xn{i,j}=abs(sqrt((p_xcenter(i)-p_cell_xcenter{i,j})^2+(p_ycenter(i)-p_cell_ycenter{i,j})^2));
            if ~isnan(p_x_xn{i,j})
                p_R(i)=p_R(i)+(p_RR_cellsum{i,j}*p_x_xn{i,j});
            end
        end
    end
    p_R(i)=p_R(i)/p_RR_sum(i);
    L_2(i)=2*((abs(p_R(i)-r_R(i)))/res);
    L(i)=L_1(i)+L_2(i);
end

scatter(S,A,30,L,'filled')
colorbar
xlim([-2 2])
ylim([-2 2])
caxis([-2 2])

v = get(gca);
lh = line([0 0 NaN v.XLim],[v.YLim NaN 0 0 ])
set(lh,'Color',[.25 .25 .25],'LineStyle',':')
