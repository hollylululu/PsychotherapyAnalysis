function runjobs( whsims , whps , nworkers )

addpath('utils', 'etl')

%% Run jobs in parallel
%whsims     = [ 3 6 ]; %%[ 28:34  ]; % which simulations to run?
%whps       = [ 1:10 ]; % which partitions?
%nworkers   = 6; % how many workers to use?

nsims = length( whsims );
np    = length( whps );

p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    poolsize = 0;
else
    poolsize = p.NumWorkers;
end

if poolsize ~= nworkers
    fprintf( 'Starting up pool with %d workers\n' , nworkers );
    parpool( nworkers );
end

% Determine number of jobs
njobs = nsims * np;
jobs = zeros( njobs , 2 );
ii = 0;
for i=1:nsims
   for  j=1:np
       ii = ii + 1;
       job( ii , 1 ) = whsims( i );
       job( ii , 2 ) = whps( j );
   end
end

parfor j=1:njobs
    whsim = job( j , 1 );
    whp   = job( j , 2 );  
    fprintf( 'Starting simulation=%d partition=%d\n' , whsim , whp );
    runlabeledlda( whsim , whp );
end

