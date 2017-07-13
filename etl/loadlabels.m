function [ newcorpus , sessioninfo , labelsinfo ] = loadlabels( corpus , minsessfreq )
%% Load the sessioninfo from an Excel file and remove any entries from corpus that do not have session labels

if nargin<=1
   % Set a threshold on the minimim number of sessions a label needs to be
   % associated with; if not met, label is deleted
   minsessfreq=5;
end

% Copy corpus to newcorpus
newcorpus = corpus;

% Load metadata
filenm = 'meta.data.4.03.13.xlsx';
warning off;
fprintf( 'Loading metadata with session and label information\n' );
sessioninfo = readtable( filenm );
warning on;

% summary( sessioninfo )
% Variables:
%     id: 1552x1 double
%         Values:
%             min          1
%             median     775
%             max       9148
%             NaNs         5
%     dorpid: 1552x1 double
%         Values:
%             min            1e+09
%             median    1.0011e+09
%             max            9e+09
%     X: 1552x1 cell string
%     X_1: 1552x1 cell string
%         Description:  Original column heading: 'X.1'
%     dorp_hierarchy: 1552x1 cell string
%     Title: 1552x1 cell string
%     Responsibility_Statement: 1552x1 cell string
%         Description:  Original column heading: 'Responsibility.Statement'
%     Page_Count: 1552x1 cell string
%         Description:  Original column heading: 'Page.Count'
%     Running_time: 1552x1 cell string
%         Description:  Original column heading: 'Running.time'
%     Publication_Year: 1552x1 cell string
%         Description:  Original column heading: 'Publication.Year'
%     Citation_Type: 1552x1 cell string
%         Description:  Original column heading: 'Citation.Type'
%     Client_gender: 1552x1 cell string
%         Description:  Original column heading: 'Client.gender'
%     Client_age_range: 1552x1 cell string
%         Description:  Original column heading: 'Client.age.range'
%     Client_marital_status: 1552x1 cell string
%         Description:  Original column heading: 'Client.marital.status'
%     Client_sexual_orientation: 1552x1 cell string
%         Description:  Original column heading: 'Client.sexual.orientation'
%     Therapist_gender: 1552x1 cell string
%         Description:  Original column heading: 'Therapist.gender'
%     Therapist_experience: 1552x1 cell string
%         Description:  Original column heading: 'Therapist.experience'
%     Therapist_education: 1552x1 cell string
%         Description:  Original column heading: 'Therapist.education'
%     Therapist_study: 1552x1 cell string
%         Description:  Original column heading: 'Therapist.study'
%     School_of_therapy: 1552x1 cell string
%         Description:  Original column heading: 'School.of.therapy'
%     Psyc_subject: 1552x1 cell string
%         Description:  Original column heading: 'Psyc.subject'
%     Symptoms: 1552x1 cell string
%     Therapies: 1552x1 cell string
%     Language_of_Edition: 1552x1 cell string
%         Description:  Original column heading: 'Language.of.Edition'
%     License_Status: 1552x1 cell string
%         Description:  Original column heading: 'License.Status'
%     Sequence_rank: 1552x1 cell string
%         Description:  Original column heading: 'Sequence.rank'
%     Lowest_Level_Div: 1552x1 cell string
%         Description:  Original column heading: 'Lowest.Level.Div'
%     action_date: 1552x1 cell string
%     ClientID: 1552x1 cell string
%     SessionID: 1552x1 cell string
%     male1: 1552x1 cell string
%     Ind_T1: 1552x1 cell string
%         Description:  Original column heading: 'Ind.T1'
%     Family_T1: 1552x1 cell string
%         Description:  Original column heading: 'Family.T1'
%     Group_T1: 1552x1 cell string
%         Description:  Original column heading: 'Group.T1'
%     Couple_T1: 1552x1 cell string
%         Description:  Original column heading: 'Couple.T1'
%     Other_T1: 1552x1 cell string
%         Description:  Original column heading: 'Other.T1'
%     Child_T1: 1552x1 cell string
%         Description:  Original column heading: 'Child.T1'
%     c_marital_status: 1552x1 cell string
%         Description:  Original column heading: 'c.marital.status'
%     new_label: 1552x1 cell string
%         Description:  Original column heading: 'new.label'
%     tx_category: 1552x1 cell string
%         Description:  Original column heading: 'tx.category'
%     caregiver: 1552x1 cell string

% Add a new column with the session ids
str = sessioninfo.X_1;
sessioninfo.sessionid_orig = str2double( str );

% remove the sessions with an empty session id
sessioninfo = sessioninfo( ~isnan( sessioninfo.sessionid_orig ) , : );

% Find the overlapping sessions that are in the corpus as well as the metadata
[ sessionid_orig , i1 , i2 ] = intersect( newcorpus.T.sessionid_orig , sessioninfo.sessionid_orig );

% Remove the sessions that are not in the metadata
sessioninfo = sessioninfo( i2 , : );

% Parse the labels with the subject as well as the symptoms
nsessions = height( sessioninfo );
ii = 0;
allstr = cell( 1,0 );
alls = zeros( 1,0 );
alltypes = zeros( 1,0 );
for i=1:nsessions
    % Parse the subject labels for this session
    str = sessioninfo.Psyc_subject( i );
    
    c = textscan( str{1} , '%s' , 'Delimiter' , { ';' } );
    strs = strtrim( lower( c{ 1 } ));
    strs( strcmp( strs , 'na' )) = [];
    ns = length( strs );
    
    allstr( ii+1:ii+ns ) = strs;
    alls( ii+1:ii+ns ) = i;
    alltype( ii+1:ii+ns ) = 1; % 1 = subject; 2 = symptom
    ii = ii + ns;

    % Parse the symptom labels for this session
    str = sessioninfo.Symptoms( i );
    
    c = textscan( str{1} , '%s' , 'Delimiter' , { ';' } );
    strs = strtrim( lower( c{ 1 } ));
    strs( strcmp( strs , 'na' )) = [];
    ns = length( strs );
    
    allstr( ii+1:ii+ns ) = strs;
    alls( ii+1:ii+ns ) = i;
    alltype( ii+1:ii+ns ) = 2; % 1 = subject; 2 = symptom
    ii = ii + ns;
end

% change all labels "suicidal ideation" to "suicidal behavior"
wh = find( strcmp( allstr , 'suicidal ideation' ));
allstr( wh ) = { 'suicidal behavior' };

% Create a sparse matrix with the subject labels
wh = find( alltype == 1 );
[ l1 , ~ , lindex ] = unique( allstr( wh ) );
nl1 = length( l1 );
m1 = sparse( lindex , alls( wh ) , ones( size( lindex )) , nl1 , nsessions ); 

% Create a sparse matrix with the symptom labels
wh = find( alltype == 2 );
[ l2 , ~ , lindex ] = unique( allstr( wh ) );
nl2 = length( l2 );
m2 = sparse( lindex , alls( wh ) , ones( size( lindex )) , nl2 , nsessions );

% Now store the combined vocabulary of labels in labelsinfo
labelsinfo.label = [ l1'; l2' ];
labelsinfo.labeltypes = { 'Subject' , 'Symptom' };
labelsinfo.labeltype = [ ones(length(l1),1); 2*ones(length(l2),1) ];
labelsinfo.labelmatrix = [ m1; m2 ];
labelsinfo.sessionid_orig = sessionid_orig;

% change the symptom 'Depression (emotion)' to 'Depression'
wh = find( strcmp( labelsinfo.label , 'depression (emotion)' ));
labelsinfo.label{ wh } = 'depression';

%% Remove rare labels 
freqs = full( sum( labelsinfo.labelmatrix , 2 ));
whok = find( freqs >= minsessfreq );

labelsinfo.labeltype   = labelsinfo.labeltype( whok );
labelsinfo.labelmatrix = labelsinfo.labelmatrix( whok , : );
labelsinfo.label       = labelsinfo.label( whok );

% are we now left with empty sessions????
nlabels = full( sum( labelsinfo.labelmatrix , 1 ));
%if any( nlabels == 0 )
%    warning( 'Some sessions in corpus have no labels and will be removed' );
%end

whok = find( nlabels > 0 );
labelsinfo.sessionid_orig = labelsinfo.sessionid_orig( whok );
labelsinfo.labelmatrix = labelsinfo.labelmatrix( : , whok );

% Remove corpus entries with sessions for which we don't have metadata
oldn = height( newcorpus.T );
[ whok , whloc ] = ismember( newcorpus.T.sessionid_orig , labelsinfo.sessionid_orig );
newcorpus.T = newcorpus.T( whok , : );
n = height( newcorpus.T );

% Vector with all session indices for each token
newcorpus.T.sessionid = uint32( whloc( whok ));
