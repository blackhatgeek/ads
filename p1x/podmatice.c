#include <stdio.h>

#define L 4
#define O 4

#define Mmax 1000
#define Nmax 1000
//M radky y
//N sloupce x
int p[Mmax][Nmax];	/* p[y][x] */
int c[Nmax];	/* Soucty sloupecku */
int ay, by;
int max=-100000, maxax, maxay, maxbx, maxby, maxobsah=0,N,M;

void
na_primce(void)
{
	int ax=0, bx, h=0;
	for (bx=0; bx<N; bx++) {
		int obsah = (bx-ax)*(by-ay);
		h+=c[bx];
		if ((h > max) || ((h == max) && (obsah<maxobsah))) {
			maxax=ax; maxay=ay; maxbx=bx; maxby=by; max=h;
			maxobsah = obsah;
		}
		if (h<=0){
			h=0; ax=bx+1;}
	}
}

int
main(void)
{
	int i,j,sum;
	scanf("%d%d",&N,&M);//nacte rozmer ... !!!nove prohozene m a n
	//nacte matici
	for(i=0;i<N;i++){
		for(j=0;j<M;j++){
			//printf("i:%d\tj:%d\n",i,j);
			fscanf(stdin,"%d",&p[i][j]);
		}
	}
	
	for (ay=0; ay<M; ay++) {//radky
		for (i=0; i<N; i++) c[i] = 0;
		for (by=ay; by<M; by++) {//radky pod
			for (i=0; i<N; i++) c[i] += p[by][i]; //pocitam soucet v sloupcich
			na_primce();
		}
	}

	sum=0;
	for(i=maxax; i<=maxbx; i++){
		for(j=maxay; j<=maxby; j++){
			sum+=p[j][i];	
		}
	}
	fprintf(stdout,"%d\n%d %d\n%d %d\n",sum,maxay+1,maxax+1,maxby+1,maxbx+1);
	return 0;
}

