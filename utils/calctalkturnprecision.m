function [precision, str2, ntt ] = calctalkturnprecision( modelpreds , avratings , wht , corpus1 , corpus2 , prc, doshow , mintoks, computeprecision )
%% Calculate the Precision

% Cutoff
% whmethod = 2; % 1=pick direct cutoff 
% 
% if whmethod==1
%    cutoff = 6.0;
% else
%    cutoff = prctile( avratings , prc*100 );
% end
% 

humantruth = double( avratings );

%% Calculate number of tokens per talk turn (after preprocessing)
ntt = length( wht );
ntoks = zeros( ntt,1 );
for i=1:ntt
    talkturnid = wht( i );
    % find the test tokens associated with these talk turns
    ntoks( i ) = sum( corpus2.T.talkturnid ==  talkturnid );  
end

whok = find( ~isnan( modelpreds ) & ntoks >= mintoks );
humantruth = humantruth( whok );
modelpreds = modelpreds( whok );
avratings  = avratings( whok );
ntoks      = ntoks( whok );
wht        = wht( whok );

[ s , index ] = sort( modelpreds , 1 , 'descend' );

humantruth = humantruth( index );
modelpreds = modelpreds( index );
avratings  = avratings( index );
ntoks      = ntoks( index );
wht        = wht( index );

% What is the model cutoff?
modelcutoff = prctile( modelpreds , prc*100 );
humancutoff = prctile_discrete( humantruth , prc*100 );

% Calculate precision -- the probability that in the top-K of the model, you observe a top-K human rating
whabove = find( modelpreds >= modelcutoff );
ntot = length( whabove );

whsatisfy = find( modelpreds >= modelcutoff & humantruth >= humancutoff );
n = length( whsatisfy );


precision = n / ntot;

%% Temporary
humantruth2 = double( humantruth >= humancutoff );
if length( unique( humantruth2 )) == 1
    error('problem' );
end
if computeprecision
    [sortmodelpreds, idx] = sort(modelpreds, 'descend'); 
    sorthumantruth2 = humantruth2(idx); 
    precision = mean(sorthumantruth2(1:sum(humantruth2))); 
else
    [X,Y,T,auc] = perfcurve(humantruth2,modelpreds,1);
    precision = auc;
end
%ttstr = '';
ntt = length( wht );
str2 = cell( 1,ntt );
if doshow==1    
     for i=1:ntt
         talkturnid = wht( i );
         str = createtalkturnstring( talkturnid , corpus1 );
         str2{ i } = sprintf( '%3.3f %d %3.3f %d %s' , avratings(i), humantruth(i), modelpreds(i) , ntoks(i) , str ); 
         %if length(str2) < 300
         %   ttstr = [ttstr ; {strtrim(str2)}];
         %end
     end
end