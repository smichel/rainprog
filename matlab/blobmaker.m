function [ data_car ] = blobmaker(u,v,x0,y0,res,amp,sigma,timesteps)

gauss_blob=zeros((40000/res)+1,(40000/res)+1,timesteps);
data_car=cell(timesteps,1);
for t=1:timesteps
    x0=x0+u;
    y0=y0+v;
    for x=1:40000/res+1
        for y=1:40000/res+1
            gauss_blob(x,y,t)=amp*exp(-((x-x0)^2/(2*sigma^2)+(y-y0)^2/(2*sigma^2)));
%             if f>0.1
%                 gauss_blob(x,y,t)=f;
%             end
            if gauss_blob(x,y,t)<0.1
                gauss_blob(x,y,t)=0.0001;
            end
        end
    end
    
    data_car{t}=gauss_blob(:,:,t);
end

end
