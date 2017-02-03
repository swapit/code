clear;

addpath(genpath('data'));
path = 'data/ratebeer/';
disp(['loading from ',path]);
[RR,RG,C,train,have,test_pairs,transac] = load_data(path);
disp('loaded');

% training using MF BPR
mf_bpr(RR,C,train,test_pairs,true,false,false,transac);

