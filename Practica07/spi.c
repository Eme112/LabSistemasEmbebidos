#include "sam.h"
#include "myprintf.h"
#include "spi.h"

void spiInit( void ) {
  /* Switch to 8MHz clock (disable prescaler) */
  SYSCTRL->OSC8M.bit.PRESC = 0;
  PM->APBCMASK.bit.SERCOM1_ = 1; //enable the clock for SERCOM1 peripheral
  GCLK->CLKCTRL.reg = GCLK_CLKCTRL_CLKEN | GCLK_CLKCTRL_GEN_GCLK0 | 
  GCLK_CLKCTRL_ID_SERCOM1_CORE;
  while( GCLK->STATUS.bit.SYNCBUSY ) { }
  //structures to configure the SERCOM1 peripheral
  const SERCOM_SPI_CTRLA_Type ctrla = {
    .bit.DORD = 0, // MSB first
    .bit.CPHA = 0, // Mode 0
    .bit.CPOL = 0,
    .bit.FORM = 10, // SPI frame
    .bit.DIPO = 0x3, // MISO on PAD[3]
    .bit.DOPO = 0x0, // MOSI on PAD[0], SCK on PAD[1], SS_ on PAD[2]
    .bit.MODE = 0x3 // Master Mode
  };
  SERCOM1->SPI.CTRLA.reg = ctrla.reg;
  const SERCOM_SPI_CTRLB_Type ctrlb = {
    .bit.RXEN = 1 // RX enabled
    .bit.MSSEN = 0 // Manual SC
    .bit.CHSIZE = 0 // 8-bit
  };
  SERCOM1->SPI.CTRLB.reg = ctrlb.reg;
  //Formula to configure the desired baudrate
  uint32_t br = ( double )( 8000000 / ( 2 * BAUDRATE ) ) - 1 ;
  SERCOM1->SPI.BAUD.reg = SERCOM_SPI_BAUD_BAUD( ( uint8_t )br );
  //structure to configure multiple PINs
  const PORT_WRCONFIG_Type wrconfig = {
    .bit.WRPINCFG = 1,
    .bit.WRPMUX = 1,
    .bit.PMUX = MUX_PA16C_SERCOM1_PAD0 | MUX_PA17C_SERCOM1_PAD1 | MUX_PA19C_SERCOM1_PAD3,
    .bit.PMUXEN = 1,
    .bit.HWSEL = 1,
    .bit.PINMASK = ( uint16_t )( ( PORT_PA16 | PORT_PA17 | PORT_PA19 ) >> 16 )
  };
  PORT->Group[0].WRCONFIG.reg = wrconfig.reg;
  //SS/CS (Slave Select/Chip Select) PIN 18 configuration
  REG_PORT_DIRSET0 = PORT_PA18;
  REG_PORT_OUTSET0 = PORT_PA18;
  //enable the SPI
  SERCOM1->SPI.CTRLA.bit.ENABLE = 1;
  while( SERCOM1->SPI.SYNCBUSY.bit.ENABLE ) { }
}

uint8_t spiSend( uint8_t data ) {
  uint8_t temp;
  while(!SERCOM1->SPI.INTFLAG.bit.DRE) { } //wait until buffer is empty
  SERCOM1->SPI.DATA.reg = SERCOM_SPI_DATA_DATA( data ); //transmit data
  while( !SERCOM1->SPI.INTFLAG.bit.RXC ) { } //wait until a data is received
  temp = SERCOM1->SPI.DATA.reg; //read data
  while( !SERCOM1->SPI.INTFLAG.bit.TXC ) { } //wait until there is no data to transmit
  myprintf( " %x", temp ); //printf the value in putty
  return temp;
}

int main(void)
{
  UARTInit();
  spiInit();
  volatile uint8_t rData;
  volatile uint8_t sData = 85;
  while (1) {
    REG_PORT_OUTCLR0 = PORT_PA18; //initiate transaction by SS_low
    rData = spiSend( sData );
    REG_PORT_OUTSET0 = PORT_PA18; //finish transaction by SS_high
  }
}

void UARTInit(void) {
  /* Initialize the SAM system */
  SystemInit();

	/* Switch to 8MHz clock (disable prescaler) */
	SYSCTRL->OSC8M.bit.PRESC = 0;
	
	/* port mux configuration*/
	PORT->Group[0].DIR.reg |= (1 << 10);                  /* Pin 10 configured as output */
	PORT->Group[0].PINCFG[PIN_PA11].bit.PMUXEN = 1;       /* Enabling peripheral functions */
	PORT->Group[0].PINCFG[PIN_PA10].bit.PMUXEN = 1;       /* Enabling peripheral functions */
	
	/*PMUX: even = n/2, odd: (n-1)/2 */
	PORT->Group[0].PMUX[5].reg |= 0x02;                   /* Selecting peripheral function C */
	PORT->Group[0].PMUX[5].reg |= 0x20;                   /* Selecting peripheral function C */
	
	/* APBCMASK */
	//PM->APBCMASK.reg |= PM_APBCMASK_SERCOM0;			  /* SERCOM 0 enable*/
	PM->APBCMASK.reg |= PM_APBCMASK_SERCOM0;

	/*GCLK configuration for sercom0 module: using generic clock generator 0, ID for sercom0, enable GCLK*/

	GCLK->CLKCTRL.reg = GCLK_CLKCTRL_ID(SERCOM0_GCLK_ID_CORE) |
	GCLK_CLKCTRL_CLKEN | GCLK_CLKCTRL_GEN(0);

	
	/* configure SERCOM0 module for UART as Standard Frame, 8 Bit size, No parity, BAUDRATE:9600*/

	SERCOM0->USART.CTRLA.reg =
	SERCOM_USART_CTRLA_DORD | SERCOM_USART_CTRLA_MODE_USART_INT_CLK |
	SERCOM_USART_CTRLA_RXPO(3/*PAD3*/) | SERCOM_USART_CTRLA_TXPO(1/*PAD2*/);
	
	uint64_t br = (uint64_t)65536 * (8000000 - 16 * 9600) / 8000000;
	
	SERCOM0->USART.CTRLB.reg = SERCOM_USART_CTRLB_RXEN | SERCOM_USART_CTRLB_TXEN | SERCOM_USART_CTRLB_CHSIZE(0/*8 bits*/);

	SERCOM0->USART.BAUD.reg = (uint16_t)br;

	SERCOM0->USART.CTRLA.reg |= SERCOM_USART_CTRLA_ENABLE;
}
