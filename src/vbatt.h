#ifndef __VBATT_H
#define __VBATT_H

#include <stdint.h>
#include <libopencm3/stm32/adc.h>

/* Battery limit in millivolts (2 cells) */
#define BATTERY_LIMIT_MV 6400
#define RESISTOR_DIVISOR 36

/* Battery */
#define BATTERY_PORT GPIOB
#define BATTERY_PIN GPIO0
#define BATTERY_CHANNEL 8
#define AVG_BATTERY_SAMPLES 20

/* Time between battery readings: 1000 ms => 1s */
#define SYS_BETWEEN_READS 1000

uint16_t read_vbatt();
uint8_t has_batt_drained(void);
uint16_t get_last_batt_meas(void);

#endif /* __VBATT_H */
