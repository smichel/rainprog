function [FSS,rain_thresholds,max_boxsize] = FSS(prog_data,real_data)
%Calculates the Fraction Skill Score for a given precip prognosis and the
%reference data, Roberts and Lean 2005/2008
%Analysis of Fraction Skill Score properties for a displaced rainy grid point
%in a rectangular domain Gregor Skok 2015

A=exist('res');
if ~A
    res=size(prog_data{1,1},1);
end
plot=0;
time=size(prog_data{1,1},3);

r=1; % idx for rain_threshold

max_boxsize=(res-1)/10;
rain_thresholds=[0.002 0.005 0.01 0.2 0.5 1 2 5 10 20 30];
FSS=zeros(max_boxsize,length(rain_thresholds),time); %Fraction Skill Score
for boxsize=1:floor(max_boxsize/10):max_boxsize
    b=1; % idx for box_size
    for rain_threshold=rain_thresholds
        p_data=prog_data{2,1};
        r_data=real_data{2,1};
        for i=1:time
            p_box=zeros(ceil(res/boxsize),ceil(res/boxsize));
            r_box=zeros(ceil(res/boxsize),ceil(res/boxsize));
            for x=1:res-1
                for y=1:res-1
                    if p_data(x,y,i)>rain_threshold
                        p_box(ceil(x/boxsize),ceil(y/boxsize))=p_box(ceil(x/boxsize),ceil(y/boxsize))+1;
                    end
                    if r_data(x,y,i)>rain_threshold
                        r_box(ceil(x/boxsize),ceil(y/boxsize))=r_box(ceil(x/boxsize),ceil(y/boxsize))+1;
                    end
                end
            end
            p_box=p_box/(boxsize^2);
            r_box=r_box/(boxsize^2);
            FSS(r,b,i)=(2*sum(sum(r_box.*p_box)))/(sum(sum(p_box.^2))+sum(sum(r_box.^2)));
            if isnan(FSS(r,b,i))
                FSS(r,b,i)=0;
            end
        end
        
        b=b+1;
    end
    r=r+1;
end
if plot
    figure
    imagesc(squeeze(flipud(FSS(:,:,1))))
    colormap('hot')
    set(gca,'Xtick',(1:length(rain_thresholds)))
    set(gca,'Xticklabels',rain_thresholds)
    xlabel('Threshold in mm')
    set(gca,'Ytick',(1:10))
    set(gca,'Yticklabels',(((10:-1:1)*(res-1)).^2)/1000000)
    ylabel('Spatial scale in km^2')
    title(strcat('Progtime ',num2str(1/2),' Minutes'))
    hcb=colorbar;
    hcb.Label.String = 'Fraction Skill Score';
    caxis([0 1])
    for i=5:10:25
        figure
        imagesc(squeeze(flipud(FSS(:,:,i))))
        colormap('hot')
        set(gca,'Xtick',(1:length(rain_thresholds)))
        set(gca,'Xticklabels',rain_thresholds)
        xlabel('Threshold in mm')
        set(gca,'Ytick',(1:10))
        set(gca,'Yticklabels',(((10:-1:1)*(res-1)).^2)/1000000)
        ylabel('Spatial scale in km^2')
        hcb=colorbar;
        hcb.Label.String = 'Fraction Skill Score';
        title(strcat('Progtime ',num2str(i/2),' Minutes'))
        caxis([0 1])
    end
end
end