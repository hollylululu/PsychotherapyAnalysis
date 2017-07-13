    function [ sim ] = setsimulationparams( whsim )
%% Sets the simulation parameters; this is the file to edit

% Vary the following params
% docdef: 1 or 2
% T: number of background topics
% preprocess option: 1 2 3
% whalgorithm: 2 or 1
% alpha 50 10 1 500
% beta
% whspeaker: 3 or 2 or 1

if whsim == 1
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5; % 
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 2
    % Same as whsim=1 but only patient speech
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 1; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 3
    % Same as whsim=1 but with talk turn level docs
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 4
    % Same as whsim=1 but with 50 additional topics
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5; % !!!!!!!!!!!!!!!!
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 5
    % Same as whsim=4 but with preprocess=1
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 1; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5; % !!!!!!!!!!!!!!!!
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 6
    % Same as whsim=3 (talk turn level docs) but with 2-3 grams added
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 7
    % Same as whsim=6 (talk turn level docs) but with 20 background topics
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 20; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 8
    % Same as whsim=6 (talk turn level docs) but with 50 background topics
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 9
    % Same as whsim=6 (talk turn level docs) but with patient talk only
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 1; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 10
    % Same as whsim = 6 (talk turn level docs) but using standard algorithm
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 1;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 11
    % Same as whsim = 6 (talk turn level docs) but using 100 topics
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 100; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 12
    % Same as whsim = 6 (talk turn level docs) but using 200 topics 
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 200; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 13
    % Same as whsim = 8 (talk turn level docs) but using patient talk turns
    % only
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 1; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 14
    % Same as whsim = 13 (talk turn level docs) but using 20 background
    % topics 
    % only
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 1; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 20; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 15
    % Same as whsim = 13 (talk turn level docs) but using 100 background
    % topics 
    % only
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 1; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 100; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 16
    % Same as whsim=6 (talk turn level docs) but using different random
    % seed
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 2; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 17
    % Same as whsim=11 (talk turn level docs) but using different
    % preprocessing 
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 100; % Number of additional topics
    sim.preprocessoption = 1; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 18
    % Same as whsim=17 (talk turn level docs) but with 200 background topics  
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 200; % Number of additional topics
    sim.preprocessoption = 1; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 19
    % Same as whsim=17 (talk turn level docs) but with 50 background topics  
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 1; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 20
    % Same as whsim=6 (talk turn level docs) but alpha = 1
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 1; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 21
    % Same as whsim=6 (talk turn level docs) but alpha = 100
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 100; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 22
    % Same as whsim=6 (talk turn level docs) but alpha = 500
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 500; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 23
    % Same as whsim = 11 (talk turn level docs) but with docdef = 1
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 100; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 24
    % Same as whsim = 12 (talk turn level docs) but docdef = 1
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 200; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 25
    % Same as whsim = 24 (talk turn level docs) but T = 50
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 26
    % Same as whsim = 23 (talk turn level docs) but with preprocessing = 1
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 100; % Number of additional topics
    sim.preprocessoption = 1; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 27
    % Same as whsim = 24 (talk turn level docs) but with preprocessing = 1
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 200; % Number of additional topics
    sim.preprocessoption = 1; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 28
    % Same as whsim=6 (talk turn level docs) but using different random
    % seed
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 3; % seed for random number generator (e.g. for crossvalidation partitions)
end
if whsim == 29
    % Same as whsim=6 (talk turn level docs) but using different random
    % seed
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 4; % seed for random number generator (e.g. for crossvalidation partitions)
end
if whsim == 30
    % Same as whsim=6 (talk turn level docs) but using different random
    % seed
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 5; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 31
    % Same as whsim=6 (talk turn level docs) but with niter = 200
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 200; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 32
    % Same as whsim=6 (talk turn level docs) but with niter = 300 
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 300; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 33
    % Same as whsim=6 (talk turn level docs) but with test_burnin = 25
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 25; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 34
    % Same as whsim=6 (talk turn level docs) but with test_burnin = 50
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 50; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 35
    % Same as whsim=6 (talk turn level docs) but with test_iter = 25
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 25; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end


if whsim == 36
    % Same as whsim=6 (talk turn level docs) but with test_iter = 50
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 50; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 37
    % Same as whsim=8 (talk turn level docs) but with preprocessing option
    % = 2 
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 38
    % Same as whsim=6 (talk turn level docs) but with preprocessing option
    % = 1
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 1; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 39
    % Same as whsim = 11 (talk turn level docs) but with preprocessing
    % option = 2
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 100; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 40
    % Same as whsim = 12 (talk turn level docs) but with preprocessing
    % option = 2
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 200; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 41
    % Same as whsim = 23 (talk turn level docs) but preprocessing option = 2
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 100; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end


if whsim == 42
    % Same as whsim = 24 (talk turn level docs) but with preprocessing
    % option = 2
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 200; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 43
    % Same as whsim=7 but whalgorithm = 1
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 20; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 1;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 44
    % Same as whsim=6 (talk turn level docs) but with  T = 0
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 0; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 45
    % Same as whsim=38 (talk turn level docs) but with T = 0
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 0; % Number of additional topics
    sim.preprocessoption = 1; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 46 % Same as whsim = 1 but with T = 0
    sim.docdef           = 1; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 0; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5; % 
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 47
    % Same as whsim=3 but with T = 0
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 0; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 48
    % Same as whsim=9 (talk turn level docs) but with T = 0
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 1; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 0; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 48
    % Same as whsim=9 (talk turn level docs) but with T = 0
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 1; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 0; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 49
    % Same as whsim=3 but with test tokens only for locally rated talk
    % turns
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 2; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    
    load('corpus2.mat');
    un = unique(corpus2.T.ngramid);
    count = histc(corpus2.T.ngramid, un);
    
    sim.alpha            = count; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    sim.nreps            = 5; % !!!!!!!!!!!!!!!!!!!!
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 0; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 1006
    % Same as whsim=3 (talk turn level docs) but with 2-3 grams added
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 5; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 0; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 1007
    % Same as whsim=6 (talk turn level docs) but with 20 background topics
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 20; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 0; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 800
    % Same as whsim=6 (talk turn level docs) but with 50 background topics
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 50; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 5;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end

if whsim == 8000
    % Same as whsim=6 (talk turn level docs) but with 50 background topics
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 1000; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end
if whsim == 80000
    % Same as whsim=6 (talk turn level docs) but with 50 background topics
    sim.docdef           = 2; % 1=session level docs; 2=talk turn level docs
    sim.whspeaker        = 3; % 1=patient only; 2=therapist only; 3=both
    sim.T                = 50; % Number of additional topics
    sim.preprocessoption = 3; % preprocessing version
    sim.minsessfreq      = 5; % minimum number of sessions needed for a label to be included
    sim.whalgorithm      = 2;
    sim.alpha            = 5000; % total prior mass
    sim.beta             = 100; % total prior mass
    sim.niter            = 100; % number of iterations for each chain
    sim.nreps            = 5;
    sim.nchains          = 1;
    sim.test_burnin      = 10; % number of iterations in initial test phase (to start the document counts)
    sim.test_iter        = 10; % number of iterations to average the probabilities
    sim.trainingmode     = 1; % -1=no test tokens; 0=cross-validate sessions; locally rated talk turns have OBSERVED labels; 1=cross-validate sessions; locally rated talk turns have NO observed labels 
    sim.seed             = 1; % seed for random number generator (e.g. for crossvalidation partitions)
end
