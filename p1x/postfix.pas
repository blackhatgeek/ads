program postfix;
{Evaluace postfixni notace}

{Postfixní notace je jistým opakem prefixní notace. Výraz v ní zapisujeme tak, že napřed napíšeme argumenty a
 pak řekneme, co s nimi chceme provádět. Výhodou je, že nepotřebujeme priority operátorů a ani závorky.
 Napište program, který vyhodnocuje výraz zadaný v této notaci. Na vstupu dostáváte pouze celá čísla,
 aritmetiku implementujte též celočíselnou (tedy 5 2 / vyjde 2). Výrazně doporučuji použít spojových seznamů a
 nechytračit! Pokud je výraz špatně zadaný (tedy operátory odkazují k nezadaným argumentům), napište "Chyba!"
 Tedy například na vstup "5 3 1 + 4 * +" je správnou odpovědí "21". Vstup čtěte až do konce vstupu, čísla jsou
 oddělena aspoň jedním dalším znakem, ve vstupu se může vyskytovat nepořádek, pokud se vyskytne cokoliv
 různého od operátorů a čísel, považujte to za mezeru. Tedy například "4A4+" vyhodnoťte jako dvě čísla "4",
 která máte sečíst (nikoliv jako číslo 44). Čísla mohou být též víceciferná (ale vždy budou celá a nezáporná).
 Pozor, délka vstupu (a ani jednotlivých jeho řádků) není omezena! Čísla se vejdou do 32bitového integeru.
 Tečka a ani čárka (kterou by bylo možno považovat za desetinnou) se v testech nevyskytuje.}

const CHYBA='Chyba!';
const n=10;

type 
cislice=0..9;
longint_32=array[1..n] of cislice;
longint_32a=array[0..n] of cislice;{kontrola preteceni}
longint_32b=record cislo:longint_32a; znamenko:boolean end;{rozdil}
zaznam=record c:cislice; p:boolean end;

var	povoleno,cislo:set of char;
	vysl:longint;
	ok2,empty:boolean;
	dalsi:char;
	souc_bez,souc_s,rozd_bez,rozd_s:array[cislice,cislice] of zaznam;
	i,j,k:integer;

function convert0(a:longint):longint_32;
var res:longint_32;
begin
	for i:=n downto 1 do begin
		res[i]:=a mod 10;
		a:=a div 10;
	end;
	convert0:=res;
end;

function convert1(a:longint_32):longint;
var res:longint;faktor:integer;
begin
	faktor:=1;
	res:=0;
	for i:=n downto 1 do begin
		res:=res+faktor*a[i];
		faktor:=faktor*10;
	end;
	convert1:=res;
end;

function convert3(a:longint_32a):longint_32;
var res:longint_32;
begin
	for i:=1 to n do res[i]:=a[i];
	convert3:=res;
end;

function f_soucet(a,b:longint_32):longint_32;
var stav:boolean; c:longint_32;
begin
	{postupujeme zprava a ke kazde dvojici vysledku urcime cislici vysledku z prislusneho pole dle stavu}
	{na zacatku je stav bez prenosu}stav:=false;
	for i:=n downto 0 do begin
		{if stav then writeln('s prenosem') else writeln('bez prenosu');}
		if stav=false then begin
			c[i]:=souc_bez[a[i],b[i]].c;
			stav:=souc_bez[a[i],b[i]].p;	
		end else begin
			c[i]:=souc_s[a[i],b[i]].c;
			stav:=souc_s[a[i],b[i]].p;
		end;
	end;
	f_soucet:=c;
end;

function f_rozdil(a,b:longint_32;var znamenko:boolean):longint_32;
var stav:boolean; c:longint_32; delka_a, delka_b:integer;pom:longint_32;
begin
	{ktere z cisel je delsi - najdu prvni nenulovou cislici a a prvni nenulovou cislici b}
	delka_a:=0;i:=0;while a[i]<>0 do i:=i+1; delka_a:=n-i;
	delka_b:=0;i:=0;while b[i]<>0 do i:=i+1; delka_b:=n-i;
	{delsi z cisel} if delka_a<delka_b then begin pom:=a; a:=b; b:=pom; i:=delka_a;delka_a:=delka_b;delka_b:=i; znamenko:=false end 
	else if delka_a=delka_b then begin 
		znamenko:=true; i:=0; 
		while (not znamenko) or (i<n) do
			if a[i]<b[i] then znamenko:=false else i:=i+1;
	end;
	{postupujeme zprava a ke kazde dvojici vysledku urcime cislici vysledku z prislusneho pole dle stavu}
	{rozdil dvou stejne velkych cisel, vetsi - mensi}
	{na zacatku je stav bez prenosu}stav:=false;
	for i:=n downto 0 do
		if stav=false then begin
			c[i]:=rozd_bez[a[i],b[i]].c;
			stav:=rozd_bez[a[i],b[i]].p;
		end else begin
			c[i]:=rozd_s[a[i],b[i]].c;
			stav:=rozd_s[a[i],b[i]].p;
		end;
	f_rozdil:=c;
end;

{pomocna funkce pro cteni vyrazu ve vstupu po prvcich}
{cely vyraz musi byt na vstupu zapsan na jednom radku}
{kazde cislo musi byt na vstupu nasledovano mezerou}
{funkcni hodnota - zda se jeste precetl dalsi prvek}
{Hodnota, Znak - predani precteneho prvku}
{pokud se cetlo cislo, bude znak '$' jako priznak}
function Prvek(var Hodnota:longint; var Znak:char):boolean;
var	Z:char;
	H:longint;
begin
	if empty then repeat read(z) until ((Z in povoleno) or eof(input))
	else begin
		z:=dalsi;
		empty:=true;
	end;
	if eof(input) then Prvek:=false else begin
		Prvek:=true;
		if(Z>='0')and(Z<='9') then begin
			Znak:='$';{na vstupu je cislo}
			H:=0;
			repeat
				if(Z>='0')and(Z<='9') then begin
					h:=H*10+ord(Z)-ord('0');
					read(Z);
				end
			until (not (Z in cislo) or eof);
			if(z in povoleno) then begin
				dalsi:=z;
				empty:=false
			end;
			Hodnota:=H
		end else Znak:=Z
	end
end;

{vyhodnoceni aritmet. vyrazu zapsaneho v postfixu}
{vyuziva funkci Prvek pro vstup vyrazu po castech}
function PostfixVyhodnoceni(var ok:boolean):longint;
const	Max = 100;{max pocet operandu ve vyrazu}
var	Zas: array [1..Max] of longint; {pracovni zasobnik}
	V: 0..Max;{vrchol zasobniku}
	H,H1,H2:longint;{hodnoty operandu}
	Z:char;{znamenko na vstupu}
	Pokracovat,zapor,q:boolean;
	soucet,O2:longint_32;
begin
	ok:=true;
	V:=0;
	Pokracovat:=Prvek(H,Z);
	while Pokracovat do begin
		if Z='$' then begin {na vstupu cislo}
			V:=V+1; Zas[V]:=H; {operand dame do zasobniku}
			Pokracovat:=Prvek(H,Z);
		end
		else if V < 2 then begin{chybny vyraz}
			ok:=false;
			writeln(CHYBA);
			Pokracovat:=false;
		end else begin {na vstupu znamenko}
			H2:=Zas[V]; V:=V-1; {pravy operand ze zasobniku}
			H1:=Zas[V]; {levy operand ze zasobniku}
			case Z of
				'+': begin
					H:=H1+H2;
					soucet:=f_soucet(convert0(h1),convert0(h2));
				end;
				'-': begin
					H:=H1-H2;
					soucet:=f_rozdil(convert0(H1),convert0(H2),zapor);
					zapor:=not zapor;
				end;
				'*': begin
					H:=0;
					if H2>H1 then begin
						H:=H2;
						H2:=H1;
						H1:=H;
						H:=0
					end;{pricitam mensi cislo}
					if H2=0 then H:=0 else if H2=1 then H:=H1 else begin
						soucet:=convert0(H1);
						O2:=convert0(H2);
						for i:=1 to H1 do begin
							H:=H+H2;{nasobeni je scitani}
							soucet:=f_soucet(soucet,O2);
						end
					end
				end;
				'/': if H2<>0 then begin
					if(((H1<0) and (H2>0)) or ((H2<0) and (H1>0))) then zapor:=true else zapor:=false;
					H:=0;
					O2:=convert0(H2);
					soucet:=convert0(H1);
					while((abs(H1)-abs(H2))>=0) do begin
						H:=H+1;
						H1:=H1-H2;
						soucet:=f_rozdil(soucet,O2,q);
					end;{deleni je odcitani}
					if zapor then H:=-H
				end else begin
						ok:=false;
						writeln(CHYBA);
					end;
			end;
			Zas[V]:=H;{vysledek dame do zasobniku}
			Pokracovat:=Prvek(H,Z);
		end;
	end;
	if V>1 then begin
		ok:=false;
		writeln(CHYBA);
	end else begin PostfixVyhodnoceni:=Zas[1]; end;
end;

procedure print0(a:longint_32);
begin
	for i:=1 to 10 do write(a[i],' ');
	writeln('');
end;

procedure print1(a:longint_32a);
begin
	for i:=0 to 10 do write(a[i],' ');
	writeln('');
end;

begin
	{SCITANI}
	{naplnim pole pro stav bez prenosu}
	for i:=0 to 9 do begin {radek, y}
		for j:=0 to (9-i) do begin{sloupec, x}
			souc_bez[j,i].c:=abs(i+j);
			souc_bez[j,i].p:=false;
		end;
		for j:=(9-i+1) to 9 do begin
			souc_bez[j,i].c:=abs(10-i-j);
			souc_bez[j,i].p:=true;
		end;
	end;
	{naplnim pole pro stav s prenosem}
	for j:=0 to 9 do begin{sloupec,x}
		for i:=0 to (8-j) do begin{radek,y}
			souc_s[j,i].c:=abs(i+j+1);
			souc_s[j,i].p:=false;
		end;
		for i:=(9-j) to 9 do begin
			souc_s[j,i].c:=abs(9-i-j);
			souc_s[j,i].p:=true;
		end;
	end;
	souc_s[9,9].c:=0;
	
	{ODCITANI}
	{naplnim pole pro stav bez prenosu}
	for i:=0 to 9 do begin{radek, mensitel}
		k:=0;
		for j:=i to 9 do begin{sloupec, mensenec}
			rozd_bez[j,i].c:=k;
			rozd_bez[j,i].p:=false;
			k:=k+1;
		end;
		for j:=0 to (i-1) do begin
			rozd_bez[j,i].c:=k;
			rozd_bez[j,i].p:=true;
			k:=k+1;
		end;
	end;
	{naplnim pole pro stav s prenosem}
	rozd_s[0,0].c:=9;rozd_s[0,0].p:=false;
	k:=0;
	for i:=1 to 9 do begin
		rozd_s[i,0].c:=k;
		rozd_s[i,0].p:=false;
		k:=k+1;
	end;
	for i:=1 to 9 do{mensitel}
		for j:=0 to i do begin{mensenec}
			rozd_s[j,i].c:=j+9-i;
			rozd_s[j,i].p:=true;
		end;
	for i:=1 to 9 do begin{mensenec}
		k:=0;
		for j:=(i+1) to 9 do begin{mensitel}
			rozd_s[j,i].c:=k;
			rozd_s[j,i].p:=false;
			k:=k+1;
		end;
	end;

dalsi:='*'; empty:=true;
cislo:=['0','1','2','3','4','5','6','7','8','9'];
povoleno:=cislo+['+','-','*','/'];
vysl:=PostfixVyhodnoceni(ok2);
if ok2 then writeln(vysl);
end.
