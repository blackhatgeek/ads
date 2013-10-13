program eukleides;
var a,b:integer;
begin
	read(a,b);
	if (a<1) or (b<1) then writeln('Cisla musi byt prirozena!');
	while a<>b do begin
		a:=min(a,b);
		b:=a-b; 
	end;
	writeln(a);
end.
