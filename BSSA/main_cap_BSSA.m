close all
clc

fobj=@(x,u) MyCostCapstone2(x,u);
Max_iteration=100; % Maximum number of iterations
N=100; % Number of particles
NrElem=36;
nVar=NrElem/2-2;

[Best_pos, Best_score,Convergence_curve]= BSSA_capstone(N, Max_iteration, nVar,fobj);
%time = toc;
%fprintf('%s  %f\tFitness:  %f\tSolution: %d\tTime: %f\n','BSSA',Best_score,num2str(Best_pos,'%1d'),time);
display(['The best solution obtained by BSSA is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by BSSA is : ', num2str(Best_score)]);

% plot(Convergence_curve,'DisplayName','BSSA','Color', 'r');
% 
% hold on
% 
% title('Convergence curve');
% xlabel('Iteration');ylabel('Average Best-so-far');
% legend('BSSA');
% box on
% 
% m = Best_pos;  
% %x = linspace(1,Max_iteration,length(m)+2);
% m = [1 m 1]; 
% u = linspace(0,1,1000);
% 
% AFopt  = fobj(m,u);           Gainopt  = 20*log10(AFopt);
% AForig = fobj(ones(1,dim+2),u);  Gainorig = 20*log10(AForig);
% %% 
% 
% figure,
% plot(u,Gainorig,'r','LineWidth',1.25), hold on
% plot(u,Gainopt,'b','LineWidth',1.25)
% 
% ylim([-40 0])
% xlabel('u = cos(\phi)')
% ylabel('20log_1_0|FF_n(u)|')
% 
% %% 
% n=0;
% m = Best_pos;  
% x = linspace(0.1,0.9,length(m)+2);
% m = [1 m 1]; 
% for i = 1:length(m)        
%     if m(i)==1
%         plot(x(i),-10,'ro','MarkerFaceColor','r')
%         text(x(i),-12,num2str(i),'VerticalAlignment','bottom','HorizontalAlignment','center')
%         n=n+1;
%     else
%         plot(x(i),-10,'bo','MarkerFaceColor','g')
%         text(x(i),-12,num2str(i),'VerticalAlignment','bottom','HorizontalAlignment','center')
%     end        
% end
% title({['Optimal Value ',num2str((Best_score),'%3.3f')];['Number of Active Elements = ',num2str(n*2)]})
% legend('Original','Optimized');



