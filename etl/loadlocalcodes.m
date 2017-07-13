function [ localcoding ] = loadlocalcodes( labelsinfo , corpus1 , doshow )
%% Read the excel files with human ratings of the representatitiveness of certain symptoms for randomly chosen talk turns  

filelabels = { 'ANGER' , 'ANXIETY' , 'DEPRESSION' , 'LOWSELFESTEEM' , 'SUICIDE' };
whdir = 'localtagging';
nf = length( filelabels );

localcoding.rating  = cell( 1,nf );
localcoding.coders = { 'AD','BP','DD','MS','RM','AC','LZ' };

ncoders = length( localcoding.coders );

% what is the number of talk turns?
ntt = max( corpus1.T.talkturnid );

fprintf( 'Reading local tagging data...\n' );

allwht = [];

for f=1:nf
    labelnow = filelabels{ f };
       
    % find the label in the labelsinfo structure
    if strcmp( labelnow , 'LOWSELFESTEEM' )
       wh = find( strcmpi( 'Low self-esteem' , labelsinfo.label )); 
    elseif strcmp( labelnow , 'SUICIDE' )
       wh = find( strcmpi( 'suicidal behavior' , labelsinfo.label ));        
    else
       wh = find( strcmpi( labelnow , labelsinfo.label ));
    end
    
    if isempty( wh )
        error( 'label not found' );
    end
    
    localcoding.rating{ f }.whlabel = wh;
    localcoding.rating{ f }.label   = labelsinfo.label{ wh };
    
    sumratings   = zeros( ntt , 1 ); 
    countratings = zeros( ntt , 1 ); 
    rawratings   = NaN( ntt , ncoders );

    filelist = cellstr( ls( [ whdir filesep labelnow '*' ] ));
    if size(filelist,1) == 1 % then I am running this on a mac
        filelist = strsplit(filelist{:}, ['\s|' filesep],'DelimiterType','RegularExpression');
        filelist = filelist(2:2:end)'; 
    end
    nfiles = length( filelist );
    for i=1:nfiles
        filenow = filelist{ i };
              
        % who is the coder?
        p1 = find( filenow == '_' );
        p2 = find( filenow == '.' );
        coder = upper( filenow(p1+1:p2-1 ));
        
        [ ismem , c ] = ismember( coder , localcoding.coders );
        if ismem==0
            fprintf( 'Coder=%s\n' , coder );
            error( 'coder not found' );
        end
        
        % read the table
        if doshow>1
           fprintf( 'Reading table: %s\n' , filenow );
        end
        %T = readtable( [ whdir '\' filenow ] );
        T = readtable( fullfile(whdir,filenow));
        
        % convert to numeric format
        T.id = uint32( str2double( T.id ));
        T.row = uint32( T.row );
                
        % convert code if needed
        if ~isnumeric( T.code(1))
            T.code = uint32( str2double( T.code ));
        end
        
        % Store these results
        rawratings( T.row , c ) = T.code;        
        sumratings( T.row)      = sumratings( T.row ) + double( T.code );
        countratings( T.row )   = countratings( T.row ) + 1;
                     
        % check that talk even exists in corpus2
        ismem = ismember( T.row , corpus1.T.talkturnid );
        if any( ismem == 0 )
            error( 'talk turn no longer exists' );
        end
        
        % check that the talk turns are indeed associated with that symptom
        ismem = ismember( corpus1.T.talkturnid , T.row );
        whs = unique( corpus1.T.sessionid_orig( ismem == 1 ));
        [ ismem2 , whloc ] = ismember( whs , labelsinfo.sessionid_orig ); 
        if any( labelsinfo.labelmatrix( wh , whloc ) == 0 )
            warning( 'problem' );
        end
        
        % check that the symptom in the symptom column matches the file
        % name
        %if ~strcmpi( T.symptom , labelnow )
        %    error( 'mismatch' );
        %end
    end
    
    % Average rating per talk turn
    avratings = sumratings ./ countratings;
     
    % What talk turns have some rating?
    wht = find( ~isnan( avratings ));
    allwht = [ allwht; wht ];
    
    % Store these indices
    localcoding.rating{ f }.wht = wht;
    
    % Now restrict the data to these talk turns (to save space)
    avratings  = avratings( wht );
    rawratings = rawratings( wht , : );
    
    localcoding.rating{ f }.avratings = avratings;
    localcoding.rating{ f }.rawratings = rawratings;
    
    %% Calculate reliability
    rhos = zeros(ncoders,1);
    avexratings = nan(size(rawratings));
    for i = 1:ncoders
        avexratings(:,i) = nanmean(rawratings(:,[1:i-1 i+1:end]),2);
        RHO = corrcoef([rawratings(:,i) avexratings(:,i)]);
        rhos(i) = RHO(1,2);
    end
    rhos = rhos(~isnan(rhos));
    
%     RHO = corrcoef( rawratings , 'rows' , 'pairwise' );
%     mask = ones( ncoders , ncoders );
%     U = triu(mask,1);
%     ii = find( U == 1 );
%     rhos = RHO( ii );
%     rhos = rhos( ~isnan( rhos ));
    
    [bootstat,bootsam] = bootstrp(1000,@mean,rhos);
    limsnow = prctile( bootstat , [ 2.5 97.5 ] );
    
    localcoding.avrho( f ) = mean( rhos );
    localcoding.stdrho( f ) = std( rhos );
    localcoding.nrho( f ) = length( rhos );
    localcoding.prc( 1:2 , f  ) = limsnow;
    
    if doshow>=1
        % show example talk turns that are highly rated for this symptom
        [ sorted , index ] = sort( avratings , 1 , 'descend' );
        whok = ~isnan( sorted );
        sorted = sorted( whok );
        index  = index( whok );
        
        K = 10;
        fprintf( 'Top %d of talk turns according to: %s\n' , K , labelnow );
        for i=1:K
            j = index( i );
            tnow = wht( j ); 
            strnow = createtalkturnstring( tnow , corpus1 );
            fprintf( 'Average Rating=%3.2f Talk turn #%d: "%s"\n' , sorted( i ) , tnow , strnow ); 
        end
        
        K = 10;
        fprintf( '\nBottom %d of talk turns according to: %s\n' , K , labelnow );
        for i=1:K
            j = index( end-i+1 );
            tnow = wht( j );
            strnow = createtalkturnstring( tnow , corpus1 );
            fprintf( 'Average Rating=%3.2f Talk turn #%d: "%s"\n' , sorted( end-i+1 ) , tnow , strnow ); 
        end
        
        fprintf( '\n\nPairwise correlations between raters:\n' );
        disp( RHO )
    end
end

localcoding.allwht = unique( allwht ); % all talk turns that have some coding done on them 
