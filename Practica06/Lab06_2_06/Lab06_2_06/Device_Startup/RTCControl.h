#ifndef RTCCONTROL_H_
#define RTCCONTROL_H_

#include <stdint.h>
#include "sam.h"
#include "stdbool.h"

#define SLAVE_ADDR 0x68u
#define BUF_SIZE 4
#define DAY_ADDR 0x03u

typedef union {
	struct {
		uint8_t U_SEC :4,
		D_SEC :3,
		CH :1;
	} BIT;
	uint8_t REG;
} SEC_TYPE;

typedef union {
	struct {
		uint8_t U_MINUTES :4,
		D_MINUTES :3,
		RESERVED :1;
	} BIT;
	uint8_t REG;
} MIN_TYPE;

typedef union {
	struct {
		uint8_t U_HOURS :4,
		D_HOURS :1,
		FORMAT1 :1,
		FORMAT2 :1,
		RESERVED :1;
	} BIT;
	uint8_t REG;
} HOUR_TYPE;

typedef union {
	struct {
		uint8_t DAY :3,
		RESERVED :5;
	} BIT;
	uint8_t REG;
} DAY_TYPE;

typedef union {
	struct {
		uint8_t U_DATE :4,
		D_DATE :2,
		RESERVED :2;
	} BIT;
	uint8_t REG;
} DATE_TYPE;

typedef union {
	struct {
		uint8_t U_MONTH :4,
		D_MONTH :1,
		RESERVED :3;
	} BIT;
	uint8_t REG;
} MONTH_TYPE;

typedef union {
	struct {
		uint8_t U_YEAR :4,
		D_YEAR :4;
	} BIT;
	uint8_t REG;
} YEAR_TYPE;

typedef struct {
	SEC_TYPE SEC;
	MIN_TYPE MIN;
	HOUR_TYPE HOUR;
	DAY_TYPE DAY;
	DATE_TYPE DATE;
	MONTH_TYPE MONTH;
	YEAR_TYPE YEAR;
} RTC_TYPE;



void sendI2CDataArray(uint8_t SlAddr, uint8_t ptr, uint8_t* ptrData, uint8_t Size);
void SendI2CData(uint8_t Data);
void StopCond();
void receiveI2CDataArray(uint8_t SlAddr, uint8_t ptr, uint8_t* ptrData, uint8_t Size);

#endif /*RTCCONTROL_H_*/