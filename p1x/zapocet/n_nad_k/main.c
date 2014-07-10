#include<stdio.h>
/**********************************************/
int main(){
	//nacteni vstupu
	int n,k,m;
	int f;

	fprintf(stdout,"Vypocet n nad k modulo m\nZadej N,K,M:");
	fscanf(stdin,"%d%d%d",&n,&k,&m);

	//osetreni vstupu
	//max hodnoty!!
	if((n<0)||(m<0)||(k<0)){
	 fprintf(stderr,"prosim n,k,m nezaporna\n"); return 0;
	}
	if (n<k){
	 fprintf(stdout,"neni definovano\n"); return 0;
	}
	if ((k==0)||(n==k)){
	 fprintf(stdout,"1\n"); return 0;
	}
	if (m==1){
	 fprintf(stdout,"0\n"); return 0;
	}
	if(k>(n-k)) k=n-k;//"n nad k = n nad (n-k)"
	if (k==1){
	 fprintf(stdout,"%d\n",n%m); return 0;
	}
	//vytvorime sito pro max(n,m)
	if(n>m) vytvor_sito(n+1);
	else vytvor_sito(m+1);
	//vyber metody vypoctu
	if(!jePrvocislo(m)){
	 rozlozM(m);
	 if(soucinP(m)==0){
	 	f=crt(n,k,m); //cinske zbytky
	 }else{
		f=n_nad_k(n,k,m);
	 }
	}
	else if (m<n){
		f=lucas(n,k,m);//Lucas
	}
	else{
		f=n_nad_k(n,k,m);
	}

	printf("%d\n",f);
}
