% This scripts runs the basic analysis for everyday observation of the
% mice's behavior in the magazine approach paradigm. A white noise is
% followed by food 10 sec later (marked with a clicker). There is a 10-s
% pre-CS period for baseline levels of responding. The experiment was run
% in the old chambers.


TSinitexperiment('SessNumberReplicAllGrps',3,[23 24 25 26 27 28 29 30 31 32 33 34 65 66 67 68 69 70],'Mouse','Gallistel')

%Creating structure

for S=1:6;
    Experiment.Subject(S).Sex='M';
    Experiment.Subject(S).Strain = 'C57BL/6';
end
    
% DOB = {'01/15/06' '03/31/06' '01/27/06' '02/11/06' '02/11/06' ...
%        '01/15/06' '02/11/06' '03/31/06' '01/27/06' '02/11/06'};
    
% for S=1:12;
%     Experiment.Subject(S).Id = ID(S);
%     Experiment.Subject(S).BirthDate = DOB{S};
% end


% TSloadexperiment('C:\Documents and Settings\gallistellab\Desktop\Stathis\FewSessGrpExperiment');

TSloadsessions('C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication\AllData');
% Loads data from a session into TSData subfield of Session subfield of Subject subfield

TSimporteventcodes('matlabcodes.m')

cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication'
TSsaveexperiment('SessNumberReplicAllGrps_0');
cd 'C:\Program Files\MATLAB\R2006b'


%%

    
% %%
% %-----------------------------RASTER PLOTS -------------------------

Events=[PokeOn2 PokeOff2; PreCS 0; WNoiseOff 0];
% Defining events for raster plots.

% Making the plots
for M=18;
    for S = length(Experiment.Subject(M).Session)-2;
        TSraster(Experiment.Subject(M).Session(S).TSData,[PreCS WNoiseOff],Events)
        title(['Mouse ' num2str(M) ' Session ' num2str(S)])
    end
end

%%

% All-session Raster Plots

Events=[PokeOn2 PokeOff2; PreCS 0; WNoiseOn 0];
% Defining events for raster plots.

for M=6;
    
    AllSessData = [];
    
    for S=1:Experiment.Subject(M).NumSessions;
        
        AllSessData = [AllSessData; Experiment.Subject(M).Session(S).TSData];
        
    end
    
    TSraster(AllSessData,[PreCS WNoiseOff],Events)

    hold on
    
    for y=[40.5 80.5 120.5 160.5 200.5 240.5 280.5 312.5 316.5]
        plot([0 22],[y y],'LineWidth',0.5,'Color',[0 0 0])
    end

%     for y=[10.5 20.5 30.5 40.5 50.5 60.5 70.5 80.5 90.5 100.5 110.5 120.5...
%            130.5 140.5 150.5 160.5 170.5 180.5 190.5 200.5 210.5 220.5 230.5 240.5...
%            250.5 260.5 270.5 280.5]
%         plot([0 22],[y y],'LineWidth',0.5,'Color',[0 0 0])
%     end
        
    title(['MassedSessGrp Mouse ' num2str(M) ' All Sessions'])
    
end
%%
    
% Main program for analyzing pokes

% TSdefinetrial('ITI',{[StartITI EndITI]});
% 
% TSdefinetrial('PreCS',{[PreCS WNoiseOn]});
% 
% TSdefinetrial('CS',{[WNoiseOn WNoiseOff]});
% 
% TrialType1='ITI';
% TrialType2='PreCS';
% TrialType3='CS';

% for i = 2:3;  % Cycle between the different trial types
%     
%     eval(['TSSettrial(TrialType' num2str(i) ')']);
TSlimit('Subjects',[13:18])
TSlimit('Sessions',[10])

TSsettrial('CS') % Calculate all of the above measures for the 10-sec periods before the CS onset

TStrialstat('PkDurs',@TSparse,'result = [time(2)-time(1)];',[WNoiseOn -PokeOn2 PokeOff2], [PokeOn2 PokeOff2] ,[PokeOn2 -PokeOff2 WNoiseOff]);
% PkDurs field contains individual head-in intervals that occurred during a trial 

TSapplystat('PkNum','PkDurs',@length); 
% Creates PkDurs field which gives the number of pokes during a trial 

TSapplystat('PkgDur','PkDurs',@sum); % Creates a field at the trial level,
% that contains the sum of the poke durations

TScombineover('CS_PkDursSes','PkDurs'); % Creates a field at the session level
% containing the vector of all poke durations

TScombineover('CS_PkNumSes','PkNum'); % Creates a field at the session level
% containing the vector of poke number for each trial

TScombineover('CS_PkgDurSes','PkgDur'); % Creates a field at the session level
% containing the vector of poking duration for each trial

TSlimit('Sessions',[1:10])

TScombineover('CS_PkDursSub','CS_PkDursSes'); % Same vector as above, but now at
% the subject level, i.e., across sessions

TScombineover('CS_PkNumSub','CS_PkNumSes'); % Ditto

TScombineover('CS_PkgDurSub','CS_PkgDurSes'); % Ditto

TSlimit('Sessions',[10])

TSsettrial('PreCS') % Calculate all of the above measures for the 10-sec periods before the CS onset

TStrialstat('PkDurs',@TSparse,'result = [time(2)-time(1)];',[PreCS -PokeOn2 PokeOff2], [PokeOn2 PokeOff2] ,[PokeOn2 -PokeOff2 WNoiseOn]);
% PkDurs field contains individual head-in intervals that occurred during the preCS period 

TSapplystat('PkNum','PkDurs',@length); 
% Creates PkDurs field which gives the number of pokes during that period 

TSapplystat('PkgDur','PkDurs',@sum); % Creates a field at the trial level,
% that contains the sum of the poke durations

TScombineover('PreCS_PkDursSes','PkDurs'); % Creates a field at the session level
% containing the vector of all poke durations

TScombineover('PreCS_PkNumSes','PkNum'); % Creates a field at the session level
% containing the vector of poke number for each trial

TScombineover('PreCS_PkgDurSes','PkgDur'); % Creates a field at the session level
% containing the vector of poking duration for each trial

TSlimit('Sessions',[1:10])

TScombineover('PreCS_PkDursSub','PreCS_PkDursSes'); % Same vector as above, but now at
% the subject level, i.e., across sessions

TScombineover('PreCS_PkNumSub','PreCS_PkNumSes'); % Ditto

TScombineover('PreCS_PkgDurSub','PreCS_PkgDurSes'); % Ditto


% TStrialstat('TrialData',@datatransfer);
%this trial stat loads data from each trial into the TrialData field of the
%Structure -- In order to use it, you must have the datatransfer function
%in
%your path.

% Calculate the difference (elevation) scores for the following two
% measures

for M=13:18;
    
    Experiment.Subject(M).PkNumElevationScores = Experiment.Subject(M).CS_PkNumSub - Experiment.Subject(M).PreCS_PkNumSub;

    Experiment.Subject(M).PkgDurElevationScores = Experiment.Subject(M).CS_PkgDurSub - Experiment.Subject(M).PreCS_PkgDurSub;
    
end

cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication'
TSsaveexperiment('SessNumberReplicAllGrps_4');
cd 'C:\Program Files\MATLAB\R2006b'


%% Extinction and Spontaneous Recovery plots (correct cell)

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores
% CS_PkgDurSub PreCS_PkgDurSub PkgDurElevationScores

for m=1:18;
    TrialNumber = length(Experiment.Subject(m).PkNumElevationScores)-8;
    SR1wk(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-7:end-4)';
    SR3wk(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-3:end)';
    FirstExt2Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(281:282));
    LastExt2Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(TrialNumber-1:TrialNumber));
end


% Mean CR during the first 2 extinction trials
GrpManyFrstExtBlckMean = mean(FirstExt2Blck(7:12));
GrpManyFrstExtBlckStError = std(FirstExt2Blck(7:12))/sqrt(6);
GrpFewFrstExtBlckMean = mean(FirstExt2Blck(1:6));
GrpFewFrstExtBlckStError = std(FirstExt2Blck(1:6))/sqrt(6);
GrpSpacedFrstExtBlckMean = mean(FirstExt2Blck(13:18));
GrpSpacedFrstExtBlckStError = std(FirstExt2Blck(13:18))/sqrt(6);

% Mean CR during the last 2 extinction trials
GrpManyLastExtBlckMean = mean(LastExt2Blck(7:12));
GrpManyLastExtBlckStError = std(LastExt2Blck(7:12))/sqrt(6);
GrpFewLastExtBlckMean = mean(LastExt2Blck(1:6));
GrpFewLastExtBlckStError = std(LastExt2Blck(1:6))/sqrt(6);
GrpSpacedLastExtBlckMean = mean(LastExt2Blck(13:18));
GrpSpacedLastExtBlckStError = std(LastExt2Blck(13:18))/sqrt(6);

% Mean CR during the 1-week SR test
GrpManySR1wkMean = mean(SR1wk(:,7:12),2);
GrpManySR1wkStError = std(SR1wk(:,7:12),0,2)/sqrt(6);
GrpFewSR1wkMean = mean(SR1wk(:,1:6),2);
GrpFewSR1wkStError = std(SR1wk(:,1:6),0,2)/sqrt(6);
GrpSpacedSR1wkMean = mean(SR1wk(:,13:18),2);
GrpSpacedSR1wkStError = std(SR1wk(:,13:18),0,2)/sqrt(6);

% Mean CR during the 3-week SR test
GrpManySR3wkMean = mean(SR3wk(:,7:12),2);
GrpManySR3wkStError = std(SR3wk(:,7:12),0,2)/sqrt(6);
GrpFewSR3wkMean = mean(SR3wk(:,1:6),2);
GrpFewSR3wkStError = std(SR3wk(:,1:6),0,2)/sqrt(6);
GrpSpacedSR3wkMean = mean(SR3wk(:,13:18),2);
GrpSpacedSR3wkStError = std(SR3wk(:,13:18),0,2)/sqrt(6);


% Plotting

figure
h = subplot(1,1,1);

% Unless I prespecify all the X and Y data, the tee of the errorbars is
% getting rescaled to such small size that is barely visible.
X = [1 3 5:8 10:13]';
YMany = [GrpManyFrstExtBlckMean;GrpManyLastExtBlckMean;GrpManySR1wkMean;GrpManySR3wkMean];
SEMMany = [GrpManyFrstExtBlckStError;GrpManyLastExtBlckStError;GrpManySR1wkStError;GrpManySR3wkStError];
YFew = [GrpFewFrstExtBlckMean;GrpFewLastExtBlckMean;GrpFewSR1wkMean;GrpFewSR3wkMean];
SEMFew = [GrpFewFrstExtBlckStError;GrpFewLastExtBlckStError;GrpFewSR1wkStError;GrpFewSR3wkStError];
YSpaced = [GrpSpacedFrstExtBlckMean;GrpSpacedLastExtBlckMean;GrpSpacedSR1wkMean;GrpSpacedSR3wkMean];
SEMSpaced = [GrpSpacedFrstExtBlckStError;GrpSpacedLastExtBlckStError;GrpSpacedSR1wkStError;GrpSpacedSR3wkStError];

% Plotting lines
% Group Many Sessions
LWidth = 1.25;
MarkSize = 8;
j(1) = plot(X(1:2),YMany(1:2),'-ok','LineWidth',LWidth,'MarkerSize',MarkSize); hold on;
plot(X(3:6),YMany(3:6),'-ok','LineWidth',LWidth,'MarkerSize',MarkSize); hold on
plot(X(7:10),YMany(7:10),'-ok','LineWidth',LWidth,'MarkerSize',MarkSize); hold on

% Group Few Sessions
j(2) = plot(X(1:2),YFew(1:2),'--sk','LineWidth',LWidth,'MarkerFaceColor','k','MarkerSize',MarkSize); hold on
plot(X(3:6),YFew(3:6),'--sk','LineWidth',LWidth,'MarkerFaceColor','k','MarkerSize',MarkSize); hold on
plot(X(7:10),YFew(7:10),'--sk','LineWidth',LWidth,'MarkerFaceColor','k','MarkerSize',MarkSize); hold on

% Group Spaced Sessions
j(3) = plot(X(1:2),YSpaced(1:2),'-.vk','LineWidth',LWidth,'MarkerSize',MarkSize); hold on
plot(X(3:6),YSpaced(3:6),'-.vk','LineWidth',LWidth,'MarkerSize',MarkSize); hold on
plot(X(7:10),YSpaced(7:10),'-.vk','LineWidth',LWidth,'MarkerSize',MarkSize); hold on

% and errorbars
errorbar(X,YMany,SEMMany,'k','LineStyle','none','LineWidth',LWidth); hold on
errorbar(X,YFew,SEMFew,'k','LineStyle','none','LineWidth',LWidth); hold on
errorbar(X,YSpaced,SEMSpaced,'k','LineStyle','none','LineWidth',LWidth); hold on

legend(j,{'Many Trial-Poor Sessions' 'Few Daily Trial-Rich Sessions' 'Few Spaced Trial-Rich Sessions'},'fontsize',11)
legend('boxoff')

set(h,'Box','off')
set(h,'LineWidth',LWidth)
set(h,'TickDir','out')
set(h,'XTick',[1 3 5:8 10:13])
set(h,'TickLength',[0.015 0.025])
set(h,'XTickLabel','First|Last|1|2|3|4|1|2|3|4','fontsize',12)
% ylabel('Mean CS Poke Number')
% ylabel('Mean Pre-CS Poke Number')
ylabel('Mean Elevation Score')
% ylabel('CS pkg dur')
% ylabel('Pre-CS pkg dur')
% ylabel('PkgDur Diff score')
% ylabel('Mean Number of Pokes ± 1 SEM')
xlim([0 14])
ylim([-2 10])

% When using x-axis fontsize of 14
% xlabel({'          Extinction          SR 1 week            SR 3 weeks          '...
%         ' 2-trial blocks                            Trials                         '});

% When using a smaller fontsize
xlabel({' Extinction                 SR 1 week                   SR 3 weeks '...
        '    2-trial blocks                                        Trials                                '});
 
% j = gcf; plot2svg('ExtnctnSRTests.svg', j);

%% Extinction and Spontaneous Recovery plots for 2-trial blocks (correct cell)

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores
% CS_PkgDurSub PreCS_PkgDurSub PkgDurElevationScores

clear SR1wk1stBlck SR1wk2ndBlck SR3wk1stBlck SR3wk2ndBlck FirstExt2Blck LastExt2Blck

for m=1:18;
    TrialNumber = length(Experiment.Subject(m).PkNumElevationScores)-8;
    SR1wk1stBlck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(end-7:end-6));
    SR1wk2ndBlck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(end-5:end-4));
    SR3wk1stBlck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(end-3:end-2));
    SR3wk2ndBlck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(end-1:end));
    FirstExt2Blck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(281:282));
    LastExt2Blck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(TrialNumber-1:TrialNumber));
end


% Mean CR during the first 2 extinction trials
GrpManyFrstExtBlckMean = mean(FirstExt2Blck(7:12));
GrpManyFrstExtBlckStError = std(FirstExt2Blck(7:12))/sqrt(6);
GrpFewFrstExtBlckMean = mean(FirstExt2Blck(1:6));
GrpFewFrstExtBlckStError = std(FirstExt2Blck(1:6))/sqrt(6);
GrpSpacedFrstExtBlckMean = mean(FirstExt2Blck(13:18));
GrpSpacedFrstExtBlckStError = std(FirstExt2Blck(13:18))/sqrt(6);

% Mean CR during the last 2 extinction trials
GrpManyLastExtBlckMean = mean(LastExt2Blck(7:12));
GrpManyLastExtBlckStError = std(LastExt2Blck(7:12))/sqrt(6);
GrpFewLastExtBlckMean = mean(LastExt2Blck(1:6));
GrpFewLastExtBlckStError = std(LastExt2Blck(1:6))/sqrt(6);
GrpSpacedLastExtBlckMean = mean(LastExt2Blck(13:18));
GrpSpacedLastExtBlckStError = std(LastExt2Blck(13:18))/sqrt(6);

% Mean CR during the 1-week SR test
GrpManySR1wk1stBlckMean = mean(SR1wk1stBlck(7:12));
GrpManySR1wk1stBlckStError = std(SR1wk1stBlck(7:12))/sqrt(6);
GrpManySR1wk2ndBlckMean = mean(SR1wk2ndBlck(7:12));
GrpManySR1wk2ndBlckStError = std(SR1wk2ndBlck(7:12))/sqrt(6);

GrpFewSR1wk1stBlckMean = mean(SR1wk1stBlck(1:6));
GrpFewSR1wk1stBlckStError = std(SR1wk1stBlck(1:6))/sqrt(6);
GrpFewSR1wk2ndBlckMean = mean(SR1wk2ndBlck(1:6));
GrpFewSR1wk2ndBlckStError = std(SR1wk2ndBlck(1:6))/sqrt(6);

GrpSpacedSR1wk1stBlckMean = mean(SR1wk1stBlck(13:18));
GrpSpacedSR1wk1stBlckStError = std(SR1wk1stBlck(13:18))/sqrt(6);
GrpSpacedSR1wk2ndBlckMean = mean(SR1wk2ndBlck(13:18));
GrpSpacedSR1wk2ndBlckStError = std(SR1wk2ndBlck(13:18))/sqrt(6);

% Mean CR during the 3-week SR test
GrpManySR3wk1stBlckMean = mean(SR3wk1stBlck(7:12));
GrpManySR3wk1stBlckStError = std(SR3wk1stBlck(7:12))/sqrt(6);
GrpManySR3wk2ndBlckMean = mean(SR3wk2ndBlck(7:12));
GrpManySR3wk2ndBlckStError = std(SR3wk2ndBlck(7:12))/sqrt(6);

GrpFewSR3wk1stBlckMean = mean(SR3wk1stBlck(1:6));
GrpFewSR3wk1stBlckStError = std(SR3wk1stBlck(1:6))/sqrt(6);
GrpFewSR3wk2ndBlckMean = mean(SR3wk2ndBlck(1:6));
GrpFewSR3wk2ndBlckStError = std(SR3wk2ndBlck(1:6))/sqrt(6);

GrpSpacedSR3wk1stBlckMean = mean(SR3wk1stBlck(13:18));
GrpSpacedSR3wk1stBlckStError = std(SR3wk1stBlck(13:18))/sqrt(6);
GrpSpacedSR3wk2ndBlckMean = mean(SR3wk2ndBlck(13:18));
GrpSpacedSR3wk2ndBlckStError = std(SR3wk2ndBlck(13:18))/sqrt(6);



[P,H] = signrank(LastExt2Blck(7:12),SR3wk1stBlck(7:12))

% Plotting

figure
h = subplot(1,1,1); hold on

% Unless I prespecify all the X and Y data, the tee of the errorbars is
% getting rescaled to such small size that is barely visible.
X = [1 3 5:6 8:9]';
YMany = [GrpManyFrstExtBlckMean;GrpManyLastExtBlckMean;GrpManySR1wk1stBlckMean;GrpManySR1wk2ndBlckMean;GrpManySR3wk1stBlckMean;GrpManySR3wk2ndBlckMean];
SEMMany = [GrpManyFrstExtBlckStError;GrpManyLastExtBlckStError;GrpManySR1wk1stBlckStError;GrpManySR1wk2ndBlckStError;GrpManySR3wk1stBlckStError;GrpManySR3wk2ndBlckStError];
YFew = [GrpFewFrstExtBlckMean;GrpFewLastExtBlckMean;GrpFewSR1wk1stBlckMean;GrpFewSR1wk2ndBlckMean;GrpFewSR3wk1stBlckMean;GrpFewSR3wk2ndBlckMean];
SEMFew = [GrpFewFrstExtBlckStError;GrpFewLastExtBlckStError;GrpFewSR1wk1stBlckStError;GrpFewSR1wk2ndBlckStError;GrpFewSR3wk1stBlckStError;GrpFewSR3wk2ndBlckStError];
YSpaced = [GrpSpacedFrstExtBlckMean;GrpSpacedLastExtBlckMean;GrpSpacedSR1wk1stBlckMean;GrpSpacedSR1wk2ndBlckMean;GrpSpacedSR3wk1stBlckMean;GrpSpacedSR3wk2ndBlckMean];
SEMSpaced = [GrpSpacedFrstExtBlckStError;GrpSpacedLastExtBlckStError;GrpSpacedSR1wk1stBlckStError;GrpSpacedSR1wk2ndBlckStError;GrpSpacedSR3wk1stBlckStError;GrpSpacedSR3wk2ndBlckStError];


% Plotting lines
% Group Many Sessions
LWidth = 1.25;
MarkSize = 8;
j(1) = plot(X(1:2),YMany(1:2),'-ok','LineWidth',LWidth,'MarkerSize',MarkSize);
plot(X(3:4),YMany(3:4),'-ok','LineWidth',LWidth,'MarkerSize',MarkSize);
plot(X(5:6),YMany(5:6),'-ok','LineWidth',LWidth,'MarkerSize',MarkSize);

% Group Few Sessions
j(2) = plot(X(1:2),YFew(1:2),'--sk','LineWidth',LWidth,'MarkerFaceColor','k','MarkerSize',MarkSize);
plot(X(3:4),YFew(3:4),'--sk','LineWidth',LWidth,'MarkerFaceColor','k','MarkerSize',MarkSize);
plot(X(5:6),YFew(5:6),'--sk','LineWidth',LWidth,'MarkerFaceColor','k','MarkerSize',MarkSize);

% Group Spaced Sessions
j(3) = plot(X(1:2),YSpaced(1:2),'-.vk','LineWidth',LWidth,'MarkerSize',MarkSize);
plot(X(3:4),YSpaced(3:4),'-.vk','LineWidth',LWidth,'MarkerSize',MarkSize);
plot(X(5:6),YSpaced(5:6),'-.vk','LineWidth',LWidth,'MarkerSize',MarkSize);

% and errorbars
errorbar(X,YMany,SEMMany,'k','LineStyle','none','LineWidth',LWidth);
errorbar(X,YFew,SEMFew,'k','LineStyle','none','LineWidth',LWidth);
errorbar(X,YSpaced,SEMSpaced,'k','LineStyle','none','LineWidth',LWidth);

legend(j,{'Many Trial-Poor Sessions' 'Few Daily Trial-Rich Sessions' 'Few Spaced Trial-Rich Sessions'},'fontsize',11)
legend('boxoff')

set(h,'Box','off')
set(h,'LineWidth',LWidth)
set(h,'TickDir','out')
set(h,'XTick',[1 3 5:6 8:9])
set(h,'TickLength',[0.015 0.025])
set(h,'XTickLabel','First|Last|1|2|1|2','fontsize',12)
% ylabel('Mean CS Poke Number')
% ylabel('Mean Pre-CS Poke Number')
ylabel('Mean Elevation Score')
% ylabel('CS pkg dur')
% ylabel('Pre-CS pkg dur')
% ylabel('PkgDur Diff score')
% ylabel('Mean Number of Pokes ± 1 SEM')
xlim([0 10])
ylim([-2 10])

% When using x-axis fontsize of 14
% xlabel({'          Extinction          SR 1 week            SR 3 weeks          '...
%         ' 2-trial blocks                            Trials                         '});

% When using a smaller fontsize
xlabel({'        Extinction                 SR 1 week                   SR 3 weeks '...
        '2-trial blocks'});
 
% j = gcf; plot2svg('ExtnctnSRTests.svg', j);


%% Cumulative distributions of CRs during SR tests

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores
% CS_PkgDurSub PreCS_PkgDurSub PkgDurElevationScores


for m=1:18;
    SR1wk(1:4,m)=Experiment.Subject(m).PkgDurElevationScores(end-7:end-4)';
    SR3wk(1:4,m)=Experiment.Subject(m).PkgDurElevationScores(end-3:end)';
    for block =1:2;
        SR1wk2trlblck(block,m)=mean(SR1wk(2*block-1:2*block,m));
        SR3wk2trlblck(block,m)=mean(SR3wk(2*block-1:2*block,m));
    end
end

figure
orient tall

% Cumulative distributions of CRs

i = 1;

% for trial = 1:4;
Field = {SR1wk2trlblck;SR3wk2trlblck};

for f = 1:2;
    
    for block = 1:2;
        
        subplot(2,2,i)

%         [XX,YY] = stairs(sort(SR3wk(trial,7:12)),1:6);
        [XX,YY] = stairs(sort(Field{f,1}(block,7:12)),1:6);
        XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
        plot(XX,YY,'Linewidth',2,'Color','b')
        hold on

%         [XX,YY] = stairs(sort(SR3wk(trial,1:6)),1:6);
        [XX,YY] = stairs(sort(Field{f,1}(block,1:6)),1:6);
        XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
        plot(XX,YY,'Linewidth',2,'Color','r')
        hold on

%         [XX,YY] = stairs(sort(SR3wk(trial,13:18)),1:6);
        [XX,YY] = stairs(sort(Field{f,1}(block,13:18)),1:6);
        XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
        plot(XX,YY,'Linewidth',2,'Color','g')

        ylim([0 7])
        ylabel('Number of subjects')
        xlabel('PkgDur Diff Score')
%         title(['SR 3-week: Trial ' num2str(trial)])
        if f==1;
            title(['SR 1-wk Cum. Distr.: 2-trial block ' num2str(block)])
        else
            title(['SR 3-wk Cum. Distr.: 2-trial block ' num2str(block)])
        end
        
        if i==4;
            legend('Many Sessions','Few Massed Sessions','Few Spaced Sessions','Location','SouthEast')
        end
        
        i=i+1;
        
    end

end

%% Group Comparison on Spontaneous Recovery using a Relative Likelihood Analysis
% This script compares the performance of two groups on a SR test trial.
% When using the skellpdf, instead of calculating the two lambdas from the
% preCS and CS data, it uses MLE to get these values. Note that in order
% for MLE to work with my custom skellam distribution, I had to turn off
% the 'FunValCheck'. The latter option, indicates whether or not MLE should
% check the values returned by the custom distribution functions for
% validity. Default is 'on'. A poor choice of starting point can sometimes
% cause these functions to return NaNs, infinite values, or out of range
% values if they are written without suitable error-checking (like mine).
% The specific line in the mlecustom.m code is: ln.22: checkFunVals =
% strcmp(userOpts.FunValCheck, 'off');

clear BF BFNoDiff

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores
% CS_PkgDurSub PreCS_PkgDurSub PkgDurElevationScores

for m=1:Experiment.NumSubjects;
    TrialNumber = length(Experiment.Subject(m).PkNumElevationScores)-8;
    SR1wk(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-7:end-4)';
    SR3wk(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-3:end)';
    FirstExt2Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(281:282));
    LastExt2Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(TrialNumber-1:TrialNumber));
end

GrpManySR1wk = SR1wk(:,7:12);
GrpManySR3wk = SR3wk(:,7:12);
GrpFewSR1wk = SR1wk(:,1:6);
GrpFewSR3wk = SR3wk(:,1:6);
GrpSpacedSR1wk = SR1wk(:,13:18);
GrpSpacedSR3wk = SR3wk(:,13:18);

    
for Trial = 1:4; % the two goups will be compared on every trial

    % Model 1 (aka No Difference) stipulates that there is no difference
    % between the two groups on the magnitude of spontaneous recovery
    % they produced.
    phat = mle([GrpManySR3wk(Trial,:) GrpSpacedSR3wk(Trial,:)],'pdf',@skellpdf,'start',[1 1]);
    % phat contains the mles of the two lambdas (CS and pre-CS)
    
    LLModel1 = sum([log(skellpdf(GrpManySR3wk(Trial,:),phat(1),phat(2)))...
                    log(skellpdf(GrpSpacedSR3wk(Trial,:),phat(1),phat(2)))]);

    % Model 2 (aka SR) says that there is a difference between the two
    % groups.
    phatGrpMany = mle(GrpManySR3wk(Trial,:),'pdf',@skellpdf,'start',[1 1]);
    phatGrpSpaced = mle(GrpSpacedSR3wk(Trial,:),'pdf',@skellpdf,'start',[1 1]);
    
    LLModel2 = sum([log(skellpdf(GrpManySR3wk(Trial,:),phatGrpMany(1),phatGrpMany(2)))...
                    log(skellpdf(GrpSpacedSR3wk(Trial,:),phatGrpSpaced(1),phatGrpSpaced(2)))]);

    LogOdds = LLModel2 - LLModel1 - 1/2*(4-2)*log(12);
    % OddsModel1 = exp[LLModel1 - LLModel2 - 1/2(d1 - d2)log(n)];

    BF(Trial) = exp(LogOdds); % Bayes Factor in favor of change model
    
    LogOddsNoDiff = LLModel1 - LLModel2 - 1/2*(2-4)*log(12);
    % OddsModel1 = exp[LLModel1 - LLModel2 - 1/2(d1 - d2)log(n)];

    BFNoDiff(Trial) = exp(LogOddsNoDiff); % Bayes Factor in favor of change model

end

[BF; BFNoDiff]


%% Acquisition slope-plots 

% Plotting the cumulative records of the elevation scores and running the
% change-point detection algorithm

for M = 18;
    
    clear Data
    
    Data(1:280,1)=Experiment.Subject(M).PreCS_PkNumSub(1:280);
    Data(1:280,2)=Experiment.Subject(M).CS_PkNumSub(1:280);
    
    [CP,Record]=ElevScoreCpRL(Data,100);

%     subplot(2,1,1);
%     title(['Mouse ' num2str(Experiment.Subject(m).Id) '. KS-test w/ Crt 4'])
%     ylabel('Cumulative Poke # Diff. Scores')
%     hold on
%     % Plot session boundaries
%     for x=[16 32 48 64 80 96 112 128]
%         plot([x x],[0 max(cumsum(Experiment.Subject(m).PkNumElevationScores))])
%     end
%     
%     subplot(2,1,2);
%     ylabel('Poke # Diff. Scores')
%     hold on
    

%     Experiment.Subject(M).AcqCPCrt100 = CP;
    % These slopes have been saved in the Experiment structure.
    
end

% for f=1:2:35;
%     M=ceil(f/2);
%     figure(f);
%     title(['SessNumReplic1: M' num2str(M) ' PkNumElevScores']);
%     saveas(f,['SessNumReplic1_AcqCP100_M' num2str(M) '_PkNumElevScore.fig']);
%     figure(f+1);
%     title(['SessNumReplic1: M' num2str(M) ' CurveFits']);
%     saveas(f+1,['SessNumReplic1_AcqCP100_M' num2str(M) '_CurveFits.fig']);
% end


% close all
% 
% cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication'
% TSsaveexperiment('SessNumberReplicAllGrps_5');
% cd 'C:\Program Files\MATLAB\R2006b'
% 

%%  ------------ ACQUISITION PERFORMANCE --------------

Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = 100; % start of criterion loop
        
        for m = 1%:length(Experiment.Subject);
            
            AsmptNote = 'The asymptote is the mean performance during the last 80 trials.';
            
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.Notes = AsmptNote']);

            clear Data Slopes PstvSlpTrls %Steps StepDur StpPkng Deviation R P Correlation Probability

            Data = eval(['Experiment.Subject(m).' Variable{f} 'ElevationScores(1:280)']);
            % Only include the acquisition data

            Slopes = eval(['Experiment.Subject(m).' Variable{f} 'AcqCPCrt' num2str(Crt)]);
            % Get the appropriate slopes as created by the algorithm and stored
            % in the structure.

            PstvSlpTrls = Slopes(find(Slopes(1:end-1,4)>0));
            % Finds the trials of the CPs that led to higher than
            % baseline performance (that is, positive slope).

            % Script for the hypothesis testing that the segment of the
            % record with this slope is significantly different from zero.
            
            if ~(isempty(PstvSlpTrls));

                i=1; OnsetLatency = []; % Initialize

                while isempty(OnsetLatency)
                    if i == length(PstvSlpTrls)
                        if ttest(Data(PstvSlpTrls(i)+1 : end),0) == 1;
                            OnsetLatency = PstvSlpTrls(i);
                        else
                            OnsetLatency = []; % No supra-baseline performance
                        end
                    else
                        if ttest(Data(PstvSlpTrls(i)+1 : Slopes(min(find(Slopes(:,1)>PstvSlpTrls(i))),1)),0) == 1;
                            OnsetLatency = PstvSlpTrls(i);
                        else OnsetLatency = []; % No supra-baseline performance
                            i = i+1;
                        end                
                    end
                end % of while loop
                
                Asmpt = mean(Data(201:end));
                % The level of the asymptote is the mean of the variable
                % (PkNum or PkgDur) for the last 80 trials.

                AsmptTrl = Slopes(min(find(Slopes(:,4) >= 0.8*Asmpt)),1);
                % Finds the trial of the CP after which the average
                % CR measure was 80% or more of the asymptote.

                if isempty(AsmptTrl); % If none of the steps reaches 80%
                    % of the asymptote, like, for example, Mouse 1 PkgDur
                    % Crt6...
                    AsmptTrl = []; % assign a maximal value to that measure.
                end

                DynIntvl = AsmptTrl - OnsetLatency;
                
            else % In case there are mice with no acquisition, according
                % to the CP algorithm (no positive steps), assign maximal
                % values to all the measures.
                
                OnsetLatency = [];
                
                Asmpt = mean(Data(201:end));
                % The level of the asymptote is the mean of the variable
                % (PkNum or PkgDur) for the last two sessions.

                AsmptTrl = [];

                DynIntvl = AsmptTrl - OnsetLatency;
                
            end
            
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.Asymptote = Asmpt;']);
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.AsmptTrl_Skellam_Crt' num2str(Crt) '= AsmptTrl;']);
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.DynIntvl_Skellam_Crt' num2str(Crt) '= DynIntvl;']);
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.OnsetLatency_Skellam_Crt' num2str(Crt) '= OnsetLatency;']);

            % The following code estimates the performance during every step of the
            % dynamic interval.

    %         Steps = find(Slopes(:,1) >= TrlOfFrstUpwrdIP & Slopes(:,1) < AsmptTrl);
    %         % Gives the row numbers (of the Slopes array) of the
    %         % various (if any) steps that occured during the dynamic
    %         % interval.
    % 
    %         if ~isempty(Steps)
    % 
    %             for b = 1:length(Steps)
    % 
    %                 StepDur(b) = Slopes(Steps(b)+1,1) - Slopes(Steps(b),1);
    %                 % Gives the duration in trials of that step.
    % 
    %                 StpPkng(b) = Slopes(Steps(b),2)/Asmpt*100;
    %                 % Gives the "amount" of poking during this step as a
    %                 % percentage of asymptotic poking.
    % 
    %                 % The following for-loop estimates the deviation of the
    %                 % conditioned responses from the average amount of
    %                 % poking per trial during every step. We will calculate
    %                 % the correlations between trial within each step and
    %                 % amount of conditioned behavior.
    %                 for i = 1 : StepDur(b)
    % 
    %                     Deviation{b}(i) = M(m).DrsTrl(Slopes(Steps(b),1)+i) - Slopes(Steps(b),2);
    % 
    %                 end
    % 
    %                 X=(1:length(Deviation{b}));
    % 
    %                 [R{b},P{b}]=corrcoef(X',Deviation{b}');
    % 
    %                 Correlation(b)=R{b}(2); Probability(b)=P{b}(2); %Correlation and probability level.
    % 
    %             end % of step loop
    % 
    %             StepPerformance{Grp,m} = [StepDur' StpPkng' Correlation' Probability'];
    % 
    %         else
    % 
    %             StepPerformance{Grp,m} = [0 0 0 0];
    % 
    %         end % of dynamic interval loop

        end % of loop for a mouse
    
    end % of criterion loop
    
end % of variable loop

%%  ---------- Group comparisons ----------Needs to be changed.

% Did the following comparisons and did not find a single positive result.

Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = [6]; % start of criterion loop
        
        for i =1:18;
            Asymptote(i,1)= eval(['Experiment.Subject(' num2str(i) ').Acquisition_CP.PkNumElevScr.Asymptote']);
            AsmptTrl(i,1)= eval(['Experiment.Subject(' num2str(i) ').Acquisition_CP.PkNumElevScr.AsmptTrl_KS_Crt' num2str(Crt)]);
            DynIntvl(i,1)= eval(['Experiment.Subject(' num2str(i) ').Acquisition_CP.PkNumElevScr.DynIntvl_KS_Crt' num2str(Crt)]);
            OnsetLatency(i,1)= eval(['Experiment.Subject(' num2str(i) ').Acquisition_CP.PkNumElevScr.OnsetLatency_KS_Crt' num2str(Crt)]);
        end

        [h p ci stats] = ttest2(Asymptote(1:6),Asymptote(7:12))
        [h p ci stats] = ttest2(AsmptTrl(1:6),AsmptTrl(7:12))
        [h p ci stats] = ttest2(DynIntvl(1:6),DynIntvl(7:12))
        [h p ci stats] = ttest2(OnsetLatency(1:6),OnsetLatency(7:12))
        
        [h p ci stats] = ttest2(Asymptote(1:6),Asymptote(13:18))
        [h p ci stats] = ttest2(AsmptTrl(1:6),AsmptTrl(13:18))
        [h p ci stats] = ttest2(DynIntvl(1:6),DynIntvl(13:18))
        [h p ci stats] = ttest2(OnsetLatency(1:6),OnsetLatency(13:18))
        
        [h p ci stats] = ttest2(Asymptote(7:12),Asymptote(13:18))
        [h p ci stats] = ttest2(AsmptTrl(7:12),AsmptTrl(13:18))
        [h p ci stats] = ttest2(DynIntvl(7:12),DynIntvl(13:18))
        [h p ci stats] = ttest2(OnsetLatency(7:12),OnsetLatency(13:18))

    end % of criterion loope
    
end % of variable loop


% Reporting significant results

% [h p ci stats] = ttest2(AsmptTrl(1:6),AsmptTrl(7:12)), Criterion 3
% h = 1
% p = 0.0379
% ci = 4.8443  137.1557
% stats = tstat: 2.3913
%         df: 10
%         sd: 51.4263

% [h p ci stats] = ttest2(AsmptTrl(1:6),AsmptTrl(7:12)), Criterion 4
% h = 1
% p = 0.0117
% ci = 18.8198  117.5135
% stats = tstat: 3.0779
%         df: 10
%         sd: 38.3599

% [h p ci stats] = ttest2(DynIntvl(1:6),DynIntvl(7:12)), Criterion 4
% h = 1
% p = 0.0425
% ci = 2.3056  110.0277
% stats = tstat: 2.3235
%         df: 10
%         sd: 41.8690

% [h p ci stats] = ttest2(AsmptTrl(1:6),AsmptTrl(7:12)), Criterion 6
% h = 1
% p = 0.0148
% ci = 15.6780  113.9886
% stats = tstat: 2.9388
%         df: 10
%         sd: 38.2110


%% Trials to extinction criterion

% I compared the 3 groups on the number of trials to reach the
% extinction criterion and found no differences.

for M=1:18;
        
    ExtinctionCriterion(M,1) = Experiment.Subject(M).Session(end-2).TrialCS.NumTrials-5;
    % The criterion was reached 5 trials before the extinction session
    % finished (remember that after 5 consecutive trials of no CS-pokes,
    % each subject received 5 additional trials before the session ended).
    
end

%                                      ANOVA
% ExtnctnCrit 
%                   Sum of Squares	   df	      Mean Square	  F	     Sig.
% Between Groups	   2.333	        2	         1.167	    .022	 .978
% Within Groups	     794.167	       15	        52.944			
% Total	             796.500	       17				


%% Extinction slope-plots 

% Plotting the cumulative records of the elevation scores and running the
% change-point detection algorithm

for M = 1:18;
    
    ExtnctnTrlNum = Experiment.Subject(M).Session(end-2).TrialCS.NumTrials;
    
    clear Data CP Record
    
    Data(1:ExtnctnTrlNum,1)=Experiment.Subject(M).PkNumElevationScores(281:(280+ExtnctnTrlNum));
    
    [CP,Record]=ElevScoreCpRL_MLE_alpha(Data,100);
    
    Experiment.Subject(M).PkNumExtCPCrt100_MLE = CP;
    % These slopes have been saved in the Experiment structure.
    
%     Data(1:ExtnctnTrlNum,1)=Experiment.Subject(M).Session(end-2).PreCS_PkNumSes;
%     Data(1:ExtnctnTrlNum,2)=Experiment.Subject(M).Session(end-2).CS_PkNumSes;
%     
%     [CP,Record]=ElevScoreCpRL(Data,100);    

%     Experiment.Subject(M).PkNumExtCPCrt100 = CP;
    % These slopes have been saved in the Experiment structure.
    
end

for f=1:2:35;
    M=ceil(f/2);
    figure(f);
    title(['SessNumReplic1: M' num2str(M) ' Extinction PkNumElevScores']);
    saveas(f,['SessNumReplic1_ExtCP100MLE_M' num2str(M) '_PkNumElevScore.fig']);
    figure(f+1);
    title(['SessNumReplic1: M' num2str(M) ' Extinction CurveFits']);
    saveas(f+1,['SessNumReplic1_ExtCP100MLE_M' num2str(M) '_CurveFits.fig']);
end

% close all

cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication'
TSsaveexperiment('SessNumberReplicAllGrps_6');
cd 'C:\Program Files\MATLAB\R2006b\Experiments'


%%   Algorithm on the Group-average Extinction Curve Cannot Be Run because
%%   the group-average data are real valued, not integers.

% Just of curiosity, I want to see what the Group Average Extinction Data
% look like. 

for M = 1:18;
    ExtnctnTrlNum(M,1) = Experiment.Subject(M).Session(end-2).TrialCS.NumTrials;    
%     PreCSData(1:ExtnctnTrlNum(M),M)=Experiment.Subject(M).Session(end-2).PreCS_PkNumSes;
%     CSData(1:ExtnctnTrlNum(M),M)=Experiment.Subject(M).Session(end-2).CS_PkNumSes;
Data(1:ExtnctnTrlNum(M)+1,M) = [Experiment.Subject(M).PkNumElevationScores(281:(280+ExtnctnTrlNum));1000];
end

MeanPreCSData(1:min(ExtnctnTrlNum),1) = mean(PreCSData(1:min(ExtnctnTrlNum),:),2);
MeanCSData(1:min(ExtnctnTrlNum),1) = mean(CSData(1:min(ExtnctnTrlNum),:),2);

clear Data CP Record

Data(1:ExtnctnTrlNum,1)=Experiment.Subject(M).PkNumElevationScores(281:(280+ExtnctnTrlNum));

[CP,Record]=ElevScoreCpRL_MLE_alpha(Data,100);

Experiment.Subject(M).PkNumExtCPCrt100_MLE = CP;
% These slopes have been saved in the Experiment structure.


% Data(1:min(ExtnctnTrlNum),1)=round(MeanPreCSData);
% Data(1:min(ExtnctnTrlNum),2)=round(MeanCSData);
% 
% [CP,Record]=ElevScoreCpRL(Data,100);


%%  ------------ EXTINCTION PERFORMANCE --------------

Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = 100; % start of criterion loop
        
        for m = 1:length(Experiment.Subject);
            
            FloorCRNote = 'The floor CR is the mean performance during the last 10 trials.';
            
            eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.Notes = FloorCRNote']);

            clear Data PreCSData CSData Slopes

            Data = eval(['Experiment.Subject(m).Session(end-2).CS_' Variable{f} 'Ses'...
                '- Experiment.Subject(m).Session(end-2).PreCS_' Variable{f} 'Ses']);
            % Only include the extinction data
            
            CSData = eval(['Experiment.Subject(m).Session(end-2).CS_' Variable{f} 'Ses']);
            
            PreCSData = eval(['Experiment.Subject(m).Session(end-2).PreCS_' Variable{f} 'Ses']);

            Slopes = eval(['Experiment.Subject(m).' Variable{f} 'ExtCPCrt' num2str(Crt) '_MLE']);
            % Get the appropriate slopes as created by the algorithm and stored
            % in the structure.
            
            Floor = mean(Data(end-9:end));
            % The level of the floor CR is the mean of the variable
            % (PkNum or PkgDur) for the last 10 trials.

            % If the very first (initial) step is higher than 0
            if Slopes(1,4)>0;
            
                FirstDropLatency = min(Slopes(find(Slopes(1:end-1,4) < Slopes(1,4))));
                % Finds the trial of the first CP that led to lower performance
                % than the initial one.
            
                NgtvSlpTrls = Slopes(find(Slopes(1:end-1,4) < Slopes(1,4)));
                % Finds the trials of the CPs that led to lower than
                % initial performance (that is, smaller slopes than the first).

                % Script for the hypothesis testing that the segment of the
                % record with this slope is not significantly different from zero.

                if ~(isempty(NgtvSlpTrls));

                    if length(NgtvSlpTrls) > 1; % if we have more than just one downward CP

                        i=1; ExtinctionTrial = []; % Initialize

                        while isempty(ExtinctionTrial)

                            if (kstest2(CSData(NgtvSlpTrls(i)+1 : Slopes(min(find(Slopes(:,1)>NgtvSlpTrls(i))),1)),...
                                     PreCSData(NgtvSlpTrls(i)+1 : Slopes(min(find(Slopes(:,1)>NgtvSlpTrls(i))),1))) == 0) ||...
                              ((kstest2(CSData(NgtvSlpTrls(i)+1 : Slopes(min(find(Slopes(:,1)>NgtvSlpTrls(i))),1)),...
                                     PreCSData(NgtvSlpTrls(i)+1 : Slopes(min(find(Slopes(:,1)>NgtvSlpTrls(i))),1))) == 1) &&...
                               (mean(PreCSData(NgtvSlpTrls(i)+1 : Slopes(min(find(Slopes(:,1)>NgtvSlpTrls(i))),1))) >...
                                   mean(CSData(NgtvSlpTrls(i)+1 : Slopes(min(find(Slopes(:,1)>NgtvSlpTrls(i))),1)))))
                                ExtinctionTrial = NgtvSlpTrls(i);
                                break
                            else
                                i = i+1;
                            end

                        end % of while loop

                    elseif length(NgtvSlpTrls) == 1; % if we have two-step extinction

                        ExtinctionTrial = FirstDropLatency;
                        % The trial that led to extinction is the same as the
                        % trial of the first downward changepoint.

                    end % of if length(NgtvSlpTrls) > 1 loope

                    DynIntvl = ExtinctionTrial - FirstDropLatency;

                else % In case there are mice with no downward steps, assign min
                    % values to the measures.

                    ExtinctionTrial = 0;

                    FirstDropLatency = 0;

                    DynIntvl = ExtinctionTrial - FirstDropLatency;

                end
                
            else %if the initial step is lower than 0
                
                ExtinctionTrial = 0;
                FirstDropLatency = 0;                
                DynIntvl = ExtinctionTrial - FirstDropLatency;
                
            end

                
            eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.FirstDropLatency_Skellam_Crt' num2str(Crt) '= FirstDropLatency;']);
            eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.ExtinctionTrial_Skellam_Crt' num2str(Crt) '= ExtinctionTrial;']);
            eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.DynIntvl_Skellam_Crt' num2str(Crt) '= DynIntvl;']);
            eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.Floor = Floor;']);

%             [m FirstDropLatency ExtinctionTrial DynIntvl]

        end % of loop for a mouse
    
    end % of criterion loop
    
end % of variable loop

%%  ---------- Extinction Group Comparisons ----------

% Did the following comparisons and found that Group Few Spaced Sessions
% had a higher Floor than Group Few Massed Sessions (meaningless). There
% was also a tendency for the Spaced group to have a later ExtinctionTrial
% than the Massed Group, but it was not significant. These analyses have
% been saved on an SPSS output file.

Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = 100; % start of criterion loop
        
        for m =1:18;
            Floor(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.Floor;']);
            FirstDropLatency(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.FirstDropLatency_Skellam_Crt' num2str(Crt) ';']);
            ExtinctionTrial(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.ExtinctionTrial_Skellam_Crt' num2str(Crt) ';']);
            DynIntvl(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.DynIntvl_Skellam_Crt' num2str(Crt) ';']);
        end

    end % of criterion loope
    
end % of variable loop


%% Weibull fits to extinction curves

% This is the curve fitting section. I will call the NewExtnctnFit.m and
% save the exported parameters (F,I,L,S) in the structure.

clear LowerF UpperF F_start I_start L_start S_start 

global m LowerF UpperF F_start I_start L_start S_start

for m=1:18;
        
    if m==1 || m==7 || m==13
        figure; orient tall;
    end

    clear X Y
    
    X = 1:Experiment.Subject(m).Session(end-2).TrialCS.NumTrials;
    
    Y = Experiment.Subject(m).PkNumElevationScores(281:(280+length(X)));
    
    LowerF = min(Y(end-4:end));
    UpperF = max(Y(end-4:end));
    if LowerF==UpperF; UpperF = UpperF+1; end
    % Because it is not allowed to have equal upper and lower bounds, if
    % this is the case, then increment the Upper limit by 1.
    I_start = max(Y(1:4));
    F_start = 0;
    L_start = 10;
    S_start = 2;
    
    [O1,Params]=ExtnctnFit(X,Y);
    Experiment.Subject(m).ExtnctnWeibullFits.F=Params(1);
    Experiment.Subject(m).ExtnctnWeibullFits.I=Params(2);
    Experiment.Subject(m).ExtnctnWeibullFits.L=Params(3);
    Experiment.Subject(m).ExtnctnWeibullFits.S=Params(4);
%     print

end

%% Group comparison on the parameters of the Extinction Weibull Fits
% There was only a difference on the Initial parameter, where Group Few
% Spaced Sessions was higher than Group Many Sessions.

for m=1:18;
    Initial(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.I;
    Latency(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.L;
    Slope(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.S;
    Final(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.F;
end

%% Various analyses on extinction performance

for Crt = 100; % start of criterion loop

    figure
    orient tall
    sbplt = 1;

    for m = [2 3 4 5 8 10 13 14 15 16 17 18];              %:length(Experiment.Subject);

        clear Slopes h

        Slopes = eval(['Experiment.Subject(m).PkNumExtCPCrt' num2str(Crt) '_MLE']);
        % Get the appropriate slopes as created by the algorithm and stored
        % in the structure.

        h = subplot(4,3,sbplt);
        
        stairs(Slopes(:,1),Slopes(:,4),'k','LineWidth',1.5)

%         set(h,'Box','off')
        set(h,'LineWidth',1.5)
        
        ylim([-1 13])
        
        set(h,'fontsize',14)
        
        sbplt = sbplt+1;

    end

end


h = subplot(4,3,4);
xlim([0 60])
h = subplot(4,3,11);
xlabel('Trials','fontsize',20)
h = subplot(4,3,7);
ylabel('Mean Elevation Score','fontsize',20')
            
%%

%% Cumulative distributions of different measures of extinction based on
%  the CP RL MLE algorithm

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores
% CS_PkgDurSub PreCS_PkgDurSub PkgDurElevationScores


Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = 100; % start of criterion loop
        
        for m =1:18;
            Floor(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.Floor;']);
            FirstDropLatency(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.FirstDropLatency_Skellam_Crt' num2str(Crt) ';']);
            ExtinctionTrial(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.ExtinctionTrial_Skellam_Crt' num2str(Crt) ';']);
            DynIntvl(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.DynIntvl_Skellam_Crt' num2str(Crt) ';']);
        end

    end % of criterion loope
    
end % of variable loop

figure
orient tall
h=subplot(1,1,1);

% Cumulative distributions

% i = 1;

Field = {FirstDropLatency DynIntvl ExtinctionTrial};

for f = 3;
    
%     subplot(3,2,i)

%     [XX,YY] = stairs(sort(Field{f}(7:12)),1:6);
%     XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
%     plot(XX,YY,'Linewidth',2,'Color','b')
%     hold on
% 
%     [XX,YY] = stairs(sort(Field{f}(1:6)),1:6);
%     XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
%     plot(XX,YY,'Linewidth',2,'Color','r')
%     hold on
% 
%     [XX,YY] = stairs(sort(Field{f}(13:18)),1:6);
%     XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
%     plot(XX,YY,'Linewidth',2,'Color','g')
% 
%     ylim([0 7])
    
    % Calculating means and SEMs
    GroupManySessMean = mean(Field{f}(7:12));
    GroupManySessSEM = std(Field{f}(7:12))/sqrt(6);
    GroupFewSessMean = mean(Field{f}(1:6));
    GroupFewSessSEM = std(Field{f}(1:6))/sqrt(6);
    GroupSpacedSessMean = mean(Field{f}(13:18));
    GroupSpacedSessSEM = std(Field{f}(13:18))/sqrt(6);
    
    % Bar plots of the means
    Y = [GroupFewSessMean GroupManySessMean GroupSpacedSessMean];
    YSEM = [GroupFewSessSEM GroupManySessSEM GroupSpacedSessSEM];
    
    if f==1;
        X = 1:3;
    elseif f==2
        X = 5:7;
    else
        X = 9:11;
    end
        
    bar(X,Y)
    hold on
    
    % Error bars
    errorbar(X(1),GroupFewSessMean,GroupFewSessSEM,'k','LineStyle','none'); hold on
    errorbar(X(2),GroupManySessMean,GroupManySessSEM,'k','LineStyle','none'); hold on
    errorbar(X(3),GroupSpacedSessMean,GroupSpacedSessSEM,'k','LineStyle','none'); hold on
    
    ylabel('Number of subjects')
%     xlabel('Number of Trials')
    
%     if f==1;
%         title('FirstDropLatency')
%     elseif f==2
%         title('Dynamic Interval')
%     else
%         title('Extinction Trial')
%     end
    
    set(h,'Box','off')
    set(h,'LineWidth',1)
    set(h,'TickDir','out')
    set(h,'XTick',[1:3 5:7 9:11])
    set(h,'TickLength',[0.0015 0.0025])
    set(h,'XTickLabel',' |Onset Latency| | |Dynamic Interval| | |Extinction Trial| ','fontsize',12)


    legend('Few Massed Sessions','Many Sessions','Few Spaced Sessions','Location','NorthEast')

%     i=i+2;


end


