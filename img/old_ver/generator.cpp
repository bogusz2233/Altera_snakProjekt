/*
Program ten zostal napisaniy w celu konwersji 3-bitowej mapy kolorow do pamieci rom
Generacja tej mapy ma posłużyć w celu wyświetlenia jej na ekranie wykorzystując standard
VGA 

*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#include "generator.h"


using namespace std;



int main(){
	int czas_start = clock();
	setup();
	mif_conversion(25*25,3);
	
	printf("\nCzas trwania programu: %f [s] \n",  (float) (clock() - czas_start)  /CLOCKS_PER_SEC );
	return 0;
}

void setup(){
	
	
	zakazane[0]=0xa;		//that's enter
	zakazane[1]=',';
	zakazane[2]=0x9;		//that's tab
	pozycja_znacznik = 0;
	liczba_iteracji = 0;

}

void wczytanie(bool display, int liczba_znakow){
	
	FILE *plik;	
	for(int i=0; i< liczba_znakow; i++){
		do {
			plik = fopen(sciezka,"r+");

		  	fseek ( plik ,pozycja_znacznik , SEEK_SET ); 
			// that sets position of character
			// SEEK_SET means start from begining of file
			fscanf(plik,"%c",&znak);
			fclose(plik);
			pozycja_znacznik++;
		}while(znak == zakazane[0]  || znak == zakazane[1] || znak == zakazane[2]);
	if(display) 	printf("\nWczytany znak = %c",znak);
	}



}


void tworzenie(char *nazwa){
	//deklaracja pamięci
	
	FILE *plik;
	plik = fopen(nazwa_pliku,"w");
	fclose(plik);
	
}

void conversion_to_3bit(char liczba){

	switch(liczba){
		
		case '0': strcpy(znak_3bit,"111"); break;	//biały
		case '1': strcpy(znak_3bit,"000"); break;	//czarny
		case '2': strcpy(znak_3bit,"110"); break;	//żółty
		case '3': strcpy(znak_3bit,"100"); break;	//czerwony
		case '4': strcpy(znak_3bit,"010"); break;	//zielony
		case '5': strcpy(znak_3bit,"011"); break;	//turkus
		case '6': strcpy(znak_3bit,"010"); break;
		case '7': strcpy(znak_3bit,"001"); break;
		default: break;

	}
	
}

void mif_conversion( int depth, int width){

	// stworzenie pliku i za pisanie podstawowych informacji
	FILE * PLIK;	
	tworzenie(nazwa_pliku);
	PLIK = fopen("ukochana.mif","a");
	fprintf(PLIK,"WIDTH = %d; \n",width);
	fprintf(PLIK,"DEPTH = %d; \n\n",depth);
	fprintf(PLIK,"ADDRESS_RADIX=UNS; \n");
	fprintf(PLIK,"DATA_RADIX=BIN; \n");
	fprintf(PLIK,"\n");
	fprintf(PLIK,"CONTENT BEGIN");
	fclose(PLIK);
	
	//orzepisanie treści
	while(znak!=0x3 and liczba_iteracji < depth ){
		
		wczytanie(false,1);
		conversion_to_3bit(znak);
		PLIK = fopen(nazwa_pliku,"a");
		fprintf(PLIK,"\n\t%d \t: %s;", liczba_iteracji,znak_3bit);
		fclose(PLIK);
		liczba_iteracji++;
	}

	// zakonczenie pliku
	PLIK = fopen(nazwa_pliku,"a");
	fprintf(PLIK,"\nEND;");
	fclose(PLIK);
}


