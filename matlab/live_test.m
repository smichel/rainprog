clear;
close all;
name='/scratch/uni/u237/users/smichel/pattern_live/online_HHG.txt';
data=zeros(333,360);
res=200;
progtime=60;
rain_threshold=0.1;
fileInfo=dir(name);
timeStamp=fileInfo.date;
while true
    n_fileInfo=dir(name);
    n_timeStamp=n_fileInfo.date;
    if ~strcmp(n_timeStamp,timeStamp)
        data=cat(3, dlmread(name,',',5,0),data);
        fileInfo=dir(name);
        timeStamp=fileInfo.date;
        prog_data=rainprog_live(res,progtime,rain_threshold,data,num_maxes);
        ncid=netcdf.create('/scratch/uni/u237/users/smichel/pattern_live/prog_data.nc','NOCLOBBER');
        dimidrow=netcdf.defDim(ncid,'rows',size(prog_data,1));
        dimidcol=netcdf.defDim(ncid,'clo',size(prog_data,2));
        varid=netcdf.defVar(ncid,'dbz_ac1','NC_DOUBLE',[dimidrow dimidcol]);
        netcdf.endDef(ncid);
        netcdf.putVar(ncid,varid,dbz_ac1)
        netcdf.close(ncid)
    end
    
    if size(data,3)>7
        data(:,:,end)=[];
    end
    pause(1)
end
