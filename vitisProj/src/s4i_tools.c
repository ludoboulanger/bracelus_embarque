/*
 * s4i_tools.c
 *
 *  Created on: 21 fÃ©vr. 2020
 *      Author: francoisferland
 */

#include "s4i_tools.h"
#include "xparameters.h"
#include "oled.h"

#include <xgpio.h>
#include <stdlib.h>

#define MY_MOUV_ANALYSE_IP_BASEADDRESS  XPAR_MOUVANALYSEIP_0_MOUVANALYSEIP_BASEADDR
#define MY_MOUV_CARDIO_IP_BASEADDRESS   XPAR_CARDIOANALYSEIP_0_S00_AXI_BASEADDR
#define MOUV_ANALYSE_NUM_BITS 	12

#define ZONE_MOUV 0
#define RAPPEL_BOUGER 1
#define MOYENNE_CARDIAQUE 2

XGpio s4i_xgpio_input_sws;

const float ReferenceVoltage = 3.3;

PmodOLED oledDevice;
PmodGPIO pmod8LD;
char oledSelector = '1';
void s4i_init_hw()
{
    // Initialise l'accï¿½s au matÅ½riel GPIO pour s4i_get_sws_state().
	XGpio_Initialize(&s4i_xgpio_input_sws, XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&s4i_xgpio_input_sws, 1, 0xF);

}

int s4i_is_cmd_sws(char *buf)
{


	buf += 5;
	// strncmp(fext, "htm", 3)
	// strcat(buf, "image/jpeg");



	return (!strncmp(buf, "cmd", 3) && !strncmp(buf+4, "sws", 3));

	// return 0;
    // TODO: VÅ½rifier si la chaâ€�ne donnÅ½e correspond Ë† "cmd/sws".
    // Retourner 0 si ce n'est pas le cas.
    // Attention: la chaâ€�ne possï¿½de la requï¿½te complï¿½te (ex. "GET cmd/sws").
    // Un indice : Allez voir les mÅ½thodes similaires dans web_utils.c.
}

int s4i_is_analyse_bpm(char *buf)
{
	return !strncmp(buf, "GET /analyse/bpm", 16);
}

int s4i_is_analyse_zone_cardiaque(char* buf) {
	return !strncmp(buf, "GET /analyse/zone_cardiaque", 27);
}

int s4i_is_analyse_o2(char *buf)
{
	return !strncmp(buf, "GET /analyse/o2", 15);
}

int s4i_is_analyse_etat_sommeil(char *buf)
{
	return !strncmp(buf, "GET /analyse/etat_sommeil", 25);
}

int s4i_is_analyse_activite_physique(char *buf)
{
	return !strncmp(buf, "GET /analyse/activite_physique", 30);
}

int s4i_is_reminder(char* buf) {
	return !strncmp(buf, "GET /analyse/rappel", 19);
}

unsigned int s4i_get_sws_state()
{
    // Retourne l'Å½tat des 4 interrupteurs dans un entier (un bit par
    // interrupteur).
    return XGpio_DiscreteRead(&s4i_xgpio_input_sws, 1);
}

u16 get_mouv_donnee() {

	// Pour l'instant on génère un nombre et on choisi le niveau d'activité selon ce dernier
	// int niv_act = rand() % 3;

	u16 resultat_mouvement = read_analyse_mouv_ip0();
	return resultat_mouvement;

}

int get_reminder() {
	// En realite, retournes 0 ou 1 dependamment de si on a un reminder de bouger ou non
	float data = get_sample_voltage_ADC(RAPPEL_BOUGER);
	if (data == 0) {
		return 0;
	} else {
		return 1;
	}
}

char* get_zone_cardiaque() {
	int zone_card = rand() % 4;

	if (zone_card == 0) {
		return "Aucune";
	} else if (zone_card == 1) {
		return "Cardio";
	} else if (zone_card == 2){
		return "Brulure de graisse";
	} else {
		return "Maximale";
	}
}

int get_bpm()
{
	int rythme = rand() % 80 + 50;

	return rythme;
}

int get_o2()
{
	return rand() % 5 + 95;
}

u16 read_analyse_mouv_ip0()
{
	u16 rawData =  MOUVANALYSEIP_mReadReg(MY_MOUV_ANALYSE_IP_BASEADDRESS, MOUVANALYSEIP_MouvAnalyseIP_SLV_REG0_OFFSET) & 0xFFF;
	return rawData;
}

u16 read_analyse_mouv_ip1()
{
	u16 rawData =  MOUVANALYSEIP_mReadReg(MY_MOUV_ANALYSE_IP_BASEADDRESS, MOUVANALYSEIP_MouvAnalyseIP_SLV_REG1_OFFSET) & 0xFFF;

	return rawData;
}

u16 read_analyse_cardio0()
{
	u16 rawData =  CARDIOANALYSEIP_mReadReg(MY_MOUV_CARDIO_IP_BASEADDRESS, 0x0) & 0xFFF;
	return rawData;
}


float get_sample_voltage_ADC(int analyse)
{
	u16 rawSample = 0;
	float conversionFactor = ReferenceVoltage / ((1 << MOUV_ANALYSE_NUM_BITS) - 1);

	if (analyse == 0) {
		rawSample = read_analyse_mouv_ip0();
	} else if (analyse == 1) {
		rawSample = read_analyse_mouv_ip1();
	} else {
		rawSample = read_analyse_cardio0();
	}


	return (float)rawSample * conversionFactor;
}

void update8LDDevice() {
	//xil_printf("Helloooo\r\n");
	u8 pmod8LDvalue = 0;
	float data = get_sample_voltage_ADC(RAPPEL_BOUGER);
//	pmod8LDvalue = 0xFF << (8 - (u8)(data / 3.3 * 8));
	if (data == 0) {
		pmod8LDvalue = 0;
	} else {
		pmod8LDvalue = 255;
	}
	GPIO_setPins(&pmod8LD,pmod8LDvalue);
}

void init8LDDevice() {
	GPIO_begin(&pmod8LD, XPAR_PMODGPIO_0_AXI_LITE_GPIO_BASEADDR, 0x00);
}

void initOLEDDevice() {
	initOLED(&oledDevice);
}

void updateOLEDDevice() {
	u16 res = get_mouv_donnee();
	if (oledSelector == '1') {
		if (res == 2) {
			updateOLED(&oledDevice, "Zone Intense");
		} else if (res == 1) {
			updateOLED(&oledDevice ,"Zone Basse");
		} else {
			updateOLED(&oledDevice, "Zone Nulle");
		}
	} else {
		updateOLED(&oledDevice ,"Cardiaque");
	}

}

void changeOLEDSelector(char selector) {
	oledSelector = selector;
}

