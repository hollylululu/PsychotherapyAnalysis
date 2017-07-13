function [ labelsinfo2 ] = addbackgroundlabels( labelsinfo , nb )
%% Add background labels to labels structure

% labelsinfo = 
%              label: {528x1 cell}
%         labeltypes: {'Subject'  'Symptom'}
%          labeltype: [528x1 double]
%        labelmatrix: [528x1184 double]
%     sessionid_orig: [1184x1 uint32]

ns = size( labelsinfo.labelmatrix , 2 );
newm = sparse( ones( nb , ns ));
newl = cell( nb , 1 );
for i=1:nb
    newl{ i } = sprintf( 'background %d' , i );
end

labelsinfo2.label       = [ labelsinfo.label;       newl ];
labelsinfo2.labeltypes  = [ labelsinfo.labeltypes   { 'Background' } ];
labelsinfo2.labeltype   = [ labelsinfo.labeltype;   repmat( max( labelsinfo.labeltype ) + 1 , nb , 1 )];
labelsinfo2.labelmatrix = [ labelsinfo.labelmatrix; newm ];
labelsinfo2.sessionid_orig = labelsinfo.sessionid_orig;
