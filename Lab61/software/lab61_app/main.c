// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x90; //make a pointer to access the PIO block

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}




/*

int main()
{
	volatile unsigned int *LED_PIO = (unsigned int*)0x90; //make a pointer to access the PIO block
	volatile unsigned int *SW = (unsigned int*) 0x60; // similar pointers for switches & keys
	volatile unsigned int *KEY0 = (unsigned int*)0x80;
	volatile unsigned int *KEY1 = (unsigned int*) 0x70;
	*LED_PIO = 0; //clear all LEDs
	int pressed = 0;
	while ( (1+1) != 3) //infinite loop
	{
		while(*KEY0 != 0)
		{
			while(*KEY1 == 0)
			{
				if (pressed == 0){
					*LED_PIO = (*LED_PIO + *SW) % 256;
				}
				pressed = 1;
			}
			pressed = 0;
		}
		*LED_PIO = 0; //clear all LEDs
	}
	return 1; //never gets here
}

*/
