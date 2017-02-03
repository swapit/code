function [ e ] = cost( inter, R, P, Q, S, lambda )

K = size(P,2);

% if interactions are pairs
if size(inter,2)==4
    inter = [inter(:,[1 3 2]);inter(:,[3 1 4])];
end

e = 0;
for i=1:length(inter)
    e = e + (R(inter(i,2),inter(i,3)) - (P(inter(i,2),:)*Q(:,inter(i,3)) + S(inter(2),inter(1)) ))^2;
    for k=1:K
        e = e + (lambda/2) *  (S(inter(2),inter(1)) + P(inter(i,2),k)*Q(k,inter(i,3)))^2;
    end
end

e = e / length(inter);

end

