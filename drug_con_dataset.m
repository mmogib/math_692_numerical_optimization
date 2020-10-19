function [t,y] = drug_con_dataset(N)
x = [100 60 -1 1 2];
phi = @(tt) x(1) + x(2)*tt + x(3)*tt^2 + x(4)*exp(-x(5)*tt); 
t = zeros(N,1);
t(1,1)=1;
y = zeros(N,1);
y(1,1) = phi(t(1,1));
for i=1:N-1
    l = rand();
    s = 2*l - 1;
    t(i+1,1)= t(i,1)+randi([1,3]);
    y(i+1,1) = phi(t(i+1,1))+s;
end
end