function [ sessionpreds ] = collectsessionpredictions( avp , labelsinfo , traininginfo )
%% Collect the output of the labeled topic model for the test sessions
    

% traininginfo = 
%     trainsessions: [1072x1 double]
%      testsessions: [109x1 double]
%       istesttoken: [1043165x1 uint8]
%        talkturnid: [111906x1 uint32]
%         sessionid: [111906x1 uint32]

% labelsinfo = 
%              label: {215x1 cell}
%         labeltypes: {'Subject'  'Symptom'  'Background'}
%          labeltype: [215x1 double]
%        labelmatrix: [215x1181 double]
%     sessionid_orig: [1181x1 uint32]

%% Number of sessions
ns = size( labelsinfo.labelmatrix , 2 );
nl = size( labelsinfo.labelmatrix , 1 );

%% Get the session indices
sessionid = traininginfo.sessionid;

% find the tokens that are part of the test set
wh = find( ismember( sessionid , traininginfo.testsessions ));

sessionid = sessionid( wh );
avp       = avp( wh , : );

sessionpreds.preds = zeros( ns , nl );

for l=1:nl
    pred = accumarray( sessionid , avp(:,l) , [ ns 1 ] , @mean , NaN );
    sessionpreds.preds( : , l ) = pred;
end

