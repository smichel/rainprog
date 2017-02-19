close all; clear;
%E:/Rainprog/m4t_BKM_wrx00_l2_dbz_v00_20130511170000.nc
%path=strcat('/home/zmaw/u300675/pattern_data/');
path=strcat('E:/Rainprog/data/');
files=dir(path);
files=files(3:end);
len=length(files);
t_len=5;
progtime=30;
plots=0;
rain_threshold=0.2; % rain threshold
parfor j=1:len
    for i=1:10
       try
        res=200;
        prog=(i+4)*5;
        uk=10;
        timesteps=prog+progtime+5;
        [realdata,progdata]=rainprog(rain_threshold,res,timesteps,prog,progtime,uk,strcat(path,files(j).name));
        real_data{j,i}=realdata;
        prog_data{j,i}=progdata;
        catch
            
        end
    end
    display(sprintf('Progress %d%%',floor(j/len*100)));
end

save('HWT+BKM.mat');
%%
% colors=winter(size(co1,1));
% 
% 
% 
% k=1;
% for j=1:size(co1,1)
%     for i=1:size(co1,2)
%         for k=1:size(co1{j,i},2)
%             if co1{j,i}(1)>0.3
%                 cor1(j,i,k)=co1{j,i}(k);
%             else
%                 cor1(j,i,k)=NaN;
%             end
%             
%             if co2{j,i}(1)>0.3
%                 cor2(j,i,k)=co2{j,i}(k);
%             else
%                 cor2(j,i,k)=NaN;
%             end
%         end
%     end
% end
% 
% 
% if plots==1
% figure
% plot(0.5,'k')
% hold on
% for j=1:size(co1,1)
%     for i=1:size(co1,2)
%         for k=1:size(co1{j,i},2)
%             if co1{j,i}(1)>0.3
%                 plot(co1{j,i},'Color',colors(j,:),'LineWidth',2)
%             end
%         end
%     end
% end
% 
% 
% plot(squeeze(mean(mean(cor1(:,:,:),2,'omitnan'),'omitnan')),'Color',[0 0 0],'LineWidth',5)
% title('Korrelationskoeffizient Regenintensität')
% xlabel('Zeit in 30s')
% ylabel('Korrelationskoeffizient')
% legend('Mittelwert')
% 
% figure
% plot(0.5,'k')
% hold on
% k=1;
% for j=1:size(co2,1)
%     for i=1:size(co2,2)
%         for k=1:size(co2{j,i},2)
%             if co2{j,i}(1)>0.3
%                 plot(co2{j,i},'Color',colors(j,:),'LineWidth',2)
%             end
%         end
%     end
% end
% 
% plot(squeeze(mean(mean(cor2(:,:,:),2,'omitnan'),'omitnan')),'Color',[0 0 0],'LineWidth',5)
% title('Korrelationskoeffizient Auftreten von Regen')
% xlabel('Zeit in 30s')
% ylabel('Korrelationskoeffizient')
% legend('Mittelwert')
% figure
% plot(squeeze(mean(mean(cor1(:,:,:),2,'omitnan'),'omitnan'))-squeeze(mean(mean(cor2(:,:,:),2,'omitnan'),'omitnan')))
% title('Korrelationskoeffizient Regenintensität - Korrelationskoeffizient Auftreten von Regen')
% xlabel('Zeit in 30s')
% ylabel('Korrelationskoeffizient')
% end