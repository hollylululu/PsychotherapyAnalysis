function [ tagginglabels , aggprecisions ,pwprecisions,rlprecisions,str,ntt ] = calculateprecision_aggregate( S , aggregateinfo , corpus1 , corpus2 , prcs, mintoks, computeprecision )
%% Calculate precision for model-human scores for locally tagged talk turns

%% Aggregate the model predictions for the locally tagged talk turns
nc = length( S{ 1 }.localcodingpreds.modelrho ); % Number of labels in tagging experiment 
np = length( S );

% calculate number of labels per session
countlabels = full( sum( S{1}.labelsinfo.labelmatrix , 1 )); 

modelpred = cell( 1,nc );

% figure out label indices to aggregate over for each rating label
for j=1:nc
    ratinglabel = S{1}.localcodingpreds.rating{j}.label; 
    % check this matches the label in aggregate info
    agglabels = aggregateinfo{ j };
    if ~strcmp( agglabels{1} , ratinglabel )
        error( 'mismatch' );
    end
    agglabels = agglabels{2};
    % find the indices
    [ ismem , whloc ] = ismember( agglabels , S{1}.labelsinfo.label );
    if any( ismem == 0 )
        error( 'hmmm' );
    end
    targetlabels{ j } = whloc;
end

for i=1:np
    % these are the individual rho's (before aggregation)
    indrho = S{ i }.localcodingpreds.modelrho;
    
    % Average the model predictions
    for j=1:nc
        % Get the id's of talk turns
        wht = S{i}.localcodingpreds.rating{j}.wht;
        ntt = length( wht );
        
        
        predsnow = S{ i }.localcodingpreds.rating{j}.allpreds;
                
        % first aggregate over target labels
        predsnow = nanmean( predsnow( : , targetlabels{j} ) , 2 ); 
        
        if (i==1)
            modelpred{ j } = predsnow;
        else
            modelpred{ j } = modelpred{ j } + predsnow;
        end
        
        if (i==np)
            modelpred{ j } = modelpred{ j } / np;
        end
    end
end

%% Analyze the performance of the average model prediction
tagginglabels = cell( 1,nc );
aggprecisions = zeros(length(prcs),nc);
pwprecisions = zeros(length(prcs),nc);
rlprecisions = zeros(length(prcs),nc);

strings = '';
for j=1:nc
    % Compare model prediction to the average human rating
    avratings = S{1}.localcodingpreds.rating{j}.avratings;
    rawratings = S{1}.localcodingpreds.rating{j}.rawratings;
    allok = find( all( ~isnan( rawratings ) , 1 ));
    rawratings = rawratings( : , allok );
    nraters = length( allok );
    
    tagginglabels{j} = S{1}.localcodingpreds.rating{j}.label;
    pred = modelpred{ j };
    
    % get indices to talk turns
    wht = S{1}.localcodingpreds.rating{j}.wht;
    
    %% Calculate the precision MODEL vs. Average Human Rating
    for k = 1:length(prcs)
        doshow = 0; 
        [precision , str{ j }, ntt( j )  ] = calctalkturnprecision( pred , avratings , wht , corpus1 , corpus2 , prcs(k), doshow , mintoks, computeprecision );        
        aggprecisions( k,j ) = precision;
    end
    
    %% Calculate the precision MODEL vs. Individual Human Rating (averaged over raters)
    for k = 1:length(prcs)
        raterprec = zeros( 1,nraters );
        for r=1:nraters
            doshow = 0; 
            [precision , str{ j }, ntt( j )  ] = calctalkturnprecision( pred , rawratings(:,r) , wht , corpus1 , corpus2 , prcs(k), doshow , mintoks, computeprecision );    
            raterprec( r ) = precision;
        end
        pwprecisions( k,j ) = mean( raterprec );
    end
    
    %% Calculate the precision Individual Human vs. Individual Human (averaged over raters)
    for k = 1:length(prcs)
        raterprec = [];
        ii = 0;
        for r1=1:nraters-1
            for r2=r1+1:nraters
               doshow = 0; 
               [precision , str{ j }, ntt( j )  ] = calctalkturnprecision( rawratings(:,r1) , rawratings(:,r2) , wht , corpus1 , corpus2 , prcs(k), doshow , mintoks, computeprecision );    
               ii = ii + 1;              
               raterprec( ii ) = precision;
            end
        end
        rlprecisions( k,j ) = mean( raterprec );
    end
end

