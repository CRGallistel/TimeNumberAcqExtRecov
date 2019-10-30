function [Weight,OddsAgainst,OddsFor,NlPrior,AltPrior,LkhdE] = BF2(C,E,AL,varargin)
% Computes the weight of the evidence and the odds against and for the null
% hypothesis that the E (experimental) data were drawn from a distribution
% with the same mean as the C (control), assuming that both distributions
% are normal with the same variance, and given the maximum possible
% deviations from equality specied by the I vector (the increment prior).
%
% Syntax:
% [Weight,OddsAgainst,OddsFor,NlPrior,AltPrior,LkhdE] = BF2(C,E,AL,I,NoFig)
%
% C,E & AL are obligatory arguments; I and NoFig are optional.
%
% The C vector contains the control data; the E vector the experimental
% data. If the distinction cannot be made, either argument may be assigned
% to either data vector
%
% AL specifies analytic limits on possible values of the mean, limits
% outside which the contrasting priors cannot go because a mean outside
% those limits is analytically impossible (for example, [0 inf] or [.5 1]
% or [-1 1] or [-inf 0]
%
% The first value in I, the increment prior, specifies the maximum possible
% deviation of the E mean from the C mean in the negative (left) direction;
% the 2nd value specifies the maximum possible deviation in the positive
% (right) direction.
%
% Examples:
%    [0 50] specifies the "one-tailed" hypothesis that the mean of
%       the E data lies somewhere between true-mean(C) and true-mean(C)+50
%    [-50 0] specifies the other tail
%    [-50 50] specifies the two-tailed hypothesis that the mean of the E
%       data lies somewhere within the interval true-mean(C)+/-50
%    [50 100] specifies the hypothesis that the mean of the E data lies
%       somewhere in the interval btwn +50 and +100 above the true mean of
%       the C data
% The default values for I (when it is not specified in the call) are the
% lowest-datum - mean(C) and highest-datum - mean(C). 
%
% If NoFig = 1 (or true), the figure is suppressed. To suppress the figure w/o
% specifying an increment prior (the 4th argument, I), enter NaN
% as the 4th argument and then 1 as the 5th argument
%
% The figure plots the null prior
% and the alternate prior against the left (probability density) axis and
% the likelihood function for the experimental data against the right
% (likelihood) axis. The function makes graphically apparent the basis for
% the BF, which is how much probability the contrasting priors place
% underneath the likelihood function
%
% Weight is the weight of the evidence, that is, the log base 10 of the
% Bayes Factor. OddsAgainst is the Bayes Factor (odds) for the comparison
% nonnull-vs-null; OddsFor is the inverse, that is, the Bayes Factor (odds)
% for the comparison null-vs-nonnull hypothesis.
%
% In cases where the design or logic does not make a distinction between a
% control and an experimental sample, either sample may be assigned to
% either of the first two input arguments. In such cases, the 4th
% argument, the increment prior, must be symmetrical about 0, e.g. [-100
% 100], because, since which group is which is arbitrary, the direction of
% any effect must also be arbitrary. The results will be the same
% regardless of assignment, up to small errors arising from the granularity
% of the numerical integration
%
% Example 1
%
% ConData = [213.1500  215.4500  147.6500  212.6000  170.8500  219.6500 ...
% 133.8500  130.4500]';
%
% ExperData = [86.5500  259.6500  167.3000  193.9000  266.4000  186.8500...
% 166.4500  157.1000   175.0000  197.8500];
%
% [Weight,OddsAgainst,OddsFor]=BF2(ConData,ExperData,[0 Inf],[-150 0],0)
%
% Weight = -0.8209
% 
% OddsAgainst = 0.1510
% 
% OddsFor = 6.6209
%
% The 4th argument in this example, [-150 0], says that the mean of the
% experimental data may be smaller than the mean of the control data by as
% much as 150 but cannot be bigger than the mean of the control data. With
% these data and this alternative prior, the odds favor the null by 6.6 to
% 1 (rounded to the first decimal place)
%
% If the priors are included in the requested outputs (NlPrior,AltPrior),
% they are returned as 2-column arrays, with the x values in the first
% column and the probability densities in the 2nd column. Likewise if the
% likelihood function of the experimental data is requested (LkhdE)

% Copyright, June 3, 2008 by Charles R Gallistel. All rights reserved.
% Anyone may use this for any non-commercial purpose. It may not
% be used in any product that is marketed, except with the written
% permission of the author.

Weight = [];

OddsAgainst = [];

OddsFor =[];

NlPrior = [];

AltPrior = [];

LkhdE = [];

C = reshape(C,length(C),1); % makes C a column vector

E = reshape(E,length(E),1);

MnC = mean(C);

if nargin < 3
    
    disp(char({'',...
        'Input error:',...
        'Not enough arguments. Required arguments are C,E and AL.',...
    'AL is the vector specifying the analytic limits on possible data.',...
    'For example, AL=[0 inf], if the data are counts or durations',...
    'or AL=[0 1] if they are proportions.'}))
    
    return
    
elseif (length(AL) ~= 2)||(AL(1)>=AL(2)) % checking for proper analytic limits
    
    disp(char({'',...
        'Input error:',...
        'Vector specifying analytic limits must have only 2 values;',...
        'with AL(1) < AL(2)'}))
    
    return
    
elseif nargin<4 % if there are only 3 arguments, set default increment prior
    
    I(1) = min([C;E]) - MnC; 
    
    I(2) = max([C;E]) - MnC;
    
    NoFig = 0;
    
elseif isnan(varargin{1})
    
    I(1) = min([C;E]) - MnC; 
    
    I(2) = max([C;E]) - MnC;
    
    NoFig = varargin{2};
    
elseif (length(varargin{1}) ~= 2)||(varargin{1}(1)>varargin{1}(2))
    % improper increment prior
    
    disp(char({'',...
        'Input error:',...
        'Improper vector for increment prior;',...
        'I vector must be length 2, with I(1)<I(2)'}))
    
    return
    
elseif length(varargin)<2
    
    I = varargin{1};
    
    NoFig = 0;
    
else
    
    I = varargin{1};
    
    NoFig = varargin{2};
    
end

if ~((NoFig==1)|(NoFig==0))
    
    disp('Input error: NoFig improperly specified; must 0 or 1')
    
    return
    
end

if length(varargin)==3 % axis for plot
    ax = true;
else
    ax = false;
end
    
%%
MnE = mean(E);

StdC = std(C);

StdE = std(E);

NC = length(C);

NE = length(E);

Std = (NC*StdC+NE*StdE)/(NC+NE); % estimated standard deviation of the
% source dist

% setting limits of x values so as to encompass the (effectively) nonzero
% ranges of the likelihood functions (next 3 lines)
Limits=[MnC-4*Std/sqrt(NC) MnC+4*Std/sqrt(NC) MnE-4*Std/sqrt(NE) MnE+4*Std/sqrt(NE)];

LLLk = min(Limits);

ULLk = max(Limits);

if LLLk < AL(1); LLLk = AL(1); end % x values should not extend below the
% analytically allowable value

if ULLk > AL(2); ULLk = AL(2); end % x values should not extend above the
% analytically allowable limit

x = linspace(LLLk,ULLk,200); % 200 equally spaced points covering the range

xDelta = x(2)-x(1); % the x increment

for d = 1:length(C) % stepping through control data
    
    LgLkC(d,:) = log10(normpdf(C(d),x,Std)); % log likelihood of the control
    % datum for each of the values in the x vector (each of the possible
    % values of the mean of the sampling distribution)
    
end

LgLkFunC = sum(LgLkC); % log likelihood function for the C data

OffSetC = round(max(LgLkFunC)); % Added 5-22-09

LgLkFunC = LgLkFunC - OffSetC; % Added 5-22-09

LkFunC = 10.^LgLkFunC; % Likelihood function for the mean of the C data

% MargLk = trapz(LkFunC); % Integral of LkFunC assuming unit increments on
% the x axis. (The true integral is xDelta times this "integral".)

NullPrior = LkFunC/sum(LkFunC); % normalizing to obtain null prior

% disp(['Max of NullPrior = ' num2str(max(NullPrior)/xDelta)])

for d = 1:length(E) % stepping through the experimental data
    
    LgLkE(d,:) = log10(normpdf(E(d),x,Std)); % likelihood of the E
    % datum for each of the values in the x vector (each of the possible
    % values of the mean of the sampling distribution)
    
end

LgLkFunE = sum(LgLkE); % log likelihood function for the E data

LkFunElimits = [x(find(LgLkFunE>(max(LgLkFunE)-3),1)) ...
    x(find(LgLkFunE>(max(LgLkFunE)-3),1,'last'))]; % points on x axis at
% which likelihood function for E data rises above (1) and falls below (2)
% its maximum by a factor of a 1000

OffSetE = round(max(LgLkFunE)); % Added 5-22-09

LgLkFunE = LgLkFunE - OffSetE;  % Added 5-22-09

LkFunE = 10.^LgLkFunE; % Likelihood function for the E data

PostLkNull = LkFunE*NullPrior'; % posterior likelihood of the E data given the
% null prior. (This is the dot product (in the linear algebra sense) of a
% row vector and a column vector, which is the sum of their
% element-by-element products.)

if MnC/xDelta > 0
    
    NumOffsetSteps = round(-MnC/xDelta); % number of steps by which NullPrior
    % must be offset to put it near 0. The
    % increment prior will usually encompass 0, whereas the NullPrior may
    % reside far from 0. If it does reside far from 0, then the
    % convolution will become unnecessarily large
    
elseif MnC/xDelta < 0
        
    NumOffsetSteps = round(MnC/xDelta); % number of steps by which NullPrior
    % must be offset to put it near 0. The
    % increment prior will generally encompass 0, whereas the NullPrior may
    % reside far from 0. If it does reside far from 0, then the
    % convolution will become unnecessarily large
    
end

xOffset = x + NumOffsetSteps*xDelta; % This moves mode of NullPrior close
% to 0 (to within the roundoff to the nearest x value)

Under = xOffset(1) - I(1); % difference between lowest xOffset value and
% low end of increment. If this is positive, then we need to extend the
% range of x values in the negative direction far enough to encompass
% the increment

Over = I(2) - xOffset(end); % difference between high end of increment
% and high end of xOffset. If this difference is positive, we need to
% extend x values in positive direction to encompass the increment
   
if Under > 0 % if the lower limit of the increment prior is less
    % than the lowest of the offset x values over which the likelihood
    % functions have been computed
    
    LeftSteps = (xOffset(1)-xDelta):-xDelta:(floor(-Under/xDelta)*xDelta+xOffset(1));
    
    xOffset = [fliplr(LeftSteps) xOffset];% left augmented range of xOffset values   
    
end % of augmenting xOffset at negative end

if Over > 0 % if the highest xOffset value is less than the positive limit
    % of the increment prior
    
    RightSteps = (xOffset(end)+xDelta):xDelta:(ceil(Over/xDelta)*xDelta+xOffset(end));
    
    xOffset = [xOffset RightSteps];% right augmented range of xOffset values
       
end

IncPrior = unifpdf(xOffset,I(1),I(2)); % increment prior defined over the
% (possibly) augmented range of xOffset values

IncPrior = IncPrior/sum(IncPrior); % normalizing

ConvArray(:,1) = xOffset'; % x values for the convolution of the null prior
% and the increment prior

if exist('LeftSteps') % if xOffset values have been extended in negative direction
    
    ConvArray(length(LeftSteps)+1:length(LeftSteps)+length(NullPrior),2) = NullPrior';
    
else
    
    ConvArray(1:length(NullPrior),2) = NullPrior';
    
end % of pairing NullPrior values with the appropriate xOffset values in the
% array to be passed to ConvDists

ConvArray(:,3) = IncPrior';

Conv = ConvDists(ConvArray); % convolving IncPrior with NullPrior

Conv(:,1) = Conv(:,1) - NumOffsetSteps*xDelta; % undoing the offset

if Conv(1) < AL(1)
    
    Conv(1:find(Conv(:,1)<AL(1),1,'last'),:) = []; % trim lower end at analytic limit
end

if Conv(end,1) > AL(2)
    
    Conv(find(Conv(:,1)>AL(2),1):end,:) = []; % trim upper end to analytic limit
    
end

IntegConv = trapz(Conv(:,2)); % integral of convolution, assuming unit increments
% on the x axis. (True integral is xDelta times this "integral")

Conv(:,2) = Conv(:,2)/IntegConv; % normalizing


%%
AltPrior = interp1(Conv(:,1),Conv(:,2),x);

LV = ~isnan(AltPrior);

PostLkAlt = AltPrior(LV)*LkFunE(LV)'; % dot product

%%
APLmRws = [find(Conv(:,2)>(max(Conv(:,2))/1000),1) ...
    find(Conv(:,2)>(max(Conv(:,2))/1000),1,'last')];

OddsAgainst = PostLkAlt/PostLkNull;

OddsFor = PostLkNull/PostLkAlt;

Weight = log10(PostLkAlt/PostLkNull); % common log of the Bayes Factor

xLims = [min([x(1) Conv(APLmRws(1))]) max([x(end) Conv(APLmRws(2))])];

NlPrior = [[xLims(1) x xLims(2)]' [0 NullPrior 0]'/xDelta];

AltPrior = [Conv(APLmRws(1):APLmRws(2),1) Conv(APLmRws(1):APLmRws(2),2)/xDelta];

LkhdE = [[xLims(1) x xLims(2)]' [0 LkFunE 0]'];

if NoFig>0;return;end
%%
if ax
    [Ax,Hyy(1),Hyy(2)] = plotyy(varargin{3},[xLims(1) x xLims(2)],[0 NullPrior 0]/xDelta,...
    [xLims(1) x xLims(2)],[0 LkFunE 0]);

    xlabel('Dependent Measure')

    set(Hyy(1),'LineWidth',2)

    set(Hyy(2),'LineWidth',2)

    set(Ax(1),'LineWidth',2)

    set(get(Ax(1),'YLabel'),'FontSize',18)

    set(get(Ax(2),'YLabel'),'FontSize',18)

    set(get(Ax(1),'XLabel'),'FontSize',18)

    set(Ax(1),'FontSize',12)

    set(Ax(2),'FontSize',12)

    set(Ax(2),'LineWidth',2)

    hold on

    Hyy(3) = plot(Ax(1),AltPrior(:,1),AltPrior(:,2),'b--','LineWidth',2);

%     legend(Hyy,'Null Prior','E Likelihood','Alt Prior','Location','Northwest')

    ylabel(Ax(1),'Probability Density')

    ylabel(Ax(2),'Likelihood')
else
    
    figure

    [Ax,Hyy(1),Hyy(2)] = plotyy([xLims(1) x xLims(2)],[0 NullPrior 0]/xDelta,...
        [xLims(1) x xLims(2)],[0 LkFunE 0]);

    xlabel('Dependent Measure')

    set(Hyy(1),'LineWidth',2)

    set(Hyy(2),'LineWidth',2)

    set(Ax(1),'LineWidth',2)

    set(get(Ax(1),'YLabel'),'FontSize',18)

    set(get(Ax(2),'YLabel'),'FontSize',18)

    set(get(Ax(1),'XLabel'),'FontSize',18)

    set(Ax(1),'FontSize',12)

    set(Ax(2),'FontSize',12)

    set(Ax(2),'LineWidth',2)

    hold on

    Hyy(3) = plot(Ax(1),AltPrior(:,1),AltPrior(:,2),'b--','LineWidth',2);

    legend(Hyy,'Null Prior','E Likelihood','Alt Prior','Location','Northwest')

    ylabel(Ax(1),'Probability Density')

    ylabel(Ax(2),'Likelihood')
end

function F = ConvDists(A)
% Syntax F = ConvDists(A)
% The array A is a common x-axis (first column) and two vectorized
% distribution functions defined over that axis (columns 2 and 3).
% The function returns the convolution of the two distributions in F.
% Col 1 of F is the expanded x axis, whose length is 1 less than twice the
% length of the x-axis vector in A; Col 2 gives the probability densities
% of the convolution distribution, normalized so that they sum to 1. The
% 2nd & 3rd cols of A must each sum to 1

% The convolution for row vectors u & v as functions of x looks like this
%
%	v1	v2	v3	v4	v5	 = A(:,3)		
%	u1	u2	u3	u4	u5	 = A(:,2)			
%	x1	x2	x3	x4	x5   = A(:,1)				
%									
%	u1v1	u1v2	u1v3	u1v4	u1v5				
%           u2v1	u2v2	u2v3	u2v4	u2v5			
%                   u3v1	u3v2	u3v3	u3v4	u3v5		
%                           u4v1	u4v2	u4v3	u4v4	u4v5	
%                                   u5v1	u5v2	u5v3	u5v4	u5v5
% F(:,2)=sums of the above columns:
%	F(:,1)= x1+x1	x1+x2	x1+x3	x1+x4	x1+x5	x2+x5	x3+x5	x4+x5	x5+x5
% 
%
% Notice that the first row is the vector v, scaled by u1; the second row
% is the vector v scaled by u2 and shifted one step to the right over the x
% axis; the third row is the vector v scaled by u3 and shifted 2 steps; and
% so on. Each scaled copy of v1 begins at the locus of the scaling factor
% in u.
%
% For viewing convenience, the function works with column vectors rather than
% row vectors. 

if (sum(A(:,2))<.99999)|(sum(A(:,2))>1.0001)|(sum(A(:,3))<.99999)|(sum(A(:,3))>1.0001)
    
    disp('One or both input distributions do not sum to 1')
    
    F=[];
    
    return
    
end

F(:,1) = [A(1,1)+A(:,1);A(end,1)+A(2:end,1)]; % the expanded x axis

F(:,2) = conv(A(:,2),A(:,3)); % convolving the y vectors

F(:,2) = F(:,2)/sum(F(:,2)); % normalizing the convolution

