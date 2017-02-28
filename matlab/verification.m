function [BIAS,CSI,FAR,ORSS,PC,POD,hit,miss,f_alert,corr_zero]=verification(prog_data,real_data)
%for documentation see master thesis: Niederschlags-Nowcasting für ein
%hochaufgeloestes X-Band Regenradar from Timur Eckmann



p_data=prog_data;
r_data=real_data;

time=size(prog_data,3);

p_nans=~isnan(p_data);
p_nans=double(p_nans==0);
p_nans(p_nans==1)=NaN;

r_nans=~isnan(r_data);
r_nans=double(r_nans==0);
r_nans(r_nans==1)=NaN;

rain_thresholds=[0.1 0.2 0.5 1 2 5 10 20 30];
num_r=length(rain_thresholds);

hit=zeros(time,num_r);
miss=zeros(time,num_r);
f_alert=zeros(time,num_r);
corr_zero=zeros(time,num_r);
total=zeros(time,num_r);
BIAS=zeros(time,num_r);
PC=zeros(time,num_r);
POD=zeros(time,num_r);
FAR=zeros(time,num_r);
CSI=zeros(time,num_r);
ORSS=zeros(time,num_r);

for r=1:num_r
    p_dat=(p_data>rain_thresholds(r))+p_nans;
    r_dat=(r_data>rain_thresholds(r))+r_nans;
    
    for i=1:time
        hit(i,r)=sum(sum(r_dat(:,:,i)==1&p_dat(:,:,i)==1));
        miss(i,r)=sum(sum(r_dat(:,:,i)==1&p_dat(:,:,i)==0));
        f_alert(i,r)=sum(sum(r_dat(:,:,i)==0&p_dat(:,:,i)==1));
        corr_zero(i,r)=sum(sum(r_dat(:,:,i)==0&p_dat(:,:,i)==0));
        total(i,r)=hit(i,r)+miss(i,r)+f_alert(i,r)+corr_zero(i,r);
        
        BIAS(i,r)=(hit(i,r)+f_alert(i,r))/(hit(i,r)+miss(i,r));
        
        PC(i,r)=(hit(i,r)+corr_zero(i,r))/(total(i,r)); % proportion correct
        POD(i,r)=hit(i,r)/(hit(i,r)+miss(i,r));          % probability of detection
        FAR(i,r)=f_alert(i,r)/(f_alert(i,r)+hit(i,r));   % false alarm ration
        CSI(i,r)=hit(i,r)/(hit(i,r)+miss(i,r)+f_alert(i,r));  % critical success index
        ORSS(i,r)=(hit(i,r)*corr_zero(i,r)-f_alert(i,r)*miss(i,r))/(hit(i,r)*corr_zero(i,r)+f_alert(i,r)*miss(i,r));
        % odds ratio skill score
        
    end
end
end