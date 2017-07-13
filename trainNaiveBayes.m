function [wordTopDist,prior,vocab ] = trainNaiveBayes( labelsinfo, trainingSet )
%function to train naive bayes on training data


labelmatrix = labelsinfo.labelmatrix;
nlabels = size(labelmatrix,1); % number of labels
vocab = unique(table2array(trainingSet(:,5)));
nwords = length(vocab); % number of total words
trainSess = table2array(unique(trainingSet(:,2)));
ndocs = length(trainSess);% number of documents
CWT = zeros(max(vocab), nlabels);



denom = zeros(1,nlabels); % denominator of count matrix
prior = zeros(1,nlabels);  % prior for each label

for i = 1:nlabels
    
    %Aggregate Text
    sessionids = labelsinfo.sessionid_orig(find(labelmatrix(i,:)==1)); % get which sessions have label turned on
    text = table2array(trainingSet(ismember(table2array(trainingSet(:,2)), sessionids),5)); % get all text in which a given label is activated
    prior(i) = sum(ismember(sessionids, trainSess))/ndocs; % prior is ratio of documents with label to total documents in training session
    
    % calculate count matrix and denominator
    h = countInstances(text, vocab);
    CWT(vocab, i) = h;
    denom(i) = sum(CWT(:,i));
    
    
end

wordTopDist = (CWT + ones(size(CWT)))./repmat(denom + nwords, max(vocab),1); % calculate joint density from count matrix and denominator (with smoothing)
toDel = find(~ismember(1:max(vocab), vocab));  % set some word probabilities to 0, (not necessary, but makes code more intuitive)
wordTopDist(toDel, :) = zeros(length(toDel), nlabels);


end

