close all; clear;
for i=1:1:10
    for res=100:100:200
    prog=(i+2)*5;
    progtime=15;
    uk=5;
    timesteps=(i+2)*5+progtime+5;
    tic
    [co1{i,res/100},co2{i,res/100}]=rainprog(res,timesteps,prog,progtime,uk,'E:/Rainprog/m4t_BKM_wrx00_l2_dbz_v00_20130511160000.nc');
    toc
    end
end

colors=hsv(length(co1));

figure
plot(0.5,'k')
hold on
plot(0.5,'k-.')
legend('Auflösung 100m','Auflösung 200m')
for i=1:length(co1)
plot(co1{i,1},'Color',colors(i,:),'LineWidth',2)
end
for i=1:length(co1)
plot(co1{i,2},'Color',colors(i,:),'Linestyle','-.','LineWidth',2)
end