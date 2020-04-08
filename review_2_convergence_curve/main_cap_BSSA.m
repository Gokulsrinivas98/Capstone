function[Convergence_curve]= mainCapstone()
close all
clc

Max_iteration=10; % Maximum number of iterations
N=10;% Number of particles
NrElem=10;
nVar=NrElem/2-2;
fobj=@(x,u) MyCostCapstone2(x,u);

tic
[Best_pos, Best_score,Convergence_curve]= BSSA_capstone(N, Max_iteration, nVar);
time=toc;
plot(Convergence_curve,'DisplayName','BGWO','Color', 'r');

hold on

title('Convergence curve');
xlabel('Iteration');ylabel('Average Best-so-far');
legend('BGWO');
box on

end

