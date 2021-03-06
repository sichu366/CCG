function ew = edge_weight(mesh)
% compute edge weight
face = mesh.face;
edge = mesh.edge;
vert = mesh.vert;
% eif indicate which face this edge belongs to, one row for one edge, -1
% means boundary edge
eif = mesh.eif;

ne = size(edge,1);
ew = zeros(ne,1);

% ev1 is the third vert in a triangle: v3 = (v1+v2+v3) - (v1+v2)
ind1 = eif(:,1)>0;
ev1 = sum(face(eif(ind1,1),:),2) - sum(edge(ind1,:),2);
ct1 = cot2(vert(ev1,:),vert(edge(ind1,1),:),vert(edge(ind1,2),:));
ew(ind1) = ew(ind1) + ct1;
% ev2 is similar to ev1
ind2 = eif(:,2)>0;
ev2 = sum(face(eif(ind2,2),:),2) - sum(edge(ind2,:),2);
ct2 = cot2(vert(ev2,:),vert(edge(ind2,1),:),vert(edge(ind2,2),:));
ew(ind2) = ew(ind2) + ct2;
ew(ind1&ind2) = ew(ind1&ind2)/2;
% store ew for later use
mesh.ew = ew;

function ct = cot2(pi,pj,pk)
a = sqrt(dot(pj-pk,pj-pk,2));
b = sqrt(dot(pk-pi,pk-pi,2));
c = sqrt(dot(pi-pj,pi-pj,2));
cs = (b.*b+c.*c-a.*a)./(2.*b.*c);
ss2 = 1-cs.*cs;
ss2(ss2<0) = 0;
ss2(ss2>1) = 1;
ss = sqrt(ss2);
ct = cs./ss;