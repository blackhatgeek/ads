unit reseni;

interface

uses spojak;

{ nedestruktivni sjednoceni mnozin S1 a S2 }
function union(S1, S2: PItem): PItem;

{ nedestruktivni prunik mnozin S1 a S2 }
function intersection(S1, S2: PItem): PItem;

{ destruktivni sjednoceni mnozin S1 a S2, vstupni seznamy jsou zniceny a 
	promenne S1, S2 jsou nastaveny na nil }
function unionDestruct(var S1, S2: PItem): PItem;

{ destruktivni prunik mnozin S1 a S2, vstupni seznamy jsou zniceny a 
	promenne S1, S2 jsou nastaveny na nil }
function intersectionDestruct(var S1, S2: PItem): PItem;



implementation

function union(S1, S2: PItem): PItem;
var head,h1,h2,pom,h1prev:PItem;
begin
	if S1=nil then
		if S2=nil then union:=nil else union:=S1
	else begin
		head:=S1;
		h1:=S1;
		h2:=S2;
		h1prev:=nil;
		while(h1<>nil) and (h2<>nil) do begin
			if h1^.val <> h2^.val then begin 
				pom:=h1^.next;

				h1^.next:=h2;
				h1:=h1^.next;
				h1^.next:=pom;
			end;
			h1prev:=h1;
			h1:=h1^.next;
			h2:=h2^.next;
		end;
		if h2<>nil then if h1prev<>nil then h1prev^.next:=h2 else head:=S2;
		union:=head;
	end;
end;



function intersection(S1, S2: PItem): PItem;
begin
	intersection := nil;
end;



function unionDestruct(var S1, S2: PItem): PItem;
begin
	unionDestruct := nil;
end;



function intersectionDestruct(var S1, S2: PItem): PItem;
begin
	intersectionDestruct := nil;
end;

end.
