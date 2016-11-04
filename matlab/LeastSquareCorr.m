function[c_d]=LeastSquareCorr(d,c)
%Calculates a leastsquare correlation between 2 matrices c and d

c_l=length(c);
d_l=length(d);

c_d=zeros(d_l+c_l-1,d_l+c_l-1);
corr=ones(d_l+2*c_l-2,d_l+2*c_l-2)*inf;
corr(c_l:d_l+c_l-1,c_l:d_l+c_l-1)=d;


k=1;m=1;
for i=1:d_l+c_l-1
    for j=1:d_l+c_l-1
        c_d(k,m)=sum(sum((corr(i:i+c_l-1,j:j+c_l-1)-c).^2));
        m=m+1;
    end
    m=1;
    k=k+1;
end

end