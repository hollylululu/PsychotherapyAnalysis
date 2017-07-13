function strnow = createtalkturnstring( talkturnid , corpus1 )
%% Create a string corresponding to a talk turn

% find the original indices in corpus corresponding to this talk turn
origp = find( corpus1.T.talkturnid == talkturnid );

% get the words
wordids = corpus1.T.wordid( origp );
nw = length( wordids );

% speaker
strnow = '';
for w=1:nw
    word = corpus1.words{ wordids( w ) };
        
    if w==1
        word(1) = upper( word( 1 ));
    end
    
    if ismember( word , 'i' )
        word = upper( word );
    end
    
    if strcmp( word , '-lrb-' )
        word = '(';
    elseif strcmp( word , '-rrb-' )
        word = ')';
    end
    
    strnow = [ strnow word ];
    
    if (w<nw)
        nextword = corpus1.words{ wordids( w+1 ) };
        if ~ismember( nextword , { ',' , '.' , '''s' , 'n''t' , '``' , '?' , '!' , ';' , '''re' , '''ve' , '''m' , '''d' , '''ll'})
            strnow = [ strnow ' ' ];
        end
    end
end


