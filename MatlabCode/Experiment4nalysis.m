% % This scripts runs the basic analysis for everyday observation of the
% % mice's behavior in the magazine approach paradigm. A white noise is
% % followed by food 10 sec later (marked with a clicker). There is a 10-s
% % pre-CS period for baseline levels of responding. The experiment was run
% % in the new chambers.
% 
% 
% TSinitexperiment('SessionsVersusTrials',7,[59,60,61,62,63,64,77,78,79,80,81,82],'Mouse','Gallistel')
% % Creating structure
% 
% for S=1:12;
%     Experiment.Subject(S).Sex='M';
%     Experiment.Subject(S).Strain = 'C57BL/6';
% end
%     
% % DOB = {'01/15/06' '03/31/06' '01/27/06' '02/11/06' '02/11/06' ...
% %        '01/15/06' '02/11/06' '03/31/06' '01/27/06' '02/11/06'};
%     
% % for S=1:10;
% %     Experiment.Subject(S).Id = ID(S);
% %     Experiment.Subject(S).BirthDate = DOB{S};
% % end
% 
% 
% cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessnsVrsTrials'
% TSsaveexperiment('SessionsVersusTrials_0');
% cd 'C:\Program Files\MATLAB\R2006b'

%%
% TSloadexperiment('C:\Documents and Settings\Gallistellab\Desktop\Stathis\SessnsRgrdlsTrials\SessnsRgrdlsTrials_1');

TSsetoverwritemode(0)

TSloadsessions('C:\Program Files\MATLAB\R2006b\Experiments\SessnsVrsTrials\Data');
% Loads data from a session into TSData subfield of Session subfield of Subject subfield

% TSimporteventcodes('matlabcodes.m')

cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessnsVrsTrials'
TSsaveexperiment('SessionsVersusTrials_1');
cd 'C:\Program Files\MATLAB\R2006b'

    
%%
%%-----------------------------RASTER PLOTS -------------------------

Events=[PokeOn2 PokeOff2; Feed2 0; PreCS 0; WNoiseOff 0];
% Defining events for raster plots.

% Making the plots
for M=1:length(Experiment.Subject);
    for S=length(Experiment.Subject(M).Session); %-2:length(Experiment.Subject(M).Session);
        TSraster(Experiment.Subject(M).Session(S).TSData,[PreCS WNoiseOff],Events)
        if M<7
            title(['ManySessFewTrls Mouse ' num2str(M) ' Session ' num2str(S)])
        else
            title(['MassedSess Mouse ' num2str(M) ' Session ' num2str(S)])
        end
    end
end

%%
% Main program for analyzing pokes

TSdefinetrial('ITI',{[StartITI EndITI]});

TSdefinetrial('PreCS',{[PreCS WNoiseOn]});

TSdefinetrial('CS',{[WNoiseOn WNoiseOff]});
%The active trial is now CS

TSsettrial('CS'); % redundant but whatever!
TSlimit('Subjects',[1:6])
TSlimit('Sessions',[31])

TStrialstat('PkDurs',@TSparse,'result = [time(2)-time(1)];',[WNoiseOn -PokeOn2 PokeOff2], [PokeOn2 PokeOff2] ,[PokeOn2 -PokeOff2 WNoiseOff]);
% PkDurs field contains individual head-in intervals that occurred during a trial 

TSapplystat('PkNum','PkDurs',@length); 
% Creates PkDurs field which gives the number of pokes during a trial 

TSapplystat('PkgDur','PkDurs',@sum); % Creates a field at the trial level,
% that contains the sum of the poke durations

TSlimit('Subjects',[7:12])
TSlimit('Sessions',[10])

TStrialstat('PkDurs',@TSparse,'result = [time(2)-time(1)];',[WNoiseOn -PokeOn2 PokeOff2], [PokeOn2 PokeOff2] ,[PokeOn2 -PokeOff2 WNoiseOff]);
% PkDurs field contains individual head-in intervals that occurred during a trial 

TSapplystat('PkNum','PkDurs',@length); 
% Creates PkDurs field which gives the number of pokes during a trial 

TSapplystat('PkgDur','PkDurs',@sum); % Creates a field at the trial level,
% that contains the sum of the poke durations

TSlimit('Subjects',{ [0 -1] })
TSlimit('Sessions',{ [0 -1] })

TScombineover('CS_PkDursSes','PkDurs'); % Creates a field at the session level
% containing the vector of all poke durations

TScombineover('CS_PkNumSes','PkNum'); % Creates a field at the session level
% containing the vector of poke number for each trial

TScombineover('CS_PkgDurSes','PkgDur'); % Creates a field at the session level
% containing the vector of poking duration for each trial

TScombineover('CS_PkDursSub','CS_PkDursSes'); % Same vector as above, but now at
% the subject level, i.e., across sessions

TScombineover('CS_PkNumSub','CS_PkNumSes'); % Ditto

TScombineover('CS_PkgDurSub','CS_PkgDurSes'); % Ditto


TSsettrial('PreCS') % Calculate all of the above measures for the 10-sec periods before the CS onset

TSlimit('Subjects',[1:6])
TSlimit('Sessions',[31])

TStrialstat('PkDurs',@TSparse,'result = [time(2)-time(1)];',[PreCS -PokeOn2 PokeOff2], [PokeOn2 PokeOff2] ,[PokeOn2 -PokeOff2 WNoiseOn]);
% PkDurs field contains individual head-in intervals that occurred during the preCS period 

TSapplystat('PkNum','PkDurs',@length); 
% Creates PkDurs field which gives the number of pokes during that period 

TSapplystat('PkgDur','PkDurs',@sum); % Creates a field at the trial level,
% that contains the sum of the poke durations

TSlimit('Subjects',[7:12])
TSlimit('Sessions',[10])

TStrialstat('PkDurs',@TSparse,'result = [time(2)-time(1)];',[PreCS -PokeOn2 PokeOff2], [PokeOn2 PokeOff2] ,[PokeOn2 -PokeOff2 WNoiseOn]);
% PkDurs field contains individual head-in intervals that occurred during the preCS period 

TSapplystat('PkNum','PkDurs',@length); 
% Creates PkDurs field which gives the number of pokes during that period 

TSapplystat('PkgDur','PkDurs',@sum); % Creates a field at the trial level,
% that contains the sum of the poke durations

TSlimit('Subjects',{ [0 -1] })
TSlimit('Sessions',{ [0 -1] })

TScombineover('PreCS_PkDursSes','PkDurs'); % Creates a field at the session level
% containing the vector of all poke durations

TScombineover('PreCS_PkNumSes','PkNum'); % Creates a field at the session level
% containing the vector of poke number for each trial

TScombineover('PreCS_PkgDurSes','PkgDur'); % Creates a field at the session level
% containing the vector of poking duration for each trial

TScombineover('PreCS_PkDursSub','PreCS_PkDursSes'); % Same vector as above, but now at
% the subject level, i.e., across sessions

TScombineover('PreCS_PkNumSub','PreCS_PkNumSes'); % Ditto

TScombineover('PreCS_PkgDurSub','PreCS_PkgDurSes'); % Ditto

% TStrialstat('TrialData',@datatransfer);
%this trial stat loads data from each trial into the TrialData field of the
%Structure -- In order to use it, you must have the datatransfer function in
%your path.


% Calculate the difference (elevation) scores for the following two
% measures

for M=1:12;
    
    Experiment.Subject(M).PkNumElevationScores = Experiment.Subject(M).CS_PkNumSub - Experiment.Subject(M).PreCS_PkNumSub;

    Experiment.Subject(M).PkgDurElevationScores = Experiment.Subject(M).CS_PkgDurSub - Experiment.Subject(M).PreCS_PkgDurSub;
    
end

cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessnsVrsTrials'
TSsaveexperiment('SessionsVersusTrials_2');
cd 'C:\Program Files\MATLAB\R2006b'

%% Extinction and Spontaneous Recovery plots

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores
% CS_PkgDurSub PreCS_PkgDurSub PkgDurElevationScores

for m=1:12;    
    TrialNumber(m) = length(Experiment.Subject(m).PkNumElevationScores)-8;
    %Number of total trials prior to the first test (that is, the number of
    %trials up to the end of extinction)
    if m<7
        FirstExt2Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(71:72));
        %The first 6 mice got 28 sessions of 2.5 trials each (on average)
        %prior to extinction.
    else
        FirstExt2Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(281:282));
        %The last 6 mice got 7 sessions of 40 trials each prior to
        %extinction.
    end
    LastExt2Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(TrialNumber(m)-1:TrialNumber(m)));
    SR3d(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-7:end-4)';   
    SR18d(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-3:end)';    
end

    
% Mean CR during the first 3 extinction trials
GrpManySessFrstExtBlckMean = mean(FirstExt2Blck(1:6));
GrpManySessFrstExtBlckStError = std(FirstExt2Blck(1:6))/sqrt(6);
GrpManyTrlsFrstExtBlckMean = mean(FirstExt2Blck(7:12));
GrpManyTrlsFrstExtBlckStError = std(FirstExt2Blck(7:12))/sqrt(6);

% Mean CR during the last 3 extinction trials
GrpManySessLastExtBlckMean = mean(LastExt2Blck(1:6));
GrpManySessLastExtBlckStError = std(LastExt2Blck(1:6))/sqrt(6);
GrpManyTrlsLastExtBlckMean = mean(LastExt2Blck(7:12));
GrpManyTrlsLastExtBlckStError = std(LastExt2Blck(7:12))/sqrt(6);

% Mean CR during the first SR test (3 days)
GrpManySessSR3dMean = mean(SR3d(:,1:6),2);
GrpManySessSR3dStError = std(SR3d(:,1:6),0,2)/sqrt(6);
GrpManyTrlsSR3dMean = mean(SR3d(:,7:12),2);
GrpManyTrlsSR3dStError = std(SR3d(:,7:12),0,2)/sqrt(6);

% Mean CR during the second SR test (18 days)
GrpManySessSR18dMean = mean(SR18d(:,1:6),2);
GrpManySessSR18dStError = std(SR18d(:,1:6),0,2)/sqrt(6);
GrpManyTrlsSR18dMean = mean(SR18d(:,7:12),2);
GrpManyTrlsSR18dStError = std(SR18d(:,7:12),0,2)/sqrt(6);


% Plotting

figure
h = subplot(1,1,1);

% Unless I prespecify all the X and Y data, the tee of the errorbars is
% getting rescaled to such small size that is barely visible.
X = [1 3 5:8 10:13]';
YManySess = [GrpManySessFrstExtBlckMean;GrpManySessLastExtBlckMean;GrpManySessSR3dMean;GrpManySessSR18dMean];
SEMManySess = [GrpManySessFrstExtBlckStError;GrpManySessLastExtBlckStError;GrpManySessSR3dStError;GrpManySessSR18dStError];
YManyTrls = [GrpManyTrlsFrstExtBlckMean;GrpManyTrlsLastExtBlckMean;GrpManyTrlsSR3dMean;GrpManyTrlsSR18dMean];
SEMManyTrls = [GrpManyTrlsFrstExtBlckStError;GrpManyTrlsLastExtBlckStError;GrpManyTrlsSR3dStError;GrpManyTrlsSR18dStError];

% Plotting lines
% Group Many Sessions
j(1) = plot(X(1:2),YManySess(1:2),'-ok','LineWidth',1.25,'MarkerSize',8); hold on;
plot(X(3:6),YManySess(3:6),'-ok','LineWidth',1.25,'MarkerSize',8); hold on
plot(X(7:10),YManySess(7:10),'-ok','LineWidth',1.25,'MarkerSize',8); hold on

% Group Many Trials
j(2) = plot(X(1:2),YManyTrls(1:2),'--sk','LineWidth',1.25,'MarkerSize',8,'MarkerFaceColor','k'); hold on
plot(X(3:6),YManyTrls(3:6),'--sk','LineWidth',1.25,'MarkerSize',8,'MarkerFaceColor','k'); hold on
plot(X(7:10),YManyTrls(7:10),'--sk','LineWidth',1.25,'MarkerSize',8,'MarkerFaceColor','k'); hold on

% and errorbars
errorbar(X,YManySess,SEMManySess,'k','LineStyle','none','LineWidth',1.25); hold on
errorbar(X,YManyTrls,SEMManyTrls,'k','LineStyle','none','LineWidth',1.25); hold on

legend(j,{'Session-Rich-Trial-Poor ' 'Session-Poor-Trial-Rich '},'fontsize',11)
legend('boxoff')

set(h,'Box','off')
set(h,'LineWidth',1.25)
set(h,'TickDir','out')
set(h,'XTick',[1 3 5:8 10:13])
set(h,'TickLength',[0.015 0.025])
set(h,'XTickLabel','First|Last|1|2|3|4|1|2|3|4','fontsize',12)
% ylabel('CS poke #')
% ylabel('Mean Pre-CS Poke Number')
ylabel('Mean Elevation Score')
% ylabel('CS pkg dur')
% ylabel('Pre-CS pkg dur')
% ylabel('PkgDur Diff score')
% ylabel('Mean Number of Pokes ± 1 SEM')

ylim([-3 10])
xlim([0 14])

% xlabel({'     Extinction            SR 3 days             SR 18 days      '...
%         '    2-trial blocks                             Trials                           '});
text(0.95,-4.6,'Extinction','fontsize',12)
text(5.3,-4.6,'SR 3 days','fontsize',12)
text(10.2,-4.6,'SR 18 days','fontsize',12)
text(0.6,-5.4,'2-trial blocks','fontsize',12)
text(8.5,-5.4,'Trials','fontsize',12)


% % Older plotting works well
% % Extinction line plot
% % figure
% % orient tall
% subplot(3,1,3)
% 
% plot([1 3],[GrpManySessFrstExtBlckMean GrpManySessLastExtBlckMean],'-o')
% hold on; plot([1 3],[GrpManyTrlsFrstExtBlckMean GrpManyTrlsLastExtBlckMean],'--sr')
% %and error bars
% hold on; errorbar([1],GrpManySessFrstExtBlckMean,GrpManySessFrstExtBlckStError)
% hold on; errorbar([3],GrpManySessLastExtBlckMean,GrpManySessLastExtBlckStError)
% hold on; errorbar([1],GrpManyTrlsFrstExtBlckMean,GrpManyTrlsFrstExtBlckStError,'r')
% hold on; errorbar([3],GrpManyTrlsLastExtBlckMean,GrpManyTrlsLastExtBlckStError,'r')
% 
% hold on; plot([4 4],[-2 5],'k') %separator line
% hold on; plot([9 9],[-2 5],'k') %separator line
% 
% % SR tests line graph
% hold on; plot([5:8],GrpManySessSR3dMean,'-o')
% hold on; plot([5:8],GrpManyTrlsSR3dMean,'--sr')
% hold on; plot([10:13],GrpManySessSR18dMean,'-o')
% hold on; plot([10:13],GrpManyTrlsSR18dMean,'--sr')
% 
% % and errorbars
% hold on; errorbar([5:8],GrpManySessSR3dMean,GrpManySessSR3dStError)
% hold on; errorbar([5:8],GrpManyTrlsSR3dMean,GrpManyTrlsSR3dStError,'r')
% hold on; errorbar([10:13],GrpManySessSR18dMean,GrpManySessSR18dStError)
% hold on; errorbar([10:13],GrpManyTrlsSR18dMean,GrpManyTrlsSR18dStError,'r')
% 
% legend('Many Sessions','Many Trials')
% title('Sessions vs Trials')
% xlim([0 14])
% ylim([-2 10])
% set(gca,'XTick',[1 3:13])
% set(gca,'XTickLabel','First|Last| |1|2|3|4| |1|2|3|4','fontsize',12)
% % ylabel('Elevation score')
% % ylabel('CS poke #')
% % ylabel('Pre-CS poke #')
% % ylabel('CS pkg dur')
% % ylabel('Pre-CS pkg dur')
% ylabel('PkgDur Diff score')
% xlabel('Trials')
% 


% for f=1:4;
%     figure(f);
%     title(['PkNumElevScore Trial ' num2str(f)]);
%     saveas(f,['ExtnctnSRTrial' num2str(f) '_PkNumElevScore.fig']);
% end

% Various t-test comparisons follow (correct for the SessnsVrsTrials
% Experiment).

% [h,p,ci,stats]=ttest(SR3d(1,1:6),LastExt2Blck(1:6))
% h = 0
% p = 0.4775
% ci = -2.7412    5.0746
% stats = tstat: 0.7674
%        df: 5
%        sd: 3.7238

% [h,p,ci,stats]=ttest2(SR3d(1,1:6),SR3d(1,7:12))
% h = 0
% p = 0.7560
% ci = -2.9876    3.9876
% stats = tstat: 0.3194
%        df: 10
%        sd: 2.7111

% [h,p,ci,stats]=ttest2(SR3d(2,1:6),SR3d(2,7:12))
% h = 0
% p = 0.0652
% ci = -0.1643    4.4976
% stats = tstat: 2.0711
%        df: 10
%        sd: 1.8120

% [h,p,ci,stats]=ttest2(SR18d(1,1:6),SR18d(1,7:12))
% h = 0
% p = 0.0891
% ci = -6.9135    0.5802
% stats = tstat: -1.8831
%         df: 10
%         sd: 2.9126
% 
% [h,p,ci,stats]=ttest2(SR18d(2,1:6),SR18d(2,7:12))
% h = 0
% p = 0.5275
% ci = -2.2018    1.2018
% stats = tstat: -0.6547
%         df: 10
%         sd: 1.3229
% 
% [h,p,ci,stats]=ttest2(SR18d(4,1:6),SR18d(4,7:12))
% h = 0
% p = 0.2713
% ci = -3.8846    1.2180
% stats = tstat: -1.1644
%         df: 10
%         sd: 1.9833

%% Cumulative distributions of CRs during SR tests

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores
% CS_PkgDurSub PreCS_PkgDurSub PkgDurElevationScores

for m=1:12;
    SR3d(1:4,m)=Experiment.Subject(m).PkgDurElevationScores(end-7:end-4)';    
    SR18d(1:4,m)=Experiment.Subject(m).PkgDurElevationScores(end-3:end)';    
    for block =1:2;
        SR3d2trlblck(block,m)=mean(SR3d(2*block-1:2*block,m));
        SR18d2trlblck(block,m)=mean(SR18d(2*block-1:2*block,m));
    end
end

figure
orient tall

% Cumulative distributions of CRs

i = 1;

for trial = 1:4;
% Field = {SR3d2trlblck;SR18d2trlblck};
% 
% for f = 1:2;
%     
%     for block = 1:2;
        
        subplot(2,2,i)

        [XX,YY] = stairs(sort(SR3d(trial,1:6)),1:6);
%         [XX,YY] = stairs(sort(Field{f,1}(block,1:6)),1:6);
        XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
        plot(XX,YY,'Linewidth',2,'Color','b')
        hold on

        [XX,YY] = stairs(sort(SR3d(trial,7:12)),1:6);
%         [XX,YY] = stairs(sort(Field{f,1}(block,7:12)),1:6);
        XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
        plot(XX,YY,'Linewidth',2,'Color','r')

        ylim([0 7])
        ylabel('Number of subjects')
        xlabel('PkgDur Diff Score')
        title(['SR 3-days: Trial ' num2str(trial)])
%         if f==1;
%             title(['SR 3-d Cum. Distr.: 2-trial block ' num2str(block)])
%         else
%             title(['SR 18-d Cum. Distr.: 2-trial block ' num2str(block)])
%         end
        
        if i==4;
            legend('Many Sessions','Many Trials','Location','SouthEast')
        end
        
        i=i+1;
        
%     end

end

%% Trials to reach the extinction criterion

% I compared the 2 groups on the number of trials to reach the
% extinction criterion but did not find any differences.

for M=1:12;
        
    ExtinctionCriterion(M,1) = Experiment.Subject(M).Session(end-2).TrialCS.NumTrials-5;
    % The criterion was reached 5 trials before the extinction session
    % finished (remember that after 5 consecutive trials of no CS-pokes,
    % each subject received 5 additional trials before the session ended).
    
end

[h p ci stats] = ttest2(ExtinctionCriterion(1:6),ExtinctionCriterion(7:12))

% h = 0
% p = 0.9362
% ci = -13.0787   14.0787
% stats = tstat: 0.0820
%        df: 10
%        sd: 10.5554

%% Acquisition slope-plots

% Plotting the cumulative records of the elevation scores and running the
% change-point detection algorithm (cpRL). I have saved the slopes in the
% Experiment structure.

for M=1:12;
    
    clear Data

    if M>6
        Data(1:280,1)=Experiment.Subject(M).PreCS_PkNumSub(1:280);
        Data(1:280,2)=Experiment.Subject(M).CS_PkNumSub(1:280);
    else
        Data(1:70,1)=Experiment.Subject(M).PreCS_PkNumSub(1:70);
        Data(1:70,2)=Experiment.Subject(M).CS_PkNumSub(1:70);
    end

    [CP,Record]=ElevScoreCpRL(Data,100);
    
    Experiment.Subject(M).PkNumAcqCPCrt100 = CP;
    % These slopes have been saved in the Experiment structure.

end
        
for f=1:2:23;
    M=ceil(f/2);
    figure(f);
    title(['SessnsVrsTrials: M' num2str(M) ' PkNumElevScores']);
    saveas(f,['SessnsVrsTrials_AcqCP100_M' num2str(M) '_PkNumElevScore.fig']);
    figure(f+1);
    title(['SessnsVrsTrials: M' num2str(M) ' CurveFits']);
    saveas(f+1,['SessnsVrsTrials_AcqCP100_M' num2str(M) '_CurveFits.fig']);
end

% close all

cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessnsVrsTrials'
TSsaveexperiment('SessionsVersusTrials_3');
cd 'C:\Program Files\MATLAB\R2006b\Experiments'


%%  ------------ ACQUISITION PERFORMANCE --------------

% NOTE: 

Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = 100; % start of criterion loop
        
        for m = 1:length(Experiment.Subject);
            
            AsmptNote = 'For the Few Sessions group the asymptote is the mean performance during the last 2 sessions, while for the Manysessions group, it is during the last 20 trials.';
            
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.Notes = AsmptNote']);

            clear Data Slopes PstvSlpTrls %Steps StepDur StpPkng Deviation R P Correlation Probability
            
            if m<7;
                Data = eval(['Experiment.Subject(m).' Variable{f} 'ElevationScores(1:70)']);
                % Only include the acquisition data
            else
                Data = eval(['Experiment.Subject(m).' Variable{f} 'ElevationScores(1:280)']);
                % Only include the acquisition data
            end

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
                
                if m<7;
                    Asmpt = mean(Data(51:end));
                    % The level of the asymptote is the mean of the variable
                    % (PkNum or PkgDur) for the last 2 sessions (80 trials).
                else
                    Asmpt = mean(Data(201:end));
                    % The level of the asymptote is the mean of the variable
                    % (PkNum or PkgDur) for the last 2 sessions (20 trials).
                end

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
                
                if m<7;
                    Asmpt = mean(Data(51:end));
                    % The level of the asymptote is the mean of the variable
                    % (PkNum or PkgDur) for the last 20 trials.
                else
                    Asmpt = mean(Data(201:end));
                    % The level of the asymptote is the mean of the variable
                    % (PkNum or PkgDur) for the last 2 sessions (80 trials).
                end

                AsmptTrl = [];

                DynIntvl = AsmptTrl - OnsetLatency;
                
            end
            
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.RLAsymptote = Asmpt;']);
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.AsmptTrl_Skellam_Crt' num2str(Crt) '= AsmptTrl;']);
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.DynIntvl_Skellam_Crt' num2str(Crt) '= DynIntvl;']);
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.OnsetLatency_Skellam_Crt' num2str(Crt) '= OnsetLatency;']);

        end % of loop for a mouse
    
    end % of criterion loop
    
end % of variable loop

%% Extinction RL slope-plots 

% Plotting the cumulative records of the elevation scores and running the
% change-point detection algorithm (relative likelihood version)

for M = 1:12;
            
    ExtnctnTrlNum = Experiment.Subject(M).Session(end-2).TrialCS.NumTrials;
    
    clear Data CP Record
    
    Data(1:ExtnctnTrlNum,1)= Experiment.Subject(M).Session(end-2).CS_PkNumSes -...
                             Experiment.Subject(M).Session(end-2).PreCS_PkNumSes;

    [CP,Record]=ElevScoreCpRL_MLE_alpha(Data,100);
    
    Experiment.Subject(M).PkNumExtCPCrt100_MLE = CP;
    % These slopes have been saved in the Experiment structure.

%     Data(1:ExtnctnTrlNum,1)=Experiment.Subject(M).Session(end-2).PreCS_PkNumSes;
%     Data(1:ExtnctnTrlNum,2)=Experiment.Subject(M).Session(end-2).CS_PkNumSes;
%     
%     [CP,Record]=ElevScoreCpRL(Data,100);    
% 
%     Experiment.Subject(M).PkNumExtCPCrt100 = CP;
%     % These slopes have been saved in the Experiment structure.
        
end


for f=1:2:23;
    M=ceil(f/2);
    figure(f);
    title(['SessnsVrsTrials: M' num2str(M) ' Extinction PkNumElevScores']);
    saveas(f,['C:\Program Files\MATLAB\R2006b\Experiments\SessnsVrsTrials\Figures\CpRL_figures\SessnsVrsTrials_ExtCP100_M' num2str(M) '_PkNumElevScore.fig']);
    figure(f+1);
    title(['SessnsVrsTrials: M' num2str(M) ' Extinction CurveFits']);
    saveas(f+1,['C:\Program Files\MATLAB\R2006b\Experiments\SessnsVrsTrials\Figures\CpRL_figures\SessnsVrsTrials_ExtCP100_M' num2str(M) '_CurveFits.fig']);
end

% close all

cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessnsVrsTrials'
TSsaveexperiment('SessionsVersusTrials_4');
cd 'C:\Program Files\MATLAB\R2006b\Experiments'


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

% Did the following comparisons and found no differences.

Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = 100; % start of criterion loop
        
        for m =1:12;
            Floor(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.Floor;']);
            FirstDropLatency(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.FirstDropLatency_Skellam_Crt' num2str(Crt) ';']);
            ExtinctionTrial(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.ExtinctionTrial_Skellam_Crt' num2str(Crt) ';']);
            DynIntvl(m,1) = eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.DynIntvl_Skellam_Crt' num2str(Crt) ';']);
        end

    end % of criterion loope
    
end % of variable loop

% [h p ci stats] = ttest2(FirstDropLatency(1:6),FirstDropLatency(7:12))
% h = 0
% p = 1.00
% ci = -6.12          6.12
% stats = tstat: 0
%        df: 10.00
%        sd: 4.76
       
% [h p ci stats] = ttest2(Floor(1:6),Floor(7:12))
% h = 0
% p = 0.37
% ci = -0.30          0.73
% stats = tstat: 0.94
%        df: 10.00
%        sd: 0.40

% [h p ci stats] = ttest2(DynIntvl(1:6),DynIntvl(7:12))
% h = 0
% p = 0.91
% ci = -13.84         12.50
% stats = tstat: -0.11
%        df: 10.00
%        sd: 10.24
           
% [h p ci stats] = ttest2(ExtinctionTrial(1:6),ExtinctionTrial(7:12))
% h = 0
% p = 0.90
% ci = -12.23         10.90
% stats = tstat: -0.13
%        df: 10.00
%        sd: 8.99
       
%% Weibull fits to extinction curves

% This is the curve fitting section. I will call the NewExtnctnFit.m and
% save the exported parameters (F,I,L,S) in the structure.

clear LowerF UpperF F_start I_start L_start S_start 

global m LowerF UpperF F_start I_start L_start S_start

for m=1:12;
        
    if m==1 || m==7
        figure; orient tall;
    end

    clear X Y
    
    X = 1:Experiment.Subject(m).Session(end-2).TrialCS.NumTrials;
    
    if m<7;
        Y = Experiment.Subject(m).PkNumElevationScores(71:(70+length(X)));
    else
        Y = Experiment.Subject(m).PkNumElevationScores(281:(280+length(X)));
    end
    
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
% No differences whatsoever.

for m=1:12;
    Initial(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.I;
    Latency(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.L;
    Slope(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.S;
    Final(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.F;
end

% [h p ci stats] = ttest2(Initial(1:6),Initial(7:12))
% h = 0
% p = 0.4079
% ci = -4.9733   11.2718
% stats = tstat: 0.8639
%        df: 10
%        sd: 6.3141
       
% [h p ci stats] = ttest2(Latency(1:6),Latency(7:12))
% h = 0
% p = 0.4560
% ci = -6.0232    2.9127
% stats = tstat: -0.7756
%        df: 10
%        sd: 3.4732
       
% [h p ci stats] = ttest2(Slope(1:6),Slope(7:12))
% h = 0
% p = 0.1828
% ci = -5.1787   23.7847
% stats = tstat: 1.4313
%        df: 10
%        sd: 11.2574
       
% [h p ci stats] = ttest2(Final(1:6),Final(7:12))
% h = 0
% p = 0.5584
% ci = -0.3300    0.5762
% stats = tstat: 0.6054
%        df: 10
%        sd: 0.3522

%% Various analyses on extinction performance

for Crt = 100; % start of criterion loop

    figure
    orient tall
    sbplt = 1;


    for m = 1:length(Experiment.Subject);

        clear Slopes h

        Slopes = eval(['Experiment.Subject(m).PkNumExtCPCrt' num2str(Crt) '_MLE']);
        % Get the appropriate slopes as created by the algorithm and stored
        % in the structure.

        h = subplot(4,3,sbplt);

        stairs(Slopes(:,1),Slopes(:,4),'k','LineWidth',1.5)

        set(h,'LineWidth',1.5)
        
%         ylim([-5 9])
        
        set(h,'fontsize',14)
        
        sbplt = sbplt+1;
        
    end

end

% h = subplot(4,3,12);
% xlim([0 60])
h = subplot(4,3,11);
xlabel('Trials','fontsize',20)
h = subplot(4,3,7);
ylabel('Mean Elevation Score','fontsize',20')



%% Stimulus Comparison on Spontaneous Recovery using a Relative Likelihood Analysis
% This script compares the two groups on each test trial. When using the
% skellpdf, instead of me providing the two lambdas from the preCS and CS
% data, it uses MLE to get these values. Note that in order for MLE to work
% with my custom skellam distribution, I had to turn off the 'FunValCheck'.
% The latter option, indicates whether or not MLE should check the values
% returned by the custom distribution functions for validity. Default is
% 'on'. A poor choice of starting point can sometimes cause these functions
% to return NaNs, infinite values, or out of range values if they are
% written without suitable error-checking (like mine). The file of interest
% is located at: C:\Program
% Files\MATLAB\R2007b\toolbox\stats\private\mlecustom.m The specific line
% in the mlecustom.m code is: ln.22: checkFunVals =
% strcmp(userOpts.FunValCheck, 'off');

clear BF BFNoDiff
   
for m=1:12;    
    SR3d(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-7:end-4)';   
    SR18d(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-3:end)';    
end

GrpManySess = SR18d(:,1:6);
GrpManyTrls = SR18d(:,7:12);
    
for Trial = 1:4; % the two groups will be compared on every trial

    % Model 1 (aka No Difference) stipulates that there is no difference
    % between the two groups on the magnitude of spontaneous recovery.
    phat = mle([GrpManySess(Trial,:) GrpManyTrls(Trial,:)],'pdf',@skellpdf,'start',[1 1]);
    % phat contains the mles of the two lambdas (CS and pre-CS)
    phatM1 = phat
    LLModel1 = sum([log(skellpdf(GrpManySess(Trial,:),phat(1),phat(2))) ...
                    log(skellpdf(GrpManyTrls(Trial,:),phat(1),phat(2)))]);

    % Model 2 (aka SR) says that there is a difference between the two
    % stimuli.
    phatManySess = mle(GrpManySess(Trial,:),'pdf',@skellpdf,'start',[1 1]);
    phatManyTrls = mle(GrpManyTrls(Trial,:),'pdf',@skellpdf,'start',[1 1]);
    phatManySess
    phatManyTrls
    LLModel2 = sum([log(skellpdf(GrpManySess(Trial,:),phatManySess(1),phatManySess(2))) ...
                    log(skellpdf(GrpManyTrls(Trial,:),phatManyTrls(1),phatManyTrls(2)))]);

    LogOdds = LLModel2 - LLModel1 - 1/2*(4-2)*log(12);
    % OddsModel1 = exp[LLModel1 - LLModel2 - 1/2(d1 - d2)log(n)];

    BF(Trial) = exp(LogOdds); % Bayes Factor in favor of change model
    
    LogOddsNoDiff = LLModel1 - LLModel2 - 1/2*(2-4)*log(12);
    % OddsModel1 = exp[LLModel1 - LLModel2 - 1/2(d1 - d2)log(n)];

    BFNoDiff(Trial) = exp(LogOddsNoDiff); % Bayes Factor in favor of the no-change model

end

[BF; BFNoDiff]


%% Stimulus Comparison on Spontaneous Recovery using a Relative Likelihood Analysis
% This script does the same thing as the one in the immediately previous
% cell. However, it compares not the elevation scores but the CS-pokes.
% Thus, it uses the poisspdf, instead of the skellpdf. I did this because I
% realized that the BF can be big if the two parameters for each group are
% widely different, even if the mean elevation scores of the two groups are not
% that different.

clear BF BFNoDiff
   
for m=1:12;    
    SR3d(1:4,m)=Experiment.Subject(m).CS_PkNumSub(end-7:end-4)';   
    SR18d(1:4,m)=Experiment.Subject(m).CS_PkNumSub(end-3:end)';    
end

GrpManySess = SR18d(:,1:6);
GrpManyTrls = SR18d(:,7:12);
    
for Trial = 1:4; % the two groups will be compared on every trial

    % Model 1 (aka No Difference) stipulates that there is no difference
    % between the two groups on the magnitude of spontaneous recovery.
    phat = mle([GrpManySess(Trial,:) GrpManyTrls(Trial,:)],'distribution','poisson');
    % phat contains the mle of the lambda (CS poking rate)
    phatM1 = phat
    LLModel1 = sum([log(poisspdf(GrpManySess(Trial,:),phat)) ...
                    log(poisspdf(GrpManyTrls(Trial,:),phat))]);

    % Model 2 (aka SR) says that there is a difference between the two
    % stimuli.
    phatManySess = mle(GrpManySess(Trial,:),'distribution','poisson');
    phatManyTrls = mle(GrpManyTrls(Trial,:),'distribution','poisson');
    phatManySess
    phatManyTrls
    LLModel2 = sum([log(poisspdf(GrpManySess(Trial,:),phatManySess)) ...
                    log(poisspdf(GrpManyTrls(Trial,:),phatManyTrls))]);

    LogOdds = LLModel2 - LLModel1 - 1/2*(2-1)*log(12);
    % OddsModel1 = exp[LLModel1 - LLModel2 - 1/2(d1 - d2)log(n)];

    BF(Trial) = exp(LogOdds); % Bayes Factor in favor of change model
    
    LogOddsNoDiff = LLModel1 - LLModel2 - 1/2*(1-2)*log(12);
    % OddsModel1 = exp[LLModel1 - LLModel2 - 1/2(d1 - d2)log(n)];

    BFNoDiff(Trial) = exp(LogOddsNoDiff); % Bayes Factor in favor of the no-change model

end

[BF; BFNoDiff]
