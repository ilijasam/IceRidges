%% Finding ridge keels with Rayleigh criteria

function [X,H] = RC(x,h,h_tres,h_k_min)

X = x;

%       find all the local maxima and minima
[h_pot,x_pot] = findpeaks(h,x,'MinPeakHeight',h_k_min);
[h_min,x_min] = findpeaks(-h,x);
h_min = -h_min;
x_min(h_min<h_tres)=[];
h_min(h_min<h_tres)=[];

%%      FINDING THE CROSSINGS OVER TREASHOLD WHERE RIDGES OCCUR



%        binary signal for for above treashold (0 - below; 1 - above)
xat = ones(length(x),1);
xat(h<h_tres) = 0;

%       find jumps in binary signal (L57) and eliminate where there are no
%       jumps, this way we fidnd jumps over treashold (crossings)
corners = abs(diff(-xat));
x_corners = x(1:end-1);
x_corners(corners<1) = [];
% x_corners(2:2:end) = x_corners(2:2:end)+diff(x(1:2)); % move end of ridge by one element so that "h" is below treashold
corners(corners<1) = [];

%       eliminating those crossings where there is no ridge

peaks_zero_flag = zeros(length(x_pot),1);

x_merged = [x_corners; x_pot];
y_merged = [corners; peaks_zero_flag];

[x_merged_S, order] = sort(x_merged);
y_merged_S = y_merged(order,:);


cor = diff(y_merged_S);
X_cor = x_merged_S(1:end);


x_cor = [X_cor(cor==-1) ; X_cor([false; cor(1:end)==1])];



%%


cuts = h( ismember(x, x_cor)  );

trigger = 1;
iii=1;
while not(trigger==0)
  
disp('---------------------------------------------------------------')
disp(['Iteration : ' num2str(iii)])
    
    if exist('XMINTEMP')
        x_min = XMINTEMP;
        h_min = HMINTEMP;
    end


for ps = 1:length(h_pot)-1
if isempty(cuts(and((x_pot(ps)<x_cor), (x_cor<x_pot(ps+1))) ))
    % if in between two peaks there are no crossings delete all minimas
    % except the smallest one (minima of minimas)
    x_del = and((x_pot(ps)<x_min), (x_min<x_pot(ps+1))) ;
    [mm,xx] = min(h_min(x_del));
    x_del(find(x_del,1)+xx-1)=0;
    
    x_min(x_del) = [];
    h_min(x_del) = [] ;   
else    
    % if there is a crossing between two peaks remove all the minimas
    x_del = and((x_pot(ps)<x_min), (x_min<x_pot(ps+1))) ;
    
    x_min(x_del) = [];
    h_min(x_del) = [] ; 
end 
end

%       remove all the minamas before the first and after the last peak
h_min(x_min<x_pot(1))=[];
x_min(x_min<x_pot(1))=[];
h_min(x_min>x_pot(end))=[];
x_min(x_min>x_pot(end))=[];

%       x_min and h_min are now the minimas between reidges where no
%       crossing has occured, this are the places where potentialy two
%       ridges can merge or be two separate ridges


XMINTEMP = x_min;
HMINTEMP = h_min;
x_min = repelem(x_min,2);
h_min = repelem(h_min,2);

x_start_stop = [x_min ; x_cor];
h_start_stop = [h_min ; cuts];

[x_start_stop, order] = sort(x_start_stop);
h_start_stop = h_start_stop(order,:);


x_start = x_start_stop(1:2:end);
x_stop = x_start_stop(2:2:end);
h_start = h_start_stop(1:2:end);
h_stop = h_start_stop(2:2:end);


if exist('AA')
clear AA I
end

AA(:,1)  = ismember(x_start ,XMINTEMP );
alpha = AA.*(max(h_pot,[0 ; h_pot(1:end-1)])-h_tres);
beta = AA.*(alpha-(h_start-h_tres));
I(:,1) = beta<0.5*alpha;
delta = AA.*(2*(alpha-beta)+h_tres);
I(:,2) = AA.*min(h_pot,[0 ; h_pot(1:end-1)])<delta;

I(:,3) = or(I(:,1),I(:,2));

x_start(I(:,3)) = [];
h_start(I(:,3)) = [];
x_stop([I(2:end,3) ;false]) = [];
h_stop([I(2:end,3);false]) = [];

tekuci = and(I(1:end,3),sign(h_pot - max(h_pot,[0 ; h_pot(1:end-1)])) ) ;
predhodni = logical( I(:,3) -    tekuci );

h_pot(or(tekuci,[predhodni(2:end);false])) = [];
x_pot(or(tekuci,[predhodni(2:end);false])) = [];

iii = iii+1;
trigger = sum(I(:,3));

disp(['Deleted objects : ' num2str(trigger)])

end

% RTime = Data.dateNUM(ismember(X,x_pot));

X = x_pot;
H = h_pot;

end

