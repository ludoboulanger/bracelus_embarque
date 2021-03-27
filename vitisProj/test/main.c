/*
 * main.c
 *
 * Atelier #3 - Projet S4 Génie informatique - H21
 *
 *  Author: Larissa Njejimana
 */



#include <xgpio.h>
#include <stdio.h>
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"
#include "PmodGPIO.h"
#include "PmodOLED.h"
#include "MouvAnalyseIP.h"
#include "CardioAnalyseIP.h"

u16 AD1_GetSampleRaw();
float AD1_GetSampleVoltage();
void DisplayVoltage(float value, char *voltage_char);
u16 getMouvZone();

#define MOUV_IP_BASE_ADDR  XPAR_MOUVANALYSEIP_0_MOUVANALYSEIP_BASEADDR
#define CARDIO_IP_BASE_ADDR  XPAR_CARDIOANALYSEIP_0_S00_AXI_BASEADDR
#define AD1_NUM_BITS 	12

const float ReferenceVoltage = 3.3;

u16 last0;
u16 last1;
u16 last2;
u16 mouvZone;

int main()
{
	XGpio inputSW, outputLED;
	PmodGPIO pmod8LD;
	PmodOLED oledDevice;
	int sw_data = 0;
	u8 pmod8LDvalue = 0;
	float currentVoltage = 0;

    print("Bienvenue\n\r");


    // Initialiser AXI_GPIO  IPs
	XGpio_Initialize(&inputSW, XPAR_AXI_GPIO_0_DEVICE_ID);		// switches
	XGpio_Initialize(&outputLED, XPAR_AXI_GPIO_1_DEVICE_ID);	// leds

	XGpio_SetDataDirection(&inputSW, 1, 0xF); 		//Fixer la direction du port 1 de l'AXI_GPIO_0 comme input
	XGpio_SetDataDirection(&outputLED, 1, 0x0);		//Fixer la direction du port 1 de l'AXI_GPIO_1 comme output

	// Initialiser PmodGPIO pour le Pmod_8LD
	GPIO_begin(&pmod8LD, XPAR_PMODGPIO_0_AXI_LITE_GPIO_BASEADDR, 0x00);

	// Initialiser le Pmod Oled
	OLED_Begin(&oledDevice, XPAR_PMODOLED_0_AXI_LITE_GPIO_BASEADDR, XPAR_PMODOLED_0_AXI_LITE_SPI_BASEADDR, 0, 0);
	// Désactiver la mise à jour automatique de l'écran de l'OLED
	OLED_SetCharUpdate(&oledDevice, 0);
	// Préparer l'écran pour afficher l'état des boutons et des switch
	OLED_ClearBuffer(&oledDevice);
	OLED_SetCursor(&oledDevice, 0, 3);
	OLED_PutString(&oledDevice, "Salut :)");
	OLED_Update(&oledDevice);



	print("Initialisation finie\n\r");

	while(1){

		// Lire puis afficher les valeurs des switch sur les leds
		sw_data = XGpio_DiscreteRead(&inputSW, 1);
		XGpio_DiscreteWrite(&outputLED, 1, sw_data);
		//xil_printf("Switch value = 0x%X\n\r", sw_data);


		// lire la tension provenant du PmodAD1
		currentVoltage = AD1_GetSampleVoltage();


		// Affichage graduel du voltage sur le Pmod 8LD
		// 3.3V => tous les leds allumés
		// 0.0V => tous les leds éteints
		//pmod8LDvalue = 0xFF << (8 - (u8)(currentVoltage / ReferenceVoltage * 8));
		if (currentVoltage == 0) {
			pmod8LDvalue = 0;
		} else {
			pmod8LDvalue = 255;
		}

		GPIO_setPins(&pmod8LD,pmod8LDvalue);

		mouvZone = getMouvZone();
		OLED_ClearBuffer(&oledDevice);
		OLED_SetCursor(&oledDevice, 0, 3);

		if (mouvZone == 2) {
			OLED_PutString(&oledDevice, "Intense");
		} else if (mouvZone == 1) {
			OLED_PutString(&oledDevice, "Basse");
		} else {
			OLED_PutString(&oledDevice, "Sedentaire");
		}


		OLED_Update(&oledDevice);

	}

    return 0;
}

u16 AD1_GetSampleRaw()
{
	u16 rawData0 =  MOUVANALYSEIP_mReadReg(MOUV_IP_BASE_ADDR, MOUVANALYSEIP_MouvAnalyseIP_SLV_REG0_OFFSET) & 0xFFF;
	u16 rawData1 =  MOUVANALYSEIP_mReadReg(MOUV_IP_BASE_ADDR, MOUVANALYSEIP_MouvAnalyseIP_SLV_REG1_OFFSET) & 0xFFF;

	u16 rawData2 =  CARDIOANALYSEIP_mReadReg(CARDIO_IP_BASE_ADDR, CARDIOANALYSEIP_S00_AXI_SLV_REG0_OFFSET) & 0xFFF;

	if(	last2 != rawData2)
	{
		last0 = rawData0;
		xil_printf("0x%x  0x%x 0x%x \n\r",rawData0, rawData1, rawData2);
	}

	last1 = rawData1;
	last2 = rawData2;
	return rawData1;
}


float AD1_GetSampleVoltage()
{
	float conversionFactor = ReferenceVoltage / ((1 << AD1_NUM_BITS) - 1);

	u16 rawSample = AD1_GetSampleRaw();

	return (float)rawSample * conversionFactor;

}

u16 getMouvZone() {
	u16 mouvZone =  MOUVANALYSEIP_mReadReg(MOUV_IP_BASE_ADDR, MOUVANALYSEIP_MouvAnalyseIP_SLV_REG0_OFFSET) & 0xFFF;
	return mouvZone;
}



