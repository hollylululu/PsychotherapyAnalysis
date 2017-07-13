function [ traininginfo ] = traintestsplit( localcoding, seed, trainingmode, corpus2, whpartition )
%% Do a train/test split of the sessions and talk turns
%
% trainingmode=-1: no test tokens; 
% trainingmode=0:  cross-validate sessions; locally rated talk turns have OBSERVED labels; 
% trainingmode=1:  cross-validate sessions; locally rated talk turns have NO observed labels 

% istesttoken = 0: this token has only the observed labels enabled; do not collect the
% predictions of p( topic | token )

% istesttoken = 1: this token has ALL labels enabled; DO collect the
% predictions of p( topic | token )

% istesttoken = 2: this token has only the observed labels enabled; DO collect the
% predictions of p( topic | token )


% labelsinfo = 
%              label: {215x1 cell}
%         labeltypes: {'Subject'  'Symptom'  'Background'}
%          labeltype: [215x1 double]
%        labelmatrix: [215x1181 double]
%     sessionid_orig: [1181x1 uint32]

% localcoding = 
%     rating: {[1x1 struct]  [1x1 struct]  [1x1 struct]  [1x1 struct]  [1x1 struct]}
%     coders: {'AD'  'BP'  'DD'  'MS'  'RM'  'AC'  'LZ'}
%      avrho: [0.7021 0.3909 0.5392 0.5154 0.6395]
%     stdrho: [0.0873 0.0806 0.0965 0.0936 0.1370]
%       nrho: [10 10 10 10 10]
%        prc: [2x5 double]
%     allwht: [982x1 double]


% Session indices
sessionid = corpus2.T.sessionid;
NS = max( sessionid ); % number of sessions
ntokens = length( sessionid );

% Find the talk turns that have any information about locally tagged labels
ratedtalkturns = localcoding.allwht;

% Find the tokens corresponding to these talk turns
whtokens = find( ismember( corpus2.T.talkturnid , ratedtalkturns ));

% And assign these as test tokens
istesttoken = zeros( ntokens , 1 );
if trainingmode == 0 
    istesttoken( whtokens ) = 2;
end
if trainingmode == 1 
    istesttoken( whtokens ) = 1;
end

% Find the unique sessions of these talk turns
insessions = unique( sessionid( whtokens ));

rng( seed );

if trainingmode<0
    % don't do anything else
    trainsessions  = (1:NS)';
    testsessions   = [];
else
    nfolds = 10;
    cv = cvpartition(NS,'kfold',nfolds);
    
    trainsessions  = find( cv.training( whpartition ));
    testsessions   = find( cv.test( whpartition ));
    ntrainsessions = length( trainsessions );
    ntestsessions  = length( testsessions );
    
    % find the sessions in the test set that overlap with the sessions with
    % locallly rated talk turns
    overlap = intersect( testsessions , insessions );
    
    % Add these sessions to the training set
    trainsessions = double( [ trainsessions; overlap ] );
    
    % And subtract them from the test set
    testsessions = setdiff( testsessions , overlap );
    
    % Find the sessions corresponding to test sessions
    whtokens = find( ismember( sessionid , testsessions ));
    
    % And assign them to the test set
    istesttoken( whtokens ) = 1;
end

traininginfo.trainsessions = trainsessions;
traininginfo.testsessions  = testsessions;
traininginfo.istesttoken   = uint8( istesttoken );
traininginfo.talkturnid    = uint32( corpus2.T.talkturnid( istesttoken > 0 ));
traininginfo.sessionid     = uint32( corpus2.T.sessionid( istesttoken > 0 ));



