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

function odecti(longint_32 a, longint_32 b):longint_32a;
var rozdil:longint_32a;
var i:integer;
var neg:boolean;
begin
	if vetsi(b,a) then begin{mensitel vetsi nez mensenec - oznacim cislo za zaporne a prohodim mensenec a mensitel uzitim promenne rozdil jako pomocne promenne}
		neg:=true;
		rozdil:=a;
		a:=b;
		b:=a;
	end else neg:=false;	
	rozdil[10]:=a[10]-b[10];
	for i:=9 downto 1 do 
		if rozdil[i+1]<0 then begin
			rozdil[i+1]:=soucet[i+1]-10;
			soucet[i]:=1+a[i]+b[i]
		end else soucet[i]:=a[i]+b[i];
	if soucet[1]>9 then soucet[0]:=1 else soucet[0]:=0;
	secti:=soucet;

		 35
		-26
		
end;
