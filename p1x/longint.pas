program longint;

type 
cislice=0..9;
longint_32=array[1..10] of cislice;
longint_32a=array[0..10] of cislice;{kontrola preteceni}
longint_32b=record cislo:longint_32a; znamenko:boolean end;{rozdil}
zaznam=record c:cislice; p:boolean end;

var 
souc_bez,souc_s,rozd_bez,rozd_s:array[cislice,cislice] of zaznam; 
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

function f_rozdil(a,b:longint_32):longint_32b;
var aa,bb,cc:longint_32a;delka_a,delka_b:integer;pom:longint_32;stav:boolean;vysl:longint_32b;
begin
	{ktere z cisel je delsi - najdu prvni nenulovou cislici a a prvni nenulovou cislici b}
	delka_a:=0;i:=0;while a[i]<>0 do i:=i+1; delka_a:=10-i;
	delka_b:=0;i:=0;while b[i]<>0 do i:=i+1; delka_b:=10-i;
	{delsi z cisel} if delka_a<delka_b then begin pom:=a; a:=b; b:=pom; i:=delka_a;delka_a:=delka_b;delka_b:=i; vysl.znamenko:=false end 
	else if delka_a=delka_b then begin 
		vysl.znamenko:=true; i:=0; 
		while (not vysl.znamenko) or (i<10) do
			if a[i]<b[i] then vysl.znamenko:=false else i:=i+1;
	end;
	{doplnime z leva jednou nulou} aa[0]:=0; for i:=1 to 10 do aa[i]:=a[i];
	{kratsi z cisel doplnime z leva tolika nulami, aby byla stejne dlouha}
	bb[0]:=0; for i:=1 to (delka_a-delka_b-1) do bb[i]:=0;
	{postupujeme zprava a ke kazde dvojici vysledku urcime cislici vysledku z prislusneho pole dle stavu}
	{rozdil dvou stejne velkych cisel, vetsi - mensi}
	{na zacatku je stav bez prenosu}stav:=false;
	for i:=10 downto 0 do
		if stav=false then begin
			cc[i]:=rozd_bez[aa[i],bb[i]].c;
			stav:=rozd_bez[aa[i],bb[i]].p;
		end else begin
			cc[i]:=rozd_s[aa[i],bb[i]].c;
			stav:=rozd_s[aa[i],bb[i]].p;
		end;
	vysl.cislo:=cc;
	f_rozdil:=vysl;
end;

begin
	{SCITANI}
	{naplnim pole pro stav bez prenosu}
	for i:=0 to 9 do begin {radek, y}
		for j:=0 to (9-i) do begin{sloupec, x}
			souc_bez[j,i].c:=i+j;
			souc_bez[j,i].p:=false;
		end;
		for j:=(9-i+1) to 9 do begin
			souc_bez[j,i].c:=10-i-j;
			souc_bez[j,i].p:=true;
		end;
	end;
	{naplnim pole pro stav s prenosem}
	for j:=0 to 9 do begin{sloupec,x}
		for i:=0 to (8-j) do begin{radek,y}
			souc_s[j,i].c:=i+j+1;
			souc_s[j,i].p:=false;
		end;
		for i:=(9-j) to 9 do begin
			souc_s[j,i].c:=9-i-j;
			souc_s[j,i].p:=true;
		end;
	end;
	{ODCITANI}
	{naplnim pole pro stav bez prenosu}
	for i:=0 to 9 do begin{radek, mensitel}
		for j:=i to 9 do begin{sloupec, mensenec}
			rozd_bez[j,i].c:=j-i;
			rozd_bez[j,i].p:=false;
		end;
		for j:=1 to (i-1) do begin
			rozd_bez[j,i].c:=i+j;
			rozd_bez[j,i].p:=true;
		end;
	end;
	{naplnim pole pro stav s prenosem}
	rozd_s[0,0].c:=9;rozd_s[0,0].p:=false;
	for j:=1 to 8 do {mensenec}
		for i:=(j+1) to 9 do begin{mensitel}
			rozd_s[j,i].c:=i+1-j;
			rozd_s[j,i].p:=false;
		end;
	for i:=1 to 9 do{mensitel}
		for j:=0 to i do begin{mensenec}
			rozd_s[j,i].c:=j+9-i;
			rozd_s[j,i].p:=true;
		end;
end.
