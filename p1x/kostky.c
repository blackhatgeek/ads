#include<stdio.h>
#define maxN 100
/*GLOBALNI*/
int kostky[7][7];                //matice kostek, [i][j] obsahuje pocet 
int cesta[maxN], maxcesta[maxN]; //aktualni cesta a maximalni cesta
int aktualni =-1;                //aktualni pozice kostky na ceste
int delka, maxdelka;             //aktualni a maximalni delka cesty (rady)
int Z; //zacatek;
int N; //pocet kostek
/*nacteni vstupu*/
void nacti()
{
     int i,d,d1,d2; //obsahuje "dvojcisli"
     fscanf(stdin,"%d%d",&N,&Z);//pocet dvojic a zacatek
     for(i=1; i<=N; i++)
       {
              fscanf(stdin,"%d",&d); d1=d%10; d2=d/10;
              kostky[d1][d2]++; //pocet vyskytu
              if (d1 != d2) kostky[d2][d1]++; //symetricky
       }       
     
 return;}
 int hledej(int odkud)
 {
      int moznosti[7];//predpokladam, ze odkud je index radku, ulozim indexy sloupcu      
      int i,j,k,plus,pocet=0; //pocet moznych cest odsud
      //vynulovat lokalni moznosti
      for(k=0; k<7; k++) moznosti[k]=-1;      
      //vyhledat vsechny moznosti od daneho stavu
      for(j=0; j<7; j++)
        if(kostky[odkud][j]>0)
          {moznosti[pocet]=j; pocet++;}
      if (pocet==0) return(0); // => odsud cesta nevede;          
      k=0;
      
      while(k<pocet)
      {
       //zpracovavam moznost k
       //k ceste pridam dalsi kostku
       aktualni ++;
       cesta[aktualni]=moznosti[k];      
       //odeberu tuto kostku
       kostky[odkud][moznosti[k]]--; 
       if(moznosti[k]!=odkud) kostky[moznosti[k]][odkud]--;
       
       //zavolam se rekurzivne...          
       plus=hledej(moznosti[k]);
       //vratili jsme se z rekurze:
       delka=delka+plus+1;
       //if (delka>maxdelka)
       if(aktualni > maxdelka)
       {
         maxdelka=aktualni;                
         //skopirovat cestu
         for(i=0; i<=aktualni; i++) maxcesta[i]=cesta[i];       
       }
       //vratit pouzite kostky nazpatek
       kostky[odkud][moznosti[k]]++; 
       if(moznosti[k]!=odkud) kostky[moznosti[k]][odkud]++;
       //vymazat z cesty
       cesta[aktualni]=-1;
       aktualni --;
       delka = delka-plus-1;
       //dalsi iterace cyklu: hledam nove doplneni cesty  
         k++;             
      }//while              
        return delka;
           
  }//hledej
  main()
  {
        int i;
        for (i=0; i<maxN; i++) {cesta[i]=-1; maxcesta[i]=-1;}
        nacti();       
        cesta[0]=Z;
        delka=0;
        aktualni=0;
        maxdelka=0;
        delka=hledej(Z);
        
        printf("%d\n",maxdelka);
        for(i=0; i<maxdelka; i++)                                
                 printf("%1d%1d ",maxcesta[i],maxcesta[i+1]);
        }
