/*
 * s4i_tools.h
 *
 *  Created on: 21 févr. 2020
 *      Author: francoisferland
 */

#ifndef SRC_S4I_TOOLS_H_
#define SRC_S4I_TOOLS_H_

#include <xgpio.h>
#include <stdio.h>
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"
#include "PmodGPIO.h"
#include "MouvAnalyseIP.h"
#include "PmodOLED.h"


#define S4I_NUM_SWITCHES	4

void			s4i_init_hw();
int 			s4i_is_cmd_sws(char *buf);

// Capteur Cardiaque
int 			s4i_is_analyse_bpm(char *buf);
int 			s4i_is_analyse_zone_cardiaque(char *buf);
int 			s4i_is_analyse_o2(char *buf);
// Capteur de mouvement
int 			s4i_is_analyse_etat_sommeil(char *buf);
int 			s4i_is_analyse_activite_physique(char *buf);
int				s4i_is_reminder(char* buf);

unsigned int 	s4i_get_sws_state();

// Capteur Electro-cardiogramme
char* 			get_zone_cardiaque();
int 			get_bpm();

// Capteur de mouvement
u16				get_mouv_donnee();
int				get_reminder();

// Autre
int 			get_o2();

u16 AD1_GetSampleRaw();
float AD1_GetSampleVoltage();

void 			initOLEDDevice();
void 			updateOLEDDevice();
void 			changeOLEDSelector(char selector);

#endif /* SRC_S4I_TOOLS_H_ */

