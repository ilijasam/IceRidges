function epp = epp(data)
set(gca,'YScale','log')
N = numel(data);
epp = scatter(sort(data),(N:-1:1)/N,'.');
end