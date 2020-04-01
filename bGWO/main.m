%___________________________________________________________________%
%  BinaryGrey Wold Optimizer (bGWO) source codes version 1.0               %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Gokul                      %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper: S. Mirjalili, S. M. Mirjalili, A. Lewis             %
%               Grey Wolf Optimizer, Advances in Engineering        %
%               Software , in press,                                %
%               DOI: 10.1016/j.advengsoft.2013.12.007               %
%                                                                   %
%___________________________________________________________________%

% You can simply define your cost in a seperate file and load its handle to fobj 
% The initial parameters that you need are:
%__________________________________________
% fobj = @YourCostFunction
% dim = number of your variables
% Max_iteration = maximum number of generations
% SearchAgents_no = number of search agents
% lb=[lb1,lb2,...,lbn] where lbn is the lower bound of variable n
% ub=[ub1,ub2,...,ubn] where ubn is the upper bound of variable n
% If all the variables have equal lower bound you can just
% define lb and ub as two single number numbers

% To run GWO: [Best_score,Best_pos,GWO_cg_curve]=GWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj)
%__________________________________________
clc

close all

fobj=@(x,u) MyCostCapstone2(x,u);
SearchAgents_no=1000; % Number of search agents

%Function_name='F1'; % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper)

Max_iteration=5; % Maximum numbef of iterations
NrElem=150;
dim=NrElem/2-1;
% Load details of the selected benchmark function
%[lb,ub,dim,fobj]=Get_Functions_details(Function_name);

[Best_score,Best_pos,Convergence_curve]=bGWO(SearchAgents_no,Max_iteration,dim,fobj);

%PSO_cg_curve=PSO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); % run PSO to compare to results

% figure('Position',[500 500 660 290])
% %Draw search space
% subplot(1,2,1);
% func_plot(Function_name);
% title('Parameter space')
% xlabel('x_1');
% ylabel('x_2');
% zlabel([Function_name,'( x_1 , x_2 )'])
% 
% %Draw objective space
% subplot(1,2,2);
% semilogy(GWO_cg_curve,'Color','r')
% hold on
% semilogy(PSO_cg_curve,'Color','b')
% title('Objective space')
% xlabel('Iteration');
% ylabel('Best score obtained so far');

% axis tight
% grid on
% box on
% legend('GWO','PSO')

plot(Convergence_curve,'DisplayName','BGWO','Color', 'r');

hold on

title('Convergence curve');
xlabel('Iteration');ylabel('Average Best-so-far');
legend('BGWO');
box on


display(['The best solution obtained by bGWO is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by bGWO is : ', num2str(Best_score)]);
display([num2str(N),num2str(Max_iteration),num2str(NrElem)]);
m = Best_pos;  
%x = linspace(1,Max_iteration,length(m)+2);
m = [m 1]; 
u = linspace(0,1,1000);

AFopt  = fobj(m,u);           Gainopt  = 20*log10(AFopt);
AForig = fobj(ones(1,dim+1),u);  Gainorig = 20*log10(AForig);
%% 

figure,
plot(u,Gainorig,'r','LineWidth',1.25), hold on
plot(u,Gainopt,'b','LineWidth',1.25)

ylim([-40 0])
xlabel('u = cos(\phi)')
ylabel('20log_1_0|FF_n(u)|')

%% 

n=0;
m = Best_pos;  
x = linspace(0.1,0.9,length(m)+2);
m = [m 1]; 
for i = 1:length(m)        
    if m(i)==1
        plot(x(i),-10,'ro','MarkerFaceColor','r')
        text(x(i),-12,num2str(i),'VerticalAlignment','bottom','HorizontalAlignment','center')
        n=n+1;
    else
        plot(x(i),-10,'bo','MarkerFaceColor','g')
        text(x(i),-12,num2str(i),'VerticalAlignment','bottom','HorizontalAlignment','center')
    end        
end
x=NrElem-(n*2);
title({['Optimal Value ',num2str((Best_score),'%3.3f')];['Number of Active Elements = ',num2str(n*2)];['Thinning Factor % =',num2str(100*x/NrElem)]})
legend('Original','Optimized');

        
display([num2str(n*2)]);


