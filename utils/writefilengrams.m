function writefilengrams( d , okgrams , filestr )
%% Write the most frequent ngrams and tag them if they are valid or invalid

% Maximum size of the ngram
MAXK = size( d.T2.wordid , 2 );

% Maximum number of ngrams to show
nshow = 1000;

strs = cell( nshow , MAXK );

for K=1:MAXK
    % find all ngrams of size k
    wh = find( d.T2.ngramsize == K );
    
    % extract the word and tag id's and the status
    words_now = d.T2.wordid( wh , 1:K );
    tags_now = d.T2.tagid( wh , 1:K );
    ok_now = okgrams( wh );
    
    % find unique combs
    [ ngrams , findex , index ] = unique( [ words_now tags_now ] , 'rows' );
    ng = size( ngrams , 1 );

    % calculate the frequency of the ngrams
    freqs = hist( index , 1:ng );
    
    % sort them in descending order of frequency
    [ sfreqs , sindex ] = sort( freqs , 2 , 'descend' );
    
    maxn = min( [ ng nshow ] );
    for i=1:maxn
        ii = sindex( i );
        ngramnow = ngrams( ii , : );
        isok = ok_now( findex( ii ));
        fnow = freqs( ii ); 
        
        for k=1:K
            wordnow = d.words{ ngramnow( k ) };
            if (k==1)
                str2 = wordnow;
            else
                str2 = [ str2 ' ' wordnow ];
            end
        end
        
        for k=1:K
            tagnow = d.tags{ ngramnow( k+K ) };
            if (k==1)
                str3 = tagnow;
            else
                str3 = [ str3 ' ' tagnow ];
            end
        end
        
        str4 = '';
        if isok==1
            str4 = '**';
        end
        
        str = sprintf( '%6d %25s %15s %2s' , fnow , str2 , str3 , str4 );
              
        strs{ i , K } = str;
    end
end

filenm = sprintf( 'counts\\%s' , filestr );
fid = fopen( filenm , 'wt' );
for i=1:nshow
    for k=1:MAXK
       str = strs{ i , k };
       if isempty( str )
           str = '';
       end
       fprintf( fid , '%s\t' , str );
    end
    fprintf( fid , '\n' );
end
fclose( fid );
