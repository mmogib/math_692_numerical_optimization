function [x,output] = sdm(f,g,x0,tol,maxIter, method)
%SDM Steepest Descent Method
%   Detailed explanation goes here

if (nargin<6), method="backtracking"; end

x = x0;
iters = sparse(maxIter,numel(x0));
iters(1,:) = x0';
for i=1:maxIter 
    p0 = -g(x0);
    if method=="wolfe"
        alpha =  wolfe(f,g, x0,p0,maxIter);
    else
        alpha =  backtracking(f,g(x0),x0,p0,maxIter);
    end
    x = x0 + alpha*p0;
    iters(i+1,:) = x'; 
    if (norm(x-x0)<tol), break; end
    x0 = x;
end
output.num_iterations = i;
output.iterations = iters(1:i,:);
end

