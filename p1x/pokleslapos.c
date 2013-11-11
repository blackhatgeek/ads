/*
Na standardním vstupu je zadáno 
celé císlo K a 
posloupnost nezáporných celých císel 
ukoncená císlem -1. 

Vypište na standardní výstup délku nejdelšího úseku posloupnosti, 
který obsahuje nejvýše K poklesu.

Úsekem se pritom myslí souvislá podposloupnost, 
poklesem dvojice po sobe jdoucích prvku taková, 
že první prvek je ostre vetší než druhý.

Císlo K se pohybuje od 0 do 100 vcetne. 
Prvky posloupnosti jsou menší než 2^31 a je jich nejvýše 2^31-1.

Príklad:
Vstup:
  1
  1 2 3 1 2 3 4 5 6 1 2 3 4 5 -1
Odpovídající výstup:
  11
*/

#include<stdio.h>
#define MaxK  101
int N, k, a, b, i, j, pred, akt;
int klesani[MaxK];
main()
{
a = 1;
b = 1;
i=0; N=0;//pocet zadanych clenu
klesani[0] = 1;
j = 1;
fscanf(stdin, "%d",&k);
fscanf(stdin, "%d",&pred);  //prvni: kdyz je to hned minus 1
       if (pred == -1) {fprintf(stdout, "%d",0); return(0); }
//prvni nebyl -1; 
i++; N++; 
fscanf(stdin, "%d",&akt); //druhy
       if(akt == -1) {fprintf(stdout, "%d",1);return(0);} // jeden prvek - delka 1
//nejvyse k poklesu               
while(akt !=-1)
{ i++; N++; //pocet aktualne prectenych clenu      
if (pred > akt)  //mame klesani
{
  if (j <= k) //ale zatim malo
           klesani[j] = i;
  else //ted uz dost
  {
    if (i-1 - klesani[j % (k+1)] > b - a )
     {
      //zbytek po deleni pouzivam proto, aby pole klesani bylo zatocene do kruhu ???
      a = klesani[j % (k+1)]; //zatim nejdelsi podposloupnost
      b = i - 1;
      } //if    
    klesani[j % (k+1)] = i; //ulozime do fronty
  }//else
j++;
}//if pred>akt
pred = akt;
fscanf(stdin, "%d",&akt); //dalsi
}//while
//jeste zkontrolujeme posledni podposloupnost
if (N - klesani[j % (k+1)] > b-a )
{
   if (j <= k)  a = 1; //vezmeme celou posloupnost}
   else a = klesani[j % (k+1)]; //nebo jen od prvniho klesani z fronty
   b = N;
}
fprintf(stdout, "%d", b-a+1);//delka mezi a,b
//printf("\na = %d, b=%d, i=%d, N=%d",a,b, i, N);
//scanf("%d",&a);
return 0;
}//main
