function [ docTopScores ] = testNaiveBayes( wordTopDist, prior, vocab, testSet)
%function to calculate estimated joint probability distribution of
%documents and topics


%get rid of words not in the vocabulary
testSet = table2array(testSet(ismember(table2array(testSet(:,5)), vocab), [2 5]));  %COLUMNS FOR TABLE ARE CHANGING: 1 = sessionid, 2 = ngramid

sessionids = unique(testSet(:,1)); %% get session ids
ndocs = size(sessionids,1); % number of documents
nlabels = size(wordTopDist, 2); % number of labels
docTopScores = zeros(ndocs, nlabels); % topic document scores

lpriors = log(prior); % convert prior to log scale

for i = 1:ndocs
    tokens = testSet(ismember(testSet(:,1), sessionids(i)),2); % get word tokens from each document
    
    
    h = countInstances(tokens,vocab);
    for j = 1:nlabels
        p = log(wordTopDist(vocab,j)).*h; % get log probability of word token occuring under label j ( log of [ word probability *word token count] )
        docTopScores(i,j) = lpriors(j) + sum(p) / length( tokens );
    end
    
    
    %LOG SUM EXP TRICK
    %m = max(docTopScores(i,:));
    %d = exp(docTopScores(i,:) - m);
    %l = m + log(sum(d));
    %docTopScores(i,:) = docTopScores(i,:) - l;
    
end
end




