function nwordtypes = calculatewordcounts(  labelsessionmatrix , WS , SS , NW )
%%
NT = size( labelsessionmatrix , 1 );
ntokens = length( WS );
wcount = zeros( NT,NW );
nwordtypes = zeros(NT,1);
for i=1:ntokens
    wordid = WS( i );
    sessionid = SS( i );
    labels   = find( labelsessionmatrix( : , sessionid ));
    wcount( labels , wordid ) = 1;
end
nwordtypes = sum( wcount , 2 );