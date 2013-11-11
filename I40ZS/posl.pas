program posl;
const n=1000;
type pole=array[1..n] of integer;
var
pos:pole;
x,i:integer;

procedure quick(var p:pole;l,r:integer);
var i,j,k,x:integer;
begin
  i:=l; j:=r;
  k:=p[(i+j) div 2];
  repeat
    if p[i]<k then i:=i+1;
    if p[j]>k then j:=j-1;
    if i<=j then begin
      x:=p[i];
      p[i]:=p[j];
      p[j]:=x;
      i:=i+1;
      j:=j-1;
    end;
  until i>=j;
  if j>l then quick(p,l,j);
  if i<r then quick(p,i,r);
end;

begin
  read(x);
  if x<>-1 then begin
    i:=0;
    repeat
      i:=i+1;
      pos[i]:=x;
      read(x)
    until x=-1;
  end;
  quick(pos,1,i);
  for x:=1 to i do write(pos[x],' ');
end.

