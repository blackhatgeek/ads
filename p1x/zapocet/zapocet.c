#include<dirent.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<stdio.h>
#include<string.h>

DIR *dir;
char dir_uri;

int otevri_adresar(){
	dir=opendir(&dir_uri);//pokus o otevreni adresare
	if(dir==NULL){
		fprintf(stderr,"Chyba pri vstupu do adresare: %s\n",&dir_uri);
		return 1;//fail
	}else return 0;
}

int vypis_adresar(){
	//otevreli jsme adresar - vypis obsazenych souboru vc. velikosti
	struct dirent *de=readdir(dir);
	struct stat st;
	while(de!=NULL){
		if (!((strlen(de->d_name)==1) && (de->d_name[0]=='.')) && !((strlen(de->d_name)==2) && (de->d_name[0]=='.') && (de->d_name[1]=='.'))){//nevypisuji . a ..
			//if(de->d_type==DT_DIR) fprintf(stdout,"d\n");
			if(de->d_type==DT_REG){
//				char *path=strcat(strcat(&dir_uri,"/"),de->d_name);
//				fprintf(stdout,"%s\n",path);
//				stat(dir_uri."/".*de->d_name,&st);
				fprintf(stdout,"%s\n",de->d_name);
			}
		}
		de=readdir(dir);
	}		
}

int main(){
	fscanf(stdin,"%s",&dir_uri);//nacte vstupni adresu
	if(otevri_adresar()==1) return 1;
	else vypis_adresar();
	return 0;
}
