function plotcorr(varx,vary,plotline,showrvalue,xlabelname,ylabelname,color)
    if nargin<7
        color='b';
    end
    if nargin<5
        xlabelname=inputname(1);
        ylabelname=inputname(2);
    end
    if nargin<4
       showrvalue=true;
    end
    if nargin<3
       plotline=true;
    end

    scatter(varx,vary,200,color,'.')

    ax=gca;
    ax.XAxis.FontSize=6;
    ax.YAxis.FontSize=6;
    xlabel(xlabelname,'FontSize',10)
    ylabel(ylabelname,'FontSize',10)
    [r,p]=corr(varx,vary)
        if plotline
            l=lsline;
            set(l,'color',color)
            set(l,'LineWidth',3)
        end
    if showrvalue
        xl=xlim;
        yl=ylim;
        if r<0
        xp=xl(2)-(xl(2)-xl(1))*0.65;
        yp=yl(1)+(yl(2)-yl(1))*0.95;
        else
        xp=xl(2)-(xl(2)-xl(1))*0.65;
        yp=yl(1)+(yl(2)-yl(1))*0.05;    
        end
        
        df=length(varx)-2;
        %text(xp,yp,{['r(',num2str(df),')=',num2str(round(r,3))],['p=',num2str(round(p,3))]});
        if p>0.001
        text(xp,yp,['r(',num2str(df),')=',num2str(round(r,3)),', p=',num2str(round(p,3))],'FontSize',8);
        else
            text(xp,yp,['r(',num2str(df),')=',num2str(round(r,3)),', p<0.001'],'FontSize',8);
        end
    end
end