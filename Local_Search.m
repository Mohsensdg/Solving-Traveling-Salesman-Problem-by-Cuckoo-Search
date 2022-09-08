function [ newnest ] = Local_Search( nest,pa )
%% Local Search
model=CreateModel;
    VarMin=0;
     VarMax=1;
    n=size(nest,1);
    empty_nest.Position=[];
    empty_nest.Cost=[];
    newnest=repmat(empty_nest,n,1);

    %Creating nest_alt to produce new solutions
    
    nest_alt=zeros(n,size(nest(1).Position,2));
    
     for j=1:n
        nest_alt(j,:)=nest(j).Position;
    end
    
    % Discovered or not -- a status vector
        K=rand(size(nest_alt))>pa;
        % In the real world, if a cuckoo's egg is very similar to a host's eggs, then 
    % this cuckoo's egg is less likely to be discovered, thus the fitness should 
    % be related to the difference in solutions.  Therefore, it is a good idea 
    % to do a random walk in a biased way with some random step sizes.  
    % New solution by biased/selective random walks
     stepsize_local=rand*(nest_alt(randperm(n),:)-nest_alt(randperm(n),:));
     nest_alt=nest_alt+stepsize_local.*K;
     
     %Substuting new solutions in the nest Structure
    for k=1:n
        newnest(k).Position=nest_alt(k,:);
        newnest(k).Cost=MyCost(newnest(k).Position,model);
        
        % Apply Position Limits
        newnest(k).Position = max(newnest(k).Position,VarMin);
        newnest(k).Position = min(newnest(k).Position,VarMax);
       
        [~ , newnest(k).Sol]=MyCost(newnest(k).Position,model);
    end
        


end

