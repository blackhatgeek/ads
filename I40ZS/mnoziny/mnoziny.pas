program mnoziny;

uses reseni,spojak;

procedure print(S1:PItem);
begin
	while(S1<>nil) do begin
		writeln(S1^.val);
		S1:=S1^.next;
	end;
end;


var a,b,c,d:PItem;
begin
	new(a);
	a^.val:=1;
	new(c);
	c^.val:=2;
	a^.next:=c;
	new(d);
	d^.val:=3;
	c^.next:=d;
	c:=d;
	new(d);
	d^.val:=5;
	c^.next:=d;
	writeln('Seznam A:');
	print(A);

	new(b);
	b^.val:=2;
	new(c);
	c^.val:=4;
	b^.next:=c;
	new(d);
	d^.val:=6;
	c^.next:=d;
	c:=d;
	new(d);
	d^.val:=8;
	c^.next:=d;
	writeln('Seznam B:');
	print(B);
	writeln('Union A,B');
	print(union(A,B));
end.
