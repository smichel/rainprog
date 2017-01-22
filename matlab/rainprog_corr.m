close all; clear;

path=strcat('/home/zmaw/u300675/pattern_data/');
files=dir(path);
files=files(3:end);
len=length(files);

parfor j=1:len
    for i=1:13
        try
        res=200;
        prog=(i+2)*5;
        progtime=30;
        uk=5;
        timesteps=prog+progtime+5;
        [co1{j,i},co2{j,i}]=rainprog(res,timesteps,prog,progtime,uk,strcat(path,files(j).name));
        res=100;
        [co1_7{j,i},co2_7{j,i}]=rainprog(res,timesteps,prog,progtime,uk,strcat(path,files(j).name));
        catch
            co1{j,i}=NaN(1,progtime-1);
            co2{j,i}=NaN(1,progtime-1);
            co1_7{j,i}=NaN(1,progtime-1);
            co2_7{j,i}=NaN(1,progtime-1);
        end
    end
    %display(sprintf('Progress %d%%',floor(j/len*100)));
end

colors=winter(size(co1,1));



% figure
% plot(0.5,'k')
% hold on
k=1;
for j=1:size(co1,1)
    for i=1:size(co1,2)
        %plot(co1{j,i},'Color',colors(j,:),'LineWidth',2)
        for k=1:size(co1{j,i},2)
            cor1(j,i,k)=co1{j,i}(k);
        end
        if co1{j,i}(1)<0.7
            corr_low(k,1)=j;
            corr_low(k,2)=i;
            k=k+1;
        end
    end
end

%plot(squeeze(mean(mean(cor1(:,:,:),2,'omitnan'),'omitnan')),'Color',[0 0 0],'LineWidth',5)

% figure
% plot(0.5,'k')
% hold on
k=1;
for j=1:size(co1,1)
    for i=1:size(co1,2)
%         plot(co1_7{j,i},'Color',colors(j,:),'LineWidth',2)
        for k=1:size(co1_7{j,i},2)
            cor1_7(j,i,k)=co1_7{j,i}(k);
        end
        if co1_7{j,i}(1)<0.7
            corr_7_low(k,1)=j;
            corr_7_low(k,2)=i;
            k=k+1;
        end
    end
end
% plot(squeeze(mean(mean(cor1_7(:,:,:),2,'omitnan'),'omitnan')),'Color',[0 0 0],'LineWidth',5)
save('correlation_factors6.mat');
% figure
% plot(squeeze(mean(mean(cor1_7(:,:,:),2,'omitnan'),'omitnan'))-squeeze(mean(mean(cor1(:,:,:),2,'omitnan'),'omitnan')))
