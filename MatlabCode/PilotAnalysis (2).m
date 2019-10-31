% % This scripts runs the basic analysis for everyday observation of the
% % mice's behavior in the magazine approach paradigm. A white noise is
% % followed by food 10 sec later (marked with a clicker). There is a 10-s
% % pre-CS period for baseline levels of responding. The experiment was run
% % in the old chambers.
% 
% 
% TSinitexperiment('SessionNumberReplic2',4,[35 36 37 38 39 40 41 42 43 44 45 46],'Mouse','Gallistel')
% % Creating structure
% 
% for S=1:10;
%     Experiment.Subject(S).Sex='M';
%     Experiment.Subject(S).Strain = 'C57BL/6';
% end
%     
% DOB = {'01/15/06' '03/31/06' '01/27/06' '02/11/06' '02/11/06' ...
%        '01/15/06' '02/11/06' '03/31/06' '01/27/06' '02/11/06'};
%     
% % for S=1:10;
% %     Experiment.Subject(S).Id = ID(S);
% %     Experiment.Subject(S).BirthDate = DOB{S};
% % end
% % 
%%
TSloadexperiment('/MATLAB/R2006b/Experiments/SessionNumber/SessionNumber_5');

TSloadsessions('/Applications/MATLAB7/Stathis/Experiments/SessionNumber/Latest data');
% Loads data from a session into TSData subfield of Session subfield of Subject subfield

TSsaveexperiment('/Applications/MATLAB7/Stathis/Experiments/SessionNumber/SessionNumber_1');

matlabcodes

%%

    
%%
%-----------------------------RASTER PLOTS -------------------------

Events=[PokeOn1 PokeOff1; PokeOn2 PokeOff2; PokeOn3 PokeOff3; PokeOn4 PokeOff4;Feed2 0; PreCS 0; WNoiseOff 0];
% Defining events for raster plots.

% Making the plots
for M=1:10;
    for S= length(Experiment.Subject(M).Session);
        TSraster(Experiment.Subject(M).Session(S).TSData,PreCS,WNoiseOff,Events)
        title(['Mouse ' num2str(M) ' Session ' num2str(S)])
    end
end

%%

% All-session Raster Plots

Events=[PokeOn2 PokeOff2];
% Defining events for raster plots.

for M=10;
    
    AllSessData = [];
    
    for S=1:Experiment.Subject(M).NumSessions-4; %Only the acquisition sessions
        
        AllSessData = [AllSessData; Experiment.Subject(M).Session(S).TSData];
        
    end
    
    TSraster(AllSessData,[PreCS WNoiseOff],Events)
    
    hold on
    
    % Plot session boundaries
    if M>5
        for y=[40.5 80.5 120.5 160.5 200.5] % 260.5 280.5 284.5 288.5]
            plot([0 21],[y y],'LineWidth',0.5,'Color',[0 0 0])
        end
        title(['Group Few: Mouse ' num2str(M) ' Acquisition'])
    else
        for y=[10.5 20.5 30.5 40.5 50.5 60.5 70.5 80.5 90.5 100.5 110.5 120.5 130.5...
               140.5 150.5 160.5 170.5 180.5 190.5 200.5 210.5 220.5 230.5 240.5] % 260.5 280.5 284.5 288.5]
            plot([0 21],[y y],'LineWidth',0.5,'Color',[0 0 0])
        end
        title(['Group Many: Mouse ' num2str(M) ' Acquisition'])
    end
    
end

%%
% Exporting the figures in tif format
f=1;
for M=1:12;
    figure(f)
    saveas(f,['M' num2str(M) 'AllSessRaster.fig']);
    f=f+1;
end



%%

    
% Main program for analyzing pokes

TSlimit('Subjects',1,5)

TSlimit('Sessions',28,Inf)


% TSdefinetrial('ITI',{[StartITI EndITI]});
% 
% TSdefinetrial('PreCS',{[PreCS WNoiseOn]});
% 
% TSdefinetrial('CS',{[WNoiseOn WNOiseOff]});

% TrialType1='ITI';
% TrialType2='PreCS';
% TrialType3='CS';;
% 
% for i = 2:3;  % Cycle between the different trial types
%     
%     eval(['TSSettrial(TrialType' num2str(i) ')']);

%The active trial is now CS
TSSettrial('CS');

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

TSlimit('Sessions',1,Inf);

TScombineover('CS_PkDursSub','CS_PkDursSes'); % Same vector as above, but now at
% the subject level, i.e., across sessions

TScombineover('CS_PkNumSub','CS_PkNumSes'); % Ditto

TScombineover('CS_PkgDurSub','CS_PkgDurSes'); % Ditto


TSSettrial('PreCS') % Calculate all of the above measures for the 10-sec periods before the CS onset

% TSsetoverwritemode(false)
TSlimit('Sessions',28,Inf)

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

% TSsetoverwritemode(true); % Update the subject-level vectors every time there is a new session
% TSnolimit;
TSlimit('Sessions',1,Inf);

TScombineover('PreCS_PkDursSub','PreCS_PkDursSes'); % Same vector as above, but now at
% the subject level, i.e., across sessions

TScombineover('PreCS_PkNumSub','PreCS_PkNumSes'); % Ditto

TScombineover('PreCS_PkgDurSub','PreCS_PkgDurSes'); % Ditto



TSsaveexperiment('/Applications/MATLAB7/Stathis/Experiments/SessionNumber/SessionNumber_2');

% TStrialstat('TrialData',@datatransfer);
%this trial stat loads data from each trial into the TrialData field of the
%Structure -- In order to use it, you must have the datatransfer function in
%your path.


% Calculate the difference (elevation) scores for the following two
% measures

for M=1:10;
    
    Experiment.Subject(M).PkNumElevationScores = Experiment.Subject(M).CS_PkNumSub - Experiment.Subject(M).PreCS_PkNumSub;

    Experiment.Subject(M).PkgDurElevationScores = Experiment.Subject(M).CS_PkgDurSub - Experiment.Subject(M).PreCS_PkgDurSub;
    
end

TSsaveexperiment('/Applications/MATLAB7/Stathis/Experiments/SessionNumber/SessionNumber_3');

%%

% Plotting the individual curves (hard to discern any curves)

figure
for M = 1:5;
    subplot(2,1,1)
    hold on
    plot(Experiment.Subject(M).PkNumElevationScores)
    subplot(2,1,2)
    hold on
    plot(Experiment.Subject(M).PkgDurElevationScores)
end

subplot(2,1,1)
xlabel('Trials')
ylabel('Poke # Diff Scores')
title('Group Many Sessions')

subplot(2,1,2)
xlabel('Trials')
ylabel('Poking Duration Diff Scores')
title('Group Many Sessions')

figure
for M = 6:10;
    subplot(2,1,1)
    hold on
    plot(Experiment.Subject(M).PkNumElevationScores)
    subplot(2,1,2)
    hold on
    plot(Experiment.Subject(M).PkgDurElevationScores)
end

subplot(2,1,1)
xlabel('Trials')
ylabel('Poke # Diff Scores')
title('Group Few Sessions')

subplot(2,1,2)
xlabel('Trials')
ylabel('Poking Duration Diff Scores')
title('Group Few Sessions')
    
    
% print

%% ------- Correct cell ---------


% Plotting the group-average elevation score curves.
% This time I will only consider the first half of each session for both
% groups.

for M = 1:10;
    
    PkNumElvtnScrs = [];

    HalfSessPkNumElvtnScrs = [];

    PkgDurElvtnScrs = [];

    HalfSessPkgDurElvtnScrs = [];

    HalfSessCS_PkNumSub = [];

    HalfSessPreCS_PkNumSub = [];

    IndPkNum5TrlBlcks = [];

    IndPkgDur5TrlBlcks = [];


    for Sess = 1:Experiment.Subject(M).NumSessions-4;
        
%         if (M==4)&(Sess==3); continue; end % Skip the 3rd session of Mouse 4, because it
%         % was sick and I didn't run it. Actually, I decided to take care
%         of these data later on. So, don't run this line.
        
        HalfSessPkNumElvtnScrs = [HalfSessPkNumElvtnScrs;...
        Experiment.Subject(M).Session(Sess).CS_PkNumSes(1:end/2) - ...
        Experiment.Subject(M).Session(Sess).PreCS_PkNumSes(1:end/2)];
    
        HalfSessPkgDurElvtnScrs = [HalfSessPkgDurElvtnScrs;...
        Experiment.Subject(M).Session(Sess).CS_PkgDurSes(1:end/2) - ...
        Experiment.Subject(M).Session(Sess).PreCS_PkgDurSes(1:end/2)];
    
        HalfSessCS_PkNumSub = [HalfSessCS_PkNumSub;...
        Experiment.Subject(M).Session(Sess).CS_PkNumSes(1:end/2)];
    
        HalfSessPreCS_PkNumSub = [HalfSessPreCS_PkNumSub;...
        Experiment.Subject(M).Session(Sess).PreCS_PkNumSes(1:end/2)];


    end
    
    Experiment.Subject(M).HalfSessPkNumElvtnScrs = HalfSessPkNumElvtnScrs;
    Experiment.Subject(M).HalfSessPkgDurElvtnScrs = HalfSessPkgDurElvtnScrs;

    Experiment.Subject(M).HalfSessCS_PkNumSub = HalfSessCS_PkNumSub;
    Experiment.Subject(M).HalfSessPreCS_PkNumSub = HalfSessPreCS_PkNumSub;
    
end
    

%%
for M=1:10;
    
%     PkNumElvtnScrs(1:length(Experiment.Subject(M).PkNumElevationScores),M) = Experiment.Subject(M).PkNumElevationScores;
%     % Create a matrix whose each column contains the Poke Number Difference
%     % Scores for each mouse.
%         
%     PkgDurElvtnScrs(1:length(Experiment.Subject(M).PkgDurElevationScores),M) = Experiment.Subject(M).PkgDurElevationScores;
%     % Ditto with the Poking Duration Difference Scores.


    PkNumElvtnScrs(1:160,M)=[Experiment.Subject(M).HalfSessPkNumElvtnScrs;...
    Experiment.Subject(M).PkNumElevationScores(241:280)]; % Add the extinction data

    PkgDurElvtnScrs(1:160,M)=[Experiment.Subject(M).HalfSessPkgDurElvtnScrs;...
    Experiment.Subject(M).PkgDurElevationScores(241:280)]; % Add the extinction data
    

    for i=1:(160/5); % For as many 5-trial blocks there are (before SR testing)
%     for i=1:(280/5); % For as many 5-trial blocks there are (before SR testing)
    
        IndPkNum5TrlBlcks(i,M) = mean(PkNumElvtnScrs(i*5-4:i*5,M));
        % Create a matrix whose each column contains the 5-trial block
        % averaged Poke Number Elevation Scores for each mouse.
        
        IndPkgDur5TrlBlcks(i,M) = mean(PkgDurElvtnScrs(i*5-4:i*5,M));
        % Ditto for the Poking Duration Elevation Scores.
        
    end
    
    PkNumElvtnScrs(161:168,M)=Experiment.Subject(M).PkNumElevationScores(281:288);
    % Add the data from the two SR tests
    PkgDurElvtnScrs(161:168,M)=Experiment.Subject(M).PkgDurElevationScores(281:288);
    % Ditto for the poking duration measure
    
end % of mouse loop
    
% The following variables contain the group average of each measure across
% subjects of a group on every single trial and 5-trial blocks.

ManySessPkNumElvtnScrGrpAve = mean(PkNumElvtnScrs(:,1:5),2);
% ManySessPkNumElvtnScrGrpAve(21:30) = ManySessPkNumElvtnScrGrpAve(21:30)*5/4;
ManySessPkNumElvtnScrGrpAve(11:15) = ManySessPkNumElvtnScrGrpAve(11:15)*5/4;
% Correct the 3rd session by excluding the sick mouse number 4.

ManySessPkgDurElvtnScrGrpAve = mean(PkgDurElvtnScrs(:,1:5),2);
% ManySessPkgDurElvtnScrGrpAve(21:30) = ManySessPkgDurElvtnScrGrpAve(21:30)*5/4;
ManySessPkgDurElvtnScrGrpAve(11:15) = ManySessPkgDurElvtnScrGrpAve(11:15)*5/4;
% Correct the 3rd session by excluding the sick mouse number 4.

FewSessPkNumElvtnScrGrpAve = mean(PkNumElvtnScrs(:,6:10),2);

FewSessPkgDurElvtnScrGrpAve = mean(PkgDurElvtnScrs(:,6:10),2);

ManySessGrpPkNum5TrlBlcks = mean(IndPkNum5TrlBlcks(:,1:5),2);
% ManySessGrpPkNum5TrlBlcks(5:6) = ManySessGrpPkNum5TrlBlcks(5:6)*5/4;
ManySessGrpPkNum5TrlBlcks(3) = ManySessGrpPkNum5TrlBlcks(3)*5/4;
% Correct the 3rd session by excluding the sick mouse number 4.

ManySessGrpPkgDur5TrlBlcks = mean(IndPkgDur5TrlBlcks(:,1:5),2);
% ManySessGrpPkgDur5TrlBlcks(5:6) = ManySessGrpPkgDur5TrlBlcks(5:6)*5/4;
ManySessGrpPkgDur5TrlBlcks(3) = ManySessGrpPkgDur5TrlBlcks(3)*5/4;
% Correct the 3rd session by excluding the sick mouse number 4.

FewSessGrpPkNum5TrlBlcks = mean(IndPkNum5TrlBlcks(:,6:10),2);
        
FewSessGrpPkgDur5TrlBlcks = mean(IndPkgDur5TrlBlcks(:,6:10),2);


%%  -------- Plot of the group average curves ---------
% Correct cell

% ManySessGrpPkNumData = [ManySessGrpPkNum5TrlBlcks;ManySessPkNumElvtnScrGrpAve(281:288)];
% FewSessGrpPkNumData = [FewSessGrpPkNum5TrlBlcks;FewSessPkNumElvtnScrGrpAve(281:288)];
ManySessGrpPkNumData = [ManySessGrpPkNum5TrlBlcks;ManySessPkNumElvtnScrGrpAve(161:168)];
FewSessGrpPkNumData = [FewSessGrpPkNum5TrlBlcks;FewSessPkNumElvtnScrGrpAve(161:168)];

figure
subplot(2,1,1)
plot(ManySessGrpPkNumData,'-')
hold on
plot(FewSessGrpPkNumData,'-r')
hold on
for x= [4.5 8.5 12.5 16.5 20.5 24.5 28.5 32.5 36.5 40.5] % Plotting session boundaries
% for x= [8.5 16.5 24.5 32.5 40.5 48.5 52.5 56.5 60.5 64.5] % Plotting session boundaries
    plot([x x],[-2 8],'Color',[0 0 0])
end
legend('Many Group','Few Group')
xlabel('5-trial Blocks and single SR trials')
ylabel('Poke Number Difference Scores')



% ManySessGrpPkgDurData = [ManySessGrpPkgDur5TrlBlcks;ManySessPkgDurElvtnScrGrpAve(281:288)];
% FewSessGrpPkgDurData = [FewSessGrpPkgDur5TrlBlcks;FewSessPkgDurElvtnScrGrpAve(281:288)];
ManySessGrpPkgDurData = [ManySessGrpPkgDur5TrlBlcks;ManySessPkgDurElvtnScrGrpAve(161:168)];
FewSessGrpPkgDurData = [FewSessGrpPkgDur5TrlBlcks;FewSessPkgDurElvtnScrGrpAve(161:168)];

subplot(2,1,2)
plot(ManySessGrpPkgDurData,'-')
hold on
plot(FewSessGrpPkgDurData,'-r')
hold on
for x= [4.5 8.5 12.5 16.5 20.5 24.5 28.5 32.5 36.5 40.5] % Plotting session boundaries
% for x= [8.5 16.5 24.5 32.5 40.5 48.5 52.5 56.5 60.5 64.5] % Plotting session boundaries
    plot([x x],[-4 4],'Color',[0 0 0])
end
legend('Many Group','Few Group')
xlabel('5-trial Blocks and single SR trials')
ylabel('Poking Duration Difference Scores')



%% --------- Spontaneous Recovery ---------

% Between-group comparisons

Test1PkgDur = [];
Test1PkNum = [];
Test2PkgDur = [];
Test2PkNum = [];

for M = 1:10;
    
    Test1PkgDur(1:4,M) = Experiment.Subject(M).PkgDurElevationScores(end-7:end-4);
    
    Test1PkNum(1:4,M) = Experiment.Subject(M).PkNumElevationScores(end-7:end-4);
    
    Test2PkgDur(1:4,M) = Experiment.Subject(M).PkgDurElevationScores(end-3:end);
    
    Test2PkNum(1:4,M) = Experiment.Subject(M).PkNumElevationScores(end-3:end);
    
end

% In the following lines the letters and numbers for each variable stand
% for the following:
% H : Hypothesis
% A : Variable A = PkgDur
% B : Variable B = PkNum
% 3rd # : 1 (SR test 1) or 2 (SR test 2)
% 4th # : Trial number

HA11 = TTEST2(Test1PkgDur(1,1:5),Test1PkgDur(1,6:10)) % 1st trial of Test 1
HA12 = TTEST2(Test1PkgDur(2,1:5),Test1PkgDur(2,6:10)) % 2nd trial
HA13 = TTEST2(Test1PkgDur(3,1:5),Test1PkgDur(3,6:10)) % 3rd trial
HA14 = TTEST2(Test1PkgDur(4,1:5),Test1PkgDur(4,6:10)) % 4th trial

HB11 = TTEST2(Test1PkNum(1,1:5),Test1PkNum(1,6:10)) % 1st trial of Test1
HB12 = TTEST2(Test1PkNum(2,1:5),Test1PkNum(2,6:10)) % 2nd trial
HB13 = TTEST2(Test1PkNum(3,1:5),Test1PkNum(3,6:10)) % 3rd trial
HB14 = TTEST2(Test1PkNum(4,1:5),Test1PkNum(4,6:10)) % 4th trial

HA21 = TTEST2(Test2PkgDur(1,1:5),Test2PkgDur(1,6:10)) % 1st trial of Test 2
HA22 = TTEST2(Test2PkgDur(2,1:5),Test2PkgDur(2,6:10)) % 2nd trial
HA23 = TTEST2(Test2PkgDur(3,1:5),Test2PkgDur(3,6:10)) % 3rd trial
HA24 = TTEST2(Test2PkgDur(4,1:5),Test2PkgDur(4,6:10)) % 4th trial

HB21 = TTEST2(Test2PkNum(1,1:5),Test2PkNum(1,6:10)) % 1st trial of Test 2
% This is statistically significant (p = .0025)
HB22 = TTEST2(Test2PkNum(2,1:5),Test2PkNum(2,6:10)) % 2nd trial
HB23 = TTEST2(Test2PkNum(3,1:5),Test2PkNum(3,6:10)) % 3rd trial
HB24 = TTEST2(Test2PkNum(4,1:5),Test2PkNum(4,6:10)) % 4th trial

%%

% I will employ the change point algorithm on the extinction (and
% acquisition) data. It seems that the KS-test with a criterion of 2 works
% fine, even though the overall distributions may not be normally
% distributed (however, it's the distribution before and after the CP that
% should be normally distributed). Note: although the code below runs
% analyses on the poking duration scores, I have already done the same
% analyses on the poke number scores.

for m=1:10;
    
    cp_wrapper(Experiment.Subject(m).HalfSessPkgDurElvtnScrs,1,2,6)
    
%     subplot(2,1,1);
%     title([' Half sessions. Mouse ' num2str(Experiment.Subject(m).Id) '. KS-test w/ Crt 2'])
%     ylabel('Cumulative Poke # Diff. Scores')
%     hold on
%     % Plot session boundaries
%     for x=[20 40 60 80 100 120 140 160 164 168]
%         plot([x x],[0 max(cumsum(Experiment.Subject(m).HalfSessPkNumElvtnScrs))])
%     end
%     
%     subplot(2,1,2);
%     ylabel('Poke # Diff. Scores')
%     hold on
%     % Plot session boundaries
%     for x=[20 40 60 80 100 120 140 160 164 168]
%         plot([x x],[-4 12],'LineWidth',0.5,'Color',[.6 0 0])
%     end

    Experiment.Subject(m).HalfSessAcquisitionSlopes.PkgDur_KStest_Crt6 = ans(3:2:end,:);
    % These slopes have been saved in the Experiment structure.
    
end

%%
% I will fit a weibull function on the extinction curves. I will call the
% NewExtnctnFit.m and save the exported parameters (F,I,L,S) in the
% structure.

% I have done curve fitting on the extinction Poke number and poking
% duration difference scores. (11/20/06)

global Experiment m

for m=1:10;
            
    [O1,Params]=NewExtnctnFit(1:40,Experiment.Subject(m).PkgDurElevationScores(241:280));
    
    Experiment.Subject(m).ExtinctionCurveFitParams.PkgDur_F=Params(1); % The final values (asymptote) seem to be correct.
    Experiment.Subject(m).ExtinctionCurveFitParams.PkgDur_I=Params(2);
    Experiment.Subject(m).ExtinctionCurveFitParams.PkgDur_L=Params(3);
    Experiment.Subject(m).ExtinctionCurveFitParams.PkgDur_S=Params(4);
%     print
%     figure % Printed figures and saved the above parameters in the stucture on 11/20/06.

end
%%
    
% I will run some between group comparisons on each of the above parameters
% using the t-test. I did that for both poke number and poking duration
% elevation scores and found no differences whatsoever.

for m = 1:10;
    Finals(m,1) = Experiment.Subject(m).ExtinctionCurveFitParams.PkgDur_F;
    Initials(m,1) = Experiment.Subject(m).ExtinctionCurveFitParams.PkgDur_I;
    Latency(m,1) = Experiment.Subject(m).ExtinctionCurveFitParams.PkgDur_L;
    Slopes(m,1) = Experiment.Subject(m).ExtinctionCurveFitParams.PkgDur_S;
end

H = TTEST2(Finals(1:5),Finals(6:10))
H = TTEST2(Initials(1:5),Initials(6:10))
H = TTEST2(Latency(1:5),Latency(6:10))
H = TTEST2(Slopes(1:5),Slopes(6:10))


%%  ------------ ACQUISITION PERFORMANCE --------------


% clear % Clear workspace of variables left over from earlier work

% TSloadexperiment('/Applications/MATLAB7/Stathis/Experiments/SessionNumber/SessionNumber_3')

Variable = {'PkNum' 'PkgDur'};

for f = 1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = [2 4 6]; % start of criterion loop
        
        for m = 1:length(Experiment.Subject);

            clear Data Slopes PstvSlpTrls AllData

            Data = eval(['Experiment.Subject(m).HalfSess' Variable{f} 'ElvtnScrs']);
            % Only include the acquisition data

% % Parenthetical plotting code
% AdditnlData = eval(['Experiment.Subject(m).' Variable{f} 'ElevationScores(241:288)']);
% 
% AllData = [Data; AdditnlData];
% 
% cp_wrapper(AllData,1,2,Crt)
% 
% subplot(2,1,1);
% title([' Half sessions. Mouse ' num2str(Experiment.Subject(m).Id) '. KS-test w/ Crt 2'])
% ylabel('Cumulative Poke # Diff. Scores')
% hold on
% % Plot session boundaries
% for x=[20 40 60 80 100 120 140 160 164 168]
%     plot([x x],[-20 max(cumsum(AllData))])
% end
% 
% subplot(2,1,2);
% ylabel('Poke # Diff. Scores')
% hold on
% % Plot session boundaries
% for x=[20 40 60 80 100 120 140 160 164 168]
%     plot([x x],[-4 12],'LineWidth',0.5,'Color',[.6 0 0])
% end
% % End of parenthesis

            Slopes = eval(['Experiment.Subject(m).HalfSessAcquisitionSlopes.' Variable{f} '_KStest_Crt' num2str(Crt)]);
            % Get the appropriate slopes as created by the algorithm and stored
            % in the structure.

            PstvSlpTrls = Slopes(find(Slopes(:,2)>0));
            % Finds the trials of the CPs that led to higher than
            % baseline performance (that is, positive slope).

            Asmpt = mean(Data(101:end));
            % The level of the asymptote is the mean of the variable
            % (PkNum or PkgDur) for the last 40 trials (basically, the
            % last two sessions).

            % Script for the hypothesis testing that the segment of the
            % record with this slope is significantly different than zero.
            
            if ~(isempty(PstvSlpTrls));

                i=1; OnsetLatency = []; % Initialize

                while isempty(OnsetLatency)
                    if i == length(PstvSlpTrls)
                        if ttest(Data(PstvSlpTrls(i)+1 : end),0) == 1;
                            OnsetLatency = PstvSlpTrls(i);
                        else
                            OnsetLatency = 0; % No supra-baseline performance
                        end
                    else
                        if ttest(Data(PstvSlpTrls(i)+1 : Slopes(min(find(Slopes(:,1)>PstvSlpTrls(i))),1)),0) == 1;
                            OnsetLatency = PstvSlpTrls(i);
                        else OnsetLatency = []; % No supra-baseline performance
                            i = i+1;
                        end                
                    end
                end % of while loop
                
    %         TrlOfFrstUpwrdIP = Slopes(min(find(Slopes(:,2)>Slopes(1,2))),1);
    %         % Finds the trial of the first upward IP.

                AsmptTrl = Slopes(min(find(Slopes(:,2) >= 0.8*Asmpt)),1);
                % Finds the trial of the CP after which the average
                % CR measure was 80% or more of the asymptote.

                if isempty(AsmptTrl); % If none of the steps reaches 80% of the asymptote (e.g., Mouse 11, PkNum Crt4),
                    % assign a zero value to that measure.
                    AsmptTrl = 0;
                end

                DynIntvl = AsmptTrl - OnsetLatency;
                
            else % There are cases like Mouse 11, PkgDur, Crt4, in which there is no acquisition
                % according to the CP algorithm (no positive steps). In
                % this case, assign zero values to all the measures.
                
                OnsetLatency = 0;
                
                AsmptTrl = 0;
                % Finds the trial of the CP after which the average
                % CR measure was 80% or more of the asymptote.

                DynIntvl = AsmptTrl - OnsetLatency;
                
            end
                
            
            eval(['Experiment.Subject(m).HalfSessAcquisition_CP.' Variable{f} '.Asymptote = Asmpt;']);
            eval(['Experiment.Subject(m).HalfSessAcquisition_CP.' Variable{f} '.AsmptTrl_KS_Crt' num2str(Crt) '= AsmptTrl;']);
            eval(['Experiment.Subject(m).HalfSessAcquisition_CP.' Variable{f} '.DynIntvl_KS_Crt' num2str(Crt) '= DynIntvl;']);
            eval(['Experiment.Subject(m).HalfSessAcquisition_CP.' Variable{f} '.OnsetLatency_KS_Crt' num2str(Crt) '= OnsetLatency;']);

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

%%  ---------- Group comparisons ----------

% Did the following t-test comparisons and did not find a single positive
% result.

Variable = {'PkNum' 'PkgDur'};

for f = 1:length(Variable) % start of variable (CR measure) loop
    
    for Crt = [2]; % start of criterion loop
        
        for m = 1:length(Experiment.Subject);

            eval(['Asymptote(m,1) = Experiment.Subject(m).HalfSessAcquisition_CP.' Variable{f} '.Asymptote;']);
            eval(['AsmptTrl(m,1) = Experiment.Subject(m).HalfSessAcquisition_CP.' Variable{f} '.AsmptTrl_KS_Crt' num2str(Crt) ';']);
            eval(['DynIntvl(m,1) = Experiment.Subject(m).HalfSessAcquisition_CP.' Variable{f} '.DynIntvl_KS_Crt' num2str(Crt) ';']);
            eval(['OnsetLat(m,1) = Experiment.Subject(m).HalfSessAcquisition_CP.' Variable{f} '.OnsetLatency_KS_Crt' num2str(Crt) ';']);
            
        end

        H = TTEST2(Asymptote(1:5),Asymptote(6:10))
        H = TTEST2(AsmptTrl(1:5),AsmptTrl(6:10))
        H = TTEST2(DynIntvl(1:5),DynIntvl(6:10))
        H = TTEST2(OnsetLat(1:5),OnsetLat(6:10))
        
    end
    
end

% Results: There are no significant differences whatsoever.


%% Extinction and Spontaneous Recovery plots

% CS_PkNumSub PreCS_PkNumSub PkNumElevationScores

for m=1:10;
    
    TrialNumber(m) = 280;
    %Number of total trials prior to the first test (that is, the number of
    %trials up to the end of extinction)

    FirstExt3Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(241:242));

    LastExt3Blck(m)=mean(Experiment.Subject(m).PkNumElevationScores(TrialNumber(m)-1:TrialNumber(m)));

    SR1d(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-7:end-4)';
    
    SR1wk(1:4,m)=Experiment.Subject(m).PkNumElevationScores(end-3:end)';
    
end

    
% Mean CR during the first 2 extinction trials
GrpManyFrstExtBlckMean = mean(FirstExt3Blck(1:5));
GrpManyFrstExtBlckStError = std(FirstExt3Blck(1:5))/sqrt(5);
GrpFewFrstExtBlckMean = mean(FirstExt3Blck(6:10));
GrpFewFrstExtBlckStError = std(FirstExt3Blck(6:10))/sqrt(5);

% Mean CR during the last 2 extinction trials
GrpManyLastExtBlckMean = mean(LastExt3Blck(1:5));
GrpManyLastExtBlckStError = std(LastExt3Blck(1:5))/sqrt(5);
GrpFewLastExtBlckMean = mean(LastExt3Blck(6:10));
GrpFewLastExtBlckStError = std(LastExt3Blck(6:10))/sqrt(5);

% Mean CR during the SR 1 day test
GrpManySR1dMean = mean(SR1d(:,1:5),2);
GrpManySR1dStError = std(SR1d(:,1:5),0,2)/sqrt(5);
GrpFewSR1dMean = mean(SR1d(:,6:10),2);
GrpFewSR1dStError = std(SR1d(:,6:10),0,2)/sqrt(5);

% % Mean CR during the SR 1 week test
GrpManySR1wkMean = mean(SR1wk(:,1:5),2);
GrpManySR1wkStError = std(SR1wk(:,1:5),0,2)/sqrt(5);
GrpFewSR1wkMean = mean(SR1wk(:,6:10),2);
GrpFewSR1wkStError = std(SR1wk(:,6:10),0,2)/sqrt(5);


% Plotting works well
% Extinction lines
figure
plot([1 3],[GrpManyFrstExtBlckMean GrpManyLastExtBlckMean],'-ob') %'-ob'
hold on
plot([1 3],[GrpFewFrstExtBlckMean GrpFewLastExtBlckMean],'-sr') % '--sr'

%and error bars
hold on; errorbar([1],GrpManyFrstExtBlckMean,GrpManyFrstExtBlckStError,'b')
hold on; errorbar([3],GrpManyLastExtBlckMean,GrpManyLastExtBlckStError,'b')
hold on; errorbar([1],GrpFewFrstExtBlckMean,GrpFewFrstExtBlckStError,'r')
hold on; errorbar([3],GrpFewLastExtBlckMean,GrpFewLastExtBlckStError,'r')

hold on; plot([4 4],[-2 6],'k') % separating line

% SR-1d line
plot([5:8],GrpManySR1dMean,'-ob')
hold on; plot([5:8],GrpFewSR1dMean,'-sr')
%and error bars
hold on; errorbar([5:8],GrpManySR1dMean,GrpManySR1dStError,'b')
hold on; errorbar([5:8],GrpFewSR1dMean,GrpFewSR1dStError,'r')

hold on; plot([9 9],[-2 6],'k') % separating line

% SR-1wk line
plot([10:13],GrpManySR1wkMean,'-ob')
hold on; plot([10:13],GrpFewSR1wkMean,'-sr')
%and error bars
hold on; errorbar([10:13],GrpManySR1wkMean,GrpManySR1wkStError,'b')
hold on; errorbar([10:13],GrpFewSR1wkMean,GrpFewSR1wkStError,'r')

legend('Many Sessions','Few Sessions')
title('Session Number Original')
xlim([0 14])
ylim([-2 8])
set(gca,'XTick',[1 3:13])
set(gca,'XTickLabel','First|Last| |1|2|3|4| |1|2|3|4','fontsize',12)
% ylabel('CS poke #')
% ylabel('Pre-CS poke #')
ylabel('Elevation score')
xlabel('Trials')


%%   ------- UNUSED OR USELESS CODE -------




% Calculate the ITI duration
for M= 6:10;
    
    for i=1:Experiment.Subject(M).Session(10).TrialPreCS.NumTrials-1;
        
        ITI(i,M) = Experiment.Subject(M).Session(10).TrialPreCS.Trial(i+1).StartTime - Experiment.Subject(M).Session(10).TrialCS.Trial(i).EndTime - 5;
        
    end
    
end
%%

% Plotting the cumulative records of the elevation scores and running the
% change-point detection algorithm

for M = 6:10;
    
    global SesLength Subject
    
%     SesLength = [40 80 120 160 200 240 260 280 284 288]; % For the massed
%     group

    SesLength = [10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 260 280 284 288]; % For the massed
%     group
    
    Subject = Experiment.Subject(M).Id;
    
    cp_wrapper(Experiment.Subject(M).PkNumElevationScores,1,3,2)

%     figure
%     subplot(2,1,1)
%     plot(cumsum(Experiment.Subject(M).PkNumElevationScores));
%     subplot(2,1,2)
%     plot(cumsum(Experiment.Subject(M).PkgDurElevationScores));
    
end

%%

% -------- EXTINCTION --------
% Cell has not been adjusted for this experiment (taken from the session
% spacing experiment).

% Let's take a look at the cumulative records of poke-number difference
% scores from extinction.

subplot(2,1,1)

for m=1:6;
    
    stairs(cumsum(Experiment.Subject(m).PkNumElevationScores(129:160)))
    % Only include the extinction trials
    
    hold on
    
end

xlabel('Extinction Trials')
ylabel('Cum Poke Number Elevation Scores')
title('1/4d group')



subplot(2,1,2)

for m=7:12;
    
    stairs(cumsum(Experiment.Subject(m).PkNumElevationScores(129:160)))
    % Only include the extinction trials
    
    hold on
    
end

xlabel('Extinction Trials')
ylabel('Cum Poke Number Elevation Scores')
title('1/d group')

%%

