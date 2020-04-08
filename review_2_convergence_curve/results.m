clc
clear all

CostFunction=@(x,u) MyCostCapstone1(x,u); 
%%
%BDA
Max_iteration1=100; 
N1=50; 
NrElem1=100;
nVar1=(NrElem1/2)-2;
%%
% BSSA
Max_iteration2=100; 
N2=50;
NrElem2=100;
nVar2=NrElem2/2-2;
%%
%BDA
[Best_pos, Best_score ,Convergence_curveBDA]=BDACapstone(N1, Max_iteration1, nVar1, NrElem1, CostFunction);
%%
%BSSA
[Best_pos, Best_score,Convergence_curveBSSA]= BSSA_capstone(N2, Max_iteration2, nVar2);
%%
%BGWO
SearchAgents_no=50; 
Max_iteration3=100; 
NrElem3=100;
nVar3=NrElem3/2-2;
fobj=@(x,u) MyCostCapstone2(x,u);
[Best_score,Best_pos,Convergence_curveBGWO]=bGWO(SearchAgents_no,Max_iteration3,nVar3,fobj);
%%

%%
plot(Convergence_curveBDA,'DisplayName','BDA','Color', 'r');
hold on
plot(Convergence_curveBSSA,'DisplayName','BSSA','Color', 'b');
hold on
plot(Convergence_curveBGWO,'DisplayName','BGWO','Color', 'k');
hold on
plot(Convergence_curveGA,'k','LineWidth',2);
hold off

title(['Convergence curve']);
xlabel('Iteration');ylabel('Average Best-so-far');
legend('BDA','BSSA','BGWO');
box on
