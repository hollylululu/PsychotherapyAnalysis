%% Analyze performance of labeled topic model

addpath( 'etl', 'utils'); 

whsims  = [ 8 ]; % which simulation2
whps    = [ 1:10 ]; % which partitions?
chain   = 1;
prcs = [ .95 .9 0.8]; % percentile of top tag turns we want to look at 
whlabelset = 1;
mintoks = 0; % 5!!! % minimum number of tokens per talk turn (after preprocessing) for talk turn to be included in evaluation
computeprecision = 1; 

nsims = length( whsims );
np = length( whps ); % number of partitions

seed = 1;
rng( seed );

if whlabelset == 1
    filename = 'labelTagCorrespondance zi 2.xlsx';
    aggregateinfo = generateAggregateInfo(filename);
elseif whlabelset == 2
    aggregateinfo = { { 'anger'          , { 'anger' }} , ...
        { 'anxiety'        , { 'anxiety','autonomy (personality)'}} , ...
        { 'depression'     , { 'depression' , 'exhaustion' , 'suicidal behavior' , 'fatigue' , 'depressive disorder' }} , ...
        { 'low self-esteem', { 'low self-esteem' , 'adequacy' , 'self-confidence' , 'dejection' }} , ...
        { 'suicidal behavior',{'suicidal behavior' , 'suicide' , 'cutting' } } };
elseif whlabelset == 3
    aggregateinfo = ...
        { { 'anger'          , { 'anger'             }} , ...
          { 'anxiety'        , { 'anxiety'           }} , ...
          { 'depression'     , { 'depression'        }} , ...
          { 'low self-esteem', { 'low self-esteem'   }} , ...
          { 'suicidal behavior',{'suicidal behavior', 'suicide' }}  };
end


%% Initialize pool of workers (speeds up AUC calculation)
nworkers =2;
p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    poolsize = 0;
else
    poolsize = p.NumWorkers;
end
if poolsize ~= nworkers
    fprintf( 'Starting up pool with %d workers\n' , nworkers );
    parpool( nworkers );
end

%% Load corpus (this structure will not change)
if ~exist( 'corpus1' , 'var' )
    corpus1 = loadcorpus;
end

for s=1:nsims
    %% Current simulation
    whsim = whsims( s );
    
   

    
    %% Load all data
    fprintf( '\n--------------------------------------------------------\n' );
    fprintf( 'Loading data for sim=%d\n' , whsim );
    fprintf( '--------------------------------------------------------\n\n' );
    for i=1:np
        whpartition = whps( i );
        %filenm = sprintf( '..\\lda_results\\labeledlda_s%d_c%d_p%d.mat' , whsim , chain , whpartition );
        %filenm = sprintf( 'lda_modelpreds\\labeledlda_s%d_c%d_p%d.mat' , whsim , chain , whpartition );
        filenm = fullfile('lda_modelpreds', sprintf( 'labeledlda_s%d_c%d_p%d.mat' , whsim , chain , whpartition ));
        
        %fprintf( 'Loading: %s\n' , filenm );
        S{ i } = load( filenm ); % 'whsim' , 'z' , 'sim' , 'traininginfo' , 'localcodingpreds' , 'sessionpreds' );
        if ~isfield( S{ i }.sim , 'trainingmode' )
            S{ i }.sim.trainingmode = 1;
        end
    end
    
    %% Get Params from one partition
    sim = S{ 1 }.sim;
    
     %% Extract n-grams and apply filters to remove bad ngrams
    if ~exist( 'corpus2' , 'var' ) | nsims>1
       corpus2 = extractngrams( corpus1 , sim.preprocessoption , 0 , sim.whspeaker );      
    end
        
    if sim.trainingmode == -1
        error( 'Not implemented yet' );
    end
    
    if sim.trainingmode >= 0
        %% Calculate rho's for model-human scores for locally tagged talk turns
        %[ rhos , rhos_pairwise, minrhos , maxrhos , tagginglabels  , rhos_alllabels] = calculaterhos( S );
        
%         fprintf( 'Correlations at talk turn level between local ratings and SINGLE target label [human reliability 95%% interval]\n' );
%         nc = length( rhos );
%         for j=1:nc
%             fprintf( '%20s = %3.3f %3.3f [%3.3f - %3.3f]\n' , tagginglabels{j} , rhos(j) , rhos_pairwise(j), minrhos(j) , maxrhos(j) );
%         end
%         fprintf( '\nAverage RHO = %3.3f %3.3f\n' , mean( rhos ), mean( rhos_pairwise ));
%         fprintf( '\n' );
                
        %% Show the AUC for local tagging
%         if sim.trainingmode >= 0 %== 1
%             [ rhos_agg , rhos_pairwise_agg, minrhos , maxrhos , tagginglabels , aucs , talkturns,ntt ] = calculaterhos_aggregate( S , aggregateinfo , corpus1 , corpus2 , prcs, mintoks );
%             
%             fprintf( 'Local Talk turn results:\n' );
%             fprintf( 'AUC 5%% | AUC 10%% | Correlations at talk turn level | [human reliability 95%% interval]\n' );
%             nc = length( rhos_agg );
%             for j=1:nc
%                 fprintf( '%20s (%3d talk turns)= %3.3f %3.3f %3.3f %3.3f [%3.3f - %3.3f]\n' , tagginglabels{j} , ntt(j) , aucs(1,j), aucs(2,j) , rhos_agg(j) , rhos_pairwise_agg(j), minrhos(j) , maxrhos(j) );
%             end
%             fprintf( '\nAverage RHO = %3.3f %3.3f\n' , mean( rhos_agg ), mean( rhos_pairwise_agg ));
%             fprintf( '\nAverage Talk Turn AUC %3.3f Percentile= %3.3f\n' ,[prcs' mean( aucs ,2)]');
%             fprintf( '\n' );
%             
% %             fprintf( 'Show most likely talk turns:\n' );
% %             nshow = 15;
% %             for j=1:nc
% %                 fprintf( 'Most likely talk turns for %s\n' , upper( tagginglabels{j} ));
% %                 for k=1:nshow
% %                      talkturn = talkturns{ j }{ k };
% %                      fprintf( '\t%s\n' , talkturn );
% %                 end
% %             end
%         end
        
        %% Show the Precision for local tagging
        if sim.trainingmode >= 0 %== 1
            [ tagginglabels , aggprec , pwprec , rlprec , talkturns,ntt ] = calculateprecision_aggregate( S , aggregateinfo , corpus1 , corpus2 , prcs, mintoks, computeprecision );
            nc = size( aggprec , 2 );
            fprintf( 'Local Talk turn results:\n' );
            fprintf( 'Model to Average Rating comparison:\n' );
            fprintf( 'Precision 5%% | Precision 10%% | Precision 20%% | [human reliability 95%% interval]\n' );
            for j=1:nc
                fprintf( '%20s (%3d talk turns)= %3.3f %3.3f %3.3f\n' , tagginglabels{j} , ntt(j) , aggprec(1,j), aggprec(2,j) , aggprec(3,j)  );
            end
            fprintf( '\n' );
            
            fprintf( 'Local Talk turn results:\n' );
            fprintf( 'Model to Individual Rater comparison:\n' );
            fprintf( 'Precision 5%% | Precision 10%% | Precision 20%% | [human reliability 95%% interval]\n' );
            for j=1:nc
                fprintf( '%20s (%3d talk turns)= %3.3f %3.3f %3.3f\n' , tagginglabels{j} , ntt(j) , pwprec(1,j), pwprec(2,j) , pwprec(3,j)  );
            end
            fprintf( '\n' );
            
            fprintf( 'Human Reliability:\n' );
            fprintf( 'Individual to Individual Rater comparison:\n' );
            fprintf( 'Precision 5%% | Precision 10%% | Precision 20%% | [human reliability 95%% interval]\n' );
            for j=1:nc
                fprintf( '%20s (%3d talk turns)= %3.3f %3.3f %3.3f\n' , tagginglabels{j} , ntt(j) , rlprec(1,j), rlprec(2,j) , rlprec(3,j)  );
            end
            fprintf( '\n' );
            
            fprintf( 'Show rating distribution:\n' );
            
            %%
            for j=1:nc
                % Get the raw ratings
                rawratings = S{1}.localcodingpreds.rating{j}.rawratings;
                rawratings = rawratings( : );
                rawratings = rawratings( ~isnan( rawratings ));
                counts = hist( rawratings , 1:7 );
                fprintf( '%s\t' , tagginglabels{j} );
                for b=1:7
                    fprintf( '%4.3f\t' , counts( b ) / sum( counts )); 
                end
                fprintf( '\n' );
            end
            
%             fprintf( 'Show most likely talk turns:\n' );
%             nshow = 15;
%             for j=1:nc
%                 fprintf( 'Most likely talk turns for %s\n' , upper( tagginglabels{j} ));
%                 for k=1:nshow
%                      talkturn = talkturns{ j }{ k };
%                      fprintf( '\t%s\n' , talkturn );
%                 end
%             end
        end
                
        %%
%         if ~isempty( rhos_alllabels )
%             % show the 5 labels that are most correlated to the ratings
%             for j=1:nc
%                 fprintf( '\nRating label: %s\n' , tagginglabels{ j } );
%                 rhosnow = rhos_alllabels( : , j );
%                 [ svals, sindex ] = sort( rhosnow , 1 , 'descend' );
%                 for k=1:10
%                     fprintf( '\t%35s: %3.3f\n' , S{1}.labelsinfo.label{ sindex( k )} , svals( k ));
%                 end
%             end
%         end
        
        %% Calculate the AUCs for inferring labels at session level
        [ sessionprecs_pooled, sessionprecs_average, sessionaucs_pooled , sessionaucs_average , range_low , range_high, labels , labeltype , labeltypes , labelcount , sessionpreds ] = scoremodelsessionlevel3( S );
        
        %fprintf( 'Labeling Test Sessions Performance:\n' );
        fprintf( 'Average AUC pooled = %3.3f\n' , mean( sessionaucs_pooled ));
        fprintf( 'Average AUC average = %3.3f\n' , mean( sessionaucs_average ));
        fprintf( '\n' );
        
        % Plot the performance of average and pooled AUC
        figure( 1 ); clf;
        gray = [ 0.8 0.8 0.8 ];
        for t=1:2
            subplot( 1,2,t );
            wh = find( labeltype == t );
            
            nlnow = length( wh );
            aucnow_average = sessionaucs_average( wh );
            aucnow_pooled = sessionaucs_pooled( wh );
            labelsnow = labels( wh );
            rangelownow = range_low( wh );
            rangehighnow = range_high( wh );
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
            
            %barh( 1:nlnow , sorted );
            set( gca , 'YTick' , 1:nlnow );
            set( gca , 'YTickLabel' , labelsnow( index ));
            ylim( [ 0 nlnow+1 ] );
            xlim( [ 0.3 1 ] );
            title( labeltypes{ t } );
            xlabel( 'AUC (Pooled and Average)' );
            set( gca , 'FontSize' , 8 );
            plot( [ 0.5 0.5 ] , [ 0 nlnow+1 ] , 'r--' );
            legend( hnd , { 'Average' , 'Pooled'} );
        end
        
        
            
        %% Plot the performance of AUC (average)
        figure( 100 ); clf;
        for t=1:2
            subplot( 1,2,t );
            wh = find( labeltype == t );
            nlnow = length( wh );
            aucnow_average = sessionaucs_average( wh );
            labelsnow = labels( wh );
            [ sorted , index ] = sort( aucnow_average , 1 , 'ascend' );
            barh( 1:nlnow , sorted );
            set( gca , 'YTick' , 1:nlnow );
            set( gca , 'YTickLabel' , labelsnow( index ));
            ylim( [ 0 nlnow+1 ] );
            xlim( [ 0.5 1 ] );
            title( labeltypes{ t } );
            xlabel( 'AUC (average)' );
            set( gca , 'FontSize' , 8 );
        end
        
        %% Scatter of AUC vs. Number of Labels
        figure( 2 ); clf;
        plot( log10( labelcount ), sessionaucs_pooled , 'bo' );
        lsline;
        xlabel( 'log Number of labels' );
        ylabel( 'AUC' );
       
        %% Plot Rprecision average vs. pooled 
        figure( 1 ); clf;
        gray = [ 0.8 0.8 0.8 ];
        for t=1:2
            subplot( 1,2,t );
            wh = find( labeltype == t );
            
            nlnow = length( wh );
            precnow_average = sessionprecs_average( wh );
            precnow_pooled = sessionprecs_pooled( wh );
            labelsnow = labels( wh );
            rangelownow = range_low( wh );
            rangehighnow = range_high( wh );
            [ sorted , index ] = sort( precnow_average, 'ascend' );
            
            for ii=1:nlnow
                i = index( ii );
                
                minv = rangelownow( i );
                maxv = rangehighnow( i );
                
                
                h = plot( [ minv maxv ] , [ ii ii ] , 'k-' , 'LineWidth' , 3 ); hold on;
                set( h , 'Color' , gray );
                
                v = precnow_average( i );
                hnd(1)=plot( v , ii , 'bo' , 'LineWidth' , 2 ); hold on; 
                
                v = precnow_pooled( i );
                hnd(2)=plot( v , ii , 'rv' , 'LineWidth' , 2 ); hold on; 
            end
            
            %barh( 1:nlnow , sorted );
            set( gca , 'YTick' , 1:nlnow );
            set( gca , 'YTickLabel' , labelsnow( index ));
            ylim( [ 0 nlnow+1 ] );
            xlim( [ 0 1 ] );
            title( labeltypes{ t } );
            xlabel( 'Rprec(Pooled and Average)' );
            set( gca , 'FontSize' , 8 );
            plot( [ 0.5 0.5 ] , [ 0 nlnow+1 ] , 'r--' );
            legend( hnd , { 'Average' , 'Pooled'} );
        end
        
        %% Plot the performance of Rprecision
        figure( 100 ); clf;
        for t=1:2
            subplot( 1,2,t );
            wh = find( labeltype == t );
            nlnow = length( wh );
            precnow_pooled = sessionprecs_pooled( wh );
            labelsnow = labels( wh );
            [ sorted , index ] = sort( precnow_pooled , 1 , 'ascend' );
            barh( 1:nlnow , sorted );
            set( gca , 'YTick' , 1:nlnow );
            set( gca , 'YTickLabel' , labelsnow( index ));
            ylim( [ 0 nlnow+1 ] );
            xlim( [ min(sessionprecs_pooled) 1 ] );
            title( labeltypes{ t } );
            xlabel( 'Rprec (pooled)' );
            set( gca , 'FontSize' , 8 );
        end
       
    end
end
