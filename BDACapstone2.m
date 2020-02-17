function [Best_pos, Best_score ,Convergence_curve]=BDA(N, max_iter, nVar, CostFunction)

display('The BDA algorithm is optimizing your problem...')

dim=nVar;

Food_fitness=inf;
Food_pos=zeros(dim,1);

Enemy_fitness=-inf;
Enemy_pos=zeros(dim,1);

NrElem=(nVar+2)*2;
u=linspace(0,1,1000);
null_idx1 = find(u>=1/(NrElem*0.5));

% Initialize X and DeltaX vectors
for i=1:N
    for j=1:nVar 
        if rand<=0.5
            X(j,i)=0;
        else
            X(j,i)=1;
        end
        
        if rand<=0.5
            DeltaX(j,i)=0;
        else
            DeltaX(j,i)=1;
        end
    end
end

Fitness=zeros(1,N);

for iter=1:max_iter
    
    w=0.9-iter*((0.9-0.4)/max_iter);
    
    my_c=0.1-iter*((0.1-0)/(max_iter/2));
    if my_c<0
        my_c=0;
    end
    
    s=2*rand*my_c; % Seperation weight
    a=2*rand*my_c; % Alignment weight
    c=2*rand*my_c; % Cohesion weight
    f=2*rand;      % Food attraction weight
    e=my_c;        % Enemy distraction weight
    
    if iter>(3*max_iter/4) 
        e=0;
    end
    AF       = CostFunction([ones(N,1) X' ones(N,1)],u); % Linear Array Factor
    Gain     = 20*log10(AF(:,null_idx1));
%               % Gain of linear array
    for i=1:N %Calculate all the objective values first
        Fitness(1,i)=max(Gain(i,:));
        if Fitness(1,i)<Food_fitness
            Food_fitness=Fitness(1,i);
            Food_pos=X(:,i);
        end
        if Fitness(1,i)>Enemy_fitness
            Enemy_fitness=Fitness(1,i);
            Enemy_pos=X(:,i);
        end
    end 
%     X
%     cost     = max(Gain,[],2);
%     [c,in]  = min(cost);    
%     Food_fitness=c;
%     Food_pos=X(:,in);
%     [c1,in1]  = max(cost);                                                                                                           
%     Enemy_fitness=c1;
%     Enemy_pos=X(:,in1);
    for i=1:N
    
        index=0;
        neighbours_no=0;
        
        clear Neighbours_DeltaX
        clear Neighbours_X
        
        %Find the neighbouring solutions (all the dragonflies are assumed as a group in binary seach spaces)
        for j=1:N
            if (i~=j)
                index=index+1;
                neighbours_no=neighbours_no+1;
                Neighbours_DeltaX(:,index)=DeltaX(:,j);
                Neighbours_X(:,index)=X(:,j);
%                 [ab,bc]=size(Neighbours_DeltaX);
            end
        end
%         [cd,ef]=size(Neighbours_DeltaX);
        % Seperation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.1)
        S=zeros(dim,1);
        for k=1:neighbours_no
            S=S+(Neighbours_X(:,k)-X(:,i));
        end
        S=-S;
        
        % Alignment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.2)
        A=(sum(Neighbours_DeltaX')')/neighbours_no;
        
        % Cohesion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.3)
        C_temp=(sum(Neighbours_X')')/neighbours_no;
        C=C_temp-X(:,i);
         
        % Attraction to food%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.4)
        F=Food_pos-X(:,i);
        
        % Distraction from enemy%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.5)
        E=Enemy_pos+X(:,i);
        
        for j=1:dim
            % Eq. (3.6)
            DeltaX(j,i)=s*S(j,1)+ a*A(j,1)+ c*C(j,1)+ f*F(j,1)+e*E(j,1) + w*DeltaX(j,i);
            if DeltaX(j,i)>6
                DeltaX(j,i)=6;
            end                       
            if DeltaX(j,i)<-6
                DeltaX(j,i)=-6;
            end
            
            % Eq. (3.11)
            T=abs(DeltaX(j,i)/sqrt((1+DeltaX(j,i)^2))); %V3 transfer function
            
            % Eq. (3.12)
            if rand<T %Equation (10)
                X(j,i)=~X(j,i);
            end
        end  
    end
    Convergence_curve(iter)=Food_fitness;
    Best_pos=Food_pos;
    Best_score=Food_fitness;
    
end