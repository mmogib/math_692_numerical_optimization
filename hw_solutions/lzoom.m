function a = lzoom(al,ah,f, g, xk, pk, phi0, phip0, c1, c2)
%LZOOM Summary of this function goes here
%   Detailed explanation goes here
while 1
    %p =  polyfit(1:2,[al;ah],1);
    %aj = polyval(p,1.5);
    aj = spline(1:2,[al;ah],1.5);
    a = aj;
    if (abs(al-ah)<=1e-9), break; end
    phij = f(xk+aj*pk);
    if (phij > phi0 + c1*aj*phip0) || (phij>=f(xk+al*pk))
        ah = aj;
    else 
        phipj=g(xk+aj*pk)'*pk;
        if (abs(phipj) <= -c2*phip0)
            a = aj;
            break;
        end
        
        if (phipj*(ah-al)>=0)
            ah = al;
        end
        al = aj;
    end
end 
end

