program longint;

type 
cislice=0..9;
longint_32=array[1..10] of cislice;
longint_32a=array[0..10] of cislice;{kontrola preteceni}
zaznam=record c:cislice; p:boolean end;

var 
bez:array[cislice,cislice] of zaznam; 
s:array[cislice,cislice] of zaznam;

function secti(longint_32 a, longint_32 b):longint_32a;
var soucet:longint_32a;
var i:integer;
begin
	soucet[10]:=a[10]+b[10];
	for i:=9 downto 1 do 
		if soucet[i+1]>9 then begin
			soucet[i+1]:=soucet[i+1]-10;
			soucet[i]:=1+a[i]+b[i]
		end else soucet[i]:=a[i]+b[i];
	if soucet[1]>9 then soucet[0]:=1 else soucet[0]:=0;
	secti:=soucet;
end;

function f_soucet(longint_32 a, longint_32 b):longint_32a;
var aa,bb,cc:longint_32a; i,j,delka_a,delka_b:integer;pom:longint_32; stav:boolean;
begin
	{ktere z cisel je delsi - najdu prvni nenulovou cislici a a prvni nenulovou cislici b}
	delka_a:=0;i:=0;while a[i]<>0 do i:=i+1; delka_a:=10-i;
	delka_b:=0;i:=0;while b[i]<>0 do i:=i+1; delka_b:=10-i;
	{delsi z cisel} if delka_a<delka_b then begin pom:=a; a:=b; b:=a; i:=delka_a;delka_a:=delka_b;delka_b:=i end;
	{doplnime z leva jednou nulou} aa[0]:=0; for i:=1 to 10 do aa[i]:=a[i];
	{kratsi z cisel doplnime z leva tolika nulami, aby byla stejne dlouha}
	bb[0]:=0; for i:=1 to (delka_a-delka_b-1) do bb[i]:=0;
	{postupujeme zprava a ke kazde dvojici vysledku urcime cislici vysledku z prislusneho pole dle stavu}
	{na zacatku je stav bez prenosu}stav:=false;
	for i:=10 downto 0 do
		if stav=false then begin
			cc[i]:=bez[aa[i],bb[i]].c;
			stav:=bez[aa[i],bb[i]].p;	
		end else begin
			cc[i]:=s[aa[i],bb[i]].c;
			stav:=s[aa[i],bb[i]].p;
		end;
end;

function vetsi(longint_32 a,longint_32 b,var stejne:boolean):boolean;
var je:boolean;
begin
	stejne:=false;
	if a[10]=b[10] then 
		if a[9]=b[9] then
			if a[8]=b[8] then
				if a[7]=b[7] then
					if a[6]=b[6] then
						if a[5]=b[5] then
							if a[4]=b[4] then
								if a[3]=b[3] then
									if a[2]=b[2] then
										if a[1]=b[1] then stejne:=true else je:=(a[1]>b[1])
									else je:=(a[2]>b[2])
								else je:=(a[3]>b[3])
							else je:=(a[4]>b[4])
						else je:=(a[5]>b[5])
					else je:=(a[6]>b[6])
				else je:=(a[7]>b[7])
			else je:=(a[8]>b[8])
		else je:=(a[9]>b[9])
	else je:=(a[10]>b[10]);
end;

function odecti(longint_32 a, longint_32 b):longint_32;
var rozdil:longint_32;
var i:integer;
var flag:boolean;
begin
	flag:=false;
	for i:=10 downto 2 do begin{do dvojky ... pri prenosu jednicky je vzdy misto na pozici o 1 vlevo}
		if flag then begin{v minulem kroku jsem chtel zvysit tuto pozici o 1, ale zde byla 9 - byla nastavena nula a nyni se pokusim zvysit dalsi pozici o 1}
			if b[i-1]<>9 then begin 
				b[i-1]:=b[i-1]+1;
				flag:=false;
			end else b[i-1]:=0; {musim zvysit dalsi i pozici o 1}
			{OTESTOVAT, ZE POKUD SE I V TOMTO KROKU NIZE BUDE UPLATNOVAT PRENOS JEDNICKY, ZE BUDE FUNGOVAT KOREKTNE}
		end
		if(a[i]-b[i])<0 then begin{odecitam mensi od vetsiho - vysledek je zaporny}
			rozdil[i]:=10-b[i]+a[i];{odectu}
			{prevod jednicky: na pozici vlevo neni 9 -> zvetsim o jedna; jinak nastavim 0 a oznacim, ze se ma zvysit dalsi pozice}
			if b[i-1]<>9 then b[i-1]:=b[i-1]+1 
			else begin
				flag:=true;
				b[i-1]:=0;
			end
		end else rozdil[i]:=a[i]-b[i];
	end;
	{rozdil posledni pozice - pokud by se mela "prenaset jednicka" tak se rozdilu nastavi znamenko -}
	if flag then {v minulem kroku jsem chtel zvysit tuto pozici o 1, ale zde byla 9 - byla nastavena nula a nyni nastavim na 10}
	b[1]:=10;
	rozdil[1]:=a[1]-b[1];{nastavi se minus a spravny rozdil}
	odecti:=rozdil;
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
