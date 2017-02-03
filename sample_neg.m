function [ neg_u, neg_i, neg_t ] = sample_neg( u, R, C, train)

    while true
        item = randi([1 size(R,2)]);
        if R(u,item) == 0; neg_i=item; break; end;
    end

    while true
        giver = randi([1 size(C,2)]);
        if C(u,giver) == 0; neg_u=giver; break; end;
    end

end