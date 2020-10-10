function alpha_star = wolfe(f,g, xk,pk,maxiters)
%WOLFE Summary of this function goes here
%   Detailed explanation goes here
c1 =1e-4; c2=0.9;
a0 = 0; % a_{i-1}
amax = 1;
a1 = rand(); % a1 in (a0,amax) = (0, 1) a_i
phi0=f(xk);
phip0 = g(xk)'*pk;
alpha_star =1;
for i=1:maxiters
    phi_a1 = f(xk+a1*pk);
    if ((phi_a1 > phi0 + c1*a1*phip0) || ((f(xk+a1*pk)>= f(xk+a0*pk)) && i>1))
        alpha_star = lzoom(a0,a1,f, g, xk, pk, phi0, phip0, c1, c2);
        break;
    end
    phipa1=g(xk+a1*pk)'*pk;
    if (abs(phipa1)<= -c2*phip0)
        alpha_star = a1;
        break;
    end
    
    if phipa1>=0 
       alpha_star = lzoom(a1,a0,f, g, xk, pk, phi0, phip0, c1, c2);
       break;
    end
    lambda = rand();
    a0 = a1;
    a1 = lambda*amax + (1-lambda)*a1;  
end

end

