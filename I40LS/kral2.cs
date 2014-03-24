using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CestaKralem{
	class Ctecka{
		static bool jeCislice(int znak){
			return ((znak >= '0') && (znak <= '9'));
		}

		static bool jeMinus(int znak){ 
			return (znak=='-');
		}

		public static int PrectiInt()
		{
			int citac = 0; bool zapor = false;
			int znak = Console.Read();
			while (!jeCislice(znak)&&!jeMinus(znak)) znak = Console.Read();
			if (jeMinus(znak)){
				zapor = true;
				znak = Console.Read();
			}
			while (jeCislice(znak)){
				citac = citac * 10 + (znak - '0');
				znak = Console.Read();
			}
			if (zapor) citac = -citac;
			return citac;
		}
	}

	class Kral{
		const short n=8; 
		const int m=4096; 
		const short uninit=-1; 
		const short block=-99; 
		const short exit=-23;

		static int[,] pole=new int[n,n];
		static int [,] zasobnik=new int[m,3];
		static int i,j,zas,startx,starty,cilx,cily,cur_x,cur_y,cur_kr,blocks;

		static void zas_push(int x,int y,int krok){
			zas=zas+1;//zas .. pocet prvku na zasobniku
			if (zas<m) {
				zasobnik[zas,0]=x;
				zasobnik[zas,1]=y;
				zasobnik[zas,2]=krok;
			}
		}

		static void zas_pop(out int x,out int y,out int krok){
			if ((zas>=0)&&(zas<m)){
				x=zasobnik[zas,0];
				y=zasobnik[zas,1];
				krok=zasobnik[zas,2];
				zas=zas-1;
			}else{
				x=-1;y=-1;krok=-1;
			}
		}

		static void dal_krok(int x,int y,int krok){
			if (x>=0) {
				if (x<n) {
					if ((y+1)<n) if (pole[x,y+1]!=block) zas_push(x,y+1,krok);
					if (y>=1) if (pole[x,y-1]!=block) zas_push(x,y-1,krok);
				}
				if (x>=1) {
					if ((y+1)<n) if (pole[x-1,y+1]!=block) zas_push(x-1,y+1,krok);
					if (y>=1) {
						if (pole[x-1,y-1]!=block) zas_push(x-1,y-1,krok);
						if (y<=n) if (pole[x-1,y]!=block) zas_push(x-1,y,krok);
					}
				}
			}
			if ((x+1)<n) {
				if ((y>=0) && (y<n)) if (pole[x+1,y]!=block) zas_push(x+1,y,krok);
				if ((y+1)<n) if (pole[x+1,y+1]!=block) zas_push(x+1,y+1,krok);
				if (y>=1) if (pole[x+1,y-1]!=block) zas_push(x+1,y-1,krok);
			}
		}

		static void Main(){
			zas=-1;
			for (i=0; i<n; i++) for (j=0;j<n;j++) pole[i,j]=uninit;
			blocks=Ctecka.PrectiInt();
			for (i=0;i<blocks;i++){
				cur_x=Ctecka.PrectiInt();
				cur_y=Ctecka.PrectiInt();
				if ((cur_x>=0) && (cur_x<n) && (cur_y>=0) && (cur_y<n)) pole[cur_x,cur_y]=block;
			}
			startx=Ctecka.PrectiInt();
			starty=Ctecka.PrectiInt();
			cilx=Ctecka.PrectiInt();
			cily=Ctecka.PrectiInt();
			startx--;starty--;cilx--;cily--;
			if ((startx>=0)&&(startx<8)&&(starty>=0)&&(starty<8)){
				pole[startx,starty]=0;
				dal_krok(startx,starty,1);
				while (zas>0) {
					zas_pop(out cur_x,out cur_y,out cur_kr);
					if ((cur_x==cilx)&&(cur_y==cily)){
						if ((pole[cur_x,cur_y]==uninit) || (pole[cur_x,cur_y]>cur_kr)) pole[cur_x,cur_y]=cur_kr;
					} else if ((pole[cur_x,cur_y]==uninit) || (pole[cur_x,cur_y]>cur_kr)){
						pole[cur_x,cur_y]=cur_kr;
						dal_krok(cur_x,cur_y,cur_kr+1);
					}
				}
				if (pole[cilx,cily]!=-1) Console.WriteLine(pole[cilx,cily]);
				else Console.WriteLine("-1");
			}
		}
	}
}
