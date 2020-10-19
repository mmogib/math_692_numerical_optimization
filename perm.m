function B = perm(A)
%PERM Summary of this function goes here
%   Detailed explanation goes here
[m,~]=size(A);
rows = randperm(m,2);
B=A;
B([rows(1),rows(2)],:) = A([rows(2),rows(1)],:);
end

