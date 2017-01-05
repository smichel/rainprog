function[mask]=NaNmask(x,y)
x(x==0)=NaN;
y(y==0)=NaN;
mask=x*0+y*0;

end