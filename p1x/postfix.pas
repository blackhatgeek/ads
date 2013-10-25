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

var	povoleno,cislo:set of char;
	vysl:longint;
	ok2,empty:boolean;
	dalsi:char;

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
	Pokracovat,zapor:boolean;
	i:integer;
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
				'+': H:=H1+H2;
				'-': H:=H1-H2;
				'*': begin
					H:=0;
					if H2>H1 then begin
						H:=H2;
						H2:=H1;
						H1:=H;
						H:=0
					end;{pricitam mensi cislo}
					if H2=0 then H:=0 else if H2=1 then H:=H1 else
					for i:=1 to H1 do H:=H+H2;{nasobeni je scitani}
				end;
				'/': if H2<>0 then begin
					if(((H1<0) and (H2>0)) or ((H2<0) and (H1>0))) then zapor:=true else zapor:=false;
					H:=0;
					while((abs(H1)-abs(H2))>=0) do begin
						H:=H+1;
						H1:=H1-H2;
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

begin
dalsi:='*'; empty:=true;
cislo:=['0','1','2','3','4','5','6','7','8','9'];
povoleno:=cislo+['+','-','*','/'];
vysl:=PostfixVyhodnoceni(ok2);
if ok2 then writeln(vysl);
end.
