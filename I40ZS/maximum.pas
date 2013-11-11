program maximum;
var x,max:integer;
begin
     read(max);
     read(x);
     while (x<>-1) do begin
           if x>max then max:=x;
           read(x)
     end;
     writeln(max)
end.
