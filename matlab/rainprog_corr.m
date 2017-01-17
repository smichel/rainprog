close all; clear;

path=strcat('/home/zmaw/u300675/pattern_data/');
files=dir(path);
files=files(3:end);
len=length(files);

for j=1
    for i=1
        res=200;
        prog=(i+2)*5;
        progtime=20;
        uk=5;
        timesteps=prog+progtime+5;
        [co1{j,i},co2{j,i}]=rainprog(res,timesteps,prog,progtime,uk,strcat(path,files(j).name));
    end
    display(sprintf('Progress %d%%',floor(j/len*100)));
end

colors=winter(size(co1,1));

figure
plot(0.5,'k')
hold on
for j=1:size(co1,1)
    for i=1:size(co1,1)
        plot(co2{j,i},'Color',colors(j,:),'LineWidth',2)
    end
end

