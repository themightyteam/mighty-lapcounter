#include "vbatt.h"

static uint16_t last_batt_meas = 0;
// For safety reasons battery flag should not be set to 0 in the code
static uint8_t out_of_battery_flag = 0;

static uint16_t read_adc_naiive(uint8_t channel) {

	uint8_t channel_array[1];
	channel_array[0] = channel;
	adc_set_regular_sequence(ADC1, 1, channel_array);
	adc_start_conversion_direct(ADC1);
	while (!adc_eoc(ADC1))
		;
	uint16_t reg16 = adc_read_regular(ADC1);
	return reg16;
}

static uint16_t read_adc_mean(uint8_t channel, int samples) {
	unsigned int total = 0;
	int my_samples = 1;
	if (samples > 1)
		my_samples = samples;
	for (int i = 0; i < my_samples; i++) {
		total = total + (unsigned int) read_adc_naiive(channel);
	}

	return total / my_samples;
}

// returns battery in milivolts
uint16_t read_vbatt() {
	last_batt_meas = read_adc_mean(BATTERY_CHANNEL,
			AVG_BATTERY_SAMPLES) * 100 / RESISTOR_DIVISOR;
	return last_batt_meas;
}

uint8_t has_batt_drained(void) {
	read_vbatt();
	if (last_batt_meas < BATTERY_LIMIT_MV) {
		out_of_battery_flag = 1;
	}

	return out_of_battery_flag;
}

uint16_t get_last_batt_meas(void) {
	return last_batt_meas;
}
