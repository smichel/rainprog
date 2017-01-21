function[corr]=NaNcorr(x,y)
%Calculates the correlation between 2 matrices x and y whilst ignoring NaNs
x=x(:);
y=y(:);

x_bar=mean(x,'omitnan');
y_bar=mean(y,'omitnan');


corr=sum((x-x_bar).*(y-y_bar),'omitnan')/...
        sqrt((sum((x-x_bar).^2,'omitnan'))*(sum((y-y_bar).^2,'omitnan')));

if x==y    
    corr=1;
elseif x==-y
    corr=-1;
end
end
