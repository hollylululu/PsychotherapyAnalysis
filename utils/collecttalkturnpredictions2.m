function [ localcodingpreds ] = collecttalkturnpredictions2( avp , localcoding , traininginfo )
%% Collect the output from the labeled topic model and average at the level of talk turns 
% Version 2 -- also collect talk turn model predictions for ALL labels --
% not just the target label
%
% traininginfo = 
%     trainsessions: [1072x1 double]
%      testsessions: [109x1 double]
%       istesttoken: [1043165x1 uint8]
%        talkturnid: [111906x1 uint32]
%         sessionid: [111906x1 uint32]

% localcoding = 
%     rating: {[1x1 struct]  [1x1 struct]  [1x1 struct]  [1x1 struct]  [1x1 struct]}
%     coders: {'AD'  'BP'  'DD'  'MS'  'RM'  'AC'  'LZ'}
%      avrho: [0.7021 0.3909 0.5392 0.5154 0.6395]
%     stdrho: [0.0873 0.0806 0.0965 0.0936 0.1370]
%       nrho: [10 10 10 10 10]
%        prc: [2x5 double]
%     allwht: [982x1 double]

%% Copy structure
localcodingpreds = localcoding;

% how many labels do we have?
nf = length( localcodingpreds.avrho );

% go through each label
for f=1:nf
%     ratings = 
%        whlabel: 164
%          label: 'anger'
%            wht: [197x1 double]
%      avratings: [197x1 double]
%     rawratings: [197x7 double]
    
     
    ratings = localcodingpreds.rating{ f }; 
    
    % Index of the label
    whlabel = ratings.whlabel;
    
    % Indices of talk turns corresponding to ratings
    wht = ratings.wht;
    ntt = length( wht );
    
    % find the test tokens associated with these talk turns
    [ ismem , whloc ] = ismember( traininginfo.talkturnid , wht );  
    whtoks        = find( ismem == 1 );
    talkturnindex = whloc( ismem == 1 );
        
    % Extract the probabilities for these tokens and for this particular
    % label
    avp2   = avp( whtoks , whlabel );
    
    % Calculate the average -- this is the model's prediction
    pred = accumarray( talkturnindex , avp2 , [ ntt 1 ] , @mean , NaN );    
    localcodingpreds.rating{ f }.pred = pred;
    
    % Compare this to the average rating
    avratings = ratings.avratings;
    RHO = corrcoef( [ pred avratings ] , 'rows' , 'pairwise' );
    
    localcodingpreds.modelrho( f ) = RHO(1,2); 
    
    % Calculate the model predictions for all labels
    nl = size( avp , 2 );
    localcodingpreds.rating{ f }.allpreds = NaN( ntt , nl , 'single' );
    
    for j=1:nl
        avp2   = avp( whtoks , j );        
        pred = accumarray( talkturnindex , avp2 , [ ntt 1 ] , @mean , NaN );
        localcodingpreds.rating{ f }.allpreds( : , j ) = pred;
    end
end