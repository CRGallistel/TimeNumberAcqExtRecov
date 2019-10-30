%{
this is my  code applied to Stathis's Experiment structures after I updated
them using the TSupdateStructure function so that the current (10/23/2019)
TSlib code works with them.
%}

%%------------Experiment 1
addpath('DataFiles','MatlabCode','MatlabCode/TSlib')
TSloadexperiment('DataFiles/Experiment1') % load Experiment structure
TSexperimentbrowser % open browser
%%
% for S=[1:6 13:18] % setting Phase field
%     for s = 1:Experiment.Subject(S).NumSessions
%         if s<=7
%             Experiment.Subject(S).Session(s).Phase = 1; % acquisition
%         elseif s>7 && s<9
%             Experiment.Subject(S).Session(s).Phase = 2; % extinction
%         elseif s==9
%             Experiment.Subject(S).Session(s).Phase = 3; % 1 wk test for recovery
%         else
%             Experiment.Subject(S).Session(s).Phase = 4; % 3 wk test for recovery
%         end
%     end
% end
% 
% for S=7:12
%     for s = 1:Experiment.Subject(S).NumSessions
%         if s<=28
%             Experiment.Subject(S).Session(s).Phase = 1; % acquisition
%         elseif s>28 && s<30
%             Experiment.Subject(S).Session(s).Phase = 2; % extinction
%         elseif s==30
%             Experiment.Subject(S).Session(s).Phase = 3; % 1 wk test for recovery
%         else
%              Experiment.Subject(S).Session(s).Phase = 4; % 3 wk test for recovery
%         end
%     end
% end
%%
TSlimit('Subjects','all')
TSlimit('Sessions','all')
TSlimit('Phases','all')
TSlimit('Trials','all')
%%
TSapplystat('CumRecPkElevationScores','PkNumElevationScores',@cumsum)
TSapplystat('CumRecPkDurElevScores','PkgDurElevationScores',@cumsum)

%% Acquisition Trial
c=20; % decision criterion for acquisition # of pokes by which cum rec of
% pokes must exceed its minimum
TSapplystat('AcqTrial','CumRecPkElevationScores' ,@Acq,c)
TSapplystat('','PkNumElevationScores',@TSplotcumrecs,'Rows',6,'Cols',3,...
    'Xlbl','Trial','LeftYlbl','cum(CS#-PreCS#')
for plt=1:18
    subplot(6,3,plt)
    hold on
    at=Experiment.Subject(plt).AcqTrial;
    plot([at at],ylim,'k-','LineWidth',1)
end    

%%
TSapplystat('PkNumDiff',{'CS_PkNumSes' 'PreCS_PkNumSes'},@minus)
TSapplystat('PkDurDiff',{'CS_PkgDurSes' 'PreCS_PkgDurSes'},@minus)
TSlimit('Phases',1);
TScombineover('AcqPkNumDiff','PkNumDiff'); % subject level

%%
TSlimit('Phases',2);
TScombineover('ExtPkNumDiff','PkNumDiff');
TSlimit('Phases',3);
TScombineover('Rec1PkNumDiff','PkNumDiff');
TSlimit('Phases',4);
TScombineover('Rec2PkNumDiff','PkNumDiff');
%%
TSlimit('Phases',1);
TScombineover('AcqPkDurDiff','PkDurDiff');
TSlimit('Phases',2);
TScombineover('ExtPkDurDiff','PkDurDiff');
TSlimit('Phases',3);
TScombineover('Rec1PkDurDiff','PkDurDiff');
TSlimit('Phases',4);
TScombineover('Rec2PkDurDiff','PkDurDiff');
%% Group 1: 7 trial-rich sessions on successive days
TSlimit('Subjects',1:6)
TSapplystat('','AcqPkNumDiff',@TSplotcumrecs,'Rows',3)
%
TSlimit('Sessions',7) % last acquisition session
TSlimit('Phases',1)
TSapplystat('','PkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Trial in Last Acq Sess',...
    'LeftYlbl','CSPks-10sPreCSPks')
%
TSlimit('Sessions','all')
TSlimit('Phases',2)
TSapplystat('','ExtPkNumDiff',@TSplotcumrecs,'Rows',3,'LeftYlm',[-10 85],...
    'Xlbl','Extinction Trial','Xlm',[0 40],'LeftYlbl','CSPks-10sPreCSPks')
%
TSlimit('Sessions','all')
TSlimit('Phases',3)
TSapplystat('','Rec1PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 1 Trial','Xlm',[0 4],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-2 10])
TSlimit('Phases',4)
TSapplystat('','Rec2PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 2 Trial','Xlm',[0 4],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-2 10])

%% Group 2: Many trial-poor sessions on successive days
TSlimit('Subjects',7:12)
%
TSlimit('Sessions',28) % last acquisition session
TSlimit('Phases',1)
TSapplystat('','PkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Trial in Last Acq Sess',...
    'LeftYlbl','CSPks-10sPreCSPks')
%
TSlimit('Sessions','all')
TSlimit('Phases',2)
TSapplystat('','ExtPkNumDiff',@TSplotcumrecs,'Rows',3,'LeftYlm',[-10 85],...
    'Xlbl','Extinction Trial','Xlm',[0 40],'LeftYlbl','CSPks-10sPreCSPks')
%
TSlimit('Sessions','all')
TSlimit('Phases',3)
TSapplystat('','Rec1PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 1 Trial','Xlm',[0 4],'LeftYlbl','CSPks-10sPreCSPks')
TSlimit('Phases',4)
TSapplystat('','Rec2PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 2 Trial','Xlm',[0 4],'LeftYlbl','CSPks-10sPreCSPks')

%% Group 3: 7 trial-rich sessions with 4-day average intersession interval
TSlimit('Subjects',13:18)
%
TSlimit('Sessions',7) % last acquisition session
TSlimit('Phases',1)
TSapplystat('','PkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Trial in Last Acq Sess',...
    'LeftYlbl','CSPks-10sPreCSPks')
%%
TSlimit('Sessions','all')
TSlimit('Phases',2)
TSapplystat('','ExtPkNumDiff',@TSplotcumrecs,'Rows',3,'LeftYlm',[0 140],...
    'Xlbl','Extinction Trial','Xlm',[0 55],'LeftYlbl','CSPks-10sPreCSPks')
%%
TSlimit('Sessions','all')
TSlimit('Phases',3)
TSapplystat('','Rec1PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 1 Trial','Xlm',[0 4],'LeftYlbl','CSPks-10sPreCSPks')
TSlimit('Phases',4)
TSapplystat('','Rec2PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 2 Trial','Xlm',[0 4],'LeftYlbl','CSPks-10sPreCSPks')
%% Summary stats for each subject
TSlimit('Subjects','all')
TSapplystat('CumExtPkNumDiff','ExtPkNumDiff',@sum)
TSapplystat('CumExtPkDurDiff','ExtPkDurDiff',@sum)
TSapplystat('TrlsToExt','ExtPkNumDiff',@numel)
TSapplystat('CumRec1PkNumDiff','Rec1PkNumDiff',@sum)
TSapplystat('CumRec2PkNumDiff','Rec2PkNumDiff',@sum)
TSapplystat('CumRec1PkDurDiff','Rec1PkDurDiff',@sum)
TSapplystat('CumRec2PkDurDiff','Rec2PkDurDiff',@sum)
%% Mean poke rate difference each session
TSlimit('Phases',1)
TSapplystat('MeanPkRateDiff','PkNumDiff',@mean)
TSapplystat('MeanPkDurDiff','PkDurDiff',@mean)
%% Response rate last Acq Trial
TSlimit('Subjects',[1:6 13:18])
TSlimit('Sessions',7)
TScombineover('MeanPkRateDiffLastAcqSes','MeanPkRateDiff') % subject level
TScombineover('MeanPkDurDiffLastAcqSes','MeanPkDurDiff') %subject level

TSlimit('Subjects',7:12)
TSlimit('Sessions',28)
TScombineover('MeanPkRateDiffLastAcqSes','MeanPkRateDiff') % subject level
TScombineover('MeanPkDurDiffLastAcqSes','MeanPkDurDiff') %subject level
%% Aggregating summary stats by groups to Experiment level
TSlimit('Subjects',1:6)
TScombineover('Grp_7_40_7_MnPkRateDiffLstAcq','MeanPkRateDiffLastAcqSes')
TScombineover('Grp_7_40_7_MnPkDurDiffLstAcq','MeanPkDurDiffLastAcqSes')
TScombineover('Grp_7_40_7_CumExtPkNumDiff','CumExtPkNumDiff')
TScombineover('Grp_7_40_7_CumExtPkDurDiff','CumExtPkDurDiff')
TScombineover('Grp_7_40_7_TrlsToExt','TrlsToExt')
TScombineover('Grp_7_40_7_CumRec1PkNumDiff','CumRec1PkNumDiff')
TScombineover('Grp_7_40_7_CumRec2PkNumDiff','CumRec2PkNumDiff')
TScombineover('Grp_7_40_7_CumRec1PkDurDiff','CumRec1PkDurDiff')
TScombineover('Grp_7_40_7_CumRec2PkDurDiff','CumRec2PkDurDiff')
TScombineover('Grp_7_40_7_AcqTrials','AcqTrial')
%
TSlimit('Subjects',7:12)
TScombineover('Grp_28_10_28_MnPkRateDiffLstAcq','MeanPkRateDiffLastAcqSes')
TScombineover('Grp_28_10_28_MnPkDurDiffLstAcq','MeanPkDurDiffLastAcqSes')
TScombineover('Grp_28_10_28_CumExtPkNumDiff','CumExtPkNumDiff')
TScombineover('Grp_28_10_28_CumExtPkDurDiff','CumExtPkDurDiff')
TScombineover('Grp_28_10_28_TrlsToExt','TrlsToExt')
TScombineover('Grp_28_10_28_CumRec1PkNumDiff','CumRec1PkNumDiff')
TScombineover('Grp_28_10_28_CumRec2PkNumDiff','CumRec2PkNumDiff')
TScombineover('Grp_28_10_28_CumRec1PkDurDiff','CumRec1PkDurDiff')
TScombineover('Grp_28_10_28_CumRec2PkDurDiff','CumRec2PkDurDiff')
TScombineover('Grp_28_10_28_AcqTrials','AcqTrial')

TSlimit('Subjects',13:18)
TScombineover('Grp_7_40_28_MnPkRateDiffLstAcq','MeanPkRateDiffLastAcqSes')
TScombineover('Grp_7_40_28_MnPkDurDiffLstAcq','MeanPkDurDiffLastAcqSes')
TScombineover('Grp_7_40_28_CumExtPkNumDiff','CumExtPkNumDiff')
TScombineover('Grp_7_40_28_CumExtPkDurDiff','CumExtPkDurDiff')
TScombineover('Grp_7_40_28_TrlsToExt','TrlsToExt')
TScombineover('Grp_7_40_28_CumRec1PkNumDiff','CumRec1PkNumDiff')
TScombineover('Grp_7_40_28_CumRec2PkNumDiff','CumRec2PkNumDiff')
TScombineover('Grp_7_40_28_CumRec1PkDurDiff','CumRec1PkDurDiff')
TScombineover('Grp_7_40_28_CumRec2PkDurDiff','CumRec2PkDurDiff')
TScombineover('Grp_7_40_28_AcqTrials','AcqTrial')

%% Between Group CDFs of summary statistics
figure % MEAN RATE DIFF LAST ACQ SESSION
subplot(3,2,1)
cdfplot(Experiment.Grp_7_40_7_MnPkRateDiffLstAcq)
hold on
cdfplot(Experiment.Grp_28_10_28_MnPkRateDiffLstAcq)
cdfplot(Experiment.Grp_7_40_28_MnPkRateDiffLstAcq)
xlabel('Mean CS-Pre Poke # Last Acq Sess')
legend('7,40,7,280','28,10,28,280','7,40,28,280','location','NW')
title('')
%
subplot(3,2,2)
cdfplot(Experiment.Grp_7_40_7_CumExtPkNumDiff)
hold on
cdfplot(Experiment.Grp_28_10_28_CumExtPkNumDiff)
cdfplot(Experiment.Grp_7_40_28_CumExtPkNumDiff)
xlabel('Total Pk # Diff in Ext')
title('')
%
subplot(3,2,3)
cdfplot(Experiment.Grp_7_40_7_TrlsToExt)
hold on
cdfplot(Experiment.Grp_28_10_28_TrlsToExt)
cdfplot(Experiment.Grp_7_40_28_TrlsToExt)
xlabel('Trials to Ext')
title('')
%
subplot(3,2,4)
cdfplot(Experiment.Grp_7_40_7_CumRec1PkNumDiff)
hold on
cdfplot(Experiment.Grp_28_10_28_CumRec1PkNumDiff)
cdfplot(Experiment.Grp_7_40_28_CumRec1PkNumDiff)
xlabel('Total Pks# Dif @ 1 wk')
title('')
%
subplot(3,2,5)
cdfplot(Experiment.Grp_7_40_7_CumRec2PkNumDiff)
hold on
cdfplot(Experiment.Grp_28_10_28_CumRec2PkNumDiff)
cdfplot(Experiment.Grp_7_40_28_CumRec2PkNumDiff)
xlabel('Total Pks# Dif @ 3 wks')
title('')
%%
figure
subplot(2,2,1)
cdfplot(Experiment.Grp_7_40_7_MnPkDurDiffLstAcq)
hold on
cdfplot(Experiment.Grp_28_10_28_MnPkDurDiffLstAcq)
cdfplot(Experiment.Grp_7_40_28_MnPkDurDiffLstAcq)
xlabel('Mean CS-Pre Poke Dur Last Acq Sess')
legend('7,40,7,280','28,10,28,280','7,40,28,280','location','NW')
title('')
%
subplot(2,2,2)
cdfplot(Experiment.Grp_7_40_7_CumExtPkDurDiff)
hold on
cdfplot(Experiment.Grp_28_10_28_CumExtPkDurDiff)
cdfplot(Experiment.Grp_7_40_28_CumExtPkDurDiff)
xlabel('Total Pk Dur Diff in Ext')
title('')

subplot(2,2,3)
cdfplot(Experiment.Grp_7_40_7_CumRec1PkDurDiff)
hold on
cdfplot(Experiment.Grp_28_10_28_CumRec1PkDurDiff)
cdfplot(Experiment.Grp_7_40_28_CumRec1PkDurDiff)
xlabel('Total Pk Dur Diff @ 1 wk')
title('')
%
subplot(2,2,4)
cdfplot(Experiment.Grp_7_40_7_CumRec2PkDurDiff)
hold on
cdfplot(Experiment.Grp_28_10_28_CumRec2PkDurDiff)
cdfplot(Experiment.Grp_7_40_28_CumRec2PkDurDiff)
xlabel('Total Pk Dur Dif @ 3 wks')
title('')




%%
%%------------Experiment 2
%%
cd('/Users/galliste/Dropbox/Stathis Thesis/Experiments/SessionNumberReplication2')
TSloadexperiment('SessionNumberReplic2_5')
Experiment.Info.ShowProgress=0;

%% Setting Phase field
for S=1:6 % setting Phase field
    for s = 1:Experiment.Subject(S).NumSessions
        if s<=24
            Experiment.Subject(S).Session(s).Phase = 1; % acquisition
        elseif s>24 && s<26
            Experiment.Subject(S).Session(s).Phase = 2; % extinction
        elseif s>25 && s<28
            Experiment.Subject(S).Session(s).Phase = 3; % context extinction
        elseif s==28
            Experiment.Subject(S).Session(s).Phase = 4; % 1 wk test for recovery
        else
            Experiment.Subject(S).Session(s).Phase = 5; % 3 wk test for recovery
        end
    end
end

for S=7:12
    for s = 1:Experiment.Subject(S).NumSessions
        if s<=6
            Experiment.Subject(S).Session(s).Phase = 1; % acquisition
        elseif s==7
            Experiment.Subject(S).Session(s).Phase = 2; % extinction
        elseif s>7 && s<10
            Experiment.Subject(S).Session(s).Phase = 3; % context extinction
        elseif s==10
             Experiment.Subject(S).Session(s).Phase = 4; % 1 wk test for recovery
        else
            Experiment.Subject(S).Session(s).Phase = 5; % 3 wk test for recovery
        end
    end
end
%%
TSlimit('Subjects','all')
TSlimit('Sessions','all')
TSlimit('Phases','all')
TSlimit('Trials','all')
%%
TSapplystat('CumRecPkElevationScores','PkNumElevationScores',@cumsum) % subject level
TSapplystat('CumRecPkDurElevScores','PkgDurElevationScores',@cumsum) % subject level

%% Acquisition Trial
c=20; % decision criterion for acquisition # of pokes by which cum rec of
% pokes must exceed its minimum
TSapplystat('AcqTrial','CumRecPkElevationScores' ,@Acq,c)
TSapplystat('','PkNumElevationScores',@TSplotcumrecs,'Rows',6,'Cols',2,...
    'Xlbl','Trial','LeftYlbl','cum(CS#-PreCS#')
for plt=1:12
    subplot(6,2,plt)
    hold on
    at=Experiment.Subject(plt).AcqTrial;
    plot([at at],ylim,'k-','LineWidth',1)
end    


%%
TSapplystat('PkNumDiff',{'CS_PkNumSes' 'PreCS_PkNumSes'},@minus) % session level
TSapplystat('PkDurDiff',{'CS_PkgDurSes' 'PreCS_PkgDurSes'},@minus) % session level
%%
TSlimit('Phases',1); % training
TScombineover('AcqPkNumDiff','PkNumDiff');
TSlimit('Phases',2); % extinction
TScombineover('ExtPkNumDiff','PkNumDiff');
TSlimit('Phases',4); % recovery 1 wk
TScombineover('Rec1PkNumDiff','PkNumDiff');
TSlimit('Phases',5); % recovery 3 wks
TScombineover('Rec2PkNumDiff','PkNumDiff');
%%
TSlimit('Phases',1); % training
TScombineover('AcqPkDurDiff','PkDurDiff');
TSlimit('Phases',2); % extinction
TScombineover('ExtPkDurDiff','PkDurDiff');
TSlimit('Phases',4); % recovery 1 wk
TScombineover('Rec1PkDurDiff','PkDurDiff');
TSlimit('Phases',5); % recocvery 3 wks
TScombineover('Rec2PkDurDiff','PkDurDiff');

%% Group 1: 24 10-trial sessions on successive days
TSlimit('Subjects',1:6) % all sessions still in force
TSapplystat('','AcqPkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Acq Trial',...
    'LeftYlbl','Cum CS-Pre Pk#diff')
%
TSlimit('Sessions',24) % last acquisition session
TSlimit('Phases',1)
TSapplystat('','PkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Trial in Last Acq Sess',...
    'LeftYlbl','Cum CS-Pre Pk#diff')
%%
TSlimit('Sessions','all')
TSlimit('Phases',2)
TSapplystat('','ExtPkNumDiff',@TSplotcumrecs,'Rows',3,'LeftYlm',[-10 85],...
    'Xlbl','Extinction Trial','Xlm',[0 40],'LeftYlbl','CSPks-10sPreCSPks')
%%
TSlimit('Phases',4)
TSapplystat('','Rec1PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 1 Trial','Xlm',[0 4],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[0 15])
TSlimit('Phases',5)
TSapplystat('','Rec2PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 2 Trial','Xlm',[0 4],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[0 15])

%% Group 2: 6 40-trial sessions
TSlimit('Subjects',7:12)
TSlimit('Sessions',1:6)
TSapplystat('','AcqPkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Acq Trial',...
    'LeftYlbl','Cum CS-Pre Pk#diff')
%
TSlimit('Sessions',6) % last acquisition session
TSlimit('Phases',1)
TSapplystat('','PkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Trial in Last Acq Sess',...
    'LeftYlbl','CSPks-10sPreCSPks')
%%
TSlimit('Sessions','all')
TSlimit('Phases',2)
TSapplystat('','ExtPkNumDiff',@TSplotcumrecs,'Rows',3,'LeftYlm',[-10 85],...
    'Xlbl','Extinction Trial','Xlm',[0 40],'LeftYlbl','CSPks-10sPreCSPks')
%%
TSlimit('Sessions','all')
TSlimit('Phases',4)
TSapplystat('','Rec1PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 1 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-5 15])
TSlimit('Phases',5)
TSapplystat('','Rec2PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 2 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-5 15])

%% Summary stats for each subject
TSlimit('Subjects','all')
TSapplystat('CumExtPkNumDiff','ExtPkNumDiff',@sum)
TSapplystat('CumExtPkDurDiff','ExtPkDurDiff',@sum)
TSapplystat('TrlsToExt','ExtPkNumDiff',@numel)
TSapplystat('CumRec1PkNumDiff','Rec1PkNumDiff',@sum)
TSapplystat('CumRec2PkNumDiff','Rec2PkNumDiff',@sum)
TSapplystat('CumRec1PkDurDiff','Rec1PkDurDiff',@sum)
TSapplystat('CumRec2PkDurDiff','Rec2PkDurDiff',@sum)
%% Mean poke rate difference each session
TSlimit('Phases',1)
TSapplystat('MeanPkRateDiff','PkNumDiff',@mean)
TSapplystat('MeanPkDurDiff','PkDurDiff',@mean)
%% Response rate last Acq Trial
TSlimit('Subjects',1:6)
TSlimit('Sessions',24)
TScombineover('MeanPkRateDiffLastAcqSes','MeanPkRateDiff') % subject level
TScombineover('MeanPkDurDiffLastAcqSes','MeanPkDurDiff') %subject level

TSlimit('Subjects',7:12)
TSlimit('Sessions',6)
TScombineover('MeanPkRateDiffLastAcqSes','MeanPkRateDiff') % subject level
TScombineover('MeanPkDurDiffLastAcqSes','MeanPkDurDiff') %subject level
%% Aggregating summary stats by groups to Experiment level
TSlimit('Subjects',1:6)
TScombineover('G24_10_24_240MnPkRateDiffLstAcq','MeanPkRateDiffLastAcqSes')
TScombineover('G24_10_24_240MnPkDurDiffLstAcq','MeanPkDurDiffLastAcqSes')
TScombineover('G24_10_24_240CumExtPkNumDiff','CumExtPkNumDiff')
TScombineover('G24_10_24_240CumExtPkDurDiff','CumExtPkDurDiff')
TScombineover('G24_10_24_240TrlsToExt','TrlsToExt')
TScombineover('G24_10_24_240CumRec1PkNumDiff','CumRec1PkNumDiff')
TScombineover('G24_10_24_240CumRec2PkNumDiff','CumRec2PkNumDiff')
TScombineover('G24_10_24_240CumRec1PkDurDiff','CumRec1PkDurDiff')
TScombineover('G24_10_24_240CumRec2PkDurDiff','CumRec2PkDurDiff')
TScombineover('G24_10_24_240AcqTrials','AcqTrial')
%
TSlimit('Subjects',7:12)
TScombineover('G6_40_6_240MnPkRateDiffLstAcq','MeanPkRateDiffLastAcqSes')
TScombineover('G6_40_6_240MnPkDurDiffLstAcq','MeanPkDurDiffLastAcqSes')
TScombineover('G6_40_6_240CumExtPkNumDiff','CumExtPkNumDiff')
TScombineover('G6_40_6_240CumExtPkDurDiff','CumExtPkDurDiff')
TScombineover('G6_40_6_240TrlsToExt','TrlsToExt')
TScombineover('G6_40_6_240CumRec1PkNumDiff','CumRec1PkNumDiff')
TScombineover('G6_40_6_240CumRec2PkNumDiff','CumRec2PkNumDiff')
TScombineover('G6_40_6_240CumRec1PkDurDiff','CumRec1PkDurDiff')
TScombineover('G6_40_6_240CumRec2PkDurDiff','CumRec2PkDurDiff')
TScombineover('G6_40_6_240AcqTrials','AcqTrial')

%% Between Group CDFs of summary statistics
figure
subplot(3,2,1)
cdfplot(Experiment.G24_10_24_240MnPkRateDiffLstAcq)
hold on
cdfplot(Experiment.G6_40_6_240MnPkRateDiffLstAcq)
xlabel('Mean CS-Pre Poke # Last Acq Sess')
legend('24,10,24,240','6,40,6,240','location','NW')
title('')
%
subplot(3,2,2)
cdfplot(Experiment.G24_10_24_240CumExtPkNumDiff)
hold on
cdfplot(Experiment.G6_40_6_240CumExtPkNumDiff)
xlabel('Total Pk # Diff in Ext')
title('')
%
subplot(3,2,3)
cdfplot(Experiment.G24_10_24_240TrlsToExt)
hold on
cdfplot(Experiment.G6_40_6_240TrlsToExt)
xlabel('Trials to Ext')
title('')
%
subplot(3,2,4)
cdfplot(Experiment.G24_10_24_240CumRec1PkNumDiff)
hold on
cdfplot(Experiment.G6_40_6_240CumRec1PkNumDiff)
xlabel('Total Pks# Dif @ 1 wk')
title('')
%
subplot(3,2,5)
cdfplot(Experiment.G24_10_24_240CumRec2PkNumDiff)
hold on
cdfplot(Experiment.G6_40_6_240CumRec2PkNumDiff)
xlabel('Total Pks# Dif @ 3 wks')
title('')
%%
figure
subplot(2,2,1)
cdfplot(Experiment.G24_10_24_240MnPkDurDiffLstAcq)
hold on
cdfplot(Experiment.G6_40_6_240MnPkDurDiffLstAcq)
xlabel('Mean CS-Pre Poke Dur Last Acq Sess')
legend('24,10,24,240','6,40,6,240','location','NW')
title('')
%
subplot(2,2,2)
cdfplot(Experiment.G24_10_24_240CumExtPkDurDiff)
hold on
cdfplot(Experiment.G6_40_6_240CumExtPkDurDiff)
xlabel('Total Pk Dur Diff in Ext')
title('')

subplot(2,2,3)
cdfplot(Experiment.G24_10_24_240CumRec1PkDurDiff)
hold on
cdfplot(Experiment.G6_40_6_240CumRec1PkDurDiff)
xlabel('Total Pk Dur Diff @ 1 wk')
title('')
%
subplot(2,2,4)
cdfplot(Experiment.G24_10_24_240CumRec2PkDurDiff)
hold on
cdfplot(Experiment.G6_40_6_240CumRec2PkDurDiff)
xlabel('Total Pk Dur Dif @ 3 wks')
title('')





%%
%%------------------Experiment 3 (old 4)
%%
cd('/Users/galliste/Dropbox/Stathis Thesis/Experiments/SessnsRgrdlsTrials')
TSloadexperiment('SessnsRgrdlsTrials_3')
% Grp 1 (Subs 1:6): 8 daily sessions, 10 trials/session, 80 total trials, 
% training spanned 8 days
% Grp 2 (Subs7:12): 8 daily sessions, 40 trials/session, 320 total trials,
% traning spanned 8 days
Experiment.Info.ShowProgress=0;
%% Setting Phase field
for S=1:6 % setting Phase field
    for s = 1:Experiment.Subject(S).NumSessions
        if s<9 % training
            Experiment.Subject(S).Session(s).Phase = 1; % acquisition
        elseif s==9 % extinction
            Experiment.Subject(S).Session(s).Phase = 2; % extinction
        elseif s==10
            Experiment.Subject(S).Session(s).Phase = 3; % 1 wk test for recovery
        else
            Experiment.Subject(S).Session(s).Phase = 4; % 3 wk test for recovery
        end
    end
end

for S=7:12
    for s = 1:Experiment.Subject(S).NumSessions
        if s<9 % training
            Experiment.Subject(S).Session(s).Phase = 1; % acquisition
        elseif s==9 % extinction
            Experiment.Subject(S).Session(s).Phase = 2; % extinction
        elseif s==10
            Experiment.Subject(S).Session(s).Phase = 3; % 1 wk test for recovery
        else
            Experiment.Subject(S).Session(s).Phase = 4; % 3 wk test for recovery
        end
    end
end
%%
TSlimit('Subjects','all')
TSlimit('Sessions','all')
TSlimit('Phases','all')
TSlimit('Trials','all')
%%
TSapplystat('CumRecPkElevationScores','PkNumElevationScores',@cumsum) % subject level
TSapplystat('CumRecPkDurElevScores','PkgDurElevationScores',@cumsum) % subject level

%% Acquisition Trial
c=20; % decision criterion for acquisition # of pokes by which cum rec of
% pokes must exceed its minimum
TSapplystat('AcqTrial','CumRecPkElevationScores' ,@Acq,c)

TSapplystat('','PkNumElevationScores',@TSplotcumrecs,'Rows',6,'Cols',2,...
    'Xlm',[0 400],'Xlbl','Trial','LeftYlbl','cum(CS#-PreCS#')
for plt=1:12
    subplot(6,2,plt)
    hold on
    at=Experiment.Subject(plt).AcqTrial;
    plot([at at],ylim,'k-','LineWidth',1)
end    

%%
TSapplystat('PkNumDiff',{'CS_PkNumSes' 'PreCS_PkNumSes'},@minus) % session level
TSapplystat('PkDurDiff',{'CS_PkgDurSes' 'PreCS_PkgDurSes'},@minus) % session level
%%
TSlimit('Phases',1); % training
TScombineover('AcqPkNumDiff','PkNumDiff'); % subject level
%%
c=20; % decision criterion for acquisition: # of pokes by which cum record
% of CS-PreCS poke # differences must exceed its last minimum
TSapplystat('AcqTrial','AcqPkNumDiff',@Acq,c) % computing acquisition trial
%%
TSlimit('Phases',2); % extinction
TScombineover('ExtPkNumDiff','PkNumDiff'); % subject level
TSlimit('Phases',3); % recovery 1 wk
TScombineover('Rec1PkNumDiff','PkNumDiff'); % subject level
TSlimit('Phases',4); % recovery 3 wks
TScombineover('Rec2PkNumDiff','PkNumDiff'); % subject level
%%
TSlimit('Phases',1); % training
TScombineover('AcqPkDurDiff','PkDurDiff'); % subject level
TSlimit('Phases',2); % extinction
TScombineover('ExtPkDurDiff','PkDurDiff'); % subject level
TSlimit('Phases',3); % recovery 1 wk
TScombineover('Rec1PkDurDiff','PkDurDiff'); % subject level
TSlimit('Phases',4); % recocvery 3 wks
TScombineover('Rec2PkDurDiff','PkDurDiff'); % subject level

%% Group 1: 8 10-trial sessions on successive days, 80 total trials, 8 days spanned
TSlimit('Subjects',1:6)
TSapplystat('','AcqPkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Acq Trial',...
    'LeftYlbl','Cum CS-Pre Pk#diff')
for plt=1:6
    subplot(3,2,plt)
    hold on
    at=Experiment.Subject(plt).AcqTrial;
    plot([at at],ylim,'k--','LineWidth',1)
end
%%
TSlimit('Sessions',8) % last acquisition session
TSlimit('Phases',1)
TSapplystat('','PkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Trial in Last Acq Sess',...
    'LeftYlbl','Cum CS-Pre Pk#diff')
%%
TSlimit('Sessions','all')
TSlimit('Phases',2)
TSapplystat('','ExtPkNumDiff',@TSplotcumrecs,'Rows',3,'LeftYlm',[-10 85],...
    'Xlbl','Extinction Trial','Xlm',[0 40],'LeftYlbl','CSPks-10sPreCSPks')
%%
TSlimit('Phases',3)
TSapplystat('','Rec1PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 1 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-4 15])
TSlimit('Phases',4)
TSapplystat('','Rec2PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 2 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-4 15])

%% Group 2: 8 40-trial sessions on successive days
TSlimit('Subjects',7:12)
TSapplystat('','AcqPkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Acq Trial',...
    'LeftYlbl','Cum CS-Pre Pk#diff')
for plt=1:6
    subplot(3,2,plt)
    hold on
    at=Experiment.Subject(plt+6).AcqTrial;
    plot([at at],ylim,'k--','LineWidth',1)
end
%%
TSlimit('Sessions',8) % last acquisition session
TSlimit('Phases',1)
TSapplystat('','PkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Trial in Last Acq Sess',...
    'LeftYlbl','CSPks-10sPreCSPks')
%%
TSlimit('Sessions','all')
TSlimit('Phases',2)
TSapplystat('','ExtPkNumDiff',@TSplotcumrecs,'Rows',3,'LeftYlm',[-10 85],...
    'Xlbl','Extinction Trial','Xlm',[0 40],'LeftYlbl','CSPks-10sPreCSPks')
%%
TSlimit('Sessions','all')
TSlimit('Phases',3)
TSapplystat('','Rec1PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 1 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-5 15])
TSlimit('Phases',4)
TSapplystat('','Rec2PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 2 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-5 15])

%% Summary stats for each subject
TSlimit('Subjects','all')
TSapplystat('CumExtPkNumDiff','ExtPkNumDiff',@sum)
TSapplystat('CumExtPkDurDiff','ExtPkDurDiff',@sum)
TSapplystat('TrlsToExt','ExtPkNumDiff',@numel)
TSapplystat('CumRec1PkNumDiff','Rec1PkNumDiff',@sum)
TSapplystat('CumRec2PkNumDiff','Rec2PkNumDiff',@sum)
TSapplystat('CumRec1PkDurDiff','Rec1PkDurDiff',@sum)
TSapplystat('CumRec2PkDurDiff','Rec2PkDurDiff',@sum)
%% Mean poke rate difference each session
TSlimit('Phases',1)
TSapplystat('MeanPkRateDiff','PkNumDiff',@mean)
TSapplystat('MeanPkDurDiff','PkDurDiff',@mean)
%% Response rate last Acq Trial
TSlimit('Subjects',1:6)
TSlimit('Sessions',8)
TScombineover('MeanPkRateDiffLastAcqSes','MeanPkRateDiff') % subject level
TScombineover('MeanPkDurDiffLastAcqSes','MeanPkDurDiff') %subject level

TSlimit('Subjects',7:12)
TSlimit('Sessions',8)
TScombineover('MeanPkRateDiffLastAcqSes','MeanPkRateDiff') % subject level
TScombineover('MeanPkDurDiffLastAcqSes','MeanPkDurDiff') %subject level
%% Aggregating summary stats by groups to Experiment level
TSlimit('Subjects',1:6)
TScombineover('G8_10_8_80MnPkRateDiffLstAcq','MeanPkRateDiffLastAcqSes')
TScombineover('G8_10_8_80MnPkDurDiffLstAcq','MeanPkDurDiffLastAcqSes')
TScombineover('G8_10_8_80CumExtPkNumDiff','CumExtPkNumDiff')
TScombineover('G8_10_8_80CumExtPkDurDiff','CumExtPkDurDiff')
TScombineover('G8_10_8_80TrlsToExt','TrlsToExt')
TScombineover('G8_10_8_80CumRec1PkNumDiff','CumRec1PkNumDiff')
TScombineover('G8_10_8_80CumRec2PkNumDiff','CumRec2PkNumDiff')
TScombineover('G8_10_8_80CumRec1PkDurDiff','CumRec1PkDurDiff')
TScombineover('G8_10_8_80CumRec2PkDurDiff','CumRec2PkDurDiff')
TScombineover('G8_10_8_80AcqTrials','AcqTrial')
%
TSlimit('Subjects',7:12)
TScombineover('G8_40_8_320MnPkRateDiffLstAcq','MeanPkRateDiffLastAcqSes')
TScombineover('G8_40_8_320MnPkDurDiffLstAcq','MeanPkDurDiffLastAcqSes')
TScombineover('G8_40_8_320CumExtPkNumDiff','CumExtPkNumDiff')
TScombineover('G8_40_8_320CumExtPkDurDiff','CumExtPkDurDiff')
TScombineover('G8_40_8_320TrlsToExt','TrlsToExt')
TScombineover('G8_40_8_320CumRec1PkNumDiff','CumRec1PkNumDiff')
TScombineover('G8_40_8_320CumRec2PkNumDiff','CumRec2PkNumDiff')
TScombineover('G8_40_8_320CumRec1PkDurDiff','CumRec1PkDurDiff')
TScombineover('G8_40_8_320CumRec2PkDurDiff','CumRec2PkDurDiff')
TScombineover('G8_40_8_320AcqTrials','AcqTrial')

%% Between Group CDFs of summary statistics
figure
subplot(3,2,1)
cdfplot(Experiment.G8_10_8_80MnPkRateDiffLstAcq)
hold on
cdfplot(Experiment.G8_40_8_320MnPkRateDiffLstAcq)
xlabel('Mean CS-Pre Poke # Last Acq Sess')
legend('8,10,8,80','8,40,8,320','location','NW')
title('')
%
subplot(3,2,2)
cdfplot(Experiment.G8_10_8_80CumExtPkNumDiff)
hold on
cdfplot(Experiment.G8_40_8_320CumExtPkNumDiff)
xlabel('Total Pk # Diff in Ext')
title('')
%
subplot(3,2,3)
cdfplot(Experiment.G8_10_8_80TrlsToExt)
hold on
cdfplot(Experiment.G8_40_8_320TrlsToExt)
xlabel('Trials to Ext')
title('')
%
subplot(3,2,4)
cdfplot(Experiment.G8_10_8_80CumRec1PkNumDiff)
hold on
cdfplot(Experiment.G8_40_8_320CumRec1PkNumDiff)
xlabel('Total Pks# Dif @ 1 wk')
title('')
%
subplot(3,2,5)
cdfplot(Experiment.G8_10_8_80CumRec2PkNumDiff)
hold on
cdfplot(Experiment.G8_40_8_320CumRec2PkNumDiff)
xlabel('Total Pks# Dif @ 3 wks')
title('')
%
figure
subplot(2,2,1)
cdfplot(Experiment.G8_10_8_80MnPkDurDiffLstAcq)
hold on
cdfplot(Experiment.G8_40_8_320MnPkDurDiffLstAcq)
xlabel('Mean CS-Pre Poke Dur Last Acq Sess')
legend('8,10,8,80','8,40,8,320','location','NW')
title('')
%
subplot(2,2,2)
cdfplot(Experiment.G8_10_8_80CumExtPkDurDiff)
hold on
cdfplot(Experiment.G8_40_8_320CumExtPkDurDiff)
xlabel('Total Pk Dur Diff in Ext')
title('')

subplot(2,2,3)
cdfplot(Experiment.G8_10_8_80CumRec1PkDurDiff)
hold on
cdfplot(Experiment.G8_40_8_320CumRec1PkDurDiff)
xlabel('Total Pk Dur Diff @ 1 wk')
title('')
%
subplot(2,2,4)
cdfplot(Experiment.G8_10_8_80CumRec2PkDurDiff)
hold on
cdfplot(Experiment.G8_40_8_320CumRec2PkDurDiff)
xlabel('Total Pk Dur Dif @ 3 wks')
title('')




%%
%%----------------------Experiment 4 (old 5)
cd('/Users/galliste/Dropbox/Stathis Thesis/Experiments/SessnsVrsTrials')
TSloadexperiment('SessionsVersusTrials_4')
% Grp 1 (Subs 1:6): 28 daily sessions, 2 or 3 trials/session, 70 total trials, 
% training spanned 28 days
% Grp 2 (Subs7:12): 7 daily sessions, 40 trials/session, 280 total trials,
% traning spanned 7 days
% Experiment.Info.ShowProgress=0;
%% Setting Phase field
for S=1:6 % setting Phase field
    for s = 1:Experiment.Subject(S).NumSessions
        if s<29 % training
            Experiment.Subject(S).Session(s).Phase = 1; % acquisition
        elseif s==29 % extinction
            Experiment.Subject(S).Session(s).Phase = 2; % extinction
        elseif s==30
            Experiment.Subject(S).Session(s).Phase = 3; % 1 wk test for recovery
        else
            Experiment.Subject(S).Session(s).Phase = 4; % 3 wk test for recovery
        end
    end
end

for S=7:12
    for s = 1:Experiment.Subject(S).NumSessions
        if s<8 % training
            Experiment.Subject(S).Session(s).Phase = 1; % acquisition
        elseif s==8 % extinction
            Experiment.Subject(S).Session(s).Phase = 2; % extinction
        elseif s==9
            Experiment.Subject(S).Session(s).Phase = 3; % 1 wk test for recovery
        else
            Experiment.Subject(S).Session(s).Phase = 4; % 3 wk test for recovery
        end
    end
end
%%
TSlimit('Subjects','all')
TSlimit('Sessions','all')
TSlimit('Phases','all')
TSlimit('Trials','all')
%%
TSapplystat('CumRecPkElevationScores','PkNumElevationScores',@cumsum) % subject level
TSapplystat('CumRecPkDurElevScores','PkgDurElevationScores',@cumsum) % subject levelx

%% Acquisition Trial
c=20; % decision criterion for acquisition # of pokes by which cum rec of
% pokes must exceed its minimum
TSapplystat('AcqTrial','CumRecPkElevationScores' ,@Acq,c)
%%
TSlimit('Subjects','all')
TSapplystat('','PkNumElevationScores',@TSplotcumrecs,'Rows',6,'Cols',2,...
    'Xlm',[0 350],'Xlbl','','LeftYlbl','')
for plt=1:12
    subplot(6,2,plt)
    hold on
    at=Experiment.Subject(plt).AcqTrial;
    plot([at at],ylim,'k-','LineWidth',1)
    if plt>10
        xlabel('Trial','FontSize',18)
    end
    if plt==7
        ylabel('# CS pokes - # PreCS pokes','FontSize',18)
    end
end    

%%
TSapplystat('PkNumDiff',{'CS_PkNumSes' 'PreCS_PkNumSes'},@minus) % session level
TSapplystat('PkDurDiff',{'CS_PkgDurSes' 'PreCS_PkgDurSes'},@minus) % session level
%%
TSlimit('Phases',1); % training
TScombineover('AcqPkNumDiff','PkNumDiff'); % subject level
TSlimit('Phases',2); % extinction
TScombineover('ExtPkNumDiff','PkNumDiff'); % subject level
TSlimit('Phases',3); % recovery 1 wk
TScombineover('Rec1PkNumDiff','PkNumDiff'); % subject level
TSlimit('Phases',4); % recovery 3 wks
TScombineover('Rec2PkNumDiff','PkNumDiff'); % subject level
%%
TSlimit('Phases',1); % training
TScombineover('AcqPkDurDiff','PkDurDiff'); % subject level
TSlimit('Phases',2); % extinction
TScombineover('ExtPkDurDiff','PkDurDiff'); % subject level
TSlimit('Phases',3); % recovery 1 wk
TScombineover('Rec1PkDurDiff','PkDurDiff'); % subject level
TSlimit('Phases',4); % recocvery 3 wks
TScombineover('Rec2PkDurDiff','PkDurDiff'); % subject level

%% Group 1: 28 2or3-trial sessions on successive days, 70 total trials, 28 days spanned
TSlimit('Subjects',1:6)
TSapplystat('','AcqPkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Acq Trial',...
    'LeftYlbl','Cum CS-Pre Pk#diff')
%%
figure % Can't use TSplotcumrecs because only 2 trials in final sessions
subplot(3,2,1);stairs([0 1 2],[0;cumsum(Experiment.Subject(1).Session(28).PkNumDiff)],...
    'k-','LineWidth',2);title('S1s28');xlim([0 2.5])
subplot(3,2,2);stairs([0 1 2],[0;cumsum(Experiment.Subject(2).Session(28).PkNumDiff)],...
    'k-','LineWidth',2);title('S2s28');xlim([0 2.5])
subplot(3,2,3);stairs([0 1 2],[0;cumsum(Experiment.Subject(3).Session(28).PkNumDiff)],...
    'k-','LineWidth',2);title('S3s28');xlim([0 2.5])
subplot(3,2,4);stairs([0 1 2],[0;cumsum(Experiment.Subject(4).Session(28).PkNumDiff)],...
    'k-','LineWidth',2);title('S4s28');xlim([0 2.5])
subplot(3,2,5);stairs([0 1 2],[0;cumsum(Experiment.Subject(5).Session(28).PkNumDiff)],...
    'k-','LineWidth',2);title('S5s28');xlim([0 2.5])
subplot(3,2,6);stairs([0 1 2],[0;cumsum(Experiment.Subject(6).Session(28).PkNumDiff)],...
    'k-','LineWidth',2);title('S6s28');xlim([0 2.5])
%%
TSlimit('Sessions','all')
TSlimit('Phases',2)
TSapplystat('','ExtPkNumDiff',@TSplotcumrecs,'Rows',3,'LeftYlm',[-10 85],...
    'Xlbl','Extinction Trial','Xlm',[0 40],'LeftYlbl','CSPks-10sPreCSPks')
%%
TSlimit('Phases',3)
TSapplystat('','Rec1PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 1 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-.5 20])
TSlimit('Phases',4)
TSapplystat('','Rec2PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 2 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-.5 20])

%% Group 2: 7 40-trial sessions on successive days
TSlimit('Subjects',7:12)
TSapplystat('','AcqPkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Acq Trial',...
    'LeftYlbl','Cum CS-Pre Pk#diff')
%
TSlimit('Sessions',7) % last acquisition session
TSlimit('Phases',1)
TSapplystat('','PkNumDiff',@TSplotcumrecs,'Rows',3,'Xlbl','Trial in Last Acq Sess',...
    'LeftYlbl','CSPks-10sPreCSPks')
%
TSlimit('Sessions','all')
TSlimit('Phases',2)
TSapplystat('','ExtPkNumDiff',@TSplotcumrecs,'Rows',3,'LeftYlm',[-10 85],...
    'Xlbl','Extinction Trial','Xlm',[0 40],'LeftYlbl','CSPks-10sPreCSPks')
%
TSlimit('Sessions','all')
TSlimit('Phases',3)
TSapplystat('','Rec1PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 1 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-5 15])
TSlimit('Phases',4)
TSapplystat('','Rec2PkNumDiff',@TSplotcumrecs,'Rows',3,...
    'Xlbl','Recovery 2 Trial','Xlm',[.5 4.5],'LeftYlbl','CSPks-10sPreCSPks',...
    'LeftYlm',[-5 15])

%% Summary stats for each subject
TSlimit('Subjects','all')
TSapplystat('CumExtPkNumDiff','ExtPkNumDiff',@sum)
TSapplystat('CumExtPkDurDiff','ExtPkDurDiff',@sum)
TSapplystat('TrlsToExt','ExtPkNumDiff',@numel)
TSapplystat('CumRec1PkNumDiff','Rec1PkNumDiff',@sum)
TSapplystat('CumRec2PkNumDiff','Rec2PkNumDiff',@sum)
TSapplystat('CumRec1PkDurDiff','Rec1PkDurDiff',@sum)
TSapplystat('CumRec2PkDurDiff','Rec2PkDurDiff',@sum)
%% Mean poke rate difference each session
TSlimit('Phases',1)
TSapplystat('MeanPkRateDiff','PkNumDiff',@mean)
TSapplystat('MeanPkDurDiff','PkDurDiff',@mean)
%% Response rate last Acq Trial
TSlimit('Subjects',1:6)
TSlimit('Sessions',8)
TScombineover('MeanPkRateDiffLastAcqSes','MeanPkRateDiff') % subject level
TScombineover('MeanPkDurDiffLastAcqSes','MeanPkDurDiff') %subject level
%
TSlimit('Subjects',7:12)
TSlimit('Sessions',7)
TScombineover('MeanPkRateDiffLastAcqSes','MeanPkRateDiff') % subject level
TScombineover('MeanPkDurDiffLastAcqSes','MeanPkDurDiff') %subject level
%% Aggregating summary stats by groups to Experiment level
TSlimit('Subjects',1:6)
TScombineover('G28_2o3_28_70MnPkRateDiffLstAcq','MeanPkRateDiffLastAcqSes')
TScombineover('G28_2o3_28_70MnPkDurDiffLstAcq','MeanPkDurDiffLastAcqSes')
TScombineover('G28_2o3_28_70CumExtPkNumDiff','CumExtPkNumDiff')
TScombineover('G28_2o3_28_70CumExtPkDurDiff','CumExtPkDurDiff')
TScombineover('G28_2o3_28_70TrlsToExt','TrlsToExt')
TScombineover('G28_2o3_28_70CumRec1PkNumDiff','CumRec1PkNumDiff')
TScombineover('G28_2o3_28_70CumRec2PkNumDiff','CumRec2PkNumDiff')
TScombineover('G28_2o3_28_70CumRec1PkDurDiff','CumRec1PkDurDiff')
TScombineover('G28_2o3_28_70CumRec2PkDurDiff','CumRec2PkDurDiff')
TScombineover('G28_2o3_28_70AcTrls','AcqTrial')
%
TSlimit('Subjects',7:12)
TScombineover('G7_40_7_280MnPkRateDiffLstAcq','MeanPkRateDiffLastAcqSes')
TScombineover('G7_40_7_280MnPkDurDiffLstAcq','MeanPkDurDiffLastAcqSes')
TScombineover('G7_40_7_280CumExtPkNumDiff','CumExtPkNumDiff')
TScombineover('G7_40_7_280CumExtPkDurDiff','CumExtPkDurDiff')
TScombineover('G7_40_7_280TrlsToExt','TrlsToExt')
TScombineover('G7_40_7_280CumRec1PkNumDiff','CumRec1PkNumDiff')
TScombineover('G7_40_7_280CumRec2PkNumDiff','CumRec2PkNumDiff')
TScombineover('G7_40_7_280CumRec1PkDurDiff','CumRec1PkDurDiff')
TScombineover('G7_40_7_280CumRec2PkDurDiff','CumRec2PkDurDiff')
TScombineover('G7_40_7_280AcTrls','AcqTrial')

%% Between Group CDFs of summary statistics
figure
subplot(3,2,1)
cdfplot(Experiment.G28_2o3_28_70MnPkRateDiffLstAcq)
hold on
cdfplot(Experiment.G7_40_7_280MnPkRateDiffLstAcq)
xlabel('Mean CS-Pre Poke # Last Acq Sess')
legend('28,2.5,28,70','7,40,7,280','location','NW')
title('')
%
subplot(3,2,2)
cdfplot(Experiment.G28_2o3_28_70CumExtPkNumDiff)
hold on
cdfplot(Experiment.G7_40_7_280CumExtPkNumDiff)
xlabel('Total Pk # Diff in Ext')
title('')
%
subplot(3,2,3)
cdfplot(Experiment.G28_2o3_28_70TrlsToExt)
hold on
cdfplot(Experiment.G7_40_7_280TrlsToExt)
xlabel('Trials to Ext')
title('')
%
subplot(3,2,4)
cdfplot(Experiment.G28_2o3_28_70CumRec1PkNumDiff)
hold on
cdfplot(Experiment.G7_40_7_280CumRec1PkNumDiff)
xlabel('Total Pks# Dif @ 1 wk')
title('')
%
subplot(3,2,5)
cdfplot(Experiment.G28_2o3_28_70CumRec2PkNumDiff)
hold on
cdfplot(Experiment.G7_40_7_280CumRec2PkNumDiff)
xlabel('Total Pks# Dif @ 3 wks')
title('')
%
figure
subplot(2,2,1)
cdfplot(Experiment.G28_2o3_28_70MnPkDurDiffLstAcq)
hold on
cdfplot(Experiment.G7_40_7_280MnPkDurDiffLstAcq)
xlabel('Mean CS-Pre Poke Dur Last Acq Sess')
legend('28,2.5,28,70','7,40,7,280','location','NW')
title('')
%
subplot(2,2,2)
cdfplot(Experiment.G28_2o3_28_70CumExtPkDurDiff)
hold on
cdfplot(Experiment.G7_40_7_280CumExtPkDurDiff)
xlabel('Total Pk Dur Diff in Ext')
title('')

subplot(2,2,3)
cdfplot(Experiment.G28_2o3_28_70CumRec1PkDurDiff)
hold on
cdfplot(Experiment.G7_40_7_280CumRec1PkDurDiff)
xlabel('Total Pk Dur Diff @ 1 wk')
title('')
%
subplot(2,2,4)
cdfplot(Experiment.G28_2o3_28_70CumRec2PkDurDiff)
hold on
cdfplot(Experiment.G7_40_7_280CumRec2PkDurDiff)
xlabel('Total Pk Dur Dif @ 3 wks')
title('')




%% Building long table
Sub=double.empty(54,0);
%
Exper =[repmat(1,18,1);repmat(2,12,1);repmat(3,12,1);repmat(4,12,1)];
%
Cond=[repmat({'7_40_7_280'},6,1);repmat({'28_10_28_280'},6,1);repmat({'7_40_28_280'},6,1);...
    repmat({'24_10_24_240'},6,1);repmat({'6_40_6_240'},6,1);...
    repmat({'8_10_8_80'},6,1);repmat({'8_40_8_320'},6,1);...
    repmat({'28_2o3_28_70'},6,1);repmat({'7_40_7_280'},6,1)];
%
NumSes = [repmat(7,6,1);repmat(28,6,1);repmat(7,6,1);...
    repmat(24,6,1);repmat(6,6,1);...
    repmat(8,12,1);...
    repmat(28,6,1);repmat(7,6,1)];
%
TrlsPerSes = [repmat(40,6,1);repmat(10,6,1);repmat(40,6,1);...
    repmat(10,6,1);repmat(40,6,1);...
    repmat(10,6,1);repmat(40,6,1);...
    repmat(2.5,6,1);repmat(40,6,1)];
%
TrngSpan =[repmat(7,6,1);repmat(28,6,1);repmat(28,6,1);...
    repmat(24,6,1);repmat(6,6,1);...
    repmat(8,12,1);...
    repmat(28,6,1);repmat(7,6,1)];
%
TtlTrls =[repmat(280,6,1);repmat(280,6,1);repmat(280,6,1);...
    repmat(240,12,1);...
    repmat(80,6,1);repmat(320,6,1);...
    repmat(70,6,1);repmat(280,6,1)];
%%
PkNumDiffLstSes =double.empty(54,0);
ExtPkNumDiff =double.empty(54,0);
TrlsToExt = double.empty(54,0);
d7PkNumDiff = double.empty(54,0);
d21PkNumDiff = double.empty(54,0);

PkDurDiffLstSes =double.empty(54,0);
ExtPkDurDiff =double.empty(54,0);
d7PkDurDiff = double.empty(54,0);
d21PkDurDiff = double.empty(54,0);
%%
LT = table(Sub,Exper,Cond,NumSes,TrlsPerSes,TrngSpan,TtlTrls,...
    PkNumDiffLstSes,ExtPkNumDiff,TrlsToExt,d7PkNumDiff,d21PkNumDiff,...
    PkDurDiffLstSes,ExtPkDurDiff,d7PkDurDiff,d21PkDurDiff,...
    'VariableNames',{',Sub','Exper','Cond','NumSes','TrlsPerSes','TrngSpan','TtlTrls',...
    'PkNumDiffLstSes','ExtPkNumDiff','TrlsToExt','d7PkNumDiff','d21PkNumDiff',...
    'PkDurDiffLstSes','ExtPkDurDiff','d7PkDurDiff','d21PkDurDiff'});
save('LongTable','LT')
%%
TSloadexperiment('Data/Experiment1')
%%
Sub(1:18,1)=Experiment.Subjects';
PkNumDiffLstSes(1:6,1)=Experiment.Grp_7_40_7_MnPkRateDiffLstAcq;
ExtPkNumDiff(1:6,1)=Experiment.Grp_7_40_7_CumExtPkNumDiff;
TrlsToExt(1:6,1) = Experiment.Grp_7_40_7_TrlsToExt;
d7PkNumDiff(1:6,1) = Experiment.Grp_7_40_7_CumRec1PkNumDiff;
d21PkNumDiff(1:6,1) = Experiment.Grp_7_40_7_CumRec2PkNumDiff;
PkDurDiffLstSes(1:6,1) = Experiment.Grp_7_40_7_MnPkDurDiffLstAcq;
ExtPkDurDiff(1:6,1) = Experiment.Grp_7_40_7_CumExtPkDurDiff;
d7PkDurDiff(1:6,1) = Experiment.Grp_7_40_7_CumRec1PkDurDiff;
d21PkDurDiff(1:6,1) = Experiment.Grp_7_40_7_CumRec2PkDurDiff;

PkNumDiffLstSes(7:12,1)=Experiment.Grp_28_10_28_MnPkRateDiffLstAcq;
ExtPkNumDiff(7:12,1)=Experiment.Grp_28_10_28_CumExtPkNumDiff;
TrlsToExt(7:12,1) = Experiment.Grp_28_10_28_TrlsToExt;
d7PkNumDiff(7:12,1) = Experiment.Grp_28_10_28_CumRec1PkNumDiff;
d21PkNumDiff(7:12,1) = Experiment.Grp_28_10_28_CumRec2PkNumDiff;
PkDurDiffLstSes(7:12,1) = Experiment.Grp_28_10_28_MnPkDurDiffLstAcq;
ExtPkDurDiff(7:12,1) = Experiment.Grp_28_10_28_CumExtPkDurDiff;
d7PkDurDiff(7:12,1) = Experiment.Grp_28_10_28_CumRec1PkDurDiff;
d21PkDurDiff(7:12,1) = Experiment.Grp_28_10_28_CumRec2PkDurDiff;

PkNumDiffLstSes(13:18,1)=Experiment.Grp_7_40_28_MnPkRateDiffLstAcq;
ExtPkNumDiff(13:18,1)=Experiment.Grp_7_40_28_CumExtPkNumDiff;
TrlsToExt(13:18,1) = Experiment.Grp_7_40_28_TrlsToExt;
d7PkNumDiff(13:18,1) = Experiment.Grp_7_40_28_CumRec1PkNumDiff;
d21PkNumDiff(13:18,1) = Experiment.Grp_7_40_28_CumRec2PkNumDiff;
PkDurDiffLstSes(13:18,1) = Experiment.Grp_7_40_28_MnPkDurDiffLstAcq;
ExtPkDurDiff(13:18,1) = Experiment.Grp_7_40_28_CumExtPkDurDiff;
d7PkDurDiff(13:18,1) = Experiment.Grp_7_40_28_CumRec1PkDurDiff;
d21PkDurDiff(13:18,1) = Experiment.Grp_7_40_28_CumRec2PkDurDiff;
%%

TSloadexperiment('Data/Experiment2')
%%
Sub(19:30,1)=Experiment.Subjects';
PkNumDiffLstSes(19:24,1)=Experiment.G24_10_24_240MnPkRateDiffLstAcq;
ExtPkNumDiff(19:24,1)=Experiment.G24_10_24_240CumExtPkNumDiff;
TrlsToExt(19:24,1) = Experiment.G24_10_24_240TrlsToExt;
d7PkNumDiff(19:24,1) = Experiment.G24_10_24_240CumRec1PkNumDiff;
d21PkNumDiff(19:24,1) = Experiment.G24_10_24_240CumRec2PkNumDiff;
PkDurDiffLstSes(19:24,1) = Experiment.G24_10_24_240MnPkDurDiffLstAcq;
ExtPkDurDiff(19:24,1) = Experiment.G24_10_24_240CumExtPkDurDiff;
d7PkDurDiff(19:24,1) = Experiment.G24_10_24_240CumRec1PkDurDiff;
d21PkDurDiff(19:24,1) = Experiment.G24_10_24_240CumRec2PkDurDiff;

PkNumDiffLstSes(25:30,1)=Experiment.G6_40_6_240MnPkRateDiffLstAcq;
ExtPkNumDiff(25:30,1)=Experiment.G6_40_6_240CumExtPkNumDiff;
TrlsToExt(25:30,1) = Experiment.G6_40_6_240TrlsToExt;
d7PkNumDiff(25:30,1) = Experiment.G6_40_6_240CumRec1PkNumDiff;
d21PkNumDiff(25:30,1) = Experiment.G6_40_6_240CumRec2PkNumDiff;
PkDurDiffLstSes(25:30,1) = Experiment.G6_40_6_240MnPkDurDiffLstAcq;
ExtPkDurDiff(25:30,1) = Experiment.G6_40_6_240CumExtPkDurDiff;
d7PkDurDiff(25:30,1) = Experiment.G6_40_6_240CumRec1PkDurDiff;
d21PkDurDiff(25:30,1) = Experiment.G6_40_6_240CumRec2PkDurDiff;

%%
TSloadexperiment('Data/Experiment3')
%%
Sub(31:42,1)=Experiment.Subjects';
PkNumDiffLstSes(31:36,1)=Experiment.G8_10_8_80MnPkRateDiffLstAcq;
ExtPkNumDiff(31:36,1)=Experiment.G8_10_8_80CumExtPkNumDiff;
TrlsToExt(31:36,1) = Experiment.G8_10_8_80TrlsToExt;
d7PkNumDiff(31:36,1) = Experiment.G8_10_8_80CumRec1PkNumDiff;
d21PkNumDiff(31:36,1) = Experiment.G8_10_8_80CumRec2PkNumDiff;
PkDurDiffLstSes(31:36,1) = Experiment.G8_10_8_80MnPkDurDiffLstAcq;
ExtPkDurDiff(31:36,1) = Experiment.G8_10_8_80CumExtPkDurDiff;
d7PkDurDiff(31:36,1) = Experiment.G8_10_8_80CumRec1PkDurDiff;
d21PkDurDiff(31:36,1) = Experiment.G8_10_8_80CumRec2PkDurDiff;

PkNumDiffLstSes(37:42,1)=Experiment.G8_40_8_320MnPkRateDiffLstAcq;
ExtPkNumDiff(37:42,1)=Experiment.G8_40_8_320CumExtPkNumDiff;
TrlsToExt(37:42,1) = Experiment.G8_40_8_320TrlsToExt;
d7PkNumDiff(37:42,1) = Experiment.G8_40_8_320CumRec1PkNumDiff;
d21PkNumDiff(37:42,1) = Experiment.G8_40_8_320CumRec2PkNumDiff;
PkDurDiffLstSes(37:42,1) = Experiment.G8_40_8_320MnPkDurDiffLstAcq;
ExtPkDurDiff(37:42,1) = Experiment.G8_40_8_320CumExtPkDurDiff;
d7PkDurDiff(37:42,1) = Experiment.G8_40_8_320CumRec1PkDurDiff;
d21PkDurDiff(37:42,1) = Experiment.G8_40_8_320CumRec2PkDurDiff;

%%
TSloadexperiment('Data/Experiment4')
%%
Sub(43:54,1)=Experiment.Subjects';
PkNumDiffLstSes(43:48,1)=Experiment.G28_2o3_28_70MnPkRateDiffLstAcq;
ExtPkNumDiff(43:48,1)=Experiment.G28_2o3_28_70CumExtPkNumDiff;
TrlsToExt(43:48,1) = Experiment.G28_2o3_28_70TrlsToExt;
d7PkNumDiff(43:48,1) = Experiment.G28_2o3_28_70CumRec1PkNumDiff;
d21PkNumDiff(43:48,1) = Experiment.G28_2o3_28_70CumRec2PkNumDiff;
PkDurDiffLstSes(43:48,1) = Experiment.G28_2o3_28_70MnPkDurDiffLstAcq;
ExtPkDurDiff(43:48,1) = Experiment.G28_2o3_28_70CumExtPkDurDiff;
d7PkDurDiff(43:48,1) = Experiment.G28_2o3_28_70CumRec1PkDurDiff;
d21PkDurDiff(43:48,1) = Experiment.G28_2o3_28_70CumRec2PkDurDiff;

PkNumDiffLstSes(49:54,1)=Experiment.G7_40_7_280MnPkRateDiffLstAcq;
ExtPkNumDiff(49:54,1)=Experiment.G7_40_7_280CumExtPkNumDiff;
TrlsToExt(49:54,1) = Experiment.G7_40_7_280TrlsToExt;
d7PkNumDiff(49:54,1) = Experiment.G7_40_7_280CumRec1PkNumDiff;
d21PkNumDiff(49:54,1) = Experiment.G7_40_7_280CumRec2PkNumDiff;
PkDurDiffLstSes(49:54,1) = Experiment.G7_40_7_280MnPkDurDiffLstAcq;
ExtPkDurDiff(49:54,1) = Experiment.G7_40_7_280CumExtPkDurDiff;
d7PkDurDiff(49:54,1) = Experiment.G7_40_7_280CumRec1PkDurDiff;
d21PkDurDiff(49:54,1) = Experiment.G7_40_7_280CumRec2PkDurDiff;


% Apparently I did not save the script before closing after I created the
% long table. Its variables are Sub,Exper,Cond,NumSes,TrlsPerSes,TrngSpan,
% TtlTrls,PkNumDiffLstSes,ExtPkNumDiff,ExtPkNumDiff,TrlsToExt,d7PkNumDiff,
% d21PkNumDiff,PkDurDiffLstSes,ExtPkDurDiff,d7PkDurDiff,d21PkDurDiff. I
% saved the table (LT) in the file LongTable and the variables in the file
% TableVariables
%%
load 'LongTable'
Nms = LT.Properties.VariableNames([1 8:16]);
for c =1:length(Nms) % unpopulated columns of long table
    LT.(Nms{c})=eval(Nms{c}); % populating empty columns of long table
end
%%
AcqTrl=[E1G1acqtrals;E1G2acqtrls;E1G3acqtrals;E2G1acqtrls;E2G2acqtrls;...
    E3G1acqtrls;E3G2acqtrls;E4G1acqtrls;E4G2acqtrls] % These came from using
% the Details button in the Browser to download the contents of the group
% AcqTrials fields
LT.AcqTrls = AcqTrls; 
%% logical vectors
LVnmses = LT.NumSes<9; 
LVnmtrls = LT.TtlTrls<90;
LVspan = LT.TrngSpan<9;
LVlngsml = ~LVspan&LVnmses; % flags condition with long training span but
   % only few (7) sessions


%% Figure 3 in MS
F1 = figure;
sb(1)=subplot(3,2,1);
plot(LT.TtlTrls,LT.PkNumDiffLstSes,'k*')
xlabel('Total Training Trials')
ylabel(char({'Mean CS-PreCS Poke Number';'Difference Last Trng Ses'}))
xlim([0 350]);ylim([-5 12])
hold on
plot([70 280],[mean(LT.PkNumDiffLstSes(LVnmtrls)),mean(LT.PkNumDiffLstSes(~LVnmtrls))],...
    'k-','LineWidth',1) 
plot(xlim,[0 0],'k--')
[~,p,CI,STATS] = ttest2(LT.PkNumDiffLstSes(~LVnmtrls),LT.PkNumDiffLstSes(LVnmtrls))
StatCA{1}='[~,p,CI,STATS] = ttest2(LT.PkNumDiffLstSes(~LVnmtrls),LT.PkNumDiffLstSes(LVnmtrls))';
StatCA{2}=char({'t(52)=5.0110';'p<<.001';'CI=[2.4 5.5]';'sd = 2.4'})
text(120,8.8,StatCA{2})
[Wt,OA,OF]=BF2(LT.PkNumDiffLstSes(LVnmtrls),LT.PkNumDiffLstSes(~LVnmtrls),...
    [-inf inf],[-STATS.sd STATS.sd])
StatCA{3}='[Wt,OA,OF]=BF2(LT.PkNumDiffLstSes(LVnmtrls),LT.PkNumDiffLstSes(~LVnmtrls),[-inf inf],[-STATS.sd STATS.sd])';
StatCA{4}=char({'BF 3,000:1';'against Null'})
figure(F1);subplot(sb(1))
text(5,10,StatCA{4})
%--------------------------------------------------------
subplot(3,2,2);
plot(LT.TtlTrls,LT.ExtPkNumDiff,'k*')
xlabel('Total Training Trials')
ylabel('Total CS-PreCS Poke # Diff in Ext')
xlim([0 350])
hold on
plot([70 280],[mean(LT.ExtPkNumDiff(LVnmtrls)) mean(LT.ExtPkNumDiff(~LVnmtrls))],...
    'k-','LineWidth',1)
plot(xlim,[0 0],'k--')
[~,p,CI,STATS] = ttest2(LT.ExtPkNumDiff(~LVnmtrls),LT.ExtPkNumDiff(LVnmtrls))
StatCA{5}='[~,p,CI,STATS] = ttest2(LT.ExtPkNumDiff(~LVnmtrls),LT.ExtPkNumDiff(LVnmtrls))'
StatCA{6}=char({'t(52)=0.4664';'p=.6429';'CI=[-14 22]';'sd=27.7'})
text(120,88,StatCA{6})
[Wt,OA,OF]=BF2(LT.ExtPkNumDiff(LVnmtrls),LT.ExtPkNumDiff(~LVnmtrls),[-inf inf],[-STATS.sd STATS.sd])
StatCA{7}='BF2(LT.ExtPkNumDiff(LVnmtrls),LT.ExtPkNumDiff(~LVnmtrls),[-inf inf],[-STATS.sd STATS.sd])';
StatCA{8}=char({'BF 2.2:1 in';'favor of Null'})
figure(F1)
text(5,100,StatCA{8})
%--------------------------------------------------------
subplot(3,2,3);
plot(LT.TtlTrls,LT.TrlsToExt,'k*')
xlabel('Total Training Trials')
ylabel('Trials to Extinction')
xlim([0 350])
ylim([20 70])
hold on
plot([70 280],[mean(LT.TrlsToExt(LVnmtrls)) mean(LT.TrlsToExt(LVnmtrls))],...
    'k-','LineWidth',1)
[~,p,CI,STATS] = ttest2(LT.TrlsToExt(~LVnmtrls),LT.TrlsToExt(LVnmtrls))
StatCA{9}='[~,p,CI,STATS] = ttest2(LT.TrlsToExt(~LVnmtrls),LT.TrlsToExt(LVnmtrls))'
StatCA{10}=char({'t(52)=-0.75';'p=.45';'CI=[-1.2 3.2]';'sd=7.7'})
figure(F1)
text(120,60,StatCA{10})
[Wt,OA,OF]=BF2(LT.TrlsToExt(LVnmtrls),LT.TrlsToExt(~LVnmtrls),[-inf inf],[-STATS.sd STATS.sd])
StatCA{11}='BF2(LT.TrlsToExt(LVnmtrls),LT.TrlsToExt(~LVnmtrls),[-inf inf],[-STATS.sd STATS.sd])';
StatCA{12}=char({'BF 1.8:1 in';'favor of Null'})
figure(F1)
text(5,65,StatCA{12})
%--------------------------------------------------------
subplot(3,2,4)
plot(LT.TrngSpan,LT.ExtPkNumDiff,'k*')
xlabel('Training Span (days)')
xlim([0 30])
hold on
plot([7 27],[mean(LT.ExtPkNumDiff(LVnmtrls)) mean(LT.ExtPkNumDiff(LVnmtrls))],...
    'k-','LineWidth',1)
plot(xlim,[0 0],'k--')
ylabel('Total CS-PreCS Poke # Diff in Ext')
[~,p,CI,STATS] = ttest2(LT.ExtPkNumDiff(~LVspan),LT.ExtPkNumDiff(LVspan))
StatCA{13}='[~,p,CI,STATS] = ttest2(LT.ExtPkNumDiff(~LVspan),LT.ExtPkNumDiff(LVspan))';
StatCA{14}=char({'t(52)=.42';'p=.68';'CI=[-12 18]';'sd=27.7'});
text(12,90,StatCA{14})
[Wt,OA,OF]=BF2(LT.ExtPkNumDiff(LVspan),LT.ExtPkNumDiff(~LVspan),[-inf inf],[-STATS.sd STATS.sd])
StatCA{15}='[Wt,OA,OF]=BF2(LT.ExtPkNumDiff(LVspan),LT.ExtPkNumDiff(~LVspan),[-inf inf],[-STATS.sd STATS.sd])';
StatCA{16}=char({'BF 6.8:1 in';'favor of Null'})
figure(F1)
text(1,105,StatCA{16})
%--------------------------------------------------------
%
subplot(3,2,5)
plot(LT.TrngSpan,LT.TrlsToExt,'k*')
xlabel('Training Span (days)')
xlim([0 30]);ylim([20 70])
ylabel('Trials to Extinction')
hold on
plot([7 27],[mean(LT.TrlsToExt(LVnmtrls)) mean(LT.TrlsToExt(~LVnmtrls))],...
    'k-','LineWidth',1)
[~,p,CI,STATS] = ttest2(LT.TrlsToExt(~LVspan),LT.TrlsToExt(LVspan))
StatCA{17}='[~,p,CI,STATS] = ttest2(LT.ExtPkNumDiff(~LVspan),LT.ExtPkNumDiff(LVspan))';
StatCA{18}=char({'t(52)=0.05';'p=.96';'CI=[-4.37 4.16]';'sd=7.76'});
text(9,60,StatCA{18})
[Wt,OA,OF]=BF2(LT.TrlsToExt(LVspan),LT.TrlsToExt(~LVspan),[-inf inf],[-STATS.sd STATS.sd])
StatCA{19}='[Wt,OA,OF]=BF2(LT.TrlsToExt(LVspan),LT.TrlsToExt(~LVspan),[-inf inf],[-STATS.sd STATS.sd])';
StatCA{20}=char({'BF 2.9:1 in';'favor of Null'});
figure(F1)
text(19,65,StatCA{20})

%--------------------------------------------------------
figure(F1)
subplot(3,2,6)
plot(LT.TrngSpan,LT.d21PkNumDiff,'k*')
xlabel('Training Span (days)')
xlim([0 30]);ylim([-4 30])
ylabel('Cum Pk Diff @ 21 days')
hold on
plot([7 27],[mean(LT.d21PkNumDiff(LVspan)) mean(LT.d21PkNumDiff(~LVspan))],...
    'k-','LineWidth',1)
plot(xlim,[0 0],'k--')
[~,p,CI,STATS] = ttest2(LT.d21PkNumDiff(~LVspan),LT.d21PkNumDiff(LVspan))
StatCA{21}='[~,p,CI,STATS] = ttest2(LT.d21PkNumDiff(~LVspan),LT.d21PkNumDiff(LVspan))';
StatCA{22}=char({'t(52)=4.6';'p<<.001';'CI=[3.2 8.2]';'sd=4.5'});
text(1,23,StatCA{22})
[Wt,OA,OF]=BF2(LT.d21PkNumDiff(LVspan),LT.d21PkNumDiff(~LVspan),[-inf inf],[-STATS.sd STATS.sd])
StatCA{23}='[Wt,OA,OF]=BF2(LT.d21PkNumDiff(LVspan),LT.d21PkNumDiff(~LVspan),[-inf inf],[-STATS.sd STATS.sd])';
StatCA{24}=char({'BF 3100:1';'against Null'});
figure(F1)
text(12,25,StatCA{24})


%% Figure 2 in MS
F2=figure;
plot(LT.TrngSpan(LVspan),LT.d21PkNumDiff(LVspan),'k*','MarkerSize',12)
hold on
plot(LT.TrngSpan(LVlngsml),LT.d21PkNumDiff(LVlngsml),'ko','MarkerSize',12);
xlim([0 30]);ylim([-4 12])
hold on
plot(xlim,[0 0],'k--','LineWidth',1)
plot([7 28],[mean(LT.d21PkNumDiff(LVspan)) mean(LT.d21PkNumDiff(LVlngsml))],...
    'k-','LineWidth',2)
set(gca,'FontSize',14)
xlabel('Training Span (days)','FontSize',18)
ylabel('Cum Pk Diff @ 21 days','FontSize',18)
[~,p,CI,STATS] = ttest2(LT.d21PkNumDiff(LVlngsml),LT.d21PkNumDiff(LVspan))
StatCA{25}='[~,p,CI,STATS] = ttest2(LT.d21PkNumDiff(LVlngsml),LT.d21PkNumDiff(LVspan))';
StatCA{26} = char({'Lng&FewVsShrt';'t(34)=1.6109';'p = 0.12';'CI=[-.69 6]';'sd=3.6554'})
[~,p,CI,STATS] = ttest2(LT.d21PkNumDiff(~LVspan&~LVlngsml),LT.d21PkNumDiff(LVlngsml))
StatCA{27}='[~,p,CI,STATS] = ttest2(LT.d21PkNumDiff(~LVspan&~LVlngsml),LT.d21PkNumDiff(LVlngsml))';
StatCA{28} = char({'Lng%FewVsLng&Mny';'t(22)=1.5989';'p = 0.1241';'CI [-1.6 9.3]';'sd = 5.3807'});
text(10,9,StatCA{26},'FontSize',12)
text(15,3,StatCA{28},'FontSize',12)
[Wt,OA,OF] = BF2(LT.d21PkNumDiff(LVspan),LT.d21PkNumDiff(LVlngsml),[-inf inf],[-2 11])
StatCA{29}='BF2(LT.d21PkNumDiff(LVspan),LT.d21PkNumDiff(LVlngsml),[-inf inf],[-2 11])';
StatCA{30} = char({'Lng&FewVsShrt';'BF = 1.15:1';'against Null'});
[Wt,OA,OF] = BF2(LT.d21PkNumDiff(~LVspan&~LVlngsml),LT.d21PkNumDiff(LVlngsml),[-inf inf],[-10 10])
StatCA{31} = '[Wt,OA,OF] = BF2(LT.d21PkNumDiff(~LVspan&~LVlngsml),LT.d21PkNumDiff(LVlngsml),[-inf inf],[-10 10])';
StatCA{32} = char({'Lng&FewVsShrt';'BF = 1.15:1';'against null'})
figure(F2)
text(20,10.5,StatCA{30})
text(20,8,StatCA{32})
legend('Short Span','Long Span w Few Sessions','location','S')


%%
LT.Properties.UserData=StatCA; % attaching statistical results to long table
%% displaying statistical results
for c=1:length(LT.Properties.UserData);disp(LT.Properties.UserData{c});end

%%
save LongTable LT
%% Figure 1new
%% logical vectors
LVnmses = LT.NumSes<9; 
LVnmtrls = LT.TtlTrls<90;
LVspan = LT.TrngSpan<9;
LVlngsml = ~LVspan&LVnmses; % flags condition with long training span but
   % only few (7) sessions
F=figure; % Figure 2 in MS
plot(LT.NumSes(LVnmses&LVnmtrls)+1,LT.AcqTrl(LVnmses&LVnmtrls),'k*')
% few sessions & few trials
set(gca,'FontSize',12)
hold on
plot(LT.NumSes(LVnmses&~LVnmtrls),LT.AcqTrl(LVnmses&~LVnmtrls),'r*') % few
% sessions & many trials
plot(LT.NumSes(~LVnmses&LVnmtrls)-1,LT.AcqTrl(~LVnmses&LVnmtrls),'g*') % many
% sessions and few trials
plot(LT.NumSes(~LVnmses&~LVnmtrls),LT.AcqTrl(~LVnmses&~LVnmtrls),'b*') % many
% sessions and many trials
xlabel('Number of Acquisition Sessions')
ylabel('Trials to Acquisition')
plot([7 28],[mean(LT.AcqTrl(LVnmses&~LVnmtrls)) mean(LT.AcqTrl(~LVnmses&~LVnmtrls))],'k-o',...
    'MarkerSize',10) % few sessions w lots of trials vs many sessions w lots of trials
xlim([0 30])
%
% STATISTICAL COMPARISONS FOR FIGURE 2
[~,p,CI,STATS] = ttest2(LT.AcqTrl(LVnmses&~LVnmtrls),LT.AcqTrl(~LVnmses&~LVnmtrls))
% short span w lots of trials/session vs long span w lots of trials/session
[Wt,OA,OF] = BF2(LT.AcqTrl(~LVnmses&~LVnmtrls),LT.AcqTrl(LVnmses&~LVnmtrls),...
    [-inf inf],2*[-STATS.sd STATS.sd])
StatCA{33}='[~,p,CI,STATS] = ttest2(LT.AcqTrl(LVnmses&~LVnmtrls),LT.AcqTrl(~LVnmses&~LVnmtrls))';
StatCA{34}='[Wt,OA,OF] = BF2(LT.AcqTrl(~LVnmses&~LVnmtrls),LT.AcqTrl(LVnmses&~LVnmtrls),[-inf inf],2*[-STATS.sd STATS.sd])';
StatCA{35}=char({'FewVsMany';'Many-Trial';'Sessions';'RedVsBlue';'t(40)=.55,p=.55';'BF 4:1 in';'favor of Null'});
% figure(F)
% text(10,30,StatCA{35})
%
[~,p,CI,STATS] = ttest2(LT.AcqTrl(LVnmses&~LVnmtrls),LT.AcqTrl(LVnmses&LVnmtrls))
% short spans with 40 trials/session vs short spans with 10 trials/session
[Wt,OA,OF] = BF2(LT.AcqTrl(LVnmses&~LVnmtrls),LT.AcqTrl(LVnmses&LVnmtrls),[-inf inf],2*[-STATS.sd STATS.sd])
StatCA{36}='[~,p,CI,STATS] = ttest2(LT.AcqTrl(LVnmses&~LVnmtrls),LT.AcqTrl(LVnmses&~LVnmtrls))';
StatCA{37}='[Wt,OA,OF] = BF2(LT.AcqTrl(LVnmses&~LVnmtrls),LT.AcqTrl(LVnmses&LVnmtrls),[-inf inf],2*[-STATS.sd STATS.sd])';
StatCA{38}=char({'FewManyTrialSes(red)';'vs';'FewFewTrialSes(black)';'t(34)=1.048,p=.30';'BF 2:1 in';'favor of Null'});
% figure(F)
% text(1,140,StatCA{38})
%
[~,p,CI,STATS] = ttest2(LT.AcqTrl(LVnmses),LT.AcqTrl(~LVnmses&~LVnmtrls))
% all small # of sessions vs large # sessions w 10 to 40 trials/session
[Wt,OA,OF] = BF2(LT.AcqTrl(LVnmses),LT.AcqTrl(~LVnmses&~LVnmtrls),[-inf inf],2*[-STATS.sd STATS.sd])
StatCA{39}='[~,p,CI,STATS] = ttest2(LT.AcqTrl(LVnmses),LT.AcqTrl(~LVnmses&~LVnmtrls))';
StatCA{40}='[Wt,OA,OF] = BF2(LT.AcqTrl(LVnmses),LT.AcqTrl(~LVnmses&~LVnmtrls),[-inf inf],2*[-STATS.sd STATS.sd])';
StatCA{41}=char({'FewVsMany';'ManyTrialSession';'(Black&RedVsBlue)';'t(46)=.8106,p=.42';'BF3.5:1 in';'favor of Null'});
% figure(F)
% text(20,140,StatCA{41})
%
[~,p,CI,STATS] = ttest2(LT.AcqTrl((LVnmses|(~LVnmses&~LVnmtrls))),...
    LT.AcqTrl(~(LVnmses|(~LVnmses&~LVnmtrls))))
[Wt,OA,OF] = BF2(LT.AcqTrl((LVnmses|(~LVnmses&~LVnmtrls))),...
    LT.AcqTrl(~(LVnmses|(~LVnmses&~LVnmtrls))),[-inf inf],2*[-STATS.sd STATS.sd])
StatCA{42}='[~,p,CI,STATS] = ttest2(LT.AcqTrl((LVnmses|(~LVnmses&~LVnmtrls))),LT.AcqTrl(~(LVnmses|(~LVnmses&~LVnmtrls))))';
StatCA{43}='[Wt,OA,OF] = BF2(LT.AcqTrl((LVnmses|(~LVnmses&~LVnmtrls))),LT.AcqTrl(~(LVnmses|(~LVnmses&~LVnmtrls))),[-inf inf],2*[-STATS.sd STATS.sd])';
StatCA{44}=char({'Black,Red&Blue';'vs';'Green';'t(52)=2.54,p=.01';'BF 8.1:1';'against Null'})
% figure(F)
% text(17,30,StatCA{44})

legend('FewSesWithFewTrls','FewSesWithMnyTrls','MnySesWithFewTrls',...
    'LngSpan&Mny-TrlSes','location','NW')
%% Experiment 4 comparison
[~,p,CI,STATS] = ttest2(LT.AcqTrl(49:54),LT.AcqTrl(43:48))
[Wt,OA,OF] = BF2(LT.AcqTrl(49:54),LT.AcqTrl(43:48),[-inf inf],2*[-STATS.sd STATS.sd])
StatCA{45}='[~,p,CI,STATS] = ttest2(LT.AcqTrl(49:54),LT.AcqTrl(43:48))';
StatCA{46} = '[Wt,OA,OF] = BF2(LT.AcqTrl(49:54),LT.AcqTrl(43:48),[-inf inf],2*[-STATS.sd STATS.sd])';
StatCA{47} = char({'E4G1vsE4G2';'t(10)=5.16,p<<.001';'BF almost 1000:1';'against Null'});