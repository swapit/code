function [ auc_uni,auc_bid ] = auc_hard( pairs_test, P, Q, R, S, C, TI,train,transac)

auc_uni = 0;
auc_bid = 0;

for i=1:length(pairs_test)
    
    u1 = pairs_test(i,1);
    i1 = pairs_test(i,2);
    u2 = pairs_test(i,3);
    i2 = pairs_test(i,4);
    
    s1 = P(u1,:)*Q(:,i2) + S(u1,u2) ;
    s2 = P(u2,:)*Q(:,i1) + S(u2,u1) ;
    
    s = mean([s1 s2]);
    
    [neg_u1_u,neg_u1_i] = sample_neg(u1,R,C,train);
    [neg_u2_u,neg_u2_i] = sample_neg(u2,R,C,train);
    
    s1_neg = P(u1,:)*Q(:,neg_u1_i) + S(u1,neg_u1_u) ;
    s2_neg = P(u2,:)*Q(:,neg_u2_i) + S(u2,neg_u2_u);
    
    if s1>s1_neg; auc_uni=auc_uni+1; elseif s1==s1_neg; auc_uni=auc_uni+0.5; end
    if s2>s2_neg; auc_uni=auc_uni+1; elseif s2==s2_neg; auc_uni=auc_uni+0.5; end
    
    if s>s1_neg; auc_bid=auc_bid+1; elseif s==s1_neg; auc_bid=auc_bid+0.5; end
    if s>s2_neg; auc_bid=auc_bid+1; elseif s==s2_neg; auc_bid=auc_bid+0.5; end
end

auc_uni = auc_uni / (length(pairs_test)*2);
auc_bid = auc_bid / (length(pairs_test)*2);

end

