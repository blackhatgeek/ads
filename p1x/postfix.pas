{$R+}
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
s_longint_32=record znamenko:boolean; cislo:longint_32; end;

zaznam=record c:cislice; p:boolean end;

var	povoleno,cislo:set of char;
	vysl:longint;
	ok2,empty:boolean;
	dalsi:char;
	souc_bez,souc_s,rozd_bez,rozd_s:array[cislice,cislice] of zaznam;
	l,j,k:integer;
	nula,jedna:s_longint_32;

function convert0(a:longint):s_longint_32;
var res:s_longint_32; i:integer;
begin
	for i:=n downto 1 do begin
		res.cislo[i]:=a mod 10;
		a:=a div 10;
	end;
	if a>=0 then res.znamenko:=true else res.znamenko:=false;
	convert0:=res;
end;

function convert1(a:s_longint_32):longint;
var res,faktor:longint;i:integer;
begin
	faktor:=1;
	res:=0;
	if a.cislo[n]<>0 then writeln(CHYBA) else
	for i:=(n-1) downto 1 do begin
		res:=res+faktor*a.cislo[i];
		faktor:=faktor*10;
	end;
	if not a.znamenko then res:=-res;
	convert1:=res;
end;

function vetsi(a,b:s_longint_32;var eq:boolean):boolean;
var i:integer; res:boolean;
begin
	i:=1; res:=true; eq:=true;
	if (a.znamenko=false) and (b.znamenko=true) then res:=false
	else if (a.znamenko=true) and (b.znamenko=false) then res:=true
	else begin
		while (i<=n) and (res) do begin
			if a.cislo[i]<b.cislo[i] then res:=false;
			if a.cislo[i]<>b.cislo[i] then eq:=false;
			i:=i+1;
		end;
		if not a.znamenko then if res then res:=false else res:=true
	end;
	vetsi:=res;
end;

procedure print0(a:s_longint_32);
var i:integer;
begin
	if a.znamenko=false then write('-');
	for i:=1 to n do write(a.cislo[i]);
	writeln('');
end;

function f_rozdil(a,b:s_longint_32):s_longint_32; forward;

function f_soucet(a,b:s_longint_32):s_longint_32;
var stav:boolean; c:s_longint_32; i:integer;
begin
	c.znamenko:=true;
	if (a.znamenko=false) and (b.znamenko=true) then c:=f_rozdil(b,a)
	else if (b.znamenko=false) and (a.znamenko=true) then c:=f_rozdil(a,b)
	else  begin
		{a,b stejne} if a.znamenko=false then c.znamenko:=false;
		{postupujeme zprava a ke kazde dvojici vysledku urcime cislici vysledku z prislusneho pole dle stavu}
		{na zacatku je stav bez prenosu}stav:=false;
		for i:=n downto 0 do begin
			if stav=false then begin
				c.cislo[i]:=souc_bez[a.cislo[i],b.cislo[i]].c;
				stav:=souc_bez[a.cislo[i],b.cislo[i]].p;	
			end else begin
				c.cislo[i]:=souc_s[a.cislo[i],b.cislo[i]].c;
				stav:=souc_s[a.cislo[i],b.cislo[i]].p;
			end;
		end;
	end;
	f_soucet:=c;
end;

function f_rozdil(a,b:s_longint_32):s_longint_32;
var stav:boolean; c:s_longint_32; delka_a, delka_b,i:integer;pom:s_longint_32;
begin
	if (a.znamenko=false)and (b.znamenko=false) then c:=f_soucet(a,b)
	else if (a.znamenko=false) and (b.znamenko=true) {(-1) - (+1)} then begin
		b.znamenko:=false; {(-1) + (-1)}
		c:=f_soucet(a,b);
	end else if (a.znamenko=true) and (b.znamenko=false) then begin {(+1) - (-1)}
		b.znamenko:=true;
		c:=f_soucet(a,b);{1+1}
	end else begin{(+1) - (+1)) nebo (-1) - (-1)}
		if (a.znamenko=false) then begin
			c:=b;
			b:=a;
			a:=c;
			a.znamenko:=true;{(+1) - (+1), prohozeny mensenec a mensitel}
		end;
		{ktere z cisel je delsi - najdu prvni nenulovou cislici a a prvni nenulovou cislici b}
		delka_a:=0;i:=1;while a.cislo[i]=0 do i:=i+1; delka_a:=n+1-i;
		delka_b:=0;i:=1;while b.cislo[i]=0 do i:=i+1; delka_b:=n+1-i;
		c:=nula;
		{delsi z cisel} if delka_a<delka_b then begin pom:=a; a:=b; b:=pom; i:=delka_a;delka_a:=delka_b;delka_b:=i; c.znamenko:=false end 
		else if delka_a=delka_b then begin 
			c.znamenko:=true; i:=1; 
			while (c.znamenko) and (i<=n) do
				if a.cislo[i]<b.cislo[i] then begin
					c:=b;
					b:=a;
					a:=c;
					c:=nula;
					c.znamenko:=false 
				end else i:=i+1
		end;
		{postupujeme zprava a ke kazde dvojici vysledku urcime cislici vysledku z prislusneho pole dle stavu}
		{rozdil dvou stejne velkych cisel, vetsi - mensi}
		{na zacatku je stav bez prenosu}stav:=false;
		for i:=n downto 1 do begin
			if stav=false then begin
				c.cislo[i]:=rozd_bez[a.cislo[i],b.cislo[i]].c;
				stav:=rozd_bez[a.cislo[i],b.cislo[i]].p;
			end else begin
				c.cislo[i]:=rozd_s[a.cislo[i],b.cislo[i]].c;
				stav:=rozd_s[a.cislo[i],b.cislo[i]].p;
			end;
		end;
		f_rozdil:=c;
	end
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
var	Zas: array [1..Max] of s_longint_32; {pracovni zasobnik}
	V: 0..Max;{vrchol zasobniku}
	H:longint;{hodnoty operandu}
	Z:char;{znamenko na vstupu}
	Pokracovat,p,q:boolean;
	soucet,O,O2,O1:s_longint_32;
	pom,i:integer;
begin
	ok:=true;
	V:=0;
	Pokracovat:=Prvek(H,Z);
	O:=convert0(H);
	while Pokracovat do begin
		if Z='$' then begin {na vstupu cislo}
			V:=V+1; if V<=100 then Zas[V]:=O else writeln(CHYBA);{operand dame do zasobniku}
			Pokracovat:=Prvek(H,Z);
			O:=convert0(H);{nastane?}
		end
		else if V < 2 then begin{chybny vyraz}
			ok:=false;
			writeln(CHYBA);
			Pokracovat:=false;
		end else begin {na vstupu znamenko}
			O2:=Zas[V]; V:=V-1; {pravy operand ze zasobniku}
			O1:=Zas[V]; {levy operand ze zasobniku}
			case Z of
				'+': begin
					writeln('Scitam:');
					print0(O1);
					print0(O2);
					O:=f_soucet(O1,O2);
				end;
				'-': begin
					writeln('Odcitam:');
					print0(O1);
					print0(O2);
					O:=f_rozdil(O1,O2);
				end;
				'*': begin{zde q je pomocna promenna, kterou pouzivame pri porovnani na rovnost}
					O:=nula;
					if vetsi(O2,O1,q) then begin
						writeln('Prohazuji O2 a O1');
						O:=O2;
						O2:=O1;
						O1:=O;
						O:=nula;
					end;{pricitam mensi cislo}
					vetsi(O2,nula,q);
					if q{O2='nula'} then begin O:=nula; writeln('O2 = 0') end else begin
						vetsi(O2,jedna,q);
						if q{O2=1} then begin O:=O1; writeln('O2 = 1') end
						else begin
							soucet:=nula;
							print0(soucet);
							pom:=convert1(O1);
							writeln(pom);
							for i:=1 to pom do begin
								writeln('Scitam:');
								print0(soucet);
								print0(O2);
								soucet:=f_soucet(soucet,O2);
							end;
							O:=soucet;
						end
					end
				end;
				'/': begin
					vetsi(O2,nula,q);
					if not q {O2<>nula} then begin
						{vetsi(O1,nula,q);
						vetsi(O2,nula,p);
						if(((not q) and (p)) or ((not p) and (q))) then zapor:=true else zapor:=false;}
						H:=0;
						{O2:=convert0(H2);}
						{soucet:=convert0(H1);}soucet:=O1;
						vetsi(f_rozdil(O1,O2),nula,p);{p:=(O1-O2)>"nula"}
						while(p) do begin
							H:=H+1;
							{H1:=H1-H2;}
							O1:=f_rozdil(O1,O2);
							soucet:=f_rozdil(soucet,O2);
							vetsi(f_rozdil(O1,O2),nula,p);
						end;{deleni je odcitani}
					end
				end else begin
					ok:=false;
					writeln(CHYBA);
				end;
			end;
			Zas[V]:=O;{vysledek dame do zasobniku a ztratime znamenko}
			Pokracovat:=Prvek(H,Z);
			O:=convert0(H);
		end;
	end;
	if V>1 then begin
		ok:=false;
		writeln(CHYBA);
	end else begin PostfixVyhodnoceni:=convert1(Zas[1]); end;
end;

begin
	{SCITANI}
	{naplnim pole pro stav bez prenosu}
	for l:=0 to 9 do begin {radek, y}
		for j:=0 to (9-l) do begin{sloupec, x}
			souc_bez[j,l].c:=abs(l+j);
			souc_bez[j,l].p:=false;
		end;
		for j:=(9-l+1) to 9 do begin
			souc_bez[j,l].c:=abs(10-l-j);
			souc_bez[j,l].p:=true;
		end;
	end;
	{naplnim pole pro stav s prenosem}
	for j:=0 to 9 do begin{sloupec,x}
		for l:=0 to (8-j) do begin{radek,y}
			souc_s[j,l].c:=abs(l+j+1);
			souc_s[j,l].p:=false;
		end;
		for l:=(9-j) to 9 do begin
			souc_s[j,l].c:=abs(9-l-j);
			souc_s[j,l].p:=true;
		end;
	end;
	souc_s[9,9].c:=0;
	
	{ODCITANI}
	{naplnim pole pro stav bez prenosu}
	for l:=0 to 9 do begin{radek, mensitel}
		k:=0;
		for j:=l to 9 do begin{sloupec, mensenec}
			rozd_bez[j,l].c:=k;
			rozd_bez[j,l].p:=false;
			k:=k+1;
		end;
		for j:=0 to (l-1) do begin
			rozd_bez[j,l].c:=k;
			rozd_bez[j,l].p:=true;
			k:=k+1;
		end;
	end;
	{naplnim pole pro stav s prenosem}
	rozd_s[0,0].c:=9;rozd_s[0,0].p:=false;
	k:=0;
	for l:=1 to 9 do begin
		rozd_s[l,0].c:=k;
		rozd_s[l,0].p:=false;
		k:=k+1;
	end;
	for l:=1 to 9 do{mensitel}
		for j:=0 to l do begin{mensenec}
			rozd_s[j,l].c:=j+9-l;
			rozd_s[j,l].p:=true;
		end;
	for l:=1 to 9 do begin{mensenec}
		k:=0;
		for j:=(l+1) to 9 do begin{mensitel}
			rozd_s[j,l].c:=k;
			rozd_s[j,l].p:=false;
			k:=k+1;
		end;
	end;
	{NULA}
	for l:=1 to n do nula.cislo[l]:=0;
	{JEDNA}
	jedna:=nula;
	jedna.cislo[n]:=1;
	

dalsi:='*'; empty:=true;
cislo:=['0','1','2','3','4','5','6','7','8','9'];
povoleno:=cislo+['+','-','*','/'];
vysl:=PostfixVyhodnoceni(ok2);
if ok2 then writeln(vysl);
end.
