function [ S ] = WriteTopicsPlusLabels( WP , BETA , WO , topicnames, K , E , M , FILENAME )
%% Note: BETA is the TOTAL prior mass distributed over words
W = size( WP , 1 );
T = size( WP , 2 );
K = min( [ W K ] );

sumWP = sum( WP , 1 ) + BETA;
probtopic = sumWP / sum( sumWP ); 

Sorted_P_w_z = zeros( K , T );
Index_P_w_z = zeros( K , T );

for t=1:T
   [ temp1 , temp2 ] = sort( -WP( : , t ) );
   Sorted_P_w_z( : , t )  = ( full( -temp1( 1:K )) + BETA/W ) ./ ( repmat( sumWP( t ) , K , 1 ));
   Index_P_w_z( : , t )   = temp2( 1:K );
end

if (nargout==1)
    S = cell( T,1 );
    for t=1:T
        cumprob = 0;
        for r=1:K
            index = Index_P_w_z( r , t );
            prob  = Sorted_P_w_z( r , t );
            cumprob = cumprob + prob;
            word = WO{ index };

            if (cumprob < E) || (r==1)
                if (r==1)
                    str = word;
                else
                    str = [ str ' ' word ];
                end
            end
        end
        S{ t } = str;
    end
end

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
largewidth = 0;
dofile = 1;
if (dofile==1)
    M = min( [ T M ] );
    
    startt = 1;
    endt   = M;
    fid = fopen( FILENAME , 'W' );
    while startt < T
        for c=startt:endt
            tempstr = sprintf( '%s %d' , topicnames{c} , c );
            
            if (largewidth==1) 
                fprintf( fid , '%45s\t%6.5f\t' , tempstr , probtopic( c ) ); else
                fprintf( fid , '%25s\t%6.5f\t' , tempstr , probtopic( c ) ); 
            end
        end
        fprintf( fid , '\r\n\r\n' );

        for r=1:K
            for c=startt:endt
                index = Index_P_w_z( r , c );
                prob = Sorted_P_w_z( r , c );

                if (largewidth==1)
                    fprintf( fid , '%45s\t%6.5f\t' , WO{ index } , prob ); else
                    fprintf( fid , '%25s\t%6.5f\t' , WO{ index } , prob );
                end
            end
            fprintf( fid , '\r\n' );
        end
        fprintf( fid , '\r\n\r\n' );

        startt = endt + 1;
        endt   = min( T , startt + M - 1 );
    end
    fclose( fid );
end
