m=0.001;v=0.02;
syms x y m v
eq1=m==x./(x+y);
eq2=v==x*y./((x+y).^2*(x+y+1));
S=solve([eq1,eq2],[x,y]);
S=solve(eq1,eq2);
double(S.x)
double(S.y)

%%
figure;
i=1;
for v=0.001:0.001:0.1
m=0.5;
b=(m - v + m*v - 2*m^2 + m^3)/v;
a=-(m*(m^2 - m + v))/v;
a./(a+b);
a*b/((a+b)^2*(a+b+1));
fplot(@(x) betapdf(x,a,b),[0 1]);hold on;
maxp(i)=betapdf(0.5,a,b);
i=i+1;
end
figure;plot(maxp)

i=1;
for v=0.001:0.099/29:0.1
m=0.5;
b=(m - v + m*v - 2*m^2 + m^3)/v;
a=-(m*(m^2 - m + v))/v;
a./(a+b);
a*b/((a+b)^2*(a+b+1));
fplot(@(x) betapdf(x,a,b),[0 1]);hold on;
maxp(i)=betapdf(0.5,a,b);
i=i+1;
end
figure;plot(maxp)

figure;
i=1;
for V=log(0.001):(log(0.1)-log(0.001))/29:log(0.1)
v=exp(V);
    m=0.5;
b=(m - v + m*v - 2*m^2 + m^3)/v;
a=-(m*(m^2 - m + v))/v;
a./(a+b);
a*b/((a+b)^2*(a+b+1));
fplot(@(x) betapdf(x,a,b),[0 1]);hold on;
maxp(i)=betapdf(0.5,a,b);
i=i+1;
end
figure;plot(maxp)

figure;
i=1;
for V=log(0.001):(log(0.1)-log(0.01))/29:log(0.99)
v=exp(V);
    m=0.5;
b=(m - v + m*v - 2*m^2 + m^3)/v;
a=-(m*(m^2 - m + v))/v;
a./(a+b);
a*b/((a+b)^2*(a+b+1));
fplot(@(x) betapdf(x,a,b),[0 1]);hold on;
ylim([0 12.3])
maxp(i)=betapdf(0.5,a,b);
i=i+1;
end
%%
clear a b
i=0;
for m=0.01:0.01:0.99
    i=i+1;
    j=0;
    for V=log(0.001):(log(0.1)-log(0.001))/19:log(0.1)
        v=exp(V);
      j=j+1;
      b(i,j)=(m - v + m*v - 2*m^2 + m^3)/v;
      a(i,j)=-(m*(m^2 - m + v))/v;
    end
end
for i=1:size(a,1)
    idx=find(a(i,:)<0);
    a(i,idx)=a(i,min(idx)-1);
    b(i,idx)=b(i,min(idx)-1);
end

figure;imagesc(a>0)
figure;imagesc(b>0)
figure;imagesc(a.*b>0)
%
figure;imagesc(a);colorbar
figure;imagesc(b);colorbar
figure;imagesc(a./(a+b));colorbar
figure;imagesc(a.*b./((a+b).^2.*(a+b+1)));colorbar
%%
figure;
for i=1:size(a,1)
    for j=1:size(a,2)
        fplot(@(x) betapdf(x,a(i,j),b(i,j)),[0,1])
        hold on
    end
end
%nn=betarnd(a(i,end),b(i,end),[20,20])
%%
figure;
for i=log(0.5):(log(50)-log(0.5))/29:log(50)
    fplot(@(x) sigmf(x,[exp(i),0]),[-0.5 0.5]);
    hold on; 
end

figure;
for i=1:20
    fplot(@(x) sigmf(x,[beta(i),0]),[-0.5 0.5]);
    hold on; 
end
%%
