function sigcorrplot_2groups(var2,var1,col,fonts,marks,xlab,ylab,type,group)
%fcorr=figure;
[r,p]=corr(var1,var2,'Type',type);
 star=[];
    if p<0.001
        star='***';
    else
        if p<0.01
            star='**';
        else
            if p<0.05
                star='*';
            end
        end
    end
scatter(var1,var2,marks,group,'filled')
map=[0.5 0 0.8;1.0 0.6 0.2];
colormap(map);
l=lsline;
l.Color=col;
l.LineWidth=3;
xpos=(max(var1)-min(var1))*0.7+min(var1);
ypos=(max(var2)-min(var2))*0.75+min(var2);
set(gca,'FontSize',fonts);
xlabel(xlab,'FontSize',fonts)
ylabel(ylab,'FontSize',fonts)
text(xpos,ypos,['r=',num2str(round(r,2),'%.2f'),star],'FontSize',fonts)
%print(fcorr,[figdir,xlab,ylab,tit,'.png'],'-dpng','-r300')