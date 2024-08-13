function plotcorr(varx,vary,plotline,showrvalue,xlabelname,ylabelname,col)
    if nargin<6
        col=[0 0.4470 0.7410];
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

    scatter(varx,vary,10,'o','MarkerEdgeColor',col,'MarkerFaceColor',col)

    ax=gca;
    ax.XAxis.FontSize=8;
    ax.YAxis.FontSize=8;
    xlabel(xlabelname,'FontSize',13)
    ylabel(ylabelname,'FontSize',13)
    [r,p]=corr(varx,vary)
        if plotline
            l=lsline;
            set(l,'color',col)
            set(l,'LineWidth',3)
        end
    if showrvalue
        xl=xlim;
        yl=ylim;
        if r<0
        xp=xl(2)-(xl(2)-xl(1))*0.55;
        yp=yl(1)+(yl(2)-yl(1))*0.95;
        else
        xp=xl(2)-(xl(2)-xl(1))*0.55;
        yp=yl(1)+(yl(2)-yl(1))*0.1;    
    end
        
        df=length(varx)-2;
        %text(xp,yp,{['r(',num2str(df),')=',num2str(round(r,3))],['p=',num2str(round(p,3))]});
        if p>0.05
           text(xp,yp,['r(',num2str(df),')=',num2str(round(r,3)),', p=',num2str(round(p,3))],'FontSize',12);  
        else
            if p>0.01
              text(xp,yp,['r(',num2str(df),')=',num2str(round(r,3)),'*'],'FontSize',12);
            else
               if p>0.001
                text(xp,yp,['r(',num2str(df),')=',num2str(round(r,3)),'**'],'FontSize',12);
                else
                   text(xp,yp,['r(',num2str(df),')=',num2str(round(r,3)),'***'],'FontSize',12);
               end
            end
        end

end