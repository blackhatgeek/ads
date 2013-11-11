/*
Standardn� vstup obsahuje posloupnost znaku (bez oddelen� mezerami nebo konci r�dku). 
Pocet v�ech znaku nen� vy��� ne� 100, znaky se mohou na vstupu libovolne opakovat. 
Urcete v zadan� posloupnosti znaku d�lku co nejdel�� vybran� podposloupnosti, kter� je symetrick�, 
a vypi�te ji na standardn� v�stup.

Pozn�mka 1: Symetrickou posloupnost znaku 
            (tedy takovou, kter� se cte stejne od zac�tku jako od konce) 
            naz�v�me palindrom.

Pozn�mka 2: 
         Vybran� podposloupnost vznikne z puvodn� posloupnosti 
         vynech�n�m ��dn�ho, jednoho nebo nekolika znaku, 
         pricem� vz�jemn� porad� v�ech zb�vaj�c�ch znaku zustane zachov�no.

Pr�klad: 
Pro vstup ve tvaru 
ABECEDA 
bude v�sledkem c�slo 
5 
Nejdel�� dosa�iteln� palindrom AECEA je d�lky 5 a z�sk�me ho vynech�n�m znaku B a D.
*/

#include <stdio.h>
#include <stdlib.h>
#include<strings.h>

#define MAX 103

int N;
int ch = 0;
char znak[MAX];
char nova_posl[MAX];
struct podposloupnost {
    int prvni, posledni;
    int delka;
} **podposl;

int main()
{
    int i;
    // p�e�teme vstup
    gets(znak);
    N=strlen(znak);

    // trivi�ln�  d�lky 1
    if (N == 1) { printf("0\n"); return 0; }

    // inicializace -- podposl d�lky 1
    podposl = calloc(N, sizeof(struct podposloupnost *));
    podposl[0] = calloc(N, sizeof(struct podposloupnost));
    for ( i=0;i<N;i++) {
        podposl[0][i].prvni = i;
        podposl[0][i].posledni = i;
        podposl[0][i].delka = 1;
    }

    // samotn� dynamika
    int d;
    for ( d=1;d<N;d++) {
        podposl[d] = calloc(N-d, sizeof(struct podposloupnost));
        int j;
        for (j=0;j<N-d;j++) {
            // vyber lepsi z predchozich podposloupnosti
            int ktery;
            if (podposl[d-1][j].delka > podposl[d-1][j+1].delka)
                ktery = j;
            else
                ktery = j+1;

            // na okrajich je stejny znak
            if ((znak[j] == znak[j+d]) && 
                // zkus�me pouz�t posloupnost, ktera obsahuje oba znaky z okraje
                ((d == 1 ? 0 : podposl[d-2][j+1].delka) + 2 >
		 podposl[d-1][ktery].delka)){
                    podposl[d][j].delka = (d == 1 ? 0 :
		                            podposl[d-2][j+1].delka) + 2;
                    podposl[d][j].prvni = j;
                    podposl[d][j].posledni = j+d;
            }
            else {
                podposl[d][j].delka = podposl[d-1][ktery].delka;
                podposl[d][j].prvni = podposl[d-1][ktery].prvni;
                podposl[d][j].posledni = podposl[d-1][ktery].posledni;
            }
        }
    }
        
    int delka = 0;
    int levy = podposl[N-1][0].prvni;
    int pravy = podposl[N-1][0].posledni;

    // Do nove posloupnosti znaku nakop�rujeme jen ty znaky, ktere tvori palindrom
    while (1) {
        nova_posl[podposl[pravy-levy][levy].prvni] =
	    znak[podposl[pravy-levy][levy].prvni];
        nova_posl[podposl[pravy-levy][levy].posledni] =
	    znak[podposl[pravy-levy][levy].posledni];
        int lt = levy+1, rt = pravy-1;
        if ((delka += 2) >= podposl[N-1][0].delka) break;
        levy = podposl[rt-lt][lt].prvni;
        pravy = podposl[rt-lt][lt].posledni;
    }

    printf("%d\n", podposl[N-1][0].delka);

    
}
