function [ Agg ] = generateAggregateInfo( filename)
%UNTITLED7 Function to load an excel file of label correspondances with
%global tags

T = readtable(filename); % load file into table
labels = table2cell(T(:,1)); % we get cell arrays of the labels and the columns indicating correspondance with an 'x'
X = table2cell(T(:,2:end));

Agg = cell(5,1);
Agg{1} = {'anger', labels(~strcmp(X(:,1),''))'};
Agg{2} = {'anxiety', labels(~strcmp(X(:,2),''))'};
Agg{3} = {'depression', labels(~strcmp(X(:,3),''))'};
Agg{4} = {'low self-esteem', labels(~strcmp(X(:,4),''))'};
Agg{5} = {'suicidal behavior', labels(~strcmp(X(:,5),''))'};

for i = 1:5
    a = Agg{i}{2};
    temp = cellstr(a(1));
    ind = strcmp(Agg{i}{1},a);
    a(1) = a(ind);
    a(ind) = temp;
    Agg{i}{2}= a;
end

Agg = Agg';

% if display == 1
%     l = max(sum(~strcmp(X,''),1));
%     for i = 1:l
%         
%     end
% end
end

