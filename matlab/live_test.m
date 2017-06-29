clear;
close all;
name='/scratch/uni/u237/users/smichel/pattern_live/online_HHG.txt';
data=zeros(333,360);
res=200;
progtime=60;
datalen=8;   %number of timesteps over which the prognosis will run
rain_threshold=0.1;
num_maxes=6; %maximum numbers of points for the correlation boxes
fileInfo=dir(name);
timeStamp=fileInfo.date;
data=dlmread(name,',',5,0);
parpool(4)
while true
    n_fileInfo=dir(name);
    n_timeStamp=n_fileInfo.date;
    if ~strcmp(n_timeStamp,timeStamp)
        data=cat(3, dlmread(name,',',5,0),data);
        fileInfo=dir(name);
        timeStamp=fileInfo.date;
        display(size(data,3))
        if size(data,3)==datalen
            display('Created a composit of 7 timesteps');
            tic
%             data=ncread('/home/zmaw/u300675/pattern_data/m4t_BKM_wrx00_l2_dbz_v00_20130426170000.nc','dbz_ac1');
%             data=data(:,:,1:7);
            prog_data=rainprog_live(res,progtime,rain_threshold,data,num_maxes);
            data_name=strcat(timeStamp(1:2),'_',timeStamp(4:6),'_',timeStamp(8:11),'_',timeStamp(end-7:end-6),'_',timeStamp(end-4:end-3),'_',timeStamp(end-1:end));
            ncid=netcdf.create(strcat('/scratch/uni/u237/users/smichel/pattern_live/',data_name,'.nc'),'CLOBBER');
            dimidrow=netcdf.defDim(ncid,'rows',size(prog_data,1));
            dimidcol=netcdf.defDim(ncid,'clo',size(prog_data,2));
            dimidtime=netcdf.defDim(ncid,'time',size(prog_data,3));
            varid=netcdf.defVar(ncid,'prog_data','NC_DOUBLE',[dimidrow dimidcol dimidtime]);
            netcdf.endDef(ncid);
            netcdf.putVar(ncid,varid,prog_data);
            netcdf.close(ncid);
            display('Prognosis successfull for the next 30 minutes')
            toc
        end
    end
    
    if size(data,3)==datalen
        data(:,:,end)=[];
    end
    pause(1)
end
figure
for i=8:-1:1
    imagesc(data(:,:,i),[0 100]);
    colorbar
        drawnow
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if i == 8
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append');
        end
end
