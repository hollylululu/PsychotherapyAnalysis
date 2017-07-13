function [ h ] = countInstances( x, y)
% a function to count the number of times elements specified by y occur in
% the vector x
% contraints: y = unique(y) , implied => y = sort(y, 'ascend')

% if y ~= unique(y)
%    disp('y must be unique and sorted');
%    return;  
% end

x = sort(x); 

h = ones(size(y)); 
parfor i = 1:length(y)
    f = (x == y(i));
    h(i) = sum(f);
end

end

