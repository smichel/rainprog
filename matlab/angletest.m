clear; close all;
uk=5;
%dir=randi([90 360],prog,1);
dir=(0:30:360);
dir=[dir,30];dir=[dir,60];
dir=[dir,90];
prog=length(dir);
v_bar=nan(prog,1);
dir_bar=nan(prog,1);
delta_dir=nan(prog,1);
delta_v=nan(prog,1);
%%
dir_=dir;
for k=1+uk:prog
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
dir=dir'; dir_=dir_';