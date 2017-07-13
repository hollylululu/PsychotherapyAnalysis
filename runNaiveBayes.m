%% NAIVE BAYES CLASSIFIER
%Implements a Naive Bayes Classifier for the general psychotherapy corpus

addpath('etl', 'utils'); 
%% Params
% whsim = 8; % set to our 'best' performing labeled topic model simulation
% output          = 1;
% writefreqngrams = 0;
% showexamples    = 0;
% performancetype = 1; % changes how we look at performance 1 = predicting documents for labels,
% %2 = predicting labels for documents-doesn't need normalization at text phase
% 
% %% load data
% if ~exist( 'corpus1' , 'var' )
%     corpus1 = loadcorpus;
% end
% 
% % get paramaters for simulation 8
% [ sim ] = setsimulationparams( whsim );
% 
% %PreProcessing
% load('corpus2.mat');  % QUICKER load data, saved for sim 8
% % corpus2 = extractngrams( corpus1 , sim.preprocessoption , writefreqngrams , sim.whspeaker );
% 
% 
% %load label data
% [ corpus2 , sessioninfo , labelsinfo_temp ] = loadlabels( corpus2 , sim.minsessfreq );
% labelsinfo = labelsinfo_temp;
% 
% % load local coding data
% %[ localcoding ] = loadlocalcodes( labelsinfo , corpus1 , showexamples );
% 
%extract label matrix and size information
labelmatrix = labelsinfo.labelmatrix;
ndocs = size(labelmatrix,2);

%% Cross Validation (write function)
k = 10;
docTopScores = zeros(size(labelmatrix'));
cvp = cvpartition(size(labelmatrix,2), 'kfold', k);
for cvi = 1:10
    fprintf('Partition %d,',cvi);
    trainSess = labelsinfo.sessionid_orig(cvp.training(cvi));
    testSess = labelsinfo.sessionid_orig(cvp.test(cvi));
    trainingSet = corpus2.T(ismember(table2array(corpus2.T(:,2)), trainSess),:);
    testSet = corpus2.T(ismember(table2array(corpus2.T(:,2)), testSess),:);
    
    % training  (training set is a table)
    fprintf('Training...');
    [ wordTopDist,priors, vocab ] = trainNaiveBayes( labelsinfo, trainingSet );
    
    % testing
    fprintf('Testing...\n');
    [ docTopPartialScores] =  testNaiveBayes( wordTopDist, priors, vocab,  testSet);
    
    docTopScores(cvp.test(cvi), :) = docTopPartialScores;
end

%%
aucScores = zeros(size(docTopScores,2),1);
fprintf('Caclulating AUC...\n');
for i = 1:length(aucScores)
    if performancetype ==1
        [X,Y,T,AUC] = perfcurve(full(labelmatrix(i,:)),docTopScores(:,i)',1);
    elseif performancetype == 2
        [X,Y,T,AUC] = perfcurve(full(labelmatrix(i,:)),docTopScores(:,i)',1);
    end
    %perfcurve(full(labelmatrix(i,:)),docTopScores(:,i)',1);
    aucScores(i) = AUC;
end

mean(aucScores)

save('docTopScores', 'docTopScores');
