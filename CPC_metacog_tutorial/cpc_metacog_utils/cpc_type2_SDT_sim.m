function sim = cpc_type2_SDT_sim(d, noise, c, Nratings, Ntrials)
% Type 2 SDT simulation with variable noise
% sim = type2_SDT_sim(d, noise, c, c1, c2, Ntrials)
%
% INPUTS
% d - type 1 dprime % 아마도 얼마나 쉽게 구별할 수 있는가?에 관한 stimulus간 distance에 대한
% factor로 보임. d가 클 수록 아래에 있는 stimulus 0, 1 에 대한 분포의 거리가 멀어짐.
% noise - standard deviation of noise to be added to type 1 internal
% response for type 2 judgment. If noise is a 1 x 2 vector then this will
% simulate response-conditional type 2 data where noise = [sigma_rS1
% sigma_rS2]
%
% c - type 1 criterion
% c1 - type 2 criteria for S1 response
% c2 - type 2 criteria for S2 response
% Ntrials - number of trials to simulate
%
% OUTPUT
%
% sim - structure containing nR_S1 and nR_S2 response counts
%
% SF 2014

% Specify the confidence criterions based on the number of ratings
c1 = c + linspace(-1.5, -0.5, (Nratings - 1));
c2 = c + linspace(0.5, 1.5, (Nratings - 1));

if length(noise) > 1
    rc = 1;
    sigma1 = noise(1);
    sigma2 = noise(2);
else
    rc = 0;
    sigma = noise;
end

S1mu = -d/2;
S2mu = d/2;

% Initialise response arrays
nC_rS1 = zeros(1, length(c1)+1); % 즉, S1이라고 잘 대답한 경우의 수
nI_rS1 = zeros(1, length(c1)+1); % 즉, S1이라고 잘못 대답한 경우의 수
nC_rS2 = zeros(1, length(c2)+1); % 즉, S2라고 잘 대답한 경우의 수
nI_rS2 = zeros(1, length(c2)+1); % 즉, S2라고 잘못 대답한 경우의 수

for t = 1:Ntrials
    s = round(rand); % 50% 확률로 0 아니면 1의 값이 나옴. 즉, stimulus는 0 또는 1로 랜덤하게 결정된다.
    
    % Type 1 SDT model
    if s == 1
        x = normrnd(S2mu, 1); % 정규분포 난수
    else
        x = normrnd(S1mu, 1);
    end
    
    % Add type 2 noise to signal
    if rc % add response-conditional noise
        if x < c
            if sigma1 > 0
                x2 = normrnd(x, sigma1);
            else
                x2 = x;
            end
        else
            if sigma2 > 0
                x2 = normrnd(x, sigma2);
            else
                x2 = x;
            end
        end
    else
        if sigma > 0
            x2 = normrnd(x,sigma);
        else
            x2 = x;
        end
    end
    
    % 아마 Stimulus S1이라는 것은 왼쪽 원에 있는 points의 수가 더 많은 경우이고,
    % response S1이라는 것은 왼쪽 원에 있는 points의 수가 많다고 답한 경우를 말하는 것 같다.
    
    % Generate confidence ratings
    if s == 0 && x < c      % stimulus S1 and response S1
        pos = (x2 <= [c1 c]);
        [y ind] = find(pos);
        i = min(ind);
        nC_rS1(i) = nC_rS1(i) + 1;
        
    elseif s == 0 && x >= c   % stimulus S1 and response S2
        pos = (x2 >= [c c2]);
        [y ind] = find(pos);
        i = max(ind);
        nI_rS2(i) = nI_rS2(i) + 1;
        
    elseif s == 1 && x < c  % stimulus S2 and response S1
        pos = (x2 <= [c1 c]);
        [y ind] = find(pos);
        i = min(ind);
        nI_rS1(i) = nI_rS1(i) + 1;
        
    elseif s == 1 && x >= c % stimulus S2 and response S2
        pos = (x2 >= [c c2]);
        [y ind] = find(pos);
        i = max(ind);
        nC_rS2(i) = nC_rS2(i) + 1;
    end
    
end

sim.nR_S1 = [nC_rS1 nI_rS2];
sim.nR_S2 = [nI_rS1 nC_rS2];
