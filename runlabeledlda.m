function  runlabeledlda( whsim , whpartition )

addpath('utils', 'etl')
%%  Apply Labeled LDA model to PsychoTherapy Corpus
% Version 3 
% Allows special settings for sim.trainingmode:

% sessionsplit=-1: no test tokens at all (useful for finding representative
% talk turns across all corpus

% sessionsplit=0: test tokens for locally rated talk turns + test sessions
% BUT the tokens for locally rated talk turns have OBSERVED labels

% sessionsplit=1: test tokens for locally rated talk turns + test sessions


% if nargin<1
%     whsim = 1;
% end
% if nargin<2
%     whpartition = 1;
% end

% Determine level of output to screen/text files
output          = 1;
writefreqngrams = 0;
showexamples    = 0;

%% Load corpus (this structure will not change)
if ~exist( 'corpus1' , 'var' )
    corpus1 = loadcorpus;
end

%% Set params of simulation
[ sim ] = setsimulationparams( whsim );

%% Extract n-grams and apply filters to remove bad ngrams
%if ~exist( 'corpus2' , 'var' )
corpus2 = extractngrams( corpus1 , sim.preprocessoption , writefreqngrams , sim.whspeaker );

%% Create a structure with information about labels and session
% overwrite corpus2 because some sessions in the original corpus don't
% have label information in the metadata -- these are removed in the
% updated version of corpus2
[ corpus2 , sessioninfo , labelsinfo_temp ] = loadlabels( corpus2 , sim.minsessfreq );

%% Extract the ratings for local talk turns (from a separate ratings experiment by Imel)
[ localcoding ] = loadlocalcodes( labelsinfo_temp , corpus1 , showexamples );

%% Add background labels
[ labelsinfo ] = addbackgroundlabels( labelsinfo_temp , sim.T );

%% Define documents in vector docid
if sim.docdef==1 % define documents by session id
    sessionid_orig = double( corpus2.T.sessionid_orig );
    [ usessionid , ~ , docid ] = unique( sessionid_orig );
elseif sim.docdef==2 % define documents by talk turn
    docid = corpus2.T.talkturnid;
end

% Extract the word id's
wordid = corpus2.T.ngramid;

% Extract the session id's
sessionid = corpus2.T.sessionid;

% Extract the vocab
vocab = corpus2.ngrams;
nw = length( vocab );

% Calculate the NWORDTYPES vector
nwordtypes = calculatewordcounts( labelsinfo.labelmatrix, wordid , sessionid , nw );

% Do a train/test split
[ traininginfo ] = traintestsplit( localcoding, sim.seed, sim.trainingmode, corpus2, whpartition );

%%  Run Gibbs sampler for multiple chains
for chain=1:sim.nchains
    fprintf( '\nRunning chain %d\n' , chain );
    tic;
    seed = chain * 1000;
    if sim.trainingmode < 0
        seed = seed + whpartition * 2;
    end
    testphase = 0;
    for s=1:sim.nreps
        fprintf( 'Working on rep = %d (testphase=%d)\n' , s , testphase );
        seed = seed + 1;
        if (s==1)
            [ wp , dp , z , avp ] = GibbsSamplerLABELEDLDA( double(wordid) , double(docid) , double(sessionid) , double(traininginfo.istesttoken), labelsinfo.labelmatrix , sim.niter , sim.alpha , sim.beta , nwordtypes , seed , output , sim.whalgorithm , testphase );
        else
            [ wp , dp , z , avp ] = GibbsSamplerLABELEDLDA( double(wordid) , double(docid) , double(sessionid) , double(traininginfo.istesttoken), labelsinfo.labelmatrix , sim.niter , sim.alpha , sim.beta , nwordtypes , seed , output , sim.whalgorithm , testphase , z );
        end
        WriteTopicsPlusLabels( wp , sim.beta , vocab , labelsinfo.label , 30 , 0.7 , 4 , ...
            fullfile('lda_results', sprintf( 'labeledlda_s%d_c%d_p%d.txt' , whsim , chain , whpartition ) ) );
    end
    
 	if whsim == 8
       filenm2 = fullfile('Results', 'Sim8', 'trainingoutput'); 
       save(filenm2, 'wp', 'dp', 'avp', 'whsim' , 'z' , 'sim' , 'traininginfo' , 'labelsinfo' );    
    end
    
    
    %% Only collect information about test tokens if there are any
    if sim.trainingmode>=0
        % Start testing and begin with a brief burnin
        testphase = 1;
        fprintf( 'Working on testphase (burnin)\n' );
        [ wp , dp , z , avp ] = GibbsSamplerLABELEDLDA( double(wordid) , double(docid) , double(sessionid) , double(traininginfo.istesttoken), labelsinfo.labelmatrix , sim.test_burnin , sim.alpha , sim.beta , nwordtypes , seed , output , sim.whalgorithm , testphase , z );
        fprintf( 'Working on testphase (collecting samples for avp)\n' );
        [ wp , dp , z , avp ] = GibbsSamplerLABELEDLDA( double(wordid) , double(docid) , double(sessionid) , double(traininginfo.istesttoken), labelsinfo.labelmatrix , sim.test_iter , sim.alpha , sim.beta , nwordtypes , seed , output , sim.whalgorithm , testphase , z );
        
        % Collect the output of the labeled topic model for the locally tagged
        % talk turns
        [ localcodingpreds ] = collecttalkturnpredictions2( avp , localcoding , traininginfo );
       
        % Collect the output of the labeled topic model for the test sessions
        [ sessionpreds ] = collectsessionpredictions( avp , labelsinfo , traininginfo );
    else
        localcodingpreds = [];
        sessionpreds = [];
    end
    
    %% Save output here....
    % keep variables to a minimum because we can reconstruct most of the data if we know what simulation was run
    % save these outside the scope of the shared dropbox folder 
    %filenm = sprintf( '..\\lda_results\\labeledlda_s%d_c%d_p%d.mat' , whsim , chain , whpartition );
    filenm = fullfile('lda_modelpreds', sprintf( 'labeledlda_s%d_c%d_p%d.mat' , whsim , chain , whpartition ));
    z = uint32( z );
    if whsim == 8
       filenm2 = fullfile('Results', 'Sim8', 'testoutput'); 
       save(filenm2, 'wp', 'dp', 'avp', 'whsim' , 'z' , 'sim' , 'traininginfo' , 'localcodingpreds' , 'sessionpreds' , 'labelsinfo' );    
    end
end
    
    save( filenm , 'whsim' , 'z' , 'sim' , 'traininginfo' , 'localcodingpreds' , 'sessionpreds' , 'labelsinfo' );    


