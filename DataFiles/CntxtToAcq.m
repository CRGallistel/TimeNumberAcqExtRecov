function T_C = CntxtToAcq(StA,SDs)
s = floor(StA); % last session before subject acquired
sf = StA-s; % fraction of the acquisition session elapsed at acquisition
T_C =sum(SDs(1:s)) + sf*SDs(s+1);
