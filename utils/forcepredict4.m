function [ outcomes, accuracy ] = forcepredict4( truelabel, scores, negoutcome , posoutcome , whmode , nreps )
%% Get the pairwise predictions
wh0 = find( truelabel == negoutcome );
wh1 = find( truelabel == posoutcome );

n1 = length( wh1 );
n0 = length( wh0 );

if n0>0 ==0 | n1==0
    outcomes = [];
    accuracy = NaN;
else    
    [ ii0 , ii1 ] = meshgrid( wh0 , wh1 );
            
    if whmode==1
        % Get the outcomes for the actual data
        scores0 = scores( ii0(:));
        scores1 = scores( ii1(:));
        outcomes = ( scores1 > scores0 ) + 0.5 * ( scores1 == scores0 );
        accuracy = mean( outcomes );
    elseif whmode == 2
        % Get the outcomes for random data
        nn = length( ii0(:) );
        outcomes = zeros( nreps , nn );
        for j=1:nreps
            scores_rand = rand( 1,n0+n1 );
            scores0 = scores_rand( ii0(:));
            scores1 = scores_rand( ii1(:));
            outcomes( j , : ) = scores1 > scores0;
        end
        accuracy = mean( outcomes == 1 , 2 );
    end
end