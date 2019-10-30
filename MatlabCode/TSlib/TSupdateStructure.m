function TSupdateStructure
% Updates older Experiment structure by renaming the
% Eperiment.Info.ActiveTrial field to Experiment.Info.ActiveTrialType and
% the Experiment.Subject.Id field to Experiment.Subject.SubId
global Experiment
TSrenamefields('Info',{'ActiveTrial'},{'ActiveTrialType'})
TSrenamefields('Subject',{'Id'},{'SubId'})