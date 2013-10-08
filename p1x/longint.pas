program longint;

type cislo=0..9;
type longint_32=array[1..10] of cislo;
type longint_32a=array[0..10] of cislo;{kontrola preteceni}

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
