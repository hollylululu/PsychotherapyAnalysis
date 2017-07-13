%% Logistic Regression
% Implements a LR Classifier for the general psychotherapy corpus
% Version 4: runs on exactly the same folds as the labeled LDA model

addpath('etl', 'utils');
tic;

if ispc 
    
else
    addAttachedFiles(gcp, {fullfile('liblinear-2.11/', 'matlab', 'train.mexmaci64'), ...
        fullfile('liblinear-2.11/', 'matlab', 'predict.mexmaci64')}); 
end
%% Params
whs = 6; 

if (whs==1)
    whsim           = 8; % set to our 'best' performing labeled topic model simulation
    np              = 10;
    lrmodel         = 6; % which LR code? 0,2, or 7
    donorm          = 1;
    Cconst          = 1; % regularization constant for liblinear solver
    lambda          = 0.01;
    doliblinear     = 1;
    
%Average AUC pooled = 0.581
%Average AUC average = 0.590

end

if (whs==2)
    whsim           = 8; % set to our 'best' performing labeled topic model simulation
    np              = 10;
    lrmodel         = 0; % which LR code? 0,2, or 7
    donorm          = 1;
    Cconst          = 1; % regularization constant for liblinear solver
    lambda          = 0.1;
    doliblinear     = 1;
    
    %Average AUC pooled = 0.563
    %Average AUC average = 0.576
end

if (whs==3)
    whsim           = 8; % set to our 'best' performing labeled topic model simulation
    np              = 10;
    lrmodel         = 6; % which LR code? 0,2, or 7
    donorm          = 1;
    Cconst          = 0.1; % regularization constant for liblinear solver
    lambda          = 0.001;
    doliblinear     = 1;
    
    %Average AUC pooled = 0.525
    %Average AUC average = 0.539
end

if (whs==4)
    whsim           = 8; % set to our 'best' performing labeled topic model simulation
    np              = 10;
    lrmodel         = 6; % which LR code? 0,2, or 7
    donorm          = 1;
    Cconst          = 10; % regularization constant for liblinear solver
    lambda          = 0.001;
    doliblinear     = 1;
    
    %Average AUC pooled = 0.575
    %Average AUC average = 0.585
end

if (whs==5)
    whsim           = 8; % set to our 'best' performing labeled topic model simulation
    np              = 10;
    lrmodel         = 6; % which LR code? 0,2, or 7
    donorm          = 1;
    Cconst          = 10; % regularization constant for liblinear solver
    lambda          = 0.0001;
    doliblinear     = 0;
    
    %Average AUC pooled = xx
    %Average AUC average = xx
end

if (whs==6)
    whsim           = 8; % set to our 'best' performing labeled topic model simulation
    np              = 40;
    lrmodel         = 6; % which LR code? 0,2, or 7
    donorm          = 1;
    Cconst          = 1; % regularization constant for liblinear solver
    lambda          = 0.01;
    doliblinear     = 1;
    
%Average AUC pooled = 0.580
%Average AUC average = 0.589

end

%% Load corpus (this structure will not change)
if ~exist( 'traininginfo' , 'var' )
    corpus1 = loadcorpus;
        
    %% Set params of simulation
    [ sim ] = setsimulationparams( whsim );
    
    %% Extract n-grams and apply filters to remove bad ngrams
    %if ~exist( 'corpus2' , 'var' )
    corpus2 = extractngrams( corpus1 , sim.preprocessoption , 0 , sim.whspeaker );
    
    %% Create a structure with information about labels and session
    % overwrite corpus2 because some sessions in the original corpus don't
    % have label information in the metadata -- these are removed in the
    % updated version of corpus2
    [ corpus2 , sessioninfo , labelsinfo_temp ] = loadlabels( corpus2 , sim.minsessfreq );
    
    %% Extract the ratings for local talk turns (from a separate ratings experiment by Imel)
    [ localcoding ] = loadlocalcodes( labelsinfo_temp , corpus1 , 0 );
    
    %% Add background labels
    [ labelsinfo ] = addbackgroundlabels( labelsinfo_temp , sim.T );
    
    %% Define documents in vector docid
    if sim.docdef==1 % define documents by session id
        sessionid_orig = double( corpus2.T.sessionid_orig );
        [ usessionid , ~ , docid ] = unique( sessionid_orig );
    elseif sim.docdef==2 % define documents by talk turn
        docid = corpus2.T.talkturnid;
    end
    
    % Extract the word id's
    wordid = corpus2.T.ngramid;
    
    % Extract the session id's
    sessionid = corpus2.T.sessionid;
    
    % Extract the vocab
    vocab = corpus2.ngrams;
    nw = length( vocab );
    
    % Calculate the NWORDTYPES vector
    nwordtypes = calculatewordcounts( labelsinfo.labelmatrix, wordid , sessionid , nw );
    
    
end

% Do a train/test split
if (np==10)
    for i=1:np
        [ traininginfo{ i } ] = traintestsplit( localcoding, sim.seed, sim.trainingmode, corpus2, i );
    end
else
    for i=1:np
        seed = ceil( i / 10 );
        whp  = mod( i-1 , 10 )+ 1;
        [ traininginfo{ i } ] = traintestsplit( localcoding, seed, sim.trainingmode, corpus2, whp  );
    end
end

%% Aggregate the labeled LDA model predictions over all test sessions
% Get the label-session matrix
labelmatrix = labelsinfo.labelmatrix;
ns = size( labelmatrix , 2 ); % number of sessions
nl = size( labelmatrix , 1 ); % number of labels

% Find the labels that are not the background
noklabels = nl - sim.T;
labelmatrix = labelmatrix( 1:noklabels , : );
labels = labelsinfo.label( 1:noklabels );
labeltype = labelsinfo.labeltype( 1:noklabels );
labeltypes = labelsinfo.labeltypes;

nl = noklabels;

%% Count the number of labels across sessions
labelcount = full( sum( labelmatrix , 2 ));

%% Now score the model per label
sessionaucs_pooled = zeros(nl,1);
sessionaucs_average = zeros(nl,1);
sessionaucs_interval1 = zeros(nl,1);
sessionaucs_interval2 = zeros(nl,1);

%sessionid = corpus2.T.sessionid;

fprintf( 'Calculating AUCs for each label...\n' );
for i=1:nl
    truelabels = full( labelmatrix( i , : ));
    label = labels{ i };
    %fprintf( 'Working on label: %s\n' , label );
    
    % loop over folds
    alloutcomes = [];
    alloutcomes_random = [];
    allscores = NaN( ns , 1 );
    scores_now = 0;
    warning off;
    parfor j=1:np
        % find the train sessions and test sessions
        testSess  = traininginfo{ j }.testsessions';
        trainSess = traininginfo{ j }.trainsessions';
        
        whtesttokens = find( ismember( sessionid , testSess ));
        testSet     = corpus2.T( whtesttokens,:);
        
        whtraintokens = find( ismember( sessionid , trainSess ));
        trainingSet     = corpus2.T( whtraintokens,:);
        
        istesttoken = find( traininginfo{ j }.istesttoken == 1);
        
        % extract n-grams for training and test sets
        sid = trainingSet.sessionid;
        [ usid , dum , newsid ] = unique( sid );
        wordid = trainingSet.ngramid;
        
        nw = length( corpus2.ngrams );
        nd = double( max( newsid ));
        CTrain = sparse( double(newsid) , double(wordid) , ones(size(sid)) , nd , nw ); % word count matrix of training data
        
        sid = testSet.sessionid;
        [ usid , dum , newsid ] = unique( sid );
        wordid = testSet.ngramid;
        nd = double( max( newsid ));
        CTest = sparse( double(newsid) , double(wordid) , ones(size(sid)) , nd , nw ); % word count matrix of test data
        
        % Do we normalize?
        if (donorm==1)
            mylog = @( x ) log( x + 1 );
            CTrain = spfun( mylog , CTrain ); 
            CTest  = spfun( mylog , CTest  ); 
        end
        
        
        % Get the labels for training and test sets
        YTrain = truelabels( trainSess )' * 2 - 1;
        YTest  = truelabels( testSess )'  * 2 - 1;
        
        %fprintf('\tPartition %d (n_train=%d n_test=%d)\n',j,sum( YTrain==1 ),sum( YTest==1 ));
        if (doliblinear==1)
            % Run the LR model
            modelparams = sprintf('-s %d -q -c %f -B 1', lrmodel , Cconst);
            model = train( YTrain,CTrain, modelparams);
            % Get the predictions for test set
            [predicted_label, accuracy, prob_estimates] = predict(YTest, CTest, model, '-b 1 -q');
            scores_now = prob_estimates(:,1);
            
            % List features
            %[ sw , sindex ] = sort( model.w(1:end-1) , 2 , 'descend' );
            %vocab( sindex(1:20) )'
        end
        
        if (doliblinear==0)
            
            [B,FitInfo] = lassoglm(CTrain,logical( YTrain == 1 ),'binomial', 'Lambda', lambda);  % 'NumLambda',10,'CV',10);
            cnst = FitInfo.Intercept;
            B1 = [cnst;B];
            scores_now = glmval(B1,CTest,'logit');
        end
        
        allscores_temp{ j } = scores_now;
        
        % Calculate the pairwise outcomes for the actual data
        [ outcomes, accuracy_fold ] = forcepredict4( YTest, scores_now, -1 , 1 , 1 , 1000 );
        alloutcomes = [ alloutcomes outcomes(:)' ];
        
        % Calculate the pairwise outcomes for the random data
        [ outcomes_random, accuracy_fold_random ] = forcepredict4( YTest, scores_now, -1 , 1 , 2 , 1000 );
        alloutcomes_random = [ alloutcomes_random outcomes_random ];
        
    end
    warning on;
    
    for j=1:np
        testSess  = traininginfo{j}.testsessions';
        allscores( testSess ) = allscores_temp{ j };
    end
    
    [X,Y,T,AUC_pooled] = perfcurve( truelabels,allscores,1);
    sessionaucs_pooled( i ) = AUC_pooled;
    
    % Calculate the average AUC
    AUC_average = mean( alloutcomes == 1 );
    sessionaucs_average( i ) = AUC_average;
    
    % calculate the 95% confidence interval
    auc_random = mean( alloutcomes_random , 2 );
    pr = prctile( auc_random, [ 5 95 ] );
    sessionaucs_interval1(i) = pr( 1 );
    sessionaucs_interval2(i) = pr( 2 );
    
    fprintf( '%35s n=%3d AUC pooled=%3.3f average=%3.3f (%3.3f-%3.3f)\n' , label , sum( truelabels) , AUC_pooled , AUC_average ,sessionaucs_interval1(i),sessionaucs_interval2(i));
end

fprintf( 'Average AUC pooled = %3.3f\n' , mean( sessionaucs_pooled ));
fprintf( 'Average AUC average = %3.3f\n' , mean( sessionaucs_average ));
fprintf( '\n' );

%% Plot the performance of average and pooled AUC
figure( 1 ); clf;
gray = [ 0.8 0.8 0.8 ];
for t=1:2
    subplot( 1,2,t );
    wh = find( labeltype == t );
    
    nlnow = length( wh );
    aucnow_average = sessionaucs_average( wh );
    aucnow_pooled = sessionaucs_pooled( wh );
    labelsnow = labels( wh );
    rangelownow = sessionaucs_interval1( wh );
    rangehighnow = sessionaucs_interval2( wh );
    [ sorted , index ] = sort( aucnow_average , 1 , 'ascend' );
    
    for ii=1:nlnow
        i = index( ii );
        
        minv = rangelownow( i );
        maxv = rangehighnow( i );
        
        
        h = plot( [ minv maxv ] , [ ii ii ] , 'k-' , 'LineWidth' , 3 ); hold on;
        set( h , 'Color' , gray );
        
        v = aucnow_average( i );
        hnd(1)=plot( v , ii , 'bo' , 'LineWidth' , 2 ); hold on;
        
        v = aucnow_pooled( i );
        hnd(2)=plot( v , ii , 'rv' , 'LineWidth' , 2 ); hold on;
    end
    
    if (t==1)
        range = 1:3:nlnow;
        set( gca , 'YTick' , range );
        set( gca , 'YTickLabel' , labelsnow( index( range )));
    else
        set( gca , 'YTick' , 1:nlnow );
        set( gca , 'YTickLabel' , labelsnow( index ));
    end
    
    ylim( [ 0 nlnow+1 ] );
    xlim( [ 0.3 1 ] );
    title( labeltypes{ t } );
    xlabel( 'AUC (Pooled and Average)' );
    set( gca , 'FontSize' , 8 );
    plot( [ 0.5 0.5 ] , [ 0 nlnow+1 ] , 'r--' );
    legend( hnd , { 'Average' , 'Pooled'} );
end

%%
lrs.sessionaucs_interval1 =  sessionaucs_interval1; 
lrs.sessionaucs_interval2 =  sessionaucs_interval2; 
lrs.sessionaucs_average   =  sessionaucs_average; 
lrs.sessionaucs_pooled    =  sessionaucs_pooled; 
lrs.labels                =  labels; 
lrs.labeltype             =  labeltype; 

filenm = fullfile( 'lrresults', sprintf( 'lr_m%d.mat' , whs );
save( filenm , 'lrs' );
