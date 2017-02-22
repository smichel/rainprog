close all; clear;
%E:/Rainprog/m4t_BKM_wrx00_l2_dbz_v00_20130511170000.nc
path=strcat('/home/zmaw/u300675/pattern_data/');
%path=strcat('E:/Rainprog/data/');
files=dir(path);
files=files(3:end);
len=length(files);
t_len=5;
progtime=30;
plots=0;
rain_threshold=0.2; % rain threshold

parfor j=1:len
    for i=1:10
      try
        res=200;
        prog=(i+4)*5;
        uk=7;
        timesteps=prog+progtime+5;
        [S{j,i},A{j,i},L{j,i},L_1{j,i},L_2{j,i}]=rainprog(rain_threshold,res,timesteps,prog,progtime,uk,strcat(path,files(j).name));
       catch
            S{j,i}=[];
            A{j,i}=[];
            L{j,i}=[];
            L_1{j,i}=[];
            L_2{j,i}=[];
        end
    end
    %display(sprintf('Progress %d%%',floor(j/len*100)));
end

save('SAL_HWT+BKM.mat');
