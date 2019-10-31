% This scripts runs the basic analysis for everyday observation of the
% mice's behavior in the magazine approach paradigm. A white noise is
% followed by food 10 sec later (marked with a clicker). There is a 10-s
% pre-CS period for baseline levels of responding. The experiment was run
% in the new chambers.


TSinitexperiment('SessionNumberReplic2',4,[35 36 37 38 39 40 41 42 43 44 45 46],'Mouse','Gallistel')
% Creating structure
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
% cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication2'
% TSsaveexperiment('SessionNumberReplic2_0');
% cd 'C:\Program Files\MATLAB\R2006b'
% 
% 
% % TSloadexperiment('C:\Documents and Settings\Gallistellab\Desktop\Stathis\SessionNumberReplication2\SessionNumberReplic2_1');
% 
% TSloadsessions('C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication2\Data');
% % Loads data from a session into TSData subfield of Session subfield of Subject subfield
% 
% % TSimporteventcodes('matlabcodes.m')
% 
% cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication2'
% TSsaveexperiment('SessionNumberReplic2_3');
% cd 'C:\Program Files\MATLAB\R2006b'
% 
% % TSsaveexperiment('W:\Experiments\Stathis\Dissertation\SessionNumberReplication2\SessionNumberReplic2_1');
% % % save a copy on the server
    

%% -----------------------------RASTER PLOTS -------------------------

Events=[PokeOn2 PokeOff2; Feed2 0; PreCS 0; WNoiseOff 0];
% Defining events for raster plots.

% Making the plots
for M=1:6; %length(Experiment.Subject);
    for S= 20; %length(Experiment.Subject(M).Session);
        TSraster(Experiment.Subject(M).Session(S).TSData,[PreCS WNoiseOff],Events)
        title(['SessNumbrReplic2 Mouse ' num2str(M) ' Session ' num2str(S)])
    end
end

%%

% % All-session Raster Plots
% 
% Events=[PokeOn2 PokeOff2; WNoiseOn 0];
% % Defining events for raster plots.
% 
% for M=1:length(Experiment.Subject);
%     
%     AllSessData = [];
%     
%     for S=1:Experiment.Subject(M).NumSessions; %Only the acquisition sessions
%         
%         AllSessData = [AllSessData; Experiment.Subject(M).Session(S).TSData];
%         
%     end
%     
%     TSraster(AllSessData,[PreCS WNoiseOff],Events)
%     
%     hold on
%     
%     % Plot session boundaries
%     if M>6
%         for y=[40.5 80.5 120.5 160.5 200.5 240.5]
%             plot([0 21],[y y],'LineWidth',0.5,'Color',[0 0 0])
%         end
%         title(['Group Few: Mouse ' num2str(M) ' Acquisition'])
%     else
%         for y=[10.5 20.5 30.5 40.5 50.5 60.5 70.5 80.5 90.5 100.5 110.5 120.5 130.5...
%                140.5 150.5 160.5 170.5 180.5 190.5 200.5 210.5 220.5 230.5 240.5]
%             plot([0 21],[y y],'LineWidth',0.5,'Color',[0 0 0])
%         end
%         title(['Group Many: Mouse ' num2str(M) ' Acquisition'])
%     end
%     
% end

% %%
% % Exporting the figures in tif format
% f=1;
% for M=1:12;
%     figure(f)
%     saveas(f,['M' num2str(M) 'AllSessRaster.fig']);
%     f=f+1;
% end
% 


%%
% Main program for analyzing pokes

TSdefinetrial('ITI',{[StartITI EndITI]});

TSdefinetrial('PreCS',{[PreCS WNoiseOn]});

TSdefinetrial('CS',{[WNoiseOn WNoiseOff]});

% TrialType1='ITI';
% TrialType2='PreCS';
% TrialType3='CS';;
% 
% for i = 2:3;  % Cycle between the different trial types
%     
%     eval(['TSSettrial(TrialType' num2str(i) ')']);

%The active trial is now CS
TSsettrial('CS');

TStrialstat('PkDurs',@TSparse,'result = [time(2)-time(1)];',[WNoiseOn -PokeOn2 PokeOff2], [PokeOn2 PokeOff2] ,[PokeOn2 -PokeOff2 WNoiseOff]);
% PkDurs field contains individual head-in intervals that occurred during a trial 

TSlimit('Subjects',[1:6])

TSlimit('Sessions',[29]) %ignore the two context extinction sessions because the TSapplystat
% command cannot run on those since they contain no trials

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

TScombineover('CS_PkDursSub','CS_PkDursSes'); % Same vector as above, but now at
% the subject level, i.e., across sessions

TScombineover('CS_PkNumSub','CS_PkNumSes'); % Ditto

TScombineover('CS_PkgDurSub','CS_PkgDurSes'); % Ditto

%%
TSlimit('Subjects',[7:12])

TSlimit('Sessions',[1:7 10:11]) % ignore the two context extinction sessions because the TSapplystat
% command cannot run on those since they contain no trials

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

TScombineover('CS_PkDursSub','CS_PkDursSes'); % Same vector as above, but now at
% the subject level, i.e., across sessions

TScombineover('CS_PkNumSub','CS_PkNumSes'); % Ditto

TScombineover('CS_PkgDurSub','CS_PkgDurSes'); % Ditto


TSsettrial('PreCS') % Calculate all of the above measures for the 10-sec periods before the CS onset

TSlimit('Subjects',{ [0 -1] })

TSlimit('Sessions',{ [0 -1] })

TStrialstat('PkDurs',@TSparse,'result = [time(2)-time(1)];',[PreCS -PokeOn2 PokeOff2], [PokeOn2 PokeOff2] ,[PokeOn2 -PokeOff2 WNoiseOn]);
% PkDurs field contains individual head-in intervals that occurred during the preCS period 

TSlimit('Subjects',[1:6])

TSlimit('Sessions',[1:25 28]) %ignore the two context extinction sessions because the TSapplystat
% command cannot run on those since they contain no trials

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

TScombineover('PreCS_PkDursSub','PreCS_PkDursSes'); % Same vector as above, but now at
% the subject level, i.e., across sessions

TScombineover('PreCS_PkNumSub','PreCS_PkNumSes'); % Ditto

TScombineover('PreCS_PkgDurSub','PreCS_PkgDurSes'); % Ditto

TSlimit('Subjects',[7:12])

TSlimit('Sessions',[1:7 10:11]) % ignore the two context extinction sessions because the TSapplystat
% command cannot run on those since they contain no trials

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

cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication2'
TSsaveexperiment('SessionNumberReplic2_2');
cd 'C:\Program Files\MATLAB\R2006b'


%% Acquisition slope-plots 

% Plotting the cumulative records of the elevation scores and running the
% change-point detection algorithm (cpRL). I have saved the slopes in the
% Experiment structure.

for M = 1:12;
    
    clear Data
    
    Data(1:240,1)=Experiment.Subject(M).PreCS_PkNumSub(1:240);
    Data(1:240,2)=Experiment.Subject(M).CS_PkNumSub(1:240);
    
    [CP,Record]=ElevScoreCpRL(Data,100)

%     subplot(2,1,1);
%     title(['Mouse ' num2str(Experiment.Subject(m).Id) '. KS-test w/ Crt 4'])
%     ylabel('Cumulative Poke # Diff. Scores')
%     hold on
%     % Plot session boundaries
%     for x=[16 32 48 64 80 96 112 128]
%         plot([x x],[0
%         max(cumsum(Experiment.Subject(m).PkNumElevationScores))
%     end
%     
%     subplot(2,1,2);
%     ylabel('Poke # Diff. Scores')
%     hold on
    
    Experiment.Subject(M).AcqCPCrt100 = CP;
    % These slopes have been saved in the Experiment structure.
    
end

for f=1:2:5;
    M=ceil(f/2);
    figure(f);
    title(['SessNumReplic2: M' num2str(M) ' PkNumElevScores']);
    saveas(f,['SessNumReplic2_AcqCP100_M' num2str(M) '_PkNumElevScore.fig']);
    figure(f+1);
    title(['SessNumReplic2: M' num2str(M) ' CurveFits']);
    saveas(f+1,['SessNumReplic2_AcqCP100_M' num2str(M) '_CurveFits.fig']);
end

% for f=1:2:5;
%     M=floor((f+20)/2);
%     figure(f);
%     title(['SessNumReplic2: M' num2str(M) ' PkNumElevScores']);
%     saveas(f,['SessNumReplic2_AcqCP100_M' num2str(M) '_PkNumElevScore.fig']);
%     figure(f+1);
%     title(['SessNumReplic2: M' num2str(M) ' CurveFits']);
%     saveas(f+1,['SessNumReplic2_AcqCP100_M' num2str(M) '_CurveFits.fig']);
% end
% 
% % close all
% % 
cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication2'
TSsaveexperiment('SessionNumberReplic2_4');
cd 'C:\Program Files\MATLAB\R2006b\Experiments'
 

%%  ------------ ACQUISITION PERFORMANCE --------------

Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = 100; % start of criterion loop
        
        for m = 1:length(Experiment.Subject);
            
            AsmptNote = 'The asymptote is the mean performance during the last 80 trials.';
            
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.Notes = AsmptNote']);

            clear Data Slopes PstvSlpTrls %Steps StepDur StpPkng Deviation R P Correlation Probability

            Data = eval(['Experiment.Subject(m).' Variable{f} 'ElevationScores(1:240)']);
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
                
                Asmpt = mean(Data(161:end));
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
                
                Asmpt = mean(Data(161:end));
                % The level of the asymptote is the mean of the variable
                % (PkNum or PkgDur) for the last two sessions.

                AsmptTrl = [];

                DynIntvl = AsmptTrl - OnsetLatency;
                
            end
            
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.Asymptote = Asmpt;']);
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.AsmptTrl_Skellam_Crt' num2str(Crt) '= AsmptTrl;']);
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.DynIntvl_Skellam_Crt' num2str(Crt) '= DynIntvl;']);
            eval(['Experiment.Subject(m).Acquisition_CP.' Variable{f} 'ElevScr.OnsetLatency_Skellam_Crt' num2str(Crt) '= OnsetLatency;']);

        end % of loop for a mouse
    
    end % of criterion loop
    
end % of variable loop

%%  ---------- Group comparisons ----------

% Did the t-tests on the following variables and did not find a single
% positive result.

Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = 100; % start of criterion loop
        
        for i =1:12;
            Asymptote(i,1)= eval(['Experiment.Subject(' num2str(i) ').Acquisition_CP.PkNumElevScr.Asymptote']);
            AsmptTrl(i,1)= eval(['Experiment.Subject(' num2str(i) ').Acquisition_CP.PkNumElevScr.AsmptTrl_Skellam_Crt' num2str(Crt)]);
            DynIntvl(i,1)= eval(['Experiment.Subject(' num2str(i) ').Acquisition_CP.PkNumElevScr.DynIntvl_Skellam_Crt' num2str(Crt)]);
            OnsetLatency(i,1)= eval(['Experiment.Subject(' num2str(i) ').Acquisition_CP.PkNumElevScr.OnsetLatency_Skellam_Crt' num2str(Crt)]);
        end

    end % of criterion loope
    
end % of variable loop


%% Trials to reach the extinction criterion

% I compared the 2 groups on the number of trials to reach the
% extinction criterion but did not find any differences.

for M=1:12;
        
    ExtinctionCriterion(M,1) = Experiment.Subject(M).Session(end-4).TrialCS.NumTrials-5;
    % The criterion was reached 5 trials before the extinction session
    % finished (remember that after 5 consecutive trials of no CS-pokes,
    % each subject received 5 additional trials before the session ended).
    
end

[h p ci stats] = ttest2(ExtinctionCriterion(1:6),ExtinctionCriterion(7:12))

% h = 0
% p = 0.16
% ci = -14.36          2.69
% stats = tstat: -1.53
%         df: 10.00
%         sd: 6.62


%% Extinction and Spontaneous Recovery plots

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores
% CS_PkgDurSub PreCS_PkgDurSub PkgDurElevationScores

for m=1:12;
    TrialNumber(m) = length(Experiment.Subject(m).PkNumElevationScores)-8;
    %Number of total trials prior to the first test (that is, the number of
    %trials up to the end of extinction)
    FirstExt2Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(241:242));
    LastExt2Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(TrialNumber(m)-1:TrialNumber(m)));
    SR1wk(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-7:end-4)';
    SR3wk(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-3:end)';
end

% Mean CR during the first 2 extinction trials
GrpManyFrstExtBlckMean = mean(FirstExt2Blck(1:6));
GrpManyFrstExtBlckStError = std(FirstExt2Blck(1:6))/sqrt(6);
GrpFewFrstExtBlckMean = mean(FirstExt2Blck(7:12));
GrpFewFrstExtBlckStError = std(FirstExt2Blck(7:12))/sqrt(6);

% Mean CR during the last 2 extinction trials
GrpManyLastExtBlckMean = mean(LastExt2Blck(1:6));
GrpManyLastExtBlckStError = std(LastExt2Blck(1:6))/sqrt(6);
GrpFewLastExtBlckMean = mean(LastExt2Blck(7:12));
GrpFewLastExtBlckStError = std(LastExt2Blck(7:12))/sqrt(6);

% Mean CR during the first SR trial of 1 week test
GrpManySR1wkMean = mean(SR1wk(:,1:6),2);
GrpManySR1wkStError = std(SR1wk(:,1:6),0,2)/sqrt(6);
GrpFewSR1wkMean = mean(SR1wk(:,7:12),2);
GrpFewSR1wkStError = std(SR1wk(:,7:12),0,2)/sqrt(6);

% % Mean CR during the first SR trial of 3 week test
GrpManySR3wkMean = mean(SR3wk(:,1:6),2);
GrpManySR3wkStError = std(SR3wk(:,1:6),0,2)/sqrt(6);
GrpFewSR3wkMean = mean(SR3wk(:,7:12),2);
GrpFewSR3wkStError = std(SR3wk(:,7:12),0,2)/sqrt(6);


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

% Plotting lines
% Group Many Sessions
j(1) = plot(X(1:2),YMany(1:2),'-ok','LineWidth',1.25,'MarkerSize',8); hold on;
plot(X(3:6),YMany(3:6),'-ok','LineWidth',1.25,'MarkerSize',8); hold on
plot(X(7:10),YMany(7:10),'-ok','LineWidth',1.25,'MarkerSize',8); hold on

% Group Few Sessions
j(2) = plot(X(1:2),YFew(1:2),'--sk','LineWidth',1.25,'MarkerFaceColor','k','MarkerSize',8); hold on
plot(X(3:6),YFew(3:6),'--sk','LineWidth',1.25,'MarkerFaceColor','k','MarkerSize',8); hold on
plot(X(7:10),YFew(7:10),'--sk','LineWidth',1.25,'MarkerFaceColor','k','MarkerSize',8); hold on

% and errorbars
errorbar(X,YMany,SEMMany,'k','LineStyle','none','LineWidth',1.25); hold on
errorbar(X,YFew,SEMFew,'k','LineStyle','none','LineWidth',1.25); hold on

legend(j,{'Many Trial-Poor Sessions' 'Few Trial-Rich Sessions'},'fontsize',11)
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

ylim([-2 10])
xlim([0 14])

% xlabel({'     Extinction            SR 1 week             SR 3 weeks      '...
%         '    2-trial blocks                             Trials                           '});

xlabel({' Extinction                 SR 1 week                   SR 3 weeks '...
        '    2-trial blocks                                        Trials                                '});

% % Older plotting (works well)
% % Extinction lines
% figure
% orient tall
% % subplot(3,1,3)
% 
% plot([1 3],[GrpManyFrstExtBlckMean GrpManyLastExtBlckMean],'-ob') %'-ob'
% hold on
% plot([1 3],[GrpFewFrstExtBlckMean GrpFewLastExtBlckMean],'-sr') % '--sr'
% 
% %and error bars
% hold on; errorbar([1],GrpManyFrstExtBlckMean,GrpManyFrstExtBlckStError,'b')
% hold on; errorbar([3],GrpManyLastExtBlckMean,GrpManyLastExtBlckStError,'b')
% hold on; errorbar([1],GrpFewFrstExtBlckMean,GrpFewFrstExtBlckStError,'r')
% hold on; errorbar([3],GrpFewLastExtBlckMean,GrpFewLastExtBlckStError,'r')
% 
% hold on; plot([4 4],[-2 6],'k') % separating line
% 
% % SR-1wk line
% plot([5:8],GrpManySR1wkMean,'-ob')
% hold on; plot([5:8],GrpFewSR1wkMean,'-sr')
% %and error bars
% hold on; errorbar([5:8],GrpManySR1wkMean,GrpManySR1wkStError,'b')
% hold on; errorbar([5:8],GrpFewSR1wkMean,GrpFewSR1wkStError,'r')
% 
% hold on; plot([9 9],[-2 6],'k') % separating line
% 
% % SR-3wk line
% plot([10:13],GrpManySR3wkMean,'-ob')
% hold on; plot([10:13],GrpFewSR3wkMean,'-sr')
% %and error bars
% hold on; errorbar([10:13],GrpManySR3wkMean,GrpManySR3wkStError,'b')
% hold on; errorbar([10:13],GrpFewSR3wkMean,GrpFewSR3wkStError,'r')
% 
% legend('Many Sessions','Few Sessions')
% title('Session Number Replication 2')
% xlim([0 14])
% ylim([-2 8])
% set(gca,'XTick',[1 3:13])
% set(gca,'XTickLabel','First|Last| |1|2|3|4| |1|2|3|4','fontsize',12)
% % ylabel('CS poke #')
% % ylabel('Pre-CS poke #')
% ylabel('Elevation score')
% % ylabel('CS pkg dur')
% % ylabel('Pre-CS pkg dur')
% % ylabel('PkgDur Diff score')
% xlabel('Trials')



% for f=1:4;
%     figure(f);
%     title(['PkNumElevScore Trial ' num2str(f)]);
%     saveas(f,['ExtnctnSRTrial' num2str(f) '_PkNumElevScore.fig']);
% end

% Stats on 1st trial of 1-wk test
% [h,p,ci,stats]=ttest2(SR1wk(1,1:6),SR1wk(1,7:12))
% 
% h = 1
% p = 0.0134
% ci = 0.7261    4.9406
% stats =    tstat: 2.9959
%            df: 10
%            sd: 1.6381

% Stats on each trial of 3-wk test
% [h,p,ci,stats]=ttest2(SR3wk(1,1:6),SR3wk(1,7:12))
% h = 0
% p = 0.0825
% ci = -0.4908    6.8241
% stats = tstat: 1.9292
%         df: 10
%         sd: 2.8431
%         
% [h,p,ci,stats]=ttest2(SR3wk(2,1:6),SR3wk(2,7:12))
% h = 0
% p = 0.0715
% ci = -0.2640    5.2640
% stats = tstat: 2.0153
%         df: 10
%         sd: 2.1486
% 
% [h,p,ci,stats]=ttest2(SR3wk(3,1:6),SR3wk(3,7:12))
% h = 0
% p = 0.7342
% ci = -1.2301    0.8967
% stats = tstat: -0.3492
%         df: 10
%         sd: 0.8266
% 
% [h,p,ci,stats]=ttest2(SR3wk(4,1:6),SR3wk(4,7:12))
% h = 0
% p = 0.0826
% ci = -2.8735    0.2068
% stats = tstat: -1.9290
%         df: 10
%         sd: 1.1972


%% Extinction and Spontaneous Recovery plots for 2-trial blocks (correct cell)

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores
% CS_PkgDurSub PreCS_PkgDurSub PkgDurElevationScores

clear SR1wk1stBlck SR1wk2ndBlck SR3wk1stBlck SR3wk2ndBlck FirstExt2Blck LastExt2Blck

for m=1:12;
    TrialNumber = length(Experiment.Subject(m).PkNumElevationScores)-8;
    %Number of total trials prior to the first test (that is, the number of
    %trials up to the end of extinction)
    SR1wk1stBlck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(end-7:end-6));
    SR1wk2ndBlck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(end-5:end-4));
    SR3wk1stBlck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(end-3:end-2));
    SR3wk2ndBlck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(end-1:end));
    FirstExt2Blck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(241:242));
    LastExt2Blck(m,1)= mean(Experiment.Subject(m).PkNumElevationScores(TrialNumber-1:TrialNumber));
end


% Mean CR during the first 2 extinction trials
GrpManyFrstExtBlckMean = mean(FirstExt2Blck(1:6));
GrpManyFrstExtBlckStError = std(FirstExt2Blck(1:6))/sqrt(6);
GrpFewFrstExtBlckMean = mean(FirstExt2Blck(7:12));
GrpFewFrstExtBlckStError = std(FirstExt2Blck(7:12))/sqrt(6);

% Mean CR during the last 2 extinction trials
GrpManyLastExtBlckMean = mean(LastExt2Blck(1:6));
GrpManyLastExtBlckStError = std(LastExt2Blck(1:6))/sqrt(6);
GrpFewLastExtBlckMean = mean(LastExt2Blck(7:12));
GrpFewLastExtBlckStError = std(LastExt2Blck(7:12))/sqrt(6);

% Mean CR during the 1-week SR test
GrpManySR1wk1stBlckMean = mean(SR1wk1stBlck(1:6));
GrpManySR1wk1stBlckStError = std(SR1wk1stBlck(1:6))/sqrt(6);
GrpManySR1wk2ndBlckMean = mean(SR1wk2ndBlck(1:6));
GrpManySR1wk2ndBlckStError = std(SR1wk2ndBlck(1:6))/sqrt(6);

GrpFewSR1wk1stBlckMean = mean(SR1wk1stBlck(7:12));
GrpFewSR1wk1stBlckStError = std(SR1wk1stBlck(7:12))/sqrt(6);
GrpFewSR1wk2ndBlckMean = mean(SR1wk2ndBlck(7:12));
GrpFewSR1wk2ndBlckStError = std(SR1wk2ndBlck(7:12))/sqrt(6);

% Mean CR during the 3-week SR test
GrpManySR3wk1stBlckMean = mean(SR3wk1stBlck(1:6));
GrpManySR3wk1stBlckStError = std(SR3wk1stBlck(1:6))/sqrt(6);
GrpManySR3wk2ndBlckMean = mean(SR3wk2ndBlck(1:6));
GrpManySR3wk2ndBlckStError = std(SR3wk2ndBlck(1:6))/sqrt(6);

GrpFewSR3wk1stBlckMean = mean(SR3wk1stBlck(7:12));
GrpFewSR3wk1stBlckStError = std(SR3wk1stBlck(7:12))/sqrt(6);
GrpFewSR3wk2ndBlckMean = mean(SR3wk2ndBlck(7:12));
GrpFewSR3wk2ndBlckStError = std(SR3wk2ndBlck(7:12))/sqrt(6);


% [P,H] = signrank(LastExt2Blck(7:12),SR3wk1stBlck(7:12))

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


% and errorbars
errorbar(X,YMany,SEMMany,'k','LineStyle','none','LineWidth',LWidth);
errorbar(X,YFew,SEMFew,'k','LineStyle','none','LineWidth',LWidth);

legend(j,{'Many Trial-Poor Sessions' 'Few Daily Trial-Rich Sessions'},'fontsize',11)
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

for m=1:12;
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

for trial = 1:4;
% Field = {SR1wk2trlblck;SR3wk2trlblck};
% 
% for f = 1:2;
%     
%     for block = 1:2;
        
        subplot(2,2,i)

        [XX,YY] = stairs(sort(SR3wk(trial,1:6)),1:6);
%         [XX,YY] = stairs(sort(Field{f,1}(block,1:6)),1:6);
        XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
        plot(XX,YY,'Linewidth',2,'Color','b')
        hold on

        [XX,YY] = stairs(sort(SR3wk(trial,7:12)),1:6);
%         [XX,YY] = stairs(sort(Field{f,1}(block,7:12)),1:6);
        XX=[min(XX);XX]; YY=[0;YY]; % force the step line to start from 0 on the y-axis
        plot(XX,YY,'Linewidth',2,'Color','r')

        ylim([0 7])
        ylabel('Number of subjects')
        xlabel('PkgDur Diff Score')
        title(['SR 3-week: Trial ' num2str(trial)])
%         if f==1;
%             title(['SR 1-wk Cum. Distr.: 2-trial block ' num2str(block)])
%         else
%             title(['SR 3-wk Cum. Distr.: 2-trial block ' num2str(block)])
%         end
        
        if i==4;
            legend('Many Sessions','Few Sessions','Location','SouthEast')
        end
        
        i=i+1;
        
%     end

end

%% Extinction slope-plots 

% Plotting the cumulative records of the elevation scores and running the
% change-point detection algorithm

for M = 1:12;
    
    ExtnctnTrlNum = Experiment.Subject(M).Session(end-4).TrialCS.NumTrials;
    
    clear Data CP Record
    
    Data(1:ExtnctnTrlNum,1)=Experiment.Subject(M).PkNumElevationScores(241:(240+ExtnctnTrlNum));
    
    [CP,Record]=ElevScoreCpRL_MLE_alpha(Data,100);
    
    Experiment.Subject(M).PkNumExtCPCrt100_MLE = CP;
    % These slopes have been saved in the Experiment structure.

%     Data(1:ExtnctnTrlNum,1)=Experiment.Subject(M).Session(end-4).PreCS_PkNumSes;
%     Data(1:ExtnctnTrlNum,2)=Experiment.Subject(M).Session(end-4).CS_PkNumSes;
%     [CP,Record]=ElevScoreCpRL(Data,100);    
%     Experiment.Subject(M).PkNumExtCPCrt100 = CP;
%     % These slopes have been saved in the Experiment structure.
    
end

for f=1:2:23;
    M=ceil(f/2);
    figure(f);
    title(['SessNumReplic2: M' num2str(M) ' Extinction PkNumElevScores']);
    saveas(f,['SessNumReplic2_ExtCP100_M' num2str(M) '_PkNumElevScore.fig']);
    figure(f+1);
    title(['SessNumReplic2: M' num2str(M) ' Extinction CurveFits']);
    saveas(f+1,['SessNumReplic2_ExtCP100_M' num2str(M) '_CurveFits.fig']);
end

% close all

cd 'C:\Program Files\MATLAB\R2006b\Experiments\SessionNumberReplication2'
TSsaveexperiment('SessionNumberReplic2_5');
cd 'C:\Program Files\MATLAB\R2006b\Experiments'


%%   Algorithm on the Group-average Extinction Curve

% Just of curiosity, I want to see what the Group Average Extinction Data
% look like. Very abrupt, which is weird.

for M = 1:12;
    ExtnctnTrlNum(M,1) = Experiment.Subject(M).Session(end-4).TrialCS.NumTrials;    
    PreCSData(1:ExtnctnTrlNum(M),M)=Experiment.Subject(M).Session(end-4).PreCS_PkNumSes;
    CSData(1:ExtnctnTrlNum(M),M)=Experiment.Subject(M).Session(end-4).CS_PkNumSes;
end

MeanPreCSData(1:min(ExtnctnTrlNum),1) = mean(PreCSData(1:min(ExtnctnTrlNum),:),2);
MeanCSData(1:min(ExtnctnTrlNum),1) = mean(CSData(1:min(ExtnctnTrlNum),:),2);

clear Data CP Record

Data(1:min(ExtnctnTrlNum),1)=round(MeanPreCSData);
Data(1:min(ExtnctnTrlNum),2)=round(MeanCSData);

[CP,Record]=ElevScoreCpRL(Data,10);


%%  ------------ EXTINCTION PERFORMANCE --------------

Variable = {'PkNum' 'PkgDur'};

for f = 1; %1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = 100; % start of criterion loop
        
        for m = 1:length(Experiment.Subject);
            
            FloorCRNote = 'The floor CR is the mean performance during the last 10 trials.';
            
            eval(['Experiment.Subject(m).Extinction_CP.' Variable{f} 'ElevScr.Notes = FloorCRNote']);

            clear Data PreCSData CSData Slopes

            Data = eval(['Experiment.Subject(m).Session(end-4).CS_' Variable{f} 'Ses'...
                '- Experiment.Subject(m).Session(end-4).PreCS_' Variable{f} 'Ses']);
            % Only include the extinction data
            
            CSData = eval(['Experiment.Subject(m).Session(end-4).CS_' Variable{f} 'Ses']);
            
            PreCSData = eval(['Experiment.Subject(m).Session(end-4).PreCS_' Variable{f} 'Ses']);

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

% Did the following comparisons and did not find any differences.

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
% p = 0.41
% ci = -14.87          6.54
% stats = tstat: -0.87
%        df: 10.00
%        sd: 8.32
       
% [h p ci stats] = ttest2(Floor(1:6),Floor(7:12))
% h = 0
% p = 0.3663
% ci = -0.6709    0.2709
% stats = tstat: -0.9463
%         df: 10
%         sd: 0.3661

% [h p ci stats] = ttest2(ExtinctionTrial(1:6),ExtinctionTrial(7:12))
% h = 0
% p = 0.20
% ci = -31.30          7.30
% stats =tstat: -1.39
%        df: 10.00
%        sd: 15.01

% [h p ci stats] = ttest2(DynIntvl(1:6),DynIntvl(7:12))
% h = 0
% p = 0.34
% ci = -25.29          9.62
% stats = tstat: -1.00
%        df: 10.00
%        sd: 13.57


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
    
    X = 1:Experiment.Subject(m).Session(end-4).TrialCS.NumTrials;
    
    Y = Experiment.Subject(m).PkNumElevationScores(241:(240+length(X)));
    
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
% As you can see in the stats below, there were no differences.

for m=1:12;
    Initial(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.I;
    Latency(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.L;
    Slope(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.S;
    Final(m,1) = Experiment.Subject(m).ExtnctnWeibullFits.F;
end

% [h p ci stats] = ttest2(Initial(1:6),Initial(7:12))
% h = 0
% p = 0.7724
% ci = -5.9859    7.8285
% stats = tstat: 0.2972
%        df: 10
%        sd: 5.3693

% [h p ci stats] = ttest2(Latency(1:6),Latency(7:12))
% h = 0
% p = 0.7714
% ci = -2.1941    2.8731
% stats = tstat: 0.2986
%        df: 10
%        sd: 1.9695

% [h p ci stats] = ttest2(Slope(1:6),Slope(7:12))
% h = 0
% p = 0.2304
% ci = -5.4057   19.9219
% stats = tstat: 1.2770
%        df: 10
%        sd: 9.8443

% [h p ci stats] = ttest2(Final(1:6),Final(7:12))
% h = 0
% p = 0.3183
% ci = -0.6527    0.2345
% stats = tstat: -1.0504
%        df: 10
%        sd: 0.3448

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
        
        ylim([-5 9])
        
        set(h,'fontsize',14)
        
        sbplt = sbplt+1;
        
    end

end

h = subplot(4,3,12);
xlim([0 60])
h = subplot(4,3,11);
xlabel('Trials','fontsize',20)
h = subplot(4,3,7);
ylabel('Mean Elevation Score','fontsize',20')
