function [Best_pos, Best_score ,Convergence_curve, Time]=BDA(N, max_iter, nVar, NrElem, CostFunction)

display('The BDA algorithm is optimizing this problem:')
tic;
dim=nVar;

Food_fitness=inf;
Food_pos=zeros(dim,1);

Enemy_fitness=-inf;
Enemy_pos=zeros(dim,1);
u=linspace(0,1,1000);

null_idx1 = find(u>=1/(NrElem*0.5));


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
    
    s=2*rand*my_c; 
    a=2*rand*my_c; 
    c=2*rand*my_c; 
    f=2*rand;      
    e=my_c;        
    
    if iter>(3*max_iter/4) 
        e=0;
    end
    AF       = CostFunction([ones(N,1) X' ones(N,1)],u); % Linear Array Factor
    Gain     = 20*log10(AF(:,null_idx1));
%               
    for i=1:N
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
%     
    for i=1:N
    
        index=0;
        neighbours_no=0;
        
        clear Neighbours_DeltaX
        clear Neighbours_X
        
        
        for j=1:N
            if (i~=j)
                index=index+1;
                neighbours_no=neighbours_no+1;
                Neighbours_DeltaX(:,index)=DeltaX(:,j);
                Neighbours_X(:,index)=X(:,j);
%                 
            end
        end
%         
        S=zeros(dim,1);
        for k=1:neighbours_no
            S=S+(Neighbours_X(:,k)-X(:,i));
        end
        S=-S;
        
       
        A=(sum(Neighbours_DeltaX')')/neighbours_no;
        
  
        C_temp=(sum(Neighbours_X')')/neighbours_no;
        C=C_temp-X(:,i);
         
    
        F=Food_pos-X(:,i);
        

        E=Enemy_pos+X(:,i);
        
        for j=1:dim
         
            DeltaX(j,i)=s*S(j,1)+ a*A(j,1)+ c*C(j,1)+ f*F(j,1)+e*E(j,1) + w*DeltaX(j,i);
            if DeltaX(j,i)>6
                DeltaX(j,i)=6;
            end                       
            if DeltaX(j,i)<-6
                DeltaX(j,i)=-6;
            end
            
            
            T=abs(DeltaX(j,i)/sqrt((1+DeltaX(j,i)^2))); 
            
            
            if rand<T 
                X(j,i)=~X(j,i);
            end
        end  
    end
    Convergence_curve(iter)=Food_fitness;
    Best_pos=Food_pos;
    Best_score=Food_fitness;
    
end
Time=toc;