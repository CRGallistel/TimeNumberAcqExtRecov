function t =Acq(V,c)
% computes an estimate of the trial at which conditioned responding began
% V is the cumsum of poke elevation scores (# pokes during CS minus
% # pokes during immediately pre-CS interval of same duration). c is the
% decision criterion (amount by which cum rec must enduringly rise above
% minimum in order for algorithm to decide that subject acquired
M = min(V); % low point in cumulative record
Im = find(V<=M,1,'last');
t = Im + find(V(Im:end)>M+c,1); % trial on which rise from last minimum
% meets criterion