unit spojak;

interface

type
	{ ukazatel na prvek spojoveho seznamu - viz dale }
	PItem = ^TItem;
	
	{ prvek spojoveho seznamu reprezentujiciho mnozinu
		Pozn: seznam je vzdy setriden vzestupne podle hodnot prvku }
	TItem = record
		val: LongInt;	{ hodnota prvku }
		next: PItem;	{ ukazatel na dalsi prvek mnoziny }
	end;


implementation


end.
