function [ nest,GlobalBest ] =Best_nest(nest,newnest,GlobalBest)
% Evaluating all new solutions
  model=CreateModel;
 VarMin=0;
 VarMax=1;
for i=1:size(nest,1)
    nest(i).Cost=MyCost(nest(i).Position,model);
    newnest(i).Cost=MyCost(newnest(i).Position,model);
    
    if newnest(i).Cost<nest(i).Cost
       nest(i).Cost=newnest(i).Cost;
       nest(i).Position=newnest(i).Position;
       
   [~ , nest(i).Sol]=MyCost(newnest(i).Position,model);
        
    end
    
    
    % Find the current best
    
    
    if  nest(i).Cost<GlobalBest.Cost
         GlobalBest=nest(i);
         
     end
end

end

