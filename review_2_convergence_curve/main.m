
clc

close all

fobj=@(x,u) MyCostCapstone2(x,u);
SearchAgents_no=1000; % Number of search agents


Max_iteration=5; % Maximum numbef of iterations
NrElem=20;
dim=NrElem/2-2;

tic
[Best_score,Best_pos,Convergence_curve]=bGWO(SearchAgents_no,Max_iteration,dim,fobj);
time=toc;


plot(Convergence_curve,'DisplayName','BGWO','Color', 'r');

hold on

title('Convergence curve');
xlabel('Iteration');ylabel('Average Best-so-far');
legend('BGWO');
box on

display(['Max_iter= ',num2str(Max_iteration),' N= ',num2str(SearchAgents_no),' NrElem= ',num2str(NrElem)]);
display(['The best solution obtained by bGWO is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by bGWO is : ', num2str(Best_score)]);
display(['Time:',num2str(time)]);
m = Best_pos;  

m = [1 m 1]; 
u = linspace(0,1,1000);

AFopt  = fobj(m,u);           Gainopt  = 20*log10(AFopt);
AForig = fobj(ones(1,dim+2),u);  Gainorig = 20*log10(AForig);
%% 

figure,
plot(u,Gainorig,'r--','LineWidth',2), hold on
plot(u,Gainopt,'b','LineWidth',1.25)

ylim([-40 0])
xlabel('u = cos(\phi)')
ylabel('Gain (dB)')
grid on
grid minor

%% 

n=0;
m = Best_pos;  
x = linspace(0.1,0.9,length(m)+2);
m = [1 m 1]; 
for i = 1:length(m)        
    if m(i)==1
        plot(x(i),-10,'go','MarkerFaceColor','g')
        text(x(i),-12,num2str(i),'VerticalAlignment','bottom','HorizontalAlignment','center')
        n=n+1;
    else
        plot(x(i),-10,'ro','MarkerFaceColor','r')
        text(x(i),-12,num2str(i),'VerticalAlignment','bottom','HorizontalAlignment','center')
    end        
end
title({['Optimal Value ',num2str((Best_score),'%3.3f')];['Number of Active Elements = ',num2str(n*2)]})
legend('Original','Optimized');
display(['Number of on elements: ',num2str(n*2)]);
        



