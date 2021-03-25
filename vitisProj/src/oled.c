#include "oled.h"


void updateOLED(PmodOLED *instance, char* value) {
	OLED_ClearBuffer(instance);
	OLED_SetCursor(instance, 0, 3);
	OLED_PutString(instance, value);
	OLED_Update(instance);
}

void initOLED(PmodOLED *instance) {
	OLED_Begin(instance, XPAR_PMODOLED_0_AXI_LITE_GPIO_BASEADDR, XPAR_PMODOLED_0_AXI_LITE_SPI_BASEADDR, 0, 0);
}
