function [ P,Q ] = mf_bpr( R, C, train, pairs_test, use_social, use_time, giver, transac)

steps    = 1000000000;
alpha    = 0.05; % learning rate
lambda   = 0.1;
lambda_S = 1.0;
lambda_T = 10.0;
sigma    = 0.1;  %std
mu       = 0.0;   %mean
K        = 100;

N = size(R,1); % U
M = size(R,2); % I

P = sigma.*randn(N,K) + mu; % Users
Q = sigma.*randn(K,M) + mu; % Items

if giver
    % remove wish if any
    train(train(:,1)==0,:) = [];
end

if use_social
    S = sigma.*randn(N,N) + mu; 
else
    S = zeros(N,N);
end
Sdummy = zeros(N,N);

if use_time
    TI = sparse(M); 
else
    TI = sparse(M);
end
TIdummy = sparse(M);

res_auc_uni = [];
res_auc_bid = [];
res_s_auc_uni = [];
res_s_auc_bid = [];

figure;
subplot(2,1,1);
s_auc_uni = plot(nan); hold on; s_auc_bid = plot(nan);
subplot(2,1,2);
auc_uni = plot(nan);hold on; auc_bid = plot(nan);

cnt = 0;
negative_density = [];
positive_density = [];

for step=1:steps
        
        i = randi([1 length(train)]);
        if giver
            u  = train(i,1);
        else
            u  = train(i,2);
        end
        ii = train(i,3);
        iu = train(i,1);
        it = train(i,4);
        
        [ju ji] = sample_neg(u,R,C,train);
            
        px = (P(u,:) * (Q(:,ii)-Q(:,ji)));
        if iu ~= 0 && use_social
            px = px + (S(u,iu)-S(u,ju));
        elseif ii ~= 0 && it ~= 0 && use_time
            tdp = TI*time_density(iu, it, transac, true);
            tdn = TI*time_density(ju, it, transac, true);
            px  = px + (tdp-tdn);
        end
        z = 1 /(1 + exp(px));
        
        % update social bias
        if iu ~=0 && use_social
            d = z - lambda_S * S(u,iu);
            S(u,iu) = S(u,iu) + alpha * d;
            
            d = -z - lambda_S * S(u,ju);
            S(u,ju) = S(u,ju) + alpha * d;
        end
        
        % update P
        d = (Q(:,ii)-Q(:,ji))*z - lambda*P(u,:)';
        P(u,:) = P(u,:) + alpha*d';
        
        % update Q positive
        d = P(u,:)*z - lambda*Q(:,ii)';
        Q(:,ii) = Q(:,ii) + alpha*d';
        
        % update Q negative
        d = -P(u,:)*z - lambda*Q(:,ji)';
        Q(:,ji) = Q(:,ji) + alpha*d';
        
        if mod(cnt,100000)==0
            cnt = cnt + 1;
            
            if use_social
                [tauc_uni,tauc_bid] = auc( pairs_test, P, Q, R, S, C, train,transac);
                res_s_auc_uni = [res_s_auc_uni;tauc_uni];
                res_s_auc_bid = [res_s_auc_bid;tauc_bid];
            end
            
            if use_time
                [tauc_uni,tauc_bid] = auc( pairs_test, P, Q, R, S, C, TI,train,transac);
                res_s_auc_uni = [res_s_auc_uni;tauc_uni];
                res_s_auc_bid = [res_s_auc_bid;tauc_bid];
            end
            
            [tauc_uni,tauc_bid] = auc( pairs_test, P, Q, R, Sdummy, C,TIdummy,train,transac);
            res_auc_uni = [res_auc_uni;tauc_uni];
            res_auc_bid = [res_auc_bid;tauc_bid];
            
            if use_social
                set(s_auc_uni,'YData',res_s_auc_uni);
                set(s_auc_bid,'YData',res_s_auc_bid);
            end
            
            if use_time
                set(s_auc_uni,'YData',res_s_auc_uni);
                set(s_auc_bid,'YData',res_s_auc_bid);
            end
            
            set(auc_uni,'YData',res_auc_uni);
            set(auc_bid,'YData',res_auc_bid);
            drawnow;
            
        else
            cnt = cnt + 1;
        end

end


end

