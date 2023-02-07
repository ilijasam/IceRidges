function [p,a,b] = linreg(x,y,PlotOption)

x = x(:);
y = y(:);

X = [ones(length(x),1) x];
b = X\y;

a = b(2);
b = b(1);



if PlotOption == 1
    xl = xlim;
    p = plot([xl(1) xl(2)],[xl(1)*a+b  xl(2)*a+b]); 
end

end

