function d = loadcorpus2( whversion )
% Load the psychotherapy corpus into structure "d"

% Check input
narginchk(0,1);
if nargin==0
   whversion=1; 
end

% which version of the corpus (future versions might support updated
% versions of the corpus
if whversion==1
    % Load data in Matlab form
    fprintf( 'Loading corpus\n' );
    load( 'corpus2_new.mat' );
    % Data contains a single structure "d"
    % d =
    %     sessionid_orig: [8051156x1 double]
    %          speakerid: [8051156x1 double]
    %         talkturnid: [8051156x1 double]
    %        talkturnid2: [8051156x1 double]
    %        isfirstword: [8051156x1 double]
    %       isquotedtext: [8051156x1 double]
    %           speakers: {2x1 cell}
    %               tags: {1x44 cell}
    %              tagid: [8051156x1 double]
    %              words: {1x39535 cell}
    %             wordid: [8051156x1 double]   maps into d.words
    %           sessions: [1199x1 double]
    %          sessionid: [8051156x1 double]
        
     T = table( uint32( d.sessionid_orig ), ...
                uint32( d.talkturnid2 ),...
                uint32( d.tagid ),...
                uint32( d.wordid ),... 
                uint8( d.speakerid ),...
                'VariableNames',...
                {'sessionid_orig','talkturnid','tagid','wordid','speakerid'});

           
    % There were some duplicate sessions in the data; remove these
    % Order pairs such that second session id of pair is the bad one
    duplicates = [...
        1000013280  1000088106; ...
        1000013418	1000013384; ...
        1000088085	1000088084; ...
        1001280398	1001083962; ...
        1004466286	1004466285 ];
    
    % partial duplicates
    duplicates = [ duplicates; 1000375333 1000122160 ];    
    nd = size( duplicates , 1 );    
    badrows = [];
    for i=1:nd
        whbad = find( d.sessionid_orig == duplicates( i , 2 ))';
        if ~isempty( whbad )
           badrows = horzcat( badrows , whbad );
        end
    end
    
    T(badrows,:) = [];
    
    fields = {'sessions','sessionid_orig','speakerid','talkturnid','talkturnid2','isfirstword','isquotedtext','tagid','wordid','sessionid'};
    d = rmfield(d,fields);
    d.T = T;
elseif whversion==2
    %% Load the MI corpus with vocabulary and pos tags aligned to General PsychoTherapy corpus
    fprintf( 'Loading psychotherapy corpus\n' );
    load( 'corpus2_new.mat' );
    d2 = d;
    
%     d2 = 
%     sessionid_orig: [8051156x1 double]
%          speakerid: [8051156x1 double]
%         talkturnid: [8051156x1 double]
%        talkturnid2: [8051156x1 double]
%        isfirstword: [8051156x1 double]
%       isquotedtext: [8051156x1 double]
%           speakers: {2x1 cell}
%               tags: {1x44 cell}
%              tagid: [8051156x1 double]
%              words: {1x39535 cell}
%             wordid: [8051156x1 double]
%           sessions: [1199x1 double]
%          sessionid: [8051156x1 double]
    
    fprintf( 'Loading psychotherapy corpus\n' );
    load( '..\data\corpusMI1.mat' );
    
%     d = 
%              misclabels: {53x1 cell}
%              nmisccodes: 53
%     misccodes_allraters: [53x30090 double]
%         misccodes_rater: [53x30090x3 double]
%          sessionid_orig: [1035174x1 double]
%               speakerid: [1035174x1 double]
%              talkturnid: [1035174x1 double]
%             talkturnid2: [1035174x1 double]
%             isfirstword: [1035174x1 double]
%            isquotedtext: [1035174x1 double]
%       reftalkturncoding: [1035174x1 double]
%                speakers: {2x1 cell}
%                    tags: {1x43 cell}
%                   tagid: [1035174x1 double]
%                   words: {1x11117 cell}
%                  wordid: [1035174x1 double]
%                sessions: [148x1 double]
%               sessionid: [1035174x1 double]
    
    %% Align vocubulary
    [ ismem , whloc ] = ismember( d.words , d2.words );
    whok  = ismem( d.wordid );
    wordid = d.wordid( whok );
    
    d3.wordid     = whloc( wordid )';
    d3.sessionid_orig  = d.sessionid_orig( whok );
    d3.tagid      = d.tagid( whok );
    d3.speakerid  = d.speakerid( whok );
    d3.talkturnid2 = d.talkturnid2( whok );
    d3.words       = d.words;
    
    %% Align tags
    [ ismem , whloc ] = ismember( d.tags , d2.tags );
    %whok  = ismem( d.tagid );
    %tagid = d.tagid( whok );
    
    d3.tagid = whloc( d3.tagid )';
    
    newd.T = table( uint32( d3.sessionid_orig ), ...
                uint32( d3.talkturnid2 ),...
                uint32( d3.tagid ),...
                uint32( d3.wordid ),... 
                uint8( d3.speakerid ),...
                'VariableNames',...
                {'sessionid_orig','talkturnid','tagid','wordid','speakerid'});
            
    newd.words = d2.words;  
    newd.speakers = d.speakers;
    newd.tags = d2.tags;
    
    d = newd;
%     d = 
%     speakers: {2x1 cell}
%         tags: {1x44 cell}
%        words: {1x39535 cell}
%            T: [8031580x5 table]
else
    error( 'Version not supported' ); 
end


