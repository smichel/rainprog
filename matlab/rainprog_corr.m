close all; clear;
for i=1:1:13
    prog=(i+2)*5;
    progtime=20;
    uk=5;
    timesteps=(i+2)*5+progtime+5;
    j=1;
    tic
    [co1{i},co2{i}]=rainprog(timesteps,prog,progtime,uk,'E:/Rainprog/m4t_BKM_wrx00_l2_dbz_v00_20130511170000.nc');
    toc
    j=j+1;
end