close all; clear;
load('verification.mat');

PC_size=size(PC);
PC_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));
BIAS_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));
POD_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));
FAR_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));
ORSS_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));
CSI_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));
hit_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));
miss_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));
f_alert_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));
corr_zero_=NaN(PC_size(1),PC_size(2),size(PC{1,1},1),size(PC{1,1},2));

for i=1:size(PC,1)
    for j=1:size(PC,2)
        for r=1:size(PC{1,1},2)
            if ~isempty(PC{i,j})
                for l=1:size(PC{1,1},1)
                    PC_(i,j,r,l)=PC{i,j}(l,r);
                    BIAS_(i,j,r,l)=BIAS{i,j}(l,r);
                    POD_(i,j,r,l)=POD{i,j}(l,r);
                    FAR_(i,j,r,l)=FAR{i,j}(l,r);
                    ORSS_(i,j,r,l)=ORSS{i,j}(l,r);
                    CSI_(i,j,r,l)=CSI{i,j}(l,r);
                    hit_(i,j,r,l)=hit{i,j}(l,r);
                    miss_(i,j,r,l)=miss{i,j}(l,r);
                    f_alert_(i,j,r,l)=f_alert{i,j}(l,r);
                    corr_zero_(i,j,r,l)=corr_zero{i,j}(l,r);
                end
            end
        end
    end
end
PC_(PC_==0)=NaN;
PC_(PC_==1)=NaN;
BIAS_(BIAS_==0)=NaN;
BIAS_(BIAS_==1)=NaN;
POD_(POD_==0)=NaN;
POD_(POD_==1)=NaN;
FAR_(FAR_==0)=NaN;
FAR_(FAR_==1)=NaN;
ORSS_(ORSS_==0)=NaN;
ORSS_(ORSS_==1)=NaN;
hit_(hit_==0)=NaN;
hit_(hit_==1)=NaN;
miss_(miss_==0)=NaN;
miss_(miss_==1)=NaN;
f_alert_(f_alert_==0)=NaN;
f_alert_(f_alert_==1)=NaN;
corr_zero_(corr_zero_==0)=NaN;
corr_zero_(corr_zero_==1)=NaN;




for i=1:size(PC,1)
    for j=1:size(PC,2)
        plot(squeeze(PC_(i,j,1,:))')
        PC_m=squeeze(mean(mean(PC_(:,:,1,:),'omitnan'),'omitnan'));
        hold on
        
    end
end
plot(PC_m,'color','k','LineWidth',5)

% PC(i,r)=(hit(i,r)+corr_zero(i,r))/(total(i,r)); % proportion correct
% POD(i,r)=hit(i,r)/(hit(i,r)+miss(i,r));          % probability of detection
% FAR(i,r)=f_alert(i,r)/(f_alert(i,r)+hit(i,r));   % false alarm ration
% CSI(i,r)=hit(i,r)/(hit(i,r)+miss(i,r)+f_alert(i,r));  % critical success index
% ORSS(i,r)=(hit(i,r)*corr_zero(i,r)-f_alert(i,r)*miss(i,r))/(hit(i,r)*corr_zero(i,r)+f_alert(i,r)*miss(i,r));
% % odds ratio skill score


hit_s=squeeze(sum(sum(hit_(:,:,1,:),'omitnan'),'omitnan'));
miss_s=squeeze(sum(sum(miss_(:,:,1,:),'omitnan'),'omitnan'));
f_alert_s=squeeze(sum(sum(f_alert_(:,:,1,:),'omitnan'),'omitnan'));
corr_zero_s=squeeze(sum(sum(corr_zero_(:,:,1,:),'omitnan'),'omitnan'));
total_s=hit_s+miss_s+f_alert_s+corr_zero_s;
PC_s=(hit_s+corr_zero_s)./total_s;
plot(PC_s,'color','b','LineWidth',5)