#pragma once


char znak, zakazane[3];			// wczytany z pliku znak i znaki które będą pominane
int pozycja_znacznik, biale_znaki;	// numer znaku wczytywanego z pliku
char sciezka[]="../h/snakeHeadDown.h";		// default in *.txt
char nazwa_pliku[]="glowa.mif";			//gdzie zostanie zapisany
char znak_3bit[4];
int liczba_iteracji;

//function
void wczytanie(bool display, int liczba_znakow);
void setup();
void tworzenie(char *nazwa);
void conversion_to_3bit(char liczba);
void mif_conversion(int width, int depth);
