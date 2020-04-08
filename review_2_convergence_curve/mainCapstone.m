%function[Convergence_curve]= mainCapstone()
clear all 
close all
clc

CostFunction=@(x,u) MyCostCapstone1(x,u); % Modify or replace Mycost.m according to your cost funciton

Max_iteration=100; % Maximum number of iterations
N=100; % Number of particles
NrElem=52;
nVar=(NrElem/2)-2;

% BDA with a v-shaped transfer function
tic
[Best_pos, Best_score ,Convergence_curve]=BDACapstone(N, Max_iteration, nVar, NrElem, CostFunction);
time=toc;


display(['The best solution obtained by BDA is : ', num2str(Best_pos')]);
display(['The best optimal value of the objective funciton found by BDA is : ', num2str(Best_score)]);
display(['Time:',num2str(time)]);

%end
