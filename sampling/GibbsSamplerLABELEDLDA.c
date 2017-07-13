#include "mex.h"
#include "cokus.cpp"

/* Implements the Gibbs Sampler for Labeled LDA model
 *    Version 3
 *    Reads in a binary vector that indicates which tokens are associated with test items; for these, all labels are allowed
 *    Outputs a matrix of #TestTokens x T with average probability that the ith test token is going to be assigned to topic T
 *
 *    Allows two different algorithms
 *    whalgorithm=1: beta mass is distributed over all lexicon entries
 *    whalgorithm=2: beta mass is distributed ONLY over all lexicon entries that the label has been associated with
 *
 *    Allows three different modes for handling tokens
 *    istesttoken = 0: this token has only the observed labels enabled; do not collect the predictions of p( topic | token )
 *    istesttoken = 1: this token has ALL labels enabled; DO collect the predictions of p( topic | token )
 *    istesttoken = 2: this token has only the observed labels enabled; DO collect the predictions of p( topic | token )
 */

/* TO DO
 *    Implement a version where we use an empirical prior for alpha -- frequent labels have higher alpha
 */

void GibbsSampler( double alpha, double beta, int W, int T, int D, int niter, int verbosity, int ntokens,
        int *z, double *docid, double *wordid, double *sessionid, double *istesttoken, int *wp, int *dp, int *ztot, int *order, double *probs, int startcond,
        mwIndex *ir_labelsession, mwIndex *jc_labelsession, double *nwordtypes, int whalgorithm, double *avp, int *tokref, int ntest,
        int testphase )
{
    int wi,di,si,i,ii,j,topic, rp, temp, iter, wioffset, dioffset, rowindex, TAVAIL;
    int n1,n2, tf, whrow;
    double totprob, r, max;
    
    /* start from previously saved state */
    if (startcond == 1) {       
        for (i=0; i<ntokens; i++)
        {
            wi    = (int) wordid[ i ]-1;
            di    = (int)  docid[ i ]-1;
            topic = z[ i ];
            tf    = (int) istesttoken[ i ];
                     
            if (tf==0) {
                dp[ di*T + topic ]++; // increment dp count matrix
                wp[ wi*T + topic ]++; // increment wp count matrix          
                ztot[ topic ]++;      // increment ztot matrix
            } else if (testphase==1)
            {
                dp[ di*T + topic ]++; // increment dp count matrix
            }
        }
    }
    
    /* random initialization */
    if (startcond == 0) {
        if (verbosity>=2) mexPrintf( "Starting Random initialization\n" );
        for (i=0; i<ntokens; i++)
        {
            wi = (int) wordid[ i ]-1;
            di = (int) docid[ i ]-1;
            si = (int) sessionid[ i ]-1;
            tf = (int) istesttoken[ i ];
            
            if (tf==0) // regular token part of training set; look up available labels from label session matrix
            {
                // what are the available labels?
                // look up the start and end index for labels associated with this session
                n1 = (int) *( jc_labelsession + si     );
                n2 = (int) *( jc_labelsession + si + 1 );
                TAVAIL = (n2-n1);
                
                // pick a random topic 0..TAVAIL-1
                rowindex = (int) ( (double) randomMT() * (double) TAVAIL / (double) (4294967296.0 + 1.0) );
                
                // convert into a Label
                topic = (int) *( ir_labelsession + n1 + rowindex );
                
                z[ i ] = topic; // assign this word token to this topic
                wp[ wi*T + topic ]++; // increment wp count matrix
                dp[ di*T + topic ]++; // increment dp count matrix
                ztot[ topic ]++; // increment ztot matrix
                
            } else if ( testphase==1 )
            {
                if (tf==1) {
                    // token is part of test set; all labels are allowed
                    // pick a random topic 0..T-1
                    topic = (int) ( (double) randomMT() * (double) T / (double) (4294967296.0 + 1.0) );
                } else
                {
                    // token is part of test set; BUT only the observed labels are allowed
                    
                    // look up the start and end index for labels associated with this session
                    n1 = (int) *( jc_labelsession + si     );
                    n2 = (int) *( jc_labelsession + si + 1 );
                    TAVAIL = (n2-n1);
                    
                    // pick a random topic 0..TAVAIL-1
                    rowindex = (int) ( (double) randomMT() * (double) TAVAIL / (double) (4294967296.0 + 1.0) );
                    
                    // convert into a Label
                    topic = (int) *( ir_labelsession + n1 + rowindex );
                }
                
                z[ i ] = topic; // assign this word token to this topic
                dp[ di*T + topic ]++; // increment dp count matrix
            }
            
            
        }
    }
    
    if (verbosity>=2) mexPrintf( "Determining random order update sequence\n" );
    
    for (i=0; i<ntokens; i++) order[i]=i; // fill with increasing series
    for (i=0; i<(ntokens-1); i++) {
        // pick a random integer between i and nw
        rp = i + (int) ((double) (ntokens-i) * (double) randomMT() / (double) (4294967296.0 + 1.0));
        
        // switch contents on position i and position rp
        temp = order[rp];
        order[rp]=order[i];
        order[i]=temp;
    }
    
    // START ITERATING
    for (iter=0; iter<niter; iter++) {
        if (verbosity >=1) {
            if ((iter % 10)==0) mexPrintf( "\tIteration %d of %d\n" , iter , niter );
            if ((iter % 10)==0) mexEvalString("drawnow;");
        }
        for (ii = 0; ii < ntokens; ii++) {
            i = order[ ii ]; // current word token to assess
            
            wi = (int) wordid[ i ]-1;
            di = (int) docid[ i ]-1;
            si = (int) sessionid[ i ]-1;
            tf = (int) istesttoken[ i ];
            
            wioffset = wi*T;
            dioffset = di*T;
            
            topic = z[i]; // current topic assignment to word token
            
                       
            // Sample a topic
            if (tf==0) 
            {
                /*------------------------------------------------------------------------------------------
                 *   regular token part of training set; look up available labels from label session matrix
                 *------------------------------------------------------------------------------------------
                 */
                
                ztot[topic]--;  // substract this from counts
                wp[wioffset+topic]--;
                dp[dioffset+topic]--;
                
                n1 = (int) *( jc_labelsession + si     );
                n2 = (int) *( jc_labelsession + si + 1 );
                TAVAIL = (n2-n1);  // NUMBER OF LABELS AVAILABLE FOR THIS DOCUMENT
                if (whalgorithm==1) // Distribute BETA over all word types
                {
                    totprob = (double) 0;
                    for (j = 0; j < TAVAIL; j++)
                    {
                        topic = (int) *( ir_labelsession + n1 + j );
                        probs[j] = ((double) wp[ wioffset+topic ] + (double) beta / (double) W )/
                                ( (double) ztot[topic]+ (double) beta ) *
                                ( (double) dp[ dioffset + topic ] + (double) alpha / (double) TAVAIL );
                        totprob += probs[j];
                    }
                } else if (whalgorithm==2) // Distribute BETA only over word types that a label has been associated with
                {
                    totprob = (double) 0;
                    for (j = 0; j < TAVAIL; j++)
                    {
                        topic = (int) *( ir_labelsession + n1 + j );
                        probs[j] = ((double) wp[ wioffset+topic ] + (double) beta / (double) nwordtypes[topic] )/
                                ( (double) ztot[topic]+ (double) beta ) *
                                ( (double) dp[ dioffset + topic ] + (double) alpha / (double) TAVAIL );
                        totprob += probs[j];
                    }
                }
                
                // sample a topic from the distribution
                r = (double) totprob * (double) randomMT() / (double) 4294967296.0;
                max = probs[0];
                j = 0;
                while (r>max) {
                    j++;
                    max += probs[j];
                }
                
                if (j>=TAVAIL) mexErrMsgTxt("Wrong value sampled");
                
                topic = (int) *( ir_labelsession + n1 + j );
                
                z[i] = topic; // assign current word token i to topic j
                dp[dioffset + topic ]++; // update counts
                wp[wioffset + topic ]++; // update counts                
                ztot[topic]++;
            } else if ( testphase == 1 )
            {
                dp[dioffset+topic]--;
                
                if (tf==1)
                {
                    /*---------------------------------------------------------------------
                     *   token part of test set; all labels are allowed
                     *   this process is expensive, so only turn this on when testphase=1
                     *---------------------------------------------------------------------
                     */
                    
                    if (whalgorithm==1) // Distribute BETA over all word types
                    {
                        totprob = (double) 0;
                        for (topic = 0; topic < T; topic++)
                        {
                            probs[topic] = ((double) wp[ wioffset+topic ] + (double) beta / (double) W )/
                                    ( (double) ztot[topic]+ (double) beta ) *
                                    ( (double) dp[ dioffset + topic ] + (double) alpha / (double) TAVAIL );
                            totprob += probs[topic];
                        }
                    } else if (whalgorithm==2) // Distribute BETA only over word types that a label has been associated with
                    {
                        totprob = (double) 0;
                        for (topic = 0; topic < T; topic++)
                        {
                            probs[topic] = ((double) wp[ wioffset+topic ] + (double) beta / (double) nwordtypes[topic] )/
                                    ( (double) ztot[topic]+ (double) beta ) *
                                    ( (double) dp[ dioffset + topic ] + (double) alpha / (double) TAVAIL );
                            totprob += probs[topic];
                        }
                    }
                    
                    // add these sampling probabilities
                    whrow = (int) tokref[ i ]; // the appropriate row of the avp output matrix
                    for (topic=0; topic<T; topic++) {
                        *( avp + whrow + topic*ntest ) += probs[ topic ] / totprob;
                    }
                    
                    // sample a topic from the distribution
                    r = (double) totprob * (double) randomMT() / (double) 4294967296.0;
                    max = probs[0];
                    topic = 0;
                    while (r>max) {
                        topic++;
                        max += probs[topic];
                    }
                    
                    if (topic>=T) mexErrMsgTxt("Wrong value sampled");
                } else
                {
                    /*---------------------------------------------------------------------
                     *   token part of test set; only observed labels are allowed
                     *---------------------------------------------------------------------
                     */
                    
                    n1 = (int) *( jc_labelsession + si     );
                    n2 = (int) *( jc_labelsession + si + 1 );
                    TAVAIL = (n2-n1);  // NUMBER OF LABELS AVAILABLE FOR THIS DOCUMENT
                    if (whalgorithm==1) // Distribute BETA over all word types
                    {
                        totprob = (double) 0;
                        for (j = 0; j < TAVAIL; j++)
                        {
                            topic = (int) *( ir_labelsession + n1 + j );
                            probs[j] = ((double) wp[ wioffset+topic ] + (double) beta / (double) W )/
                                    ( (double) ztot[topic]+ (double) beta ) *
                                    ( (double) dp[ dioffset + topic ] + (double) alpha / (double) TAVAIL );
                            totprob += probs[j];
                        }
                    } else if (whalgorithm==2) // Distribute BETA only over word types that a label has been associated with
                    {
                        totprob = (double) 0;
                        for (j = 0; j < TAVAIL; j++)
                        {
                            topic = (int) *( ir_labelsession + n1 + j );
                            probs[j] = ((double) wp[ wioffset+topic ] + (double) beta / (double) nwordtypes[topic] )/
                                    ( (double) ztot[topic]+ (double) beta ) *
                                    ( (double) dp[ dioffset + topic ] + (double) alpha / (double) TAVAIL );
                            totprob += probs[j];
                        }
                    }
                    
                    // add these sampling probabilities
                    whrow = (int) tokref[ i ]; // the appropriate row of the avp output matrix
                    for (j=0; j<TAVAIL; j++) {
                        topic = (int) *( ir_labelsession + n1 + j );
                        *( avp + whrow + topic*ntest ) += probs[ j ] / totprob;
                    }
                    
                    // sample a topic from the distribution
                    r = (double) totprob * (double) randomMT() / (double) 4294967296.0;
                    max = probs[0];
                    j = 0;
                    while (r>max) {
                        j++;
                        max += probs[j];
                    }
                    
                    if (j>=TAVAIL) mexErrMsgTxt("Wrong value sampled");
                    
                    topic = (int) *( ir_labelsession + n1 + j );
                    
                }
                
                z[i] = topic; // assign current word token i to topic j
                dp[dioffset + topic ]++; // update counts
            }
            
            
        }
    }
}

/*  Syntax
 * [ WP , DP , Z , AVP ] = GibbsSamplerLDA( wordid , docid , sessionid , labelsession , N , alpha , beta , nwordtypes , seed , verbosity , whalgorithm , z_input (OPTIONAL) )
 *
 * 0 = wordid         vector with ntokens word indices with values between 1 and W (W=number of lexical entries)
 * 1 = docid          vector with ntokens document indices with values between 1 and D (D=number of documents)
 * 2 = sessionid      vector with ntokens session indices that are used to look up correct column of the label matrix
 * 3 = istesttoken    vector with ntokens binary entries; 0=token is not part of test set; 1=token is part of test set and all labels are allowed (overrides the labels associated with labelsession matrix); 2=token is part of test set but only observed labels are allowed
 * 4 = labelsessionmatrix sparse matrix of size L x S where L is the number of labels and S is the number of sessions; value>0 if a label can be expressed for that session
 * 5 = niter              number of iterations to run sampler
 * 6 = alpha
 * 7 = beta
 * 8 = nwordtypes
 * 9 = seed
 * 10 = verbosity
 * 11 = whalgorithm
 * 12 = testphase?  binary flag; testphase=1 --> do sample for the test tokens; testphase=0 --> only sample for the training tokens
 * 13 = z_input (OPTIONAL)
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *sr_wp, *sr_dp, *sr_labelsession, *probs, *z_output, *wordid, *docid, *z_input, *nwordtypes, alpha,beta, *sessionid, *istesttoken;
    double *avprobs;
    mwIndex *ir_wp, *jc_wp, *ir_labelsession, *jc_labelsession, *ir_dp, *jc_dp;
    int *z,*order, *wp, *dp, *ztot, *tokref;
    int W,T,D,S,niter,seed,verbosity, nzmax, nz_wp, nz_labelsession, nz_dp, ntokens, tempT;
    int i,j,c,n,nt,wi,di, startcond, n1,n2, TAVAIL, topic,whalgorithm,ntest,ii,istest,testphase;
    
    /* Check for proper number of arguments. */
    if (nrhs < 13) {
        mexErrMsgTxt("At least 13 input arguments required");
    } else if (nlhs < 4) {
        mexErrMsgTxt("4 output arguments required");
    }
    
    // if we have 14 input arguments, an extra Z vector is supplied that forms the start of the sampler
    startcond = 0;
    if (nrhs == 14) startcond = 1;
    
    /* process the input arguments */
    if (mxIsDouble( prhs[ 0 ] ) != 1) mexErrMsgTxt("wordid input vector must be a double precision");
    wordid = mxGetPr( prhs[ 0 ] ); // pointer to word indices
    
    if (mxIsDouble( prhs[ 1 ] ) != 1) mexErrMsgTxt("docid input vector must be a double precision");
    docid = mxGetPr( prhs[ 1 ] ); // pointer to document indices
    
    // get the number of tokens
    ntokens = (int) mxGetM( prhs[ 0 ] ) * (int) mxGetN( prhs[ 0 ] );
    if (ntokens == 0) mexErrMsgTxt("wordid vector is empty");
    if (ntokens != ( mxGetM( prhs[ 1 ] ) * mxGetN( prhs[ 1 ] ))) mexErrMsgTxt("wordid and docid vectors should have same number of entries");
    
    if (mxIsDouble( prhs[ 2 ] ) != 1) mexErrMsgTxt("sessionid input vector must be a double precision");
    sessionid = mxGetPr( prhs[ 2 ] ); // pointer to session indices
    if (ntokens != ( mxGetM( prhs[ 2 ] ) * mxGetN( prhs[ 2 ] ))) mexErrMsgTxt("wordid and sessionid vectors should have same number of entries");
    
    if (mxIsDouble( prhs[ 3 ] ) != 1) mexErrMsgTxt("istesttoken input vector must be a double precision");
    istesttoken = mxGetPr( prhs[ 3 ] ); // pointer to vector
    if (ntokens != ( mxGetM( prhs[ 3 ] ) * mxGetN( prhs[ 3 ] ))) mexErrMsgTxt("wordid and istesttoken vectors should have same number of entries");
    
    
    // Get pointers to the Sparse Label by Session Matrix
    sr_labelsession = mxGetPr(prhs[4]);
    ir_labelsession = mxGetIr(prhs[4]);
    jc_labelsession = mxGetJc(prhs[4]);
    nz_labelsession = (int) mxGetNzmax(prhs[4]); // number of nonzero entries in Label-Session matrix
    
    niter    = (int) mxGetScalar(prhs[5]);
    if (niter<0) mexErrMsgTxt("Number of iterations must be positive");
    
    alpha = (double) mxGetScalar(prhs[6]);
    if (alpha<=0) mexErrMsgTxt("alpha must be greater than zero");
    
    beta = (double) mxGetScalar(prhs[7]);
    if (beta<=0) mexErrMsgTxt("beta must be greater than zero");
    
    nwordtypes = mxGetPr( prhs[ 8 ] );
    
    seed = (int) mxGetScalar(prhs[9]);
    
    verbosity = (int) mxGetScalar(prhs[10]);
    
    whalgorithm = (int) mxGetScalar(prhs[11]);
    
    testphase = (int) mxGetScalar(prhs[12]);
    
    if (startcond == 1) {
        z_input = mxGetPr( prhs[ 13 ] );
        if (ntokens != ( mxGetM( prhs[ 13 ] ) * mxGetN( prhs[ 13 ] ))) mexErrMsgTxt("wordid and z_input vectors should have same number of entries");
    }
    
    // seeding
    seedMT( 1 + seed * 2 ); // seeding only works on uneven numbers
    
    /* allocate memory for topic assignments z and order vector */
    z      = (int *) mxCalloc( ntokens , sizeof( int ));
    order  = (int *) mxCalloc( ntokens , sizeof( int ));
    
    // if we start with an externally provided vector z_input, copy these over into z
    if (startcond == 1) {
        for (i=0; i<ntokens; i++) z[ i ] = (int) z_input[ i ] - 1;
    }
    
    // Calculate the number of words W, number of documents D, and number of sessions S
    W = 0;
    D = 0;
    S = 0;
    for (i=0; i<ntokens; i++) {
        if ((int) wordid[ i ] > W) W = (int) wordid[ i ];
        if ((int) docid[ i ]  > D) D = (int) docid[ i ];
        if ((int) sessionid[ i ]  > S) S = (int) sessionid[ i ];
    }
    
    // Number of topics T is based on number of labels in sparse Label-Session matrix
    T  = (int) mxGetM( prhs[ 4 ] );
    tempT = (int) mxGetM( prhs[ 8 ]) * (int) mxGetN( prhs[ 8 ]);
    if (T != tempT) mexErrMsgTxt("Mismatch in number of topics in label-session matrix and nwordtypes vector");
    
    // check that number of sessions does not exceed number of columns in sparse Label-Session matrix
    if (S > (int) mxGetN( prhs[ 4 ])) mexErrMsgTxt("Mismatch in number of sessions in sessionid vector and sparse label-session matrix");
    
    
    
    // Allocate memory
    ztot   = (int *) mxCalloc( T , sizeof( int ));
    probs  = (double *) mxCalloc( T , sizeof( double ));
    wp     = (int *) mxCalloc( T*W , sizeof( int ));
    dp     = (int *) mxCalloc( T*D , sizeof( int ));
    tokref = (int *) mxCalloc( ntokens , sizeof( int ));
    
    // count number of test tokens and get references to appropriate row of avp output matrix
    ntest = 0;
    for (i=0; i<ntokens; i++) 
    {
        istest = (int) istesttoken[ i ];
        if (istest>0) 
        {
            tokref[ i ] = ntest;
            ntest++;
        }        
    }
    
    if (verbosity>=2) {
        mexPrintf( "Running Labeled LDA Gibbs Sampler Version 1.0\n" );
        if (startcond==1) mexPrintf( "Starting from previous state z_input\n" );
        if (testphase==1) mexPrintf( "TESTING PHASE\n" );
        mexPrintf( "Arguments:\n" );
        mexPrintf( "\tAlgorithm version        = %d\n"    , whalgorithm );
        mexPrintf( "\tNumber of words        W = %d\n"    , W );
        mexPrintf( "\tNumber of docs         D = %d\n"    , D );
        mexPrintf( "\tNumber of sessions     S = %d\n"    , S );
        mexPrintf( "\tNumber of labels       T = %d\n"    , T );
        mexPrintf( "\tNumber of test tokens ntest = %d\n" , ntest );
        mexPrintf( "\tNumber of iterations   N = %d\n"    , niter );
        mexPrintf( "\tHyperparameter     alpha = %4.4f\n" , alpha );
        mexPrintf( "\tHyperparameter      beta = %4.4f\n" , beta );
        mexPrintf( "\tSeed number              = %d\n"    , seed );
        mexPrintf( "\tNumber of tokens         = %d\n"    , ntokens );
        mexPrintf( "\tNonzeros labelsession matrix = %d\n"    , nz_labelsession );
    }
    
    // Create the output matrix with the (average) probability of the topic assignments for each test token and topic
    plhs[ 3 ] = mxCreateDoubleMatrix( ntest, T , mxREAL );
    avprobs = mxGetPr( plhs[ 3 ] );
    
    /* run the model */
    GibbsSampler( alpha, beta, W, T, D, niter, verbosity, ntokens, z, docid, wordid, sessionid, istesttoken, wp, dp, ztot, order, probs, startcond,
            ir_labelsession, jc_labelsession,nwordtypes,whalgorithm, avprobs,tokref, ntest, testphase );
    
    /* convert the full wp matrix into a sparse matrix */
    nz_wp = 0;
    for (i=0; i<W; i++) {
        for (j=0; j<T; j++)
            nz_wp += (int) ( *( wp + j + i*T )) > 0;
    }
    
    // Create the output sparse WP matrix
    plhs[0] = mxCreateSparse( W,T,nz_wp,mxREAL);
    sr_wp  = mxGetPr(plhs[0]);
    ir_wp = mxGetIr(plhs[0]);
    jc_wp = mxGetJc(plhs[0]);
    n = 0;
    for (j=0; j<T; j++) {
        *( jc_wp + j ) = n;
        for (i=0; i<W; i++) {
            c = (int) *( wp + i*T + j );
            if (c >0) {
                *( sr_wp + n ) = c;
                *( ir_wp + n ) = i;
                n++;
            }
        }
    }
    *( jc_wp + T ) = n;
    
    
    // create the output sparse DP matrix
    nz_dp = 0;
    for (i=0; i<D; i++) {
        for (j=0; j<T; j++)
            nz_dp += (int) ( *( dp + i*T + j )) > 0;
    }
    plhs[1] = mxCreateSparse( D,T,nz_dp,mxREAL);
    sr_dp = mxGetPr(plhs[1]);
    ir_dp = mxGetIr(plhs[1]);
    jc_dp = mxGetJc(plhs[1]);
    
    n = 0;
    for (j=0; j<T; j++) {
        *( jc_dp + j ) = n;
        for (i=0; i<D; i++) {
            c = (int) *( dp + i*T + j );
            if (c >0) {
                *( sr_dp + n ) = c;
                *( ir_dp + n ) = i;
                n++;
            }
        }
    }
    *( jc_dp + T ) = n;
    
    // Create the output vector with the topic assignments
    plhs[ 2 ] = mxCreateDoubleMatrix( 1,ntokens , mxREAL );
    z_output = mxGetPr( plhs[ 2 ] );
    for (i=0; i<ntokens; i++) z_output[ i ] = (double) z[ i ] + 1;
    
    // Divide by niter
    for (i=0; i<ntest; i++) {
        for (j=0; j<T; j++)
            *( avprobs + i + j*ntest ) = *( avprobs + i + j*ntest ) / (double) niter;
    }
}
