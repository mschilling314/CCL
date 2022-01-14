function finsets = munion(setosets,x,y)
%munion Unions two arrays within a cell array given their indices 
%   Takes the indices of the arrays within the cell arrays, unifies, and
%   flattens.
tempa = setosets{1,x};
tempb = setosets{1,y};

tempa = [tempa, tempb];
setosets(1,x) = {tempa};
if x ~=y
    setosets(:,y) = [];
end
finsets = setosets;
end

