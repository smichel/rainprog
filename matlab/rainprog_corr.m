close all; clear;
parfor i=1:1:10
    for res=1:2
    prog=(i+2)*5;
    progtime=15;
    uk=5;
    timesteps=(i+2)*5+progtime+5;
    tic
    [co1{i,res},co2{i,res}]=rainprog(res*100,timesteps,prog,progtime,uk,'E:/Rainprog/m4t_BKM_wrx00_l2_dbz_v00_20130511170000.nc');
    toc
    end
end

colors=hsv(length(co1));
figure
for i=1:length(co1)
plot(co1{i,1},'Color',colors(i,:))
hold on
end
for i=1:length(co1)
plot(co1{i,2},'Color',colors(i,:),'Linestyle','-.')
hold on
end