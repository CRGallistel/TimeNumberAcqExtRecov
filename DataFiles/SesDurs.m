function Drs = SesDurs(ED,SD)
d = ED-SD; % durations in Matlab's decimal representation
dv = datevec(d); % in date vector representation: el4 = hours; el5 = minutes; el5=seconds
Drs = 60*dv(:,4) +dv(:,5) + dv(:,6)/60; % session durations in minutes