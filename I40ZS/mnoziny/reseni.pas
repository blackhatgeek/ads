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
var seznam,p,q:PItem;
begin
	if S1=nil then begin
		if S2=nil then union:=nil
		else begin
			new(seznam);
			seznam^.val:=S2^.val;
			p:=seznam;
			S2:=S2^.next;
			while S2<>nil do begin
				new(q);
				q^.val:=S2^.val;
				p^.next:=q;
				p:=q;
				S2:=S2^.next
			end;
			p^.next:=nil;
			union:=seznam
		end
	end else if S2=nil then begin
		new(seznam);
		seznam^.val:=S1^.val;
		p:=seznam;
		S1:=S1^.next;
		while S1<>nil do begin
			new(q);
			q^.val:=S1^.val;
			p^.next:=q;
			p:=q;
			S1:=S1^.next
		end;
		p^.next:=nil;
		union:=seznam
	end else begin
		new(seznam);
		if S1^.val>S2^.val then begin			
			seznam^.val:=S1^.val;
			S1:=S1^.next
		end else if S2^.val>S1^.val then begin
			seznam^.val:=S2^.val;
			S2:=S2^.next
		end else begin
			seznam^.val:=S1^.val;
			S1:=S1^.next;
			S2:=S2^.next
		end;
		p:=seznam;
		while(S1<>nil)and(S2<>nil) do begin
			while(S1^.val>S2^.val) do begin
				new(q);
				q^.val:=S1^.val;
				p^.next:=q;
				p:=q;
				S1:=S1^.next
			end;
			while(S2^.val>S1^.val) do begin
				new(q);
				q^.val:=S2^.val;
				p^.next:=q;
				p:=q;
				S2:=S2^.next
			end;
			while(S1^.val=S2^.val) do begin
				new(q);
				q^.val:=S1^.val;
				p^.next:=q;
				p:=q;
				S1:=S1^.next;
				S2:=S2^.next
			end
		end;
		p^.next:=nil;
		union:=seznam
	end
end;



function intersection(S1, S2: PItem): PItem;
begin
	intersection := nil;
end;



function unionDestruct(var S1, S2: PItem): PItem;
var p,head:PItem;
begin
	if(S1=nil)and(S2=nil) then unionDestruct:=nil
	else if (S1=nil) and (S2<>nil) then unionDestruct:=S2
	else if (S1<>nil) and (S2=nil) then unionDestruct:=S1
	else begin
		if S1^.val <= S2^.val then head:=S1 else head:=S2;
		{while (S1^.next<>nil) or (S2^.next<>nil) do begin}
		repeat
			while (S1^.val>S2^.val) and (S2^.next<>nil) do S2:=S2^.next;
			if (S1^.val>=S2^.val) then
				if S2^.val=S1^.val then begin 
					p:=S2^.next; 
					dispose(S2); 
					S2:=p 
				end else begin
					p:=S2^.next;
					S2^.next:=S1;
					S2:=p
				end;
			while (S2^.val>S1^.val) and (S1^.next<>nil) do S1:=S1^.next;
			if (S2^.val>=S1^.val) then
				if S2^.val=S1^.val then begin
					p:=S2^.next;
					dispose(S2);
					S2:=p
				end else begin
					p:=S1^.next;
					S1^.next:=S2;
					S1:=p
				end
		until (S1^.next=nil) or (S2^.next=nil);
		if S1^.next=nil then begin S1^.next:=S2; S2:=nil end;
		p:=S1;
		S1:=nil;
		unionDestruct:=head;
	end;
end;



function intersectionDestruct(var S1, S2: PItem): PItem;
begin
	intersectionDestruct := nil;
end;

end.
