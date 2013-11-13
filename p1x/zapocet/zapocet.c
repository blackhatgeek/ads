#include<stdio.h>
#include<dirent.h>

#define TRUE 1
#define FALSE 0
#define T_FILE 'f'
#define T_DIR 'd'
#define STACK_MAX 10

//zasobnik konstantni delky
struct T_STACK{
	char *stack[STACK_MAX];
	unsigned short head;
} stack;

//vlozi do zasobniku adresar
int stack_push(char *dir){
	stack.head++;
	if (stack.head<STACK_MAX){
		stack.stack[stack.head]=dir;
		return TRUE;
	}else return FALSE;
}

//vezmi adresar ze zasobniku a pokus se ho otevrit - vrati ukazatel na soubor
int stack_pop_open(FILE *file){
	if ((stack.head>-1)&&(stack.head<STACK_MAX)){
		DIR *dir=opendir(stack.stack[stack.head]);//vezme ze zasobniku adresu adresare a pokusi se ho otevrit
		stack.head--;
//		struct dirent *de=readdir(stack.stack[stack.head]);
		
		
	} else{
		file=NULL;
		return FALSE;
	}
}

//cti prvek v adresari - dostane adresar, vrati jmeno souboru
int read_dir(FILE *dir, char *name){
}

//vlozi do "databaze" jmeno souboru a velikost v B
int db_put(char *name, int length){
}

//vrati delku souboru - dostane soubor a jmeno, vrati delku v B, pokud soubor neexistuje, je to 0
int get_length(FILE *dir,char *name){
}


int main(){
	char *dir,*name;
	FILE file;
	stack.head=-1;

	//nacti vstupni adresar
	fscanf(stdin,"%s",dir);

	//vloz adresar do zasobniku
	stack_push(dir);

	//dokud je zasobnik neprazdny
	while(stack.head>-1){
		//vezmi adresar ze zasobniku a pokus se ho otevrit
		if(stack_pop_open(&file)==TRUE){
			//pokud se povedlo adresar otevri, cti prvky v adresari
			//je-li to soubor, vloz ho do "databaze": dle velikosti usporadane skupiny souboru, vsechny prvky nejake skupiny maji stejnou velikost
			//je-li to adresar, vloz ho do zasobniku
			if(read_dir(&file,name)==T_FILE) db_put(name,get_length(&file,name));
			else stack_push(name);
		}
	}
}
