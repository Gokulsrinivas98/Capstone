 function [Alpha_score,Alpha_pos,Convergence_curve]=bGWO(Nagents,NIter,dim,fobj)

display('The BGWO algorithm is optimizing your problem...')
tic;
Alpha_score=inf;
Beta_score=inf;
Delta_score=inf;

Alpha_pos=zeros(1,dim);
Delta_pos=zeros(1,dim);
Beta_pos=zeros(1,dim);

Positions=initialization(Nagents,dim,1,0)>0.5;
%Positions=rand(Nagents,dim);

Convergence_curve=zeros(1,NIter);
NrElem=(dim+2)*2;
u=linspace(0,1,1000);
null_idx1 = find(u>=1/(NrElem*0.5));
fitness=zeros(1,Nagents);
%%

for la=1:NIter
    AF       = fobj([ones(Nagents,1) Positions ones(Nagents,1)],u); % Linear Array Factor
    Gain     = 20*log10(AF(:,null_idx1));
    
    for i=1:size(Positions,1)             
        fitness(1,i)=max(Gain(i,:));
       
        if fitness(1,i)<Alpha_score 
            Alpha_score=fitness(1,i);
            Alpha_pos=Positions(i,:);
        end
        
        if fitness(1,i)>Alpha_score && fitness(1,i)<Beta_score 
            Beta_score=fitness(1,i);
            Beta_pos=Positions(i,:);
        end
        
        if fitness(1,i)>Alpha_score && fitness(1,i)>Beta_score && fitness(1,i)<Delta_score 
            Delta_score=fitness(1,i); 
            Delta_pos=Positions(i,:);
        end
    end
    
    
    a=2-la*((2)/NIter);
    
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)     
                       
            r1=rand(); 
            r2=rand();
                
            A1=2*a*r1-a;
            C1=2*r2; 
            
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j));
            v1=sigmfd(-A1*D_alpha,[10, 0.5]);
            if v1<rand
                v1=0;
            else
                v1=1;
            end
            X1=(Alpha_pos(j)+v1)>=1;
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a;
            C2=2*r2; 
            
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); 
            v1=sigmfd(-A2*D_beta,[10 0.5]);
            if v1<rand
                v1=0;
            else
                v1=1;
            end
            
            X2=(Beta_pos(j)+v1)>=1 ;
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a;
            C3=2*r2;
            
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j));
             v1=sigmfd(-A3*D_delta,[10 0.5]);%eq. 25
            if v1<rand
                v1=0;
            else
                v1=1;
            end
            X3=(Delta_pos(j)+v1)>=1;         
            
            Positions(i,j)=CrossOver(X1,X2,X3); 
            
        end

    end
   
    Convergence_curve(la+1)=Alpha_score;
end

Time=toc;


