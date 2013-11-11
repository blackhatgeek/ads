var max1,max2,x:integer;
begin
	read(max1,max2);
	if max2>max1 then begin
		x:=max1;
		max1:=max2; 
		max2:=x;
	end;
	read(x);
	while x<>-1 do begin
		if max1=max2 then if x<max1 then max2:=x else max1:=x;
		if x>max1 then begin
			max2:=max1; 
			max1:=x;
		end else if (x>max2) and (x<>max1) then max2:=x;
		read(x);
	end;
	write(max2);
end.
