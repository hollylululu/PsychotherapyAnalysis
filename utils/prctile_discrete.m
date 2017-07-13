function cutoff = prctile_discrete( ratings , prc )

cutoffs = [ 1.5 2.5 3.5 4.5 5.5 6.5 ];
nc = length( cutoffs );
n = length( ratings );
nt = zeros(1,nc );
for i=1:nc
   nt( i ) = sum( ratings < cutoffs(i) );  
end
prcs = 100 * nt / n;

[ mind , wh ] = min( abs( prcs - prc ));

cutoff = cutoffs( wh );


