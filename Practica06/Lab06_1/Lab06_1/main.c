/**
 * \file
 *
 * \brief Empty user application template
 *
 */

/**
 * \mainpage User Application template doxygen documentation
 *
 * \par Empty user application template
 *
 * Bare minimum empty user application template
 *
 * \par Content
 *
 * -# Include the ASF header files (through asf.h)
 * -# Minimal main function that starts with a call to system_init()
 * -# "Insert application code here" comment
 *
 */

/*
 * Include header files for all drivers that have been imported from
 * Atmel Software Framework (ASF).
 */
/*
 * Support and FAQ: visit <a href="https://www.microchip.com/support/">Microchip Support</a>
 */
#include "sam.h"

#define PINCFG_CONFIG_VALUE 0b00000000

int main(void) {
    /* Initialize the SAM system */
    SystemInit();

    //PORT configuration for general-purpose PIN
    PORT->Group[0].PINCFG[17].reg = PINCFG_CONFIG_VALUE;
    PORT->Group[0].DIRSET.reg = PORT_PA17;

    //TIMER configuration
    //Configure the POWER MANAGER to enable the TC3 module
    PM->APBCMASK.reg |= PM_APBCMASK_TC3;

    //Configure the GENERIC CLOCK CONTROL used by the TC3 module
	GCLK->GENDIV.reg = 0x00;
	GCLK->GENCTRL.reg = 0x10600;
	GCLK->CLKCTRL.reg = 0x401B;
	
	// Disable TC first 
	TC3->COUNT16.CTRLA.bit.ENABLE = 0;

	// Calculate the value to load into the COUNT register for the desired delay time
	// Time = Toscillator * (2^TIMERMODE - COUNT) * Prescaler
	TC3->COUNT16.COUNT.reg = 3036;
	// Configure prescaler (16 bit prescaler)
	TC3->COUNT16.CTRLA.reg = TC_CTRLA_PRESCALER_DIV16 | TC_CTRLA_ENABLE;

    //Loop to sync the TC clock with the processor/main clock
	while(TC3->COUNT16.STATUS.bit.SYNCBUSY == 1) {
		
	}
	
	PORT->Group[0].OUTCLR.reg = PORT_PA17;

    //Loop to generate the square-wave signal
	while(1) {
		if(TC3->COUNT16.INTFLAG.bit.OVF == 1) {
			//Reset Overflow
			TC3->COUNT16.INTFLAG.reg = 1;
			//Recharge initial count
			TC3->COUNT16.COUNT.reg = 3036;
			//Toggle pin
			PORT->Group[0].OUTTGL.reg = PORT_PA17;
		}
	}
}