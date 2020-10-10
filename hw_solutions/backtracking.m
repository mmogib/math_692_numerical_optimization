function alpha = backtracking(f,gk,xk,pk, maxIter)
%BACKTRACKING Summary of this function goes here
%   Detailed explanation goes here
alpha = 1;
rho = rand();
c = rand();
fk = f(xk);
for i=1:maxIter
   if (f(xk+alpha*pk)<=fk+c*alpha*gk'*pk), break; end
   alpha = rho*alpha;    
end

end

