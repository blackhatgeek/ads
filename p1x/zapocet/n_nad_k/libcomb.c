#include<stdio.h> 

/**********************************************/
/*  GLOBALNI POLE SITO A ROZKLAD */
#define MAXP 100001  //MAXP je nejvetsi prvocislo, pro ktere provadime vypocet
int sito[MAXP],    //pole pro Eratosthenovo sito 
    rozklad[MAXP], //pole pro vytvareni vysledku
    rozkladM[MAXP];//pole pro rozklad M na soucin prvocisel


/******************************/
int n_nad_k(int N, int K,int M)
/*N nad K mod M : "univerzalni", pozor na konstantu pro alokaci pole*/
{   
	int i,j,mocnina;   
	int vysledek; 

	if(N<K) return 0;
	if(M==1) return 0;
	if(N==K) return 1;   

	for (i=2;i<=N;i++){
		rozklad[i]=0; 
	}
	if (K > N-K) K=N-K;
	for (i=2;i<=N;i++) if (sito[i]==0){
		j=i*2;
		while (j<=N){
			sito[j]=i;j=j+i;
		}
	}//if (for if)
  
	//Kombinacni cislo je soucin cisel od N-K+1 do N ...}
	for(i=N-K+1; i<=N; i++) rozklad[i]++;
	//...deleny k! 
	for(i=2; i<=K; i++) rozklad[i]--;
	vysledek=1;  
	for (i=N ; i>= 2; i--){
		if (sito[i]==0) {//Nejvyssi cislo rozkladu je prvocislo, zpracujeme je.
			mocnina =i % M;
			while (rozklad[i]!=0){
				//Rozlozime exponent na soucet mocnin dvojky a ty spocitame prostym mocnenim modulo M.
				if (rozklad[i]%2 == 1) vysledek=(vysledek*mocnina) % M;
				//Zkus vyssi mocninu.
				mocnina=(mocnina*mocnina) % M;
        			rozklad[i]=rozklad[i]/2;
        		}//while rozklad[i]
            
        	}//if sito[i]
		else {
			//Nejvyssi cislo rozkladu je cislo slozene. Vysledek se nemeni, upravuji se mocniny prvocisel v rozkladu
			rozklad[sito[i]]=rozklad[sito[i]]+rozklad[i];
			rozklad[i/sito[i]]=rozklad[i/sito[i]]+rozklad[i];
		}//{else}
	}//{for i}             
	return vysledek;            
} //N nad K mod M

/*********************************/
int invmod(int n,int b)
/* dano: n,b; chceme  inverzni prvek k b v Z_n */
/* Vstup: Prirozena cisla n, b, kde n >= b >0 */
{
//int a1, a2,  b1, b2, delitel, zbytek,p, pa;
int t=0, newt=1, r=n, newr=b,pom;
while (newr!=0){
	int q=r/newr;
	pom=t;
	t=newt;
	newt=pom-q*newt;

	pom=r;
	r=newr;
	newr=pom-q*newr;
}
if (r>1) return -1;
if (t<0) t=t+n;
return t;
}
/**********************************************/
void vytvor_sito (int M)
{/*vytvori Eratosthenovo sito */
	int i,j;
	for(i=0; i<MAXP; i++) sito[i]=0;
	//Eratosthenovo sito, ve kterem pro kazde i je uvedeno nejvetsi prvocislo, ktere je deli
	for(i=2 ;i<=M;i++)
		if (sito[i]==0){
			j=i*2;
		        while (j<=M){
				sito[j]=i;
				j=j+i;
			}       
        	}        
}       
/**********************************************/
void rozlozM(int M)
/*v poli sito jsou prvocisla 
sito[i] je nejvetsi prvocislo, ktere deli i*/
{    
    int i;
        
    for(i=0; i<M; i++)  rozkladM[i]=0; rozkladM[M]=1;
    for(i=M; i>=2; i--)       
    if(sito[i]) //!=0
    {            
         rozkladM[sito[i]]=rozkladM[sito[i]]+rozkladM[i];
         rozkladM[i/sito[i]]=rozkladM[i/sito[i]]+rozkladM[i];
         rozkladM[i]=0;
    }
}    
/**********************************************/
int soucinP(int m){//zda-li je m soucin prvocisel
	int i=0,pok=0;
	while((i<=m)&&(pok==0)){
		if((rozkladM[i]!=0)&&(rozkladM[i]!=1)) pok=1;
		else i++;
	}
	return pok;
}
/**********************************************/
void rozloz(int A, int B)
/*predpoklada se, ze pole sito a rozklad jsou vytvorena
  do "rozkladu" se pridaji +1 a -1
*/
{ 
	int i;
	if (B > A-B) B=A-B; 
	//Kombinacni cislo je soucin cisel od A-B+1 do A ...}
	for(i=A-B+1; i<=A; i++) rozklad[i]++;
	//...deleny B! 
	for(i=2;i<=B; i++) rozklad[i]--;

 }//rozloz

/********************************/
int zpracuj_rozklad(int N,int M)
/* zpracuje vytvoreny rozklad - vygeneruje odpovidajici binomicky koeficient */
/* N: pocet prvku v poli rozklad,M: modulo*/
{
	int i,mocnina;
	long long vysledek;
	vysledek=1;
	for (i=N ; i>= 2; i--){      
		if (sito[i]==0) {
			//Nejvyssí cislo rozkladu je prvocislo, zpracujeme je.
			mocnina =i % M;
			while (rozklad[i]!=0){
				//Rozlozime exponent na soucet mocnin dvojky a ty spocitame prostym mocnenim modulo M.
				if (rozklad[i]%2 == 1) vysledek=(vysledek*mocnina) % M;
				//Zkus vyssi mocninu.
				mocnina=(mocnina*mocnina) % M;
				rozklad[i]=rozklad[i]/2;                  
			}//while rozklad[i]          
		}//if sito[i]
		else {            
			//Nejvyssi cislo rozkladu je cislo slozene. 
			//Vysledek se nemeni, upravuji se mocniny prvocisel v rozkladu
			rozklad[sito[i]]=rozklad[sito[i]]+rozklad[i];
			rozklad[i/sito[i]]=rozklad[i/sito[i]]+rozklad[i];            
		}//{else}
	}//{for i}
	return vysledek;
} //zpracuj_rozklad  



/********************************/
int jePrvocislo(int m){
	if (sito[m]==0) return 1;
	else return 0;
}


/*********************************** */
int lucas (int n, int k, int p)
/* Lucasova veta: n nad k mod prvocislo 
   n=n0+n1*p + ... + nd*p^d
   k=k0+k1*p + ... + kd*p^d,
   0<=ki,ni<=p-1
   pokud existuje dvojice ni, ki: ni<ki => vysledek je nula
   jinak je vysledek roven soucinu binomickych koeficientu ni nad ki mod p
*/   
{  
	if (p<=1) return 0;  
	if (n<k)  return 0;
	if (n==k) return 1;
	if (k==0) return 1;
	if (k==1) return n%p;
	if ((n%p)<(k%p))  return 0;

	int vysl;
	int ni,ki,i;

	//vytvor_sito();
	for(i=0; i<MAXP; i++) { rozklad[i]=0;}
	//Eratosthenovo sito, ve kterem pro kazde i je uvedeno nejvetsi prvocislo, ktere je deli

	/*
	v poli rozklad vytvarime mocniny cisel n0, n1, ... nd a k0,k1,...kd, 0<ki<ni<p-1,
	ve kterych se vyskytuji ve vyslednem binom. koeficientu; 
	*/
	while(n>0){
		ni=n%p; ki=k%p;
		if(ni<ki) return 0;
		if(ni>ki && ki){
			rozloz(ni,ki);  
   		}
           	//kdyz ni==ki, tak je ni nad ki = 1, kdyz ki==0, tak take
		n=n/p; k=k/p;
	}

	vysl=zpracuj_rozklad(p-1,p);
	return vysl;   
}//Lucas
/**********************************************/
int crt(int n,int k,int M)
/* v poli rozkladM je rozklad M na prvocisla*/
{
     int i,j,vysledek=0,x,y,p,a;          
     for(i=2; i<=M; i++)
     if(rozkladM[i]!=0)
     {
      if(rozkladM[i]==1) //prvocislo
      {
        x=lucas(n,k,i); 
	y=M/i;
        p=invmod(i,y); //a>=b>0
      }                                                   
      else               //mocnina prvocisla
      {
	a=i;j=2; 
	while(j<=rozkladM[i]){ a=a*i;j++;}//lze predelat na rychlejsi mocneni 
	x=n_nad_k(n,k,a); 
	y=M/a; 
	p=invmod(a,y); //a>=b>0
      }
      vysledek=(vysledek+(x*p*y)%M)%M;
     }
      
 return vysledek;        
 }
