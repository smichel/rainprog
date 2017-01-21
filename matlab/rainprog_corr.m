close all; clear;

path=strcat('/home/zmaw/u300675/pattern_data/');
files=dir(path);
files=files(3:11);
len=length(files);

for j=1:len
    parfor i=1:13
        res=200;
        prog=(i+2)*5;
        progtime=30;
        uk=5;
        timesteps=prog+progtime+5;
        [co1{j,i},co2{j,i}]=rainprog(res,timesteps,prog,progtime,uk,strcat(path,files(j).name));
        uk=7;
        [co1_7{j,i},co2_7{j,i}]=rainprog(res,timesteps,prog,progtime,uk,strcat(path,files(j).name));
    end
    display(sprintf('Progress %d%%',floor(j/len*100)));
end

colors=winter(size(co1,1));

figure
plot(0.5,'k')
hold on
k=1;
for j=1:size(co1,1)
    for i=1:size(co1,1)
        plot(co1{j,i},'Color',colors(j,:),'LineWidth',2)
        if co1{j,i}(1)<0.7
            corr_low(k,1)=j;
            corr_low(k,2)=i;
            k=k+1;
        end
    end
end


figure
plot(0.5,'k')
hold on
k=1;
for j=1:size(co1,1)
    for i=1:size(co1,1)
        plot(co1_7{j,i},'Color',colors(j,:),'LineWidth',2)
        if co1_7{j,i}(1)<0.7
            corr_7_low(k,1)=j;
            corr_7_low(k,2)=i;
            k=k+1;
        end
    end
end