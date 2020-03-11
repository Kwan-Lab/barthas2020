function [sqErr, respRate]=costfun(xpar, dat)
% costfun.m
% Energetic and opportunity cost model
% 
% function returns the least-square error (to be minimized using fminsearch)

%% initialize parameters

%the slopes, corresponding to four reward types, in opportunity cost
o_cost_slope=xpar(1)*[1 xpar(2) xpar(3) xpar(4)];  

%parameter for marginal utility
alpha=xpar(5);

%change point in utility function (linear + diminishing return segments)
utilityCP=xpar(6);

%% set up the cost functions

%costfcn_dt=0.1;
%costfcn_t=[0:costfcn_dt:250];

%---energetic cost
%param1: time constant for the 1/x function;
%"latency-dependent vigor cost (Niv paper cited Staddon 2001 book)
%"inversely proportional to latency (Niv, 2007)

%e_cost = 1./costfcn_t;

%---opportunity cost
%param1: slope (due to reward type)
%"rat chooses the latency with which to perform an action.. cost of this
%committment is latency*average reward rate because the rat is effectively
%forgoing this much reward by doing nothing (Niv, 2007) -- in our case, the
%near-future reward rate is entirely predictable, so just substitute with
%reward type

%o_cost = o_cost_slope' * costfcn_t;

%---satiety
%RewardNum: number of rewards already consumed
%
%Iso-elastic        U(R) = R^(1-alpha) / (1-alpha)
%marginal utility   U'(R) = R^(-alpha),            alpha>0 for diminishing returns
%marginal_util = @(param1,RewardNum) (RewardNum-utilityCP).^(-1*alpha);
%
%Exponential        U(R) = -exp(-alpha*R)    alpha>0
%marginal utility   U'(R) = alpha*exp(-alpha*R)
%the alpha in front is a constant, that gets absorbed into the opportunity
%cost slope term
%marginal_util = @(param1,RewardNum) exp(-1*param1*(RewardNum-utilityCP));

%% simulate!

nBlock=60;  %simulate up to this many blocks
dat_extended=[dat zeros(1,nBlock-numel(dat))];

sqErr=0;
rewardConsumed=0;
respRate=zeros(nBlock,1);

rewardType=repmat([1,3,4,2],1,ceil(nBlock/4));

for jj=1:nBlock
    timeLeft = 60;  %each block is 60 s long
    
    while (timeLeft > 0)
        
        %method 1 - base on the cost function, minimize to estimate the time to next response
%         if rewardConsumed > utilityCP
%             cost = e_cost + o_cost(rewardType(jj),:) .* marginal_util(alpha,rewardConsumed);
%         else
%             cost = e_cost + o_cost(rewardType(jj),:);
%         end
%         [~,idx] = nanmin(cost);
%         interRespTime = costfcn_t(idx);

        %method 2 - take derivative of cost, can solve for interRespTime directly
         if rewardConsumed > utilityCP
            % exponential utility
             interRespTime = 1/sqrt(o_cost_slope(rewardType(jj)) .* exp(-1*alpha*(rewardConsumed-utilityCP))); 

            % isoelastic utility
%             interRespTime = 1/sqrt(o_cost_slope(rewardType(jj)) .* (rewardConsumed-utilityCP).^(-1*alpha));
         else
             interRespTime = 1/sqrt(o_cost_slope(rewardType(jj)));
         end

        %can animal respond before the end of block?
        if interRespTime > timeLeft  %if time to next response > time left for this block
            respRate(jj) = respRate(jj) + timeLeft/interRespTime;  %take a fraction of a reward (idea is this makes numbers continuous-valued to help fitting)
            rewardConsumed = rewardConsumed + timeLeft/interRespTime;
            timeLeft = 0;
        else
            respRate(jj) = respRate(jj) + 1;
            rewardConsumed = rewardConsumed + 1;
            timeLeft = timeLeft - interRespTime;
        end       
    end
    
    %keep track of sum of least-square error of each block
    sqErr = sqErr + (respRate(jj)-dat_extended(jj)).^2;
end

end