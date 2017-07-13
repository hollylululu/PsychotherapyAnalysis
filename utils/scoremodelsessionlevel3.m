function [ sessionprecs_pooled, sessionprecs_average, sessionaucs_pooled , sessionaucs_average, sessionaucs_interval1, sessionaucs_interval2 , labels , labeltype , labeltypes , labelcount , sessionpreds ] = scoremodelsessionlevel3( S )
%% Calculate pooled and average AUCs for session labeling task


%% Aggregate the model predictions over all test sessions
% Get the label-session matrix
labelmatrix = S{1}.labelsinfo.labelmatrix;
ns = size( labelmatrix , 2 ); % number of sessions
nl = size( labelmatrix , 1 ); % number of labels
np = length( S ); % number of files
sessionpreds = NaN( nl, ns );
whfold = NaN( 1 , ns );
%for i=1:npperf
for i=1:np
    sessionpred = S{ i }.sessionpreds.preds;
    whok = find( ~isnan( sessionpred(:,1)));
    sessionpreds( : , whok ) = sessionpred( whok , : )'; 
    whfold( whok ) = i; % save the fold
end
% Find the sessions with no model predictions
oksessions = find( ~isnan( sessionpreds(1,:)));
labelmatrix = full( labelmatrix( : , oksessions ));
sessionpreds = sessionpreds( : , oksessions );
whfold = whfold( oksessions );

% Find the labels that are not the background
noklabels = nl - S{1}.sim.T;
labelmatrix = labelmatrix( 1:noklabels , : );
sessionpreds = sessionpreds( 1:noklabels , : );
labels = S{1}.labelsinfo.label( 1:noklabels );
labeltype = S{1}.labelsinfo.labeltype( 1:noklabels );
labeltypes = S{1}.labelsinfo.labeltypes;

nl = noklabels;

%% Count the number of labels across sessions
labelcount = sum( labelmatrix , 2 );

%% Now score the model per label
sessionaucs_pooled = zeros(nl,1);
sessionaucs_average = zeros(nl,1);
sessionaucs_interval1 = zeros(nl,1);
sessionaucs_interval2 = zeros(nl,1);
sessionprecs_pooled = zeros(nl,1); 

fprintf( 'Calculating AUCs for each label...\n' );
for i=1:nl
    scores = sessionpreds( i , : );
    if any( isnan( scores ))
        1==1;
    end
    truelabels = labelmatrix( i , : );   
    
    %% Calculate the pooled AUC
    [X,Y,T,AUC_pooled] = perfcurve( truelabels,scores,1);
    sessionaucs_pooled( i ) = AUC_pooled;
    label = labels{ i };
    
    %% Calculate pooled precision
    [~, idx] = sort(scores, 'descend'); 
    sorttruelabels = truelabels(idx); 
    sessionprecs_pooled(i) = mean(sorttruelabels(1:sum(truelabels)));
    
    %% Calculate average precision
    avprec = zeros(np,1); 
    for j = 1:np
        % get the predictions just for fold j
        wh = find( whfold == j );
        scores_now = scores( wh );
        truelabels_now = truelabels( wh );
        
        % calculate precision 
        [~, idx] = sort(scores_now, 'descend'); 
        sorttruelabels = truelabels_now(idx); 
        avprec(j) = mean(sorttruelabels(1:sum(truelabels_now)));
    end
    sessionprecs_average( i ) = nanmean(avprec); 
    
    %% Calculate the average AUC
    alloutcomes = [];
    alloutcomes_random = [];
    for j=1:np % loop over the folds
        % get the predictions just for fold j
        wh = find( whfold == j );
        scores_now = scores( wh );
        truelabels_now = truelabels( wh );
        
        % Calculate the pairwise outcomes for the actual data 
        [ outcomes, accuracy_fold ] = forcepredict4( truelabels_now, scores_now, 0 , 1 , 1 , 1000 );
        alloutcomes = [ alloutcomes outcomes ];
        
        % Calculate the pairwise outcomes for the random data 
        [ outcomes_random, accuracy_fold_random ] = forcepredict4( truelabels_now, scores_now, 0 , 1 , 2 , 1000 );
        alloutcomes_random = [ alloutcomes_random outcomes_random ];
    end
    AUC_average = mean( alloutcomes == 1 );
    sessionaucs_average( i ) = AUC_average;
    
    % calculate the 95% confidence interval
    auc_random = mean( alloutcomes_random , 2 );
    pr = prctile( auc_random, [ 5 95 ] );
    sessionaucs_interval1(i) = pr( 1 );
    sessionaucs_interval2(i) = pr( 2 );
    
    
    %fprintf( '%35s n=%3d AUC pooled=%3.3f average=%3.3f (%3.3f-%3.3f)\n' , label , sum( truelabels) , AUC_pooled , AUC_average ,sessionaucs_interval1(i),sessionaucs_interval2(i));
end
1==1;