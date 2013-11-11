program sudalicha;
const max=1000;
var licha:array[1..max] of integer;
l,x:integer;
begin
  l:=0;
  repeat
    read(x);
    if x<>-1 then begin
      if x mod 2 = 0 then write(x,' ')
      else begin
        l:=l+1;
        licha[l]:=x
      end
    end;
  until (x=-1);
  for x:=1 to l do write(licha[x],' ');
end.
