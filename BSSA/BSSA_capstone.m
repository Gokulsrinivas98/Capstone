function [FoodPosition,FoodFitness,Convergence_curve]=BSSA_capstone(N,Max_iter,dim,fobj)
clc; close all;
fobj=@(x,u) MyCostCapstone2(x,u);
N=100;
Max_iter=100;
dim=24;
disp('The BSSA algorithm is optimizing your problem...')

Convergence_curve = zeros(1,Max_iter);

%Initialize the positions of salps
SalpPositions=initialization_cap_BSSA(N,dim,1,0)>0.5;


FoodPosition=zeros(1,N);
SalpFitness=zeros(1,N);
Sorted_salps=zeros(N,dim);
FoodFitness=Inf;
NrElem=(dim+2)*2;
u=linspace(0,1,1000);
null_idx1 = find(u>=1/(NrElem*0.5));

%calculate the fitness of initial salps
AF = fobj([ones(N,1) SalpPositions ones(N,1)],u); % Linear Array Factor
Gain= 20*log10(AF(:,null_idx1));

for i=1:N
      %fitness=max(Gain(i,:));
      SalpFitness(1,i)=max(Gain(i,:));%fitness;
end

[sorted_salps_fitness,sorted_indexes]=sort(SalpFitness);

for newindex=1:N
    Sorted_salps(newindex,:)=SalpPositions(sorted_indexes(newindex),:);
end

FoodPosition=Sorted_salps(1,:);
FoodFitness=sorted_salps_fitness(1);

%Main loop
%la=2; % start from the second iteration since the first iteration was dedicated to calculating the fitness of salps
for la=2:Max_iter+1    
    c1 = 2*exp(-(4*la/Max_iter)^2); % Eq. (3.2) in the paper  
    for i=1:size(SalpPositions,1)        
        SalpPositions= SalpPositions';        
        if i<=N/2
            for j=1:1:dim
                c2=rand();
                c3=rand();
                %%%%%%%%%%%%% % Eq. (3.1) in the paper %%%%%%%%%%%%%%
                if c3<0.5 
                       temp=FoodPosition(j)+(c1*c2); %Binary
                       SalpPositions(j,i)=SalpPositions(j,i)>0.5;  %You can use a transfer function instead
                       %SalpPositions(j,i)=trnasferFun(SalpPositions(j,i),temp,1); 
                else
                      temp=FoodPosition(j)-(c1*c2); %Binary
                      SalpPositions(j,i)=SalpPositions(j,i)>0.5;  %Binary 
                      %SalpPositions(j,i)=trnasferFun(SalpPositions(j,i),temp,1);
                 end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        elseif i>N/2 && i<N+1
            point1=SalpPositions(:,i-1);
            point2=SalpPositions(:,i);
            SalpPositions(:,i)=(point2+point1)/2; % % Eq. (3.4) in the paper
        end
        SalpPositions= SalpPositions';
    end
    for i=1:size(SalpPositions,1)
        Tp=SalpPositions(i,:)>1;
        Tm=SalpPositions(i,:)<0;
%         ub=1;
%         lb=0;
        SalpPositions(i,:)=(SalpPositions(i,:).*(~(Tp+Tm)))+Tp;
       %SalpFitness(1,i)=fobj(SalpPositions(i,:));
        AF = fobj([ones(N,1) SalpPositions ones(N,1)],u); % Linear Array Factor
        Gain= 20*log10(AF(:,null_idx1));
        %fitness=max(Gain(i,:));
        SalpFitness(1,i)=max(Gain(i,:));%fitness;   
   
        if SalpFitness(1,i)<FoodFitness
            FoodPosition=SalpPositions(i,:);
            FoodFitness=SalpFitness(1,i);
        end
   end 
    
%       if mod(l,1)==0
% %         display(['At iteration ', num2str(l), ' the best universes fitness is ', num2str(FoodFitness,'%.9f')]);
%     end

%         fprintf('%f:\t',FoodFitness);
%         fprintf('%d',FoodPosition(:));
%         display(num2str(la))
% %         fprintf('\n');
Convergence_curve(la)=FoodFitness; 
end


