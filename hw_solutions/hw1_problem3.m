clearvars; clc;
f = @(x) (x(1)-2)^4+(x(1)-2*x(2))^2;
ff = @(x,y) (x-2).^4+(x-2*y).^2;
g = @(x) [4*(x(1)-2)^3 + 2*(x(1)-2*x(2));-4*(x(1)-2*x(2))];
%H = @(x1,x2) [12*(x1-2)^2 + 2 -4; -4 8];
x0 = [0;3];
tol = 1E-5;
maxIters = 1000;
% 3) (c)

%[xc,oc] = sdm(f,g,x0,tol,maxIters)

% 3) (d)
% [xd,od] = sdm(f,g,x0,tol,maxIters,"wolfe")
% solsC = oc.iterations;
% solsD = od.iterations;
% [X,Y] = meshgrid(-1:0.01:3,-1:0.01:3);
% Z = ff(X,Y);
% figure
% contour(X,Y,Z)
% hold on
% plot(solsC(:,1),solsC(:,2),'-r')
% plot(solsD(:,1),solsD(:,2),'-b')
% hold off

% experiments
nItersC = 0;
tC = 0;
nItersD = 0;
tD = 0;
for j=1:1000
    tic
    [~,oc] = sdm(f,g,x0,tol,maxIters);
    tC = tC + toc;
    nItersC = nItersC + oc.num_iterations;
    
    tic
    [~,od] = sdm(f,g,x0,tol,maxIters,"wolfe");
    tD = tD + toc;
    nItersD = nItersD + od.num_iterations;
end
disp(["C", tC, nItersC])
disp(["D", tD, nItersD])
    