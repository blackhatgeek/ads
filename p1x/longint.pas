program longint;

type 
cislice=0..9;
longint_32=array[1..10] of cislice;
longint_32a=array[0..10] of cislice;{kontrola preteceni}
zaznam=record c:cislice; p:boolean end;

var 
souc_bez:array[cislice,cislice] of zaznam; 
souc_s:array[cislice,cislice] of zaznam;
i,j:integer;

function f_soucet(a,b:longint_32):longint_32a;
var aa,bb,cc:longint_32a; delka_a,delka_b:integer;pom:longint_32; stav:boolean;
begin
	{ktere z cisel je delsi - najdu prvni nenulovou cislici a a prvni nenulovou cislici b}
	delka_a:=0;i:=0;while a[i]<>0 do i:=i+1; delka_a:=10-i;
	delka_b:=0;i:=0;while b[i]<>0 do i:=i+1; delka_b:=10-i;
	{delsi z cisel} if delka_a<delka_b then begin pom:=a; a:=b; b:=pom; i:=delka_a;delka_a:=delka_b;delka_b:=i end;
	{doplnime z leva jednou nulou} aa[0]:=0; for i:=1 to 10 do aa[i]:=a[i];
	{kratsi z cisel doplnime z leva tolika nulami, aby byla stejne dlouha}
	bb[0]:=0; for i:=1 to (delka_a-delka_b-1) do bb[i]:=0;
	{postupujeme zprava a ke kazde dvojici vysledku urcime cislici vysledku z prislusneho pole dle stavu}
	{na zacatku je stav bez prenosu}stav:=false;
	for i:=10 downto 0 do
		if stav=false then begin
			cc[i]:=souc_bez[aa[i],bb[i]].c;
			stav:=souc_bez[aa[i],bb[i]].p;	
		end else begin
			cc[i]:=souc_s[aa[i],bb[i]].c;
			stav:=souc_s[aa[i],bb[i]].p;
		end;
	f_soucet:=cc;
end;

begin
	
	{naplnim pole pro stav bez prenosu}
	for i:=0 to 9 do begin {radek, y}
		for j:=0 to (9-i) do begin{sloupec, x}
			bez[j,i].c:=i+j;
			bez[j,i].p:=false;
		end;
		for j:=(9-i+1) to 9 do begin
			bez[j,i].c:=10-i-j;
			bez[j,i].p:=true;
		end;
	end;
	{naplnim pole pro stav s prenosem}
	for j:=0 to 9 do begin{sloupec,x}
		for i:=0 to (8-j) do begin{radek,y}
			s[j,i].c:=i+j+1;
			s[j,i].p:=false;
		end;
		for i:=(9-j) to 9 do begin
			s[j,i].c:=9-i-j;
			s[j,i].p:=true;
		end;
	end;
end.
