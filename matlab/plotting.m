close all; 
clear;
load('verification_60_timesteps.mat');

PC_size=size(PC);
rain_thresholds={'0.1 mm','0.2 mm','0.5 mm','1 mm','2 mm','5 mm','10 mm','20 mm','30 mm'};

r_thrs=1; % Rain Threshold
PC_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));
BIAS_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));
POD_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));
FAR_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));
ORSS_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));
CSI_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));
hit_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));
miss_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));
f_alert_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));
corr_zero_=NaN(PC_size(1),PC_size(2),size(PC{2,2},2),size(PC{2,2},1));

for i=1:size(PC,1)
    for j=1:size(PC,2)
        for r=1:size(PC{2,2},2)
            if ~isempty(PC{i,j})
                for l=1:size(PC{2,2},1)
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
% PC_(PC_==0)=NaN;
% PC_(PC_==1)=NaN;
% BIAS_(BIAS_==0)=NaN;
% BIAS_(BIAS_==1)=NaN;
% POD_(POD_==0)=NaN;
% POD_(POD_==1)=NaN;
% FAR_(FAR_==0)=NaN;
% FAR_(FAR_==1)=NaN;
% ORSS_(ORSS_==0)=NaN;
% ORSS_(ORSS_==1)=NaN;
% hit_(hit_==0)=NaN;
% hit_(hit_==1)=NaN;
% miss_(miss_==0)=NaN;
% miss_(miss_==1)=NaN;
% f_alert_(f_alert_==0)=NaN;
% f_alert_(f_alert_==1)=NaN;
% corr_zero_(corr_zero_==0)=NaN;
% corr_zero_(corr_zero_==1)=NaN;

hit_s=squeeze(sum(sum(hit_(:,:,r_thrs,:),'omitnan'),'omitnan'));
miss_s=squeeze(sum(sum(miss_(:,:,r_thrs,:),'omitnan'),'omitnan'));
f_alert_s=squeeze(sum(sum(f_alert_(:,:,r_thrs,:),'omitnan'),'omitnan'));
corr_zero_s=squeeze(sum(sum(corr_zero_(:,:,r_thrs,:),'omitnan'),'omitnan'));

total_s=hit_s+miss_s+f_alert_s+corr_zero_s;

PC_s=(hit_s+corr_zero_s)./total_s;
POD_s=hit_s./(hit_s+miss_s);
FAR_s=f_alert_s./(f_alert_s+hit_s);
CSI_s=hit_s./(hit_s+miss_s+f_alert_s);

hit_a=squeeze(sum(sum(hit_(:,:,:,:),'omitnan'),'omitnan'));
miss_a=squeeze(sum(sum(miss_(:,:,:,:),'omitnan'),'omitnan'));
f_alert_a=squeeze(sum(sum(f_alert_(:,:,:,:),'omitnan'),'omitnan'));
corr_zero_a=squeeze(sum(sum(corr_zero_(:,:,:,:),'omitnan'),'omitnan'));

total_a=hit_a+miss_a+f_alert_a+corr_zero_a;

PC_a=((hit_a+corr_zero_a)./total_a)';
POD_a=(hit_a./(hit_a+miss_a))';
FAR_a=(f_alert_a./(f_alert_a+hit_a))';
CSI_a=(hit_a./(hit_a+miss_a+f_alert_a))';

total_a=total_a';

figure
plot(PC_s,'color','k','LineWidth',8)
legend('PC')
hold on
for i=1:size(PC,1)
    for j=1:size(PC,2)
        plot(squeeze(PC_(i,j,r_thrs,:))','color','b')
        %PC_m=squeeze(mean(mean(PC_(:,:,r_thrs,:),'omitnan'),'omitnan'));
        hold on
        
    end
end
xlabel('Minuten')
title('Proportion Correct')
plot(PC_s,'color','k','LineWidth',8)
set(gca,'Xtick',0:10:60)
set(gca,'Xticklabels',0:5:30)
%plot(PC_m,'color','k','LineWidth',5)

% PC(i,r)=(hit(i,r)+corr_zero(i,r))/(total(i,r)); % proportion correct
% POD(i,r)=hit(i,r)/(hit(i,r)+miss(i,r));          % probability of detection
% FAR(i,r)=f_alert(i,r)/(f_alert(i,r)+hit(i,r));   % false alarm ration
% CSI(i,r)=hit(i,r)/(hit(i,r)+miss(i,r)+f_alert(i,r));  % critical success index
% ORSS(i,r)=(hit(i,r)*corr_zero(i,r)-f_alert(i,r)*miss(i,r))/(hit(i,r)*corr_zero(i,r)+f_alert(i,r)*miss(i,r));
% % odds ratio skill score



figure
hold on
plot(POD_s,'color','b','LineWidth',8)
plot(FAR_s,'color','r','LineWidth',8)
for i=1:size(POD,1)
    for j=1:size(POD,2)
        plot(squeeze(POD_(i,j,r_thrs,:))','color','b')
        %POD_m=squeeze(mean(mean(POD_(:,:,1,:),'omitnan'),'omitnan'));
        hold on
        
    end
end
title('Probability of Detection + False Alarm Ratio')
plot(FAR_s,'color','r','LineWidth',8)
set(gca,'Xtick',0:10:60)
set(gca,'Xticklabels',0:5:30)
xlabel('Minuten')
legend('POD','FAR')
%plot(POD_m,'color','k','LineWidth',5);



figure
plot(CSI_s,'color','k','LineWidth',8)
legend('CSI')
hold on
for i=1:size(CSI,1)
    for j=1:size(CSI,2)
        plot(squeeze(CSI_(i,j,r_thrs,:))','color','b')
        hold on
    end
end
title('Critical Success Index')
plot(CSI_s,'color','k','LineWidth',8)
set(gca,'Xtick',0:10:60)
set(gca,'Xticklabels',0:5:30)
xlabel('Minuten')

figure
plot(hit_s,'LineWidth',4)
hold on
plot(miss_s,'LineWidth',4)
plot(f_alert_s,'LineWidth',4)
plot(corr_zero_s,'LineWidth',4)
plot(total_s,'LineWidth',4)

set(gca,'Xtick',0:10:60)
set(gca,'Xticklabels',0:5:30)
xlabel('Minuten')
ylabel('Anzahl/Punkte')
legend('Hit','Miss','False Alert','Corr Zero','Total')


figure
for i=1:size(PC_a,2)
    plot(PC_a(:,i),'LineWidth',2,'Color',[(1/9)*i 0 0])
    hold on
end
legend(rain_thresholds)
title('Proportion Correct')
figure

for i=1:size(PC_a,2)
    plot(POD_a(:,i),'LineWidth',2,'Color',[(1/9)*i 0 0])
    hold on
end

title('Propability of Detection')
legend(rain_thresholds)
figure

for i=1:size(PC_a,2)
    plot(FAR_a(:,i),'LineWidth',2,'Color',[(1/9)*i 0 0])
    hold on
end
title('False Alarm Ratio')
legend(rain_thresholds)
figure

for i=1:size(PC_a,2)
    plot(CSI_a(:,i),'LineWidth',2,'Color',[(1/9)*i 0 0])
    hold on
end

title('Criticial Success Index')
legend(rain_thresholds)

% figure
% 
% for i=1:size(hit_a,2)
%     plot(hit_a(:,i),'b')
%     hold on
%     plot(miss_a(:,i),'r')
%     plot(f_alert_a(:,i),'y')
%     plot(corr_zero_a(:,i),'m')
% 
% end
% 
%     plot(total_a(1,:)','g')