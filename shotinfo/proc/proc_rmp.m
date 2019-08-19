function rmp = proc_rmp(shotno, time_range)
thres_rmp_val = 300;
thres_rmp_duration = 0.2;
if nargin < 2
    time_range = [];
end
rmp.status = 0;
sig = signal(shotno, 'east_1');
sig.nodename = {...
    'irmpu1', ...
    'irmpu2', ...
    'irmpu3', ...
    'irmpu4', ...
    'irmpu5', ...
    'irmpu6', ...
    'irmpu7', ...
    'irmpu8', ...
    'irmpl1', ...
    'irmpl2', ...
    'irmpl3', ...
    'irmpl4', ...
    'irmpl5', ...
    'irmpl6', ...
    'irmpl7', ...
    'irmpl8'};
sig.sigread(time_range);
sig.sigslice([0 sig.time(end)], 1);
rmp.signal = sig;

channel_status = [];
for i=1:size(sig.data, 1)
    inds = find(abs(sig.data(i,:))>=thres_rmp_val);
    if isempty(inds) || diff(sig.time(inds([1 end]))) < thres_rmp_duration
        channel_status(end+1) = 0;
    else
        channel_status(end+1) = 1;
    end
end
if sum(channel_status) >= 4
    rmp.status = 1;
    rmp.channel_status = channel_status;
end