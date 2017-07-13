function corpus2 = extractngrams( corpus , preprocessoption , dow , whspeaker )
%% Extract all n-grams and filter out bad n-grams with stopword and POS-rules

% Check input
narginchk(1,4);
if nargin<2
   preprocessoption=1; 
end
if nargin<3
   dow = 1; % % do we write the most frequent ngrams to text files "'allngramsbyfrequency.txt' and 'allngramsbyfrequency2.txt'?
end
if nargin<4
   whspeaker = 3; % 1=patient only; 2=therapist only; 3=both    
end

% Apply a filter based on stopwords and POS tags rules
if preprocessoption == 1   
    %% -----------------------------------------------------
    %  This filter creates 1,2, and 3 grams consisting 
    %  of various POS tags including non-nouns
    %-------------------------------------------------------
    
    % Size of n-grams to extract
    MAXK = 3;
    
    % minimum frequency for an ngram to become part of corpus
    minf = 5; 
  
    % files that contain stopword ngrams
    file_ngramstopwords = { ...
        'stopwordlists\stopwordlist_unigrams.txt', ... % unigrams
        'stopwordlists\stopwordlist_bigrams.txt' , ... % bigrams
        'stopwordlists\stopwordlist_trigrams.txt' };   % trigrams
    
    file_uhwords = 'stopwordlists\stopwordlist_uhwords.txt';
    
    % disallow ngrams with these POS tags -- these relate to punctuation
    separatortags = { '.', '''''' , ',' , ':' , '``'  , '-LRB-' , '-RCB-' , '$' }; 
    
    % special POS tags we should disallow in unigrams
    badtags_unigrams = { '.', '''''' , ',' , ':' , '``'  , ...
        '-LRB-' , '-RCB-' , 'PRP' , 'DT' , 'IN' , 'CC' , 'RB' , 'TO'  , 'MD', 'UH' , 'PRP$' , 'WRB' , 'WP' , 'CD' , 'RP' , 'WDT' , ...
        'EX' , 'PDT' , 'FW' , 'SYM' , 'RBS' , '$' }; % disallow unigrams with these POS tags
    
    % disallow ngrams that end with these tags
    badtags_end = { 'WDT' , 'DT' , 'CC' }; 
    
    % disallow ngrams that start with these tags
    badtags_start = { 'WDT' , 'RB' , 'TO' , 'CC' };
    
    % disallow ngrams that start with these words
    badwords_start = { '''s' , 'n''t' , '%' , '''' }; 
    
    % disallow ngrams that end with these words
    badwords_end = { '''s' , '''ve' , '''m' , '''re' , 'it' }; 
elseif preprocessoption == 2
    %% -----------------------------------------------------
    %    This filter creates only unigrams
    %-------------------------------------------------------
     
    % Size of n-grams to extract
    MAXK = 1;
    
    % minimum frequency for an ngram to become part of corpus
    minf = 5; 
  
    % files that contain stopword ngrams
    file_ngramstopwords = { ...
        fullfile('stopwordlists','stopwordlist_unigrams.txt'), ... % unigrams
        fullfile('stopwordlists','stopwordlist_bigrams.txt') , ... % bigrams
        fullfile('stopwordlists','stopwordlist_trigrams.txt') };   % trigrams
    
    file_uhwords = fullfile('stopwordlists','stopwordlist_uhwords.txt');
    
    % disallow ngrams with these POS tags -- these relate to punctuation
    separatortags = { '.', '''''' , ',' , ':' , '``'  , '-LRB-' , '-RCB-' , '$' }; 
    
    % special POS tags we should disallow in unigrams
    badtags_unigrams = { '.', '''''' , ',' , ':' , '``'  , ...
        '-LRB-' , '-RCB-' , 'PRP' , 'DT' , 'IN' , 'CC' , 'RB' , 'TO'  , 'MD', 'UH' , 'PRP$' , 'WRB' , 'WP' , 'CD' , 'RP' , 'WDT' , ...
        'EX' , 'PDT' , 'FW' , 'SYM' , 'RBS' , '$' }; % disallow unigrams with these POS tags
    
    % disallow ngrams that end with these tags
    badtags_end = { 'WDT' , 'DT' , 'CC' }; 
    
    % disallow ngrams that start with these tags
    badtags_start = { 'WDT' , 'RB' , 'TO' , 'CC' };
    
    % disallow ngrams that start with these words
    badwords_start = { '''s' , 'n''t' , '%' , '''' }; 
    
    % disallow ngrams that end with these words
    badwords_end = { '''s' , '''ve' , '''m' , '''re' , 'it' }; 
elseif preprocessoption == 3   
    %% -----------------------------------------------------
    %  This filter creates 1,2, and 3 grams that
    %  are more restrictive than preprocessing option 1
    %  pronouns are disallowed
    %-------------------------------------------------------
    
    % Size of n-grams to extract
    MAXK = 3;
    
    % minimum frequency for an ngram to become part of corpus
    minf = 5; 
  
    % files that contain stopword ngrams
    file_ngramstopwords = { ...
        fullfile('stopwordlists','stopwordlist_unigrams.txt'), ... % unigrams
        fullfile('stopwordlists','stopwordlist_bigrams.txt') , ... % bigrams
        fullfile('stopwordlists','stopwordlist_trigrams.txt')};   % trigrams
    
    file_uhwords = fullfile('stopwordlists','stopwordlist_uhwords.txt');
    
    % disallow ngrams with these POS tags -- expanded list for this filter
    % (!!!!)
    separatortags = { '.', '''''' , ',' , ':' , '``'  , ...
        '-LRB-' , '-RCB-' , 'PRP' , 'DT' , 'IN' , 'CC' , 'RB' , 'TO'  , 'MD', 'UH' , 'PRP$' , 'WRB' , 'WP' , 'CD' , 'RP' , 'WDT' , ...
        'EX' , 'PDT' , 'FW' , 'SYM' , 'RBS' , '$' }; 
    
    % special POS tags we should disallow in unigrams
    badtags_unigrams = { '.', '''''' , ',' , ':' , '``'  , ...
        '-LRB-' , '-RCB-' , 'PRP' , 'DT' , 'IN' , 'CC' , 'RB' , 'TO'  , 'MD', 'UH' , 'PRP$' , 'WRB' , 'WP' , 'CD' , 'RP' , 'WDT' , ...
        'EX' , 'PDT' , 'FW' , 'SYM' , 'RBS' , '$' }; % disallow unigrams with these POS tags
    
    % disallow ngrams that end with these tags
    badtags_end = { 'WDT' , 'DT' , 'CC' }; 
    
    % disallow ngrams that start with these tags
    badtags_start = { 'WDT' , 'RB' , 'TO' , 'CC' };
    
    % disallow ngrams that start with these words
    badwords_start = { '''s' , 'n''t' , '%' , '''' }; 
    
    % disallow ngrams that end with these words
    badwords_end = { '''s' , '''ve' , '''m' , '''re' , 'it' }; 
else
    % can add different filters in the future
    error( 'Not implemented' ); 
end

%% ---------------------------------------------------------------
%    Copy "d" to new version 
%---------------------------------------------------------------
corpus2 = corpus;


%% ---------------------------------------------------------------
%    Focus on particular speaker
%---------------------------------------------------------------
if whspeaker < 3
    whok = find( corpus2.T.speakerid == whspeaker );
    corpus2.T = corpus2.T( whok , : );
end

% find the separator
seps = find( ismember( corpus2.tags , separatortags ));
seps_one = find( ismember( corpus2.tags , badtags_unigrams ));

%% ---------------------------------------------------------------
%    Fix some POS tags -- words that should be assigned 'UH'
%---------------------------------------------------------------
fid = fopen( file_uhwords , 'r' );
c = textscan( fid , '%s' );
uhwords = c{ 1 };
fclose( fid );   
targettag = find( strcmp( corpus2.tags , 'UH' ));
[ ismem , whloc ] = ismember(  uhwords , corpus2.words );
whloc = whloc( ismem == 1 );
whpos = find( ismember( corpus2.T.wordid , whloc ));
corpus2.T.tagid( whpos ) = targettag;

%---------------------------------------------------------------
%    Fix some POS tags -- words that should be assigned 'PRP'
%---------------------------------------------------------------
targettag = find( strcmp( corpus2.tags , 'PRP' ));
targetwords = { 'i.' , 'i' };
[ ismem , whloc ] = ismember(  targetwords , corpus2.words );
whloc = whloc( ismem == 1 );
whpos = find( ismember( corpus2.T.wordid , whloc ));
corpus2.T.tagid( whpos ) = targettag;

%---------------------------------------------------------------
%    Read ngram stopword lists
%---------------------------------------------------------------
for k=1:length( file_ngramstopwords )
    filenow = file_ngramstopwords{ k };
    fid = fopen( filenow , 'r' );
    if (k==1)
        c = textscan( fid , '%s' , 'Delimiter' , '\t');
        nn = length( c{1} );
        wnow = c{ 1 }; 
        [ ismem, whloc ] = ismember( wnow , corpus2.words );
        dropunigrams = whloc( ismem == 1);
    elseif (k==2)
        c = textscan( fid , '%s\t%s' , 'Delimiter' , '\t');
        nn = length( c{ 1 });
        dropbigrams = zeros( nn , k );
        for i=1:k
            wnow = c{ i }; 
            [ ismem, whloc ] = ismember( wnow , corpus2.words );
            dropbigrams( : , i ) = whloc;
        end
        whok = all( dropbigrams>0 , 2 );
        dropbigrams = dropbigrams( whok , : );
    elseif (k==3)
        c = textscan( fid , '%s\t%s\t%s' , 'Delimiter' , '\t');
        nn = length( c{1} );
        droptrigrams = zeros( nn , k );
        for i=1:k
            wnow = c{ i }; 
            [ ismem, whloc ] = ismember( wnow , corpus2.words );
            droptrigrams( : , i ) = whloc;
        end
        whok = all( droptrigrams>0 , 2 );
        droptrigrams = droptrigrams( whok , : );
    end
    fclose( fid ); 
end

%---------------------------------------------------------------
%    Find tags that belong to start and end exclusion lists
%---------------------------------------------------------------
[ ismem , badtags_end_index ] = ismember( badtags_end , corpus2.tags );
[ ismem , badtags_start_index ] = ismember( badtags_start , corpus2.tags );
[ ismem , badwords_end_index ] = ismember( badwords_end , corpus2.words );
[ ismem , badwords_start_index ] = ismember( badwords_start , corpus2.words );

%---------------------------------------------------------------
%   Extract n-grams
%---------------------------------------------------------------

% this variable keeps track of the original position of the word in the corpus 
ntokens = height( corpus2.T );
origpos = 1:ntokens'; 

% analyze space needed for all ngrams
nt = 0;
for K=1:MAXK
    nt = nt + ntokens-K+1;
end

% create a new table that keeps track of all ngrams
corpus2.T2 = table( zeros( nt , 1 , 'uint32' ),...
               zeros( nt , 1 , 'uint32' ),...
               zeros( nt , 1 , 'uint8' ),...
               zeros( nt , 1 , 'uint32' ),...
               zeros( nt , MAXK ) , ...
               zeros( nt , MAXK ) , ...
               zeros( nt , 1 , 'uint32' ),...  
               zeros( nt , 1 , 'uint8' ),...               
               'VariableNames',...
              {'origpos',...,         % keep track of the position in the original corpus "d"
               'sessionid_orig',...  % keep track of original sessionid associated with ngrams
               'speakerid',...
               'talkturnid',...
               'tagid',...          % a n x MAXK matrix with the pos tags of the ngram
               'wordid',...         % a n x MAXK matrix with the wordid's of the ngram  
               'ngramid',...        % an id of the ngram that maps to d.ngram
               'ngramsize'...       % size of the ngram (e.g. 1, 2, or 3)              
               });
   
% Keep track of which ngrams are allowable
okgrams = ones( nt , 1 );

ii = 0;
for K=1:MAXK 
    fprintf( 'Analyzing %d-grams\n' , K );
    
    ngrams_words_local = zeros( ntokens-K+1 , K );
    ngrams_tags_local = zeros( ntokens-K+1 , K );
    okgrams_local = ones( ntokens-K+1 , 1 );
    n_local = ntokens-K+1;
    for k=1:K
        wordsnow = corpus2.T.wordid( k:(ntokens-K+k) );
        ngrams_words_local( : , k ) = wordsnow;
        
        tagsnow = corpus2.T.tagid( k:(ntokens-K+k) );
        ngrams_tags_local( : , k ) = tagsnow;
        
        ismem = ismember( tagsnow , seps );
        okgrams_local( ismem == 1 ) = 0;
        
        %---------------------------------------------------------------
        %    Drop ngrams that start or end with the wrong tag or word
        %---------------------------------------------------------------
        if (k==1)
            ismem = ismember( tagsnow , badtags_start_index );
            okgrams_local( ismem == 1 ) = 0;
            
            ismem = ismember( wordsnow , badwords_start_index );
            okgrams_local( ismem == 1 ) = 0;
        end
        
        if (k==K)
            ismem = ismember( tagsnow , badtags_end_index );
            okgrams_local( ismem == 1 ) = 0;
            
            ismem = ismember( wordsnow , badwords_end_index );
            okgrams_local( ismem == 1 ) = 0;
        end
    end
       
    if (K==1)
        %---------------------------------------------------------------
        %    Drop some unigrams
        %---------------------------------------------------------------
        ismem = ismember( tagsnow , seps_one );
        okgrams_local( ismem == 1 ) = 0;              
        [ ismem ] = ismember( ngrams_words_local , dropunigrams , 'rows' );
        whbad = find( ismem == 1 );
        okgrams_local( whbad ) = 0;
    end
    
    if (K==2) 
        %---------------------------------------------------------------
        %    Drop some bigrams but not as part of trigrams
        %---------------------------------------------------------------
        if ~isempty( dropbigrams )
            [ ismem ] = ismember( ngrams_words_local , dropbigrams , 'rows' );
            whbad = find( ismem == 1 );
            okgrams_local( whbad ) = 0;
        end
    end
    
    if (K==3)
        %---------------------------------------------------------------
        %    Drop some trigrams but not as part of fourgrams
        %---------------------------------------------------------------
        if ~isempty( droptrigrams )
            [ ismem ] = ismember( ngrams_words_local , droptrigrams , 'rows' );
            whbad = find( ismem == 1 );
            okgrams_local( whbad ) = 0;
        end
    end
    
    okgrams( ii+1:ii+ntokens-K+1 ) = okgrams_local;
        
    corpus2.T2.wordid( ii+1:ii+ntokens-K+1 , 1:K ) = ngrams_words_local;
    corpus2.T2.tagid( ii+1:ii+ntokens-K+1 , 1:K )  = ngrams_tags_local;    
    corpus2.T2.sessionid_orig( ii+1:ii+ntokens-K+1 ) = corpus2.T.sessionid_orig( 1:ntokens-K+1 );
    corpus2.T2.speakerid( ii+1:ii+ntokens-K+1 ) = corpus2.T.speakerid( 1:ntokens-K+1 );
    corpus2.T2.talkturnid( ii+1:ii+ntokens-K+1 ) = corpus2.T.talkturnid( 1:ntokens-K+1 );
    corpus2.T2.ngramsize( ii+1:ii+ntokens-K+1 ) = K;
    corpus2.T2.origpos( ii+1:ii+ntokens-K+1 ) = origpos( 1:ntokens-K+1 );

    ii = ii + ntokens-K+1;
end

% create a file with all legal and illegal ngrams
if (dow==1)
    fprintf( 'Writing ngrams to file...\n' );
    writefilengrams( corpus2 , okgrams , sprintf( 'ngramfrequencya_%d.txt' , preprocessoption ));
end

% keep only the good ngrams
corpus2.T2 = corpus2.T2( okgrams==1 , : );

% find the unique n-grams
[ corpus2.ngramtypes , ~ , corpus2.T2.ngramid ] = unique( corpus2.T2.wordid , 'rows' );
ng = length( corpus2.ngramtypes );

% remove n-grams below cut-off frequency
ngfreqs = hist( corpus2.T2.ngramid , 1:ng );
oktypes = find( ngfreqs >= minf );
okgrams = ismember( corpus2.T2.ngramid , oktypes );

% keep only the good ngrams
corpus2.T2 = corpus2.T2( okgrams==1 , : );

% redo the mapping to ngrams
[ corpus2.ngramtypes , ~ , index ] = unique( corpus2.T2.wordid , 'rows' );
corpus2.T2.ngramid = uint32( index );
ng = length( corpus2.ngramtypes );
fprintf( 'Final tally: %d unique n-grams\n' , ng);

if dow==1
    fprintf( 'Writing final set of ngrams to file...\n' );
    okgrams = ones( height( corpus2.T2 ),1);
    writefilengrams( corpus2 , okgrams , sprintf( 'ngramfrequencyb_%d.txt' , preprocessoption ));
end

% create vocabulary of ngram strings
for k=1:MAXK
    wordid = corpus2.ngramtypes( : , k );
    whok = wordid > 0;
    nok = sum( whok );
    words = corpus2.words( wordid( whok ))';
    if (k==1)
        corpus2.ngrams = words;
    else
        %spaces = cellstr( char( 32*ones(sum(whok),1) ));
        spaces = char( double('_')*ones(nok,1) );
        corpus2.ngrams( whok ) = strcat( corpus2.ngrams( whok ) , spaces, words ); 
    end
end

% replace "T" with "T2" 
corpus2.T = corpus2.T2;

% drop the T2 field
fields = {'T2'};
corpus2 = rmfield(corpus2,fields);

% delete the tagid and wordid fields in T
corpus2.T.tagid = [];
corpus2.T.wordid = [];

% Sort the table by origpos
corpus2.T = sortrows( corpus2.T );
