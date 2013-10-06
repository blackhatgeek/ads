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

{implementuji binarni strom}
type	Uk = ^Uzel;
	Uzel = record
		Hodnota:integer;
		Znak:char;
		L,P:Uk;
	end;

{pruchod stromem s korenem K metodou postorder}
{vypsani aritmetickeho vyrazu v postfixove notaci}
procedure vypis(K:Uk);
begin
	if K^.L = nil then {list}
		write(K^.Hodnota, ' ')
	else begin
		vypis(K^.L);
		vypis(K^.P);
		write(K^.Znak);
	end
end;

{pomocna funkce pro cteni vyrazu ve vstupu po prvcich}
{cely vyraz musi byt na vstupu zapsan na jednom radku}
{kazde cislo musi byt na vstupu nasledovano mezerou}
{funkcni hodnota - zda se jeste precetl dalsi prvek}
{Hodnota, Znak - predani precteneho prvku}
{pokud se cetlo cislo, bude znak '$' jako priznak}
function Prvek(var Hodnota:integer; var Znak:char):boolean;
var	Z:char;
	H:integer;
begin
	repeat read(z) until Z<>' ';
	writeln('-> Z=',Z,',',ord(Z));
	if ord(Z)=10 then Prvek:=false else begin
		writeln('->TRUE');
		Prvek:=true;
		if(Z>='0')and(Z<='9') then begin
			Znak:='$';{na vstupu je cislo}
			H:=0;
			repeat
				h:=H*10+ord(Z)-ord('0');
				read(Z)
			until (Z = ' ') or eof;
			Hodnota:=H
		end else Znak:=Z
	end
end;

{vyhodnoceni aritmet. vyrazu zapsaneho v postfixu}
{vyuziva funkci Prvek pro vstup vyrazu po castech}
function PostfixVyhodnoceni:integer;
const	Max = 100;{max pocet operandu ve vyrazu}
var	Zas: array [1..Max] of integer; {pracovni zasobnik}
	V: 0..Max;{vrchol zasobniku}
	H,H1,H2:integer;{hodnoty operandu}
	Z:char;{znamenko na vstupu}
	Pokracovat:boolean;
begin
	V:=0;
	Pokracovat:=Prvek(H,Z);
	
	writeln('Hodnota: ',H);
	writeln('Znak: ',Z);
	writeln('Pokracovat: ',Pokracovat);

	while Pokracovat do begin
		if Z='$' then begin {na vstupu cislo}
			V:=V+1; Zas[V]:=H; {operand dame do zasobniku}
			writeln('Zas[',V,']=',H);
			Pokracovat:=Prvek(H,Z);
		end
		else if V < 2 then begin
			writeln(CHYBA,': PostfixVyhodnoceni:82');
			Pokracovat:=false;
		end else begin {na vstupu znamenko}
			H2:=Zas[V]; V:=V-1; {pravy operand ze zasobniku}
			H1:=Zas[V]; {levy operand ze zasobniku}
			case Z of
				'+': begin writeln(H1,'+',H2); H:=H1+H2; end;
				'-': begin writeln(H1,'-',H2);H:=H1-H2; end;
				'*': begin writeln(H1,'*',H2);H:=H1*H2; end;
				'/': begin writeln(H1,'/',H2);H:=H1 div H2; end;
			end;
			Zas[V]:=H;{vysledek dame do zasobniku}
			writeln('Zas[',V,']=',H);
			Pokracovat:=Prvek(H,Z);
			writeln('Hodnota: ',H);
			writeln('Znak: ',Z);
			writeln('Pokracovat: ',Pokracovat)
		end;
	end;
	if V>1 then writeln(CHYBA,': PostfixVyhodnoceni:97') else PostfixVyhodnoceni:=Zas[1];
end;

begin
writeln(PostfixVyhodnoceni);
end.
