function D = Dwell(f,x)
%DWELL Summary of this function goes here
%   Detailed explanation goes here
n = numel(x);
e=1e-30;
p= 1:n;
df = arrayfun(@(j) imag((f(x+(e*1i)*(p==j)))/e),p);
D = [f(x) df]';
end
