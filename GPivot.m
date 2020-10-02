function x = GPivot(A,b)
%GPIVOT: Gaussian eleminitaion with partial pivoting
%   x = GPivot(A,b)
% input:
%   A = square coefficient matrix
%   b = right hand side vector
% output:
%   x = solution vector


[m, n] = size(A);
if m~=n, error('Marix A must be a square matrix'); end 
Aug = [A b];
for k = 1:n-1
    [~, imax]= max(abs(Aug(k:n,k)));
    ipivot = imax + k -1;
    if (ipivot~=k)
        Aug([k,ipivot],:) = Aug([ipivot,k],:);
    end
    for i=k+1:n
        pivot = Aug(i,k)/Aug(k,k);
        Aug(i,k:(n+1))=Aug(i,k:(n+1))- pivot*Aug(k,k:(n+1));
    end
end

x = zeros(n,1);
x(n) = Aug(n,n+1)/Aug(n,n);
for i=n-1:-1:1
    x(i)= (Aug(i,n+1)-Aug(i,i+1:n)*x(i+1:n))/Aug(i,i);
end
end

