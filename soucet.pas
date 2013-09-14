program soucet;
{funkce soucet secte dva integery}
function soucet(x,y:integer):integer;
var ret:integer;
begin
	if x=0 then ret:=y else ret:=soucet((x and y)<<1,x xor y);
	soucet:=ret;
end;

begin
end.
