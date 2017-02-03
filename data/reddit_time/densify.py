
pairs_in    = 'pairs.csv'
pairs_out   = 'pairs_dense2.csv'
wish_in     = 'wish.csv'
wish_out    = 'wish_dense2.csv'

u_store = {}
i_store = {}
u_cnt = 1
i_cnt = 1

with open(pairs_in) as f:
  lines = f.readlines()

t_out = []
for l in lines:
  la = l.strip().split(',')
  u1 = int(la[0])
  i1 = int(la[1])
  u2 = int(la[2])
  i2 = int(la[3])

  if u1 not in u_store:
    u_store[u1] = u_cnt
    u_cnt += 1
  if u2 not in u_store:
    u_store[u2] = u_cnt
    u_cnt += 1
  if i1 not in i_store:
    i_store[i1] = i_cnt
    i_cnt += 1
  if i2 not in i_store:
    i_store[i2] = i_cnt
    i_cnt += 1

  t_out.append((u_store[u1], i_store[i1], u_store[u2], i_store[i2]))

with open(pairs_out, 'w') as f:
  for t in t_out:
    f.write(str(t[0]) + ',' + str(t[1]) + ',' + str(t[2]) + ',' + str(t[3]) + '\n')

with open(wish_in) as f:
  lines = f.readlines()

t_out = []
for l in lines:
  la = l.strip().split(',')
  user     = int(la[0])
  item     = int(la[1])

  if user not in u_store:
    u_store[user] = u_cnt
    u_cnt += 1
  if item not in i_store:
    i_store[item] = i_cnt
    i_cnt += 1

  t_out.append((u_store[user], i_store[item]))

with open(wish_out, 'w') as f:
  for t in t_out:
    f.write(str(t[0]) + ',' + str(t[1]) + '\n')










