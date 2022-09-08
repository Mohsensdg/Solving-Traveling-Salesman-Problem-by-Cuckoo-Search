clc;
clear;
close all;
%% Problem Definition
%CostFunction=@(x) Sphere(x);    %Cost Function
%global NFE;

model = CreateModel;
%nVar=4;                    %Number of Decision Variables

VarSize = [1 model.N]; %Size of Decision Variable Matrix

VarMax = 1; %Upper Bound of Variables

VarMin = 0; %Lower Bound of Variables
%% CS Parameters

MaxIt = 1200; %Maximum Number of Iterations

nPop = 60; % Number of nests (Population Size)

pa = 0.3; % Discovery rate of alien eggs/solutions

alpha = 0.015; %Step Size
beta = 1; %Index
%% Initialization

empty_nest.Position = [];
empty_nest.Cost = [];

nest = repmat(empty_nest, nPop, 1);
newnest = repmat(empty_nest, nPop, 1);

for i = 1:nPop
    nest(i).Position = unifrnd(VarMin, VarMax, VarSize);
    [~, nest(i).Sol] = MyCost(nest(i).Position, model);
end

GlobalBest.Cost = inf;
[nest, GlobalBest] = Best_nest(nest, nest, GlobalBest);
BestCost = zeros(MaxIt + 1, 1);
BestCost(1) = GlobalBest.Cost;
nfe = zeros(MaxIt, 1);

%% Cs Main Loop
for it = 1:MaxIt

    for i = 1:nPop
        % Generate new solutions (but keep the current best)
        %Update StepSize

        %Levy flights by Mantegna's algorithm
        sigma = (gamma(1 + beta) * sin(pi * beta / 2) / (gamma((1 + beta) / 2) * ...
        beta * 2^((beta - 1) / 2)))^(1 / beta);

        u = randn(size(nest(i).Position)) * sigma;

        v = randn(size(nest(i).Position));

        Step = u ./ abs(v).^(1 / beta);
        StepSize_Levy = 0.01 * Step .* (nest(i).Position - GlobalBest.Position);
        %Update Position
        newnest(i).Position = nest(i).Position + StepSize_Levy ...
        .* randn(size(nest(i).Position));

        %Mutation
        NewSol.Position = Mutate(newnest(i).Position);
        [NewSol.Cost, NewSol.Sol] = MyCost(newnest(i).Position, model);

        if NewSol.Cost < newnest(i).Cost
            newnest(i).Position = NewSol.Position;
            newnest(i).Cost = NewSol.Cost;
            newnest(i).Sol = NewSol.Sol;
        end

    end

    [nest, GlobalBest] = Best_nest(nest, newnest, GlobalBest);

    % Discovery and randomization
    newnest = Local_Search(nest, pa);

    % Evaluate this set of solutions
    [nest, GlobalBest] = Best_nest(nest, newnest, GlobalBest);

    %  nfe(it)=NFE;

    NewSol.Position = Mutate(GlobalBest.Position);
    [NewSol.Cost, NewSol.Sol] = MyCost(GlobalBest.Position, model);

    if NewSol.Cost < GlobalBest.Cost
        GlobalBest.Position = NewSol.Position;
        GlobalBest.Cost = NewSol.Cost;
        GlobalBest.Sol = NewSol.Sol;
    end

    BestCost(it + 1) = GlobalBest.Cost;

    disp(['Iteration  ' num2str(it) ' NFE =  ' num2str(nfe(it)) ...
            ' Best Cost = ' num2str(BestCost(it))]);

    figure(1);
    PlotSolution(GlobalBest.Sol.Tour, model);

end

%% Result
figure;
plot(BestCost, 'LineWidth', 2);
semilogy(BestCost, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
