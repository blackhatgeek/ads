program oppole;
var pole:array[1..1000] of integer;
i,x:integer;
begin
  i:=1;
  repeat
    read(x);
    if x<>-1 then begin
      pole[i]:=x;
      i:=i+1;
    end
  until x=-1;
  x:=i-1;
  for i:=x downto 1 do write(pole[i],' ');
end.
