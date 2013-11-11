{$R+}{$O+}
program kral;
const n=8; m=4096; uninit=-1; block=-99; exit=-23;
var pole:array[1..n,1..n] of integer;
zasobnik: array[1..m,'a'..'c'] of integer;
i,j,zas,startx,starty,cilx,cily,cur_x,cur_y,cur_kr,blocks:integer;

procedure zas_push(x,y,krok:integer);
begin
	zas:=zas+1;{zas .. pocet prvku na zasobniku}
	if zas<=m then begin
		zasobnik[zas,'a']:=x;
		zasobnik[zas,'b']:=y;
		zasobnik[zas,'c']:=krok;
	end;
end;

procedure zas_pop(var x,y,krok:integer);
begin
	if (zas>0) and (zas<=m) then begin
		x:=zasobnik[zas,'a'];
		y:=zasobnik[zas,'b'];
		krok:=zasobnik[zas,'c'];
		zas:=zas-1;
	end
end;

procedure dal_krok(x,y,krok:integer);
begin
	if (x>0) then begin
		if x<=n then begin
			if ((y+1)<n) then if (pole[x,y+1]<>block) then zas_push(x,y+1,krok);
			if (y>1) then if (pole[x,y-1]<>block) then zas_push(x,y-1,krok)
		end;
		if x>1 then begin
			if (y<n) then if (pole[x-1,y+1]<>block) then zas_push(x-1,y+1,krok);
			if (y>1) then begin
				if pole[x-1,y-1]<>block then zas_push(x-1,y-1,krok);
				if (y<=n) then if pole[x-1,y]<>block then zas_push(x-1,y,krok);
			end
		end;
	end;
	if x<n then begin
		if (y>0) and (y<=n) then if pole[x+1,y]<>block then zas_push(x+1,y,krok);
		if (y<n) then if pole[x+1,y+1]<>block then zas_push(x+1,y+1,krok);
		if (y>1) then if pole[x+1,y-1]<>block then zas_push(x+1,y-1,krok);
	end;
	
end;

begin
	zas:=0;
	for i:=1 to n do for j:=1 to n do pole[i,j]:=uninit;
	read(blocks);
	for i:=1 to blocks do begin
		read(cur_x,cur_y);
		if (cur_x>0) and (cur_x<=n) and (cur_y>0) and (cur_y<=n) then pole[cur_x,cur_y]:=block;
	end;
	read(startx,starty,cilx,cily);
	if (startx>0)and(startx<9)and(starty>0)and(starty<9) then begin
		pole[startx,starty]:=0;
		dal_krok(startx,starty,1);
		while zas>0 do begin
			zas_pop(cur_x,cur_y,cur_kr);
			if (cur_x=cilx)and(cur_y=cily) then begin
				if (pole[cur_x,cur_y]=uninit) or (pole[cur_x,cur_y]>cur_kr) then pole[cur_x,cur_y]:=cur_kr;
			end else if (pole[cur_x,cur_y]=uninit) or (pole[cur_x,cur_y]>cur_kr) then begin
				pole[cur_x,cur_y]:=cur_kr;
				dal_krok(cur_x,cur_y,cur_kr+1);
			end;
		
		end;
		if pole[cilx,cily]<>-1 then writeln(pole[cilx,cily])
		else writeln('-1');
	end
end.
