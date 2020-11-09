function [x,BB,NN] = simplex(c,A,b)
%SIMPLEX Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(A);
BB = 1:m;
NN = m+1:n;

for i=1:1
    B = A(:,BB);
    N = A(:,NN);
    cB = c(BB);
    cN = c(NN);
    L = B'\cB;
    sN = cN - N'*L;
    [val,ind1] = min(sN);
    if val>=0, break;end
    xB = B\b;
    q = BB(ind1)
    Aq = A(:,q);
    d = B\Aq;
    [~,ind2] =min(xB./d);
    p = NN(ind2)
    NN(ind2) = q;
    BB(ind1) = p;
end
x = zeros(n,1);
x(BB) = xB;
x(NN) = zeros(numel(NN),1);
end

