function [ RR,RG,C,train,have,test_pairs,transac_out] = load_data( path )
direct_pairs = false;
pairs   = csvread(strcat(path, 'pairs_dense.csv'));
wish    = csvread(strcat(path, 'wish_dense.csv'));
try
    transac = csvread(strcat(path, 'transac_dense.csv'));
    have    = csvread(strcat(path, 'have_dense.csv'));
catch
    wish    = csvread(strcat(path, 'wish_dense.csv'));
    pairs = pairs + 1;
    wish = wish + 1;
    direct_pairs = true;
    pairs   = pairs(:,[1 2 3 4 5 5]);
    transac = [pairs(:,[1 3 2 5]);pairs(:,[3 1 4 5])];
    %transac = double.empty(0,3);
    have    = double.empty(0,2);
end

transac_out  = transac;
%transac(:,4) = unixtime_to_datenum(transac(:,4),true);
% min_time = min(transac(:,4))-1;
% max_time = max(transac(:,4));

transac_u = transac(:,1:2);
t_max_u = max(transac_u(:));
w_max_u = max(wish(:,1));
pairs_u = pairs(:,[1 3]);
p_max_u = max(pairs_u(:));
max_u = max([t_max_u p_max_u w_max_u]);
t_max_i = max(transac(:,3));
w_max_i = max(wish(:,2));
pairs_i = pairs(:,[2 4]);
p_max_i = max(pairs_i(:));
max_i = max([t_max_i p_max_i w_max_i]);

% interaction matrix - receiver
RR = sparse(max_u,max_i);
% interaction matrix - giver
RG = sparse(max_u,max_i);

% Create interaction matrix
% c_ij represent the number of transactions
% that i received from j
C = zeros(max_u,max_u);

% split test-train
num_test = floor(length(pairs)/10);
perms = randperm(length(pairs));
test_rows   = perms(1:num_test);
train_rows  = perms(num_test:end);
test_pairs  = pairs(test_rows,:);
train_pairs = pairs(train_rows,:);

if ~direct_pairs
    time_pairs = [length(test_pairs) 2];
    for i=1:length(test_pairs)
        idx1 = find(all(bsxfun(@eq, transac(:,[1 2 3]), test_pairs(i,[3 1 4])), 2));
        idx1 = idx1(randi([1 length(idx1)]));
        time_pairs(i,1) = transac(idx1,4);
        idx2 = find(all(bsxfun(@eq, transac(:,[1 2 3]), test_pairs(i,[1 3 2])), 2));
        idx2 = idx2(randi([1 length(idx2)]));
        time_pairs(i,2) = transac(idx2,4);
    end
    test_pairs = [test_pairs time_pairs];
end

% create train from transaction and pairs
% Giver - Receiver - Item
%train = [transac(:,[1 2 3]);train_pairs(:,[3 1 4]);train_pairs(:,[1 3 2])];
train = transac;
train = [train;[zeros(length(wish),1) wish zeros(length(wish),1)]];

% filter test set from train
% Should we remove observed ITEM or observed (ITEM - GIVER)
filter_test = [test_pairs(:,[1 4]);test_pairs(:,[3 2])];
indices = [];
for i=1:length(filter_test)
    index = find(all(bsxfun(@eq, train(:,[2 3]), filter_test(i,:)), 2));
    indices = [indices;index];
end
train(indices,:) = [];

train(train(:,2) > size(RR,1),:) = [];
train(train(:,3) > size(RR,2),:) = [];

% Compute train interaction matrix
for i=1:length(train)
    RR(train(i,2),train(i,3)) = 1;
    
    if train(i,1) ~= 0
        RG(train(i,1),train(i,3)) = 1;
        C(train(i,2),train(i,1)) = C(train(i,2),train(i,1)) + 1;
    end
end


end

