
function[minc]=Figure11_13()
% clear all
% close all
tic;
NrElem  = 100;
Nvar    = NrElem/2-2;
nbits   = 1;
Nt      = Nvar*nbits;

% Genetic Algorithm parameters
NPop    =50;                            % population size
mutrate = 0.2;                          % mutation rate
el      = 1;                            % number of chromosomes not mutated
Nmut    = ceil(mutrate*((NPop-el)*Nt)); % # mutations

% stopping criteria
maxgen  = 100;                          % max # generations
mincost = -50;                          % acceptable cost

% initial population
P = round(rand(NPop,Nt));

% Evaluate Cost of initial population
u        = linspace(0,1,1000);         % half u-space
null_idx1 = find(u>=1/(NrElem*0.5));    % find u values greater than 1/(N*d)
null_idx2=find(u>=0);
null_idx3=find(u<1/(NrElem*0.5));
AF       = LinAF_func([ones(NPop,1) P ones(NPop,1)],u); % Linear Array Factor
Gain     = 20*log10(AF);               % Gain of linear array
cost     = max(Gain(:,null_idx1),[],2); % Peak sidelobe level (max of row)

[c,in]  = min(cost);
tp      = P(1,:);  tc       = cost(1);
P(1,:)  = P(in,:); cost(1)  = cost(in);
P(in,:) = tp;      cost(in) = tc;
minc(1) = min(cost);                % best cost in each generation
avgc(1) = mean(cost);               % average cost in each generation

%% Perform GA Optimization
Psave = [];
for gen = 1:maxgen
    % Natural selection
    indx = find(cost<=mean(cost));
    keep = length(indx);
    cost = cost(indx); 
    P    = P(indx,:);
    M    = NPop-keep;
    
    % Create mating pool using tournament selection
    Ntourn = 2;  % Size of tournament
    for ic = 1:M
        rc     = ceil(keep*rand(1,Ntourn));
        [~,ci] = min(cost(rc)); % indicies of mother
        ma     = rc(ci);
        rc     = ceil(keep*rand(1,Ntourn));
        [~,ci] = min(cost(rc)); % indicies of father
        pa     = rc(ci);
        
        % generate mask
        mask = round(rand(1,Nt));
        
        % crossover
        P(keep+ic,:) = mask.*P(ma,:)+not(mask).*P(pa,:);
    end
    
    % Mutation
    elP = P(el+1:NPop,:);
    elP(ceil((NPop-el)*Nt*rand(1,Nmut)))=round(rand(1,Nmut));
    P(el+1:NPop,:) = elP;
    
    % Compute cost function
    AF     = LinAF_func([ones(NPop,1) P ones(NPop,1)],u);
    Gain   = 20*log10(AF);
    cost   = max(Gain(:,null_idx1),[],2);        
    [c,in] = min(cost);
    
    tp      = P(1,:);  tc       = cost(1);
    P(1,:)  = P(in,:); cost(1)  = cost(in);
    P(in,:) = tp;      cost(in) = tc;
    minc(gen+1) = cost(1);
    avgc(gen+1) = mean(cost);
    
    % Convergence check
    Psave(gen,:) = P(1,:);
    if gen>maxgen | minc(gen+1)<mincost
        break
    end
end
time=toc;
%display(['Max_iter= ',num2str(maxgen),' N= ',num2str(NPop),' NrElem= ',num2str(NrElem)]);
% disp(['Min cost = ' num2str(minc(end))])
% disp(['Best chromosome = ' num2str(P(1,:))])
% display(['Time:',num2str(time)]);
%% Plot Original and Optimized Array Pattern
p = P(1,:);
NrActiveElems = sum(p)*2+4;
AFopt  = LinAF_func([1 p 1],u);           Gainopt  = 20*log10(AFopt);
AForig = LinAF_func(ones(1,NrElem/2),u);  Gainorig = 20*log10(AForig);

% figure,
% plot(u,Gainorig,'k'), hold on
% plot(u,Gainopt,'k','LineWidth',2)
% ylim([-40 0])
% xlabel('u = cos(\phi)')
% ylabel('20log_1_0|FF_n(u)|')

% x = linspace(0.1,0.9,length(p)+2);
% p = [1 round(p) 1]; 
% for i = 1:length(p)        
%     if p(i)==1
%         plot(x(i),-10,'ko','MarkerFaceColor','k')
%     else
%         plot(x(i),-10,'ko')
%         text(x(i),-9,num2str(i),'VerticalAlignment','bottom','HorizontalAlignment','center')
%     end        
% end
% text(x(1),-9,'1','VerticalAlignment','bottom','HorizontalAlignment','center')
% text(x(end),-9,'26','VerticalAlignment','bottom','HorizontalAlignment','center')
% title({['Peak Sidelobe Level: ',num2str(minc(end),'%3.3f')];['Number of Active Elements = ',num2str(NrActiveElems)]})
% legend('Original','Optimized')

%% Plot convergence and score progression
figure
% subplot(223)
% plot(0:gen,minc,'k','LineWidth',2),hold on
% plot(0:gen,avgc,'k')
% xlabel('Iteration Number (Generation)');
% ylabel('Peak Sidelobe Level (dB)')
% legend('Best Score','Avg Score')
% xlim([1 200])


% plot(0:gen,minc,'k','LineWidth',2),hold on
% 
% xlabel('Iteration Number (Generation)');
% ylabel('Peak Sidelobe Level (dB)')
% legend('Best Score')
% xlim([1 200])

% subplot(221)
% imagesc([ones(size(Psave,1),1) Psave ones(size(Psave,1),1)]'),axis xy,colormap(gray)
% xlim([1 200])
% xlabel('Iteration Number (Generation)');
% ylabel('Array Element Number')
% title('Progression of Best Chromosome')
% display(['Number of on elements: ',num2str(NrActiveElems)]);
end


