#include<stdio.h>
#include<dirent.h>
#include<string.h>
#include<stdlib.h>

#define TRUE 1
#define FALSE 0
#define T_FILE 'f'
#define T_DIR 'd'
#define T_ERR 'e'
#define STACK_MAX 10
#define MAX_FN_SIZE 255

//zasobnik konstantni delky
struct T_STACK{
	char *stack[STACK_MAX];
	short head;
} stack;

//vlozi do zasobniku adresar
int stack_push(char *dir){
	stack.head++;
	fprintf(stdout,"stack head: %d\t",stack.head);
	if (stack.head<STACK_MAX){
		stack.stack[stack.head]=dir;
		fprintf(stdout,"stack: %s\n",dir);
		return TRUE;
	}else{fprintf(stdin,"\n"); return FALSE;}
}

//vezmi adresar ze zasobniku a pokus se ho otevrit - vrati ukazatel na adresar
int stack_pop_open(DIR *dir){
	fprintf(stdout,"%d\n",stack.head);
	if ((stack.head>-1)&&(stack.head<STACK_MAX)){
		fprintf(stdout,"Open %s\n",stack.stack[stack.head]);
		dir=opendir(stack.stack[stack.head]);//vezme ze zasobniku adresu adresare a pokusi se ho otevrit
		stack.head--;
		if (dir==NULL){
			fprintf(stderr,"Chyba pri vstupu do adresare: %s\n",stack.stack[stack.head+1]);
			return FALSE;
		}
	} else{
		dir=NULL;
		return FALSE;
	}
	return TRUE;
}

//cti prvek v adresari - dostane adresar, vrati jmeno souboru, returnem vrati f nebo d
char read_dir(DIR *dir, char *name){
	struct dirent *de;
	de=readdir(dir);
	/*if (de!=NULL){
		if (!((strlen(de->d_name)==1) && (de->d_name[0]=='.')) && !((strlen(de->d_name)==2) && (de->d_name[0]=='.') && (de->d_name[1]=='.'))){//nevypisuji . a ..
			name=de->d_name;
			if((de->d_type)==DT_DIR) return T_DIR;
			else if((de->d_type)==DT_REG) return T_FILE;
			else return T_ERR;
		} else return T_ERR;
	} else return T_ERR;*/
}

//vlozi do "databaze" jmeno souboru a velikost v B
int db_put(char *name, int length){
	fprintf(stdout,"%s\n",name);
}

//vrati delku souboru - dostane soubor a jmeno, vrati delku v B, pokud soubor neexistuje, je to 0
int get_length(FILE *dir,char *name){
}


int main(){
	char *dir,*name;
	DIR *directory;
	FILE file;
	stack.head=-1;
	
	dir=(char*) malloc(MAX_FN_SIZE*sizeof(char));
	//nacti vstupni adresar
	fscanf(stdin,"%s",dir);

	//vloz adresar do zasobniku
	stack_push(dir);

	//dokud je zasobnik neprazdny
	while(stack.head>-1){
		//vezmi adresar ze zasobniku a pokus se ho otevrit
		if(stack_pop_open(directory)==TRUE){
			//pokud se povedlo adresar otevri, cti prvky v adresari
			//je-li to soubor, vloz ho do "databaze": dle velikosti usporadane skupiny souboru, vsechny prvky nejake skupiny maji stejnou velikost
			//je-li to adresar, vloz ho do zasobniku
			char type=read_dir(directory,name);
			//if(type==T_FILE) db_put(name,get_length(&file,name));
			//else if (type==T_DIR) stack_push(name);
		}
	}
}
