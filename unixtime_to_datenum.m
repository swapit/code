function dn = unixtime_to_datenum( unix_time, truncate )
if truncate
  dn = floor(unix_time/86400 + 719529);         %# == datenum(1970,1,1)
else
  dn = unix_time/86400 + 719529;         %# == datenum(1970,1,1)
end
end

