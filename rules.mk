CROSS_COMPILE = arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
CPUFLAGS = -mcpu=cortex-m3 -mthumb
LIBPATHS := ./libopencm3 ../../libopencm3  ../libopencm3

OPENCM3_DIR := $(wildcard $(LIBPATHS:=/locm3.sublime-project))
OPENCM3_DIR := $(firstword $(dir $(OPENCM3_DIR)))

### CHANGE THIS LINE TO SELECT BLUEPILL OR BLACKPILL
ifeq ($(PILL), BLACK)
PILLFLAGS = -DINTERNAL_LED=GPIO12 -DINTERNAL_LED_PORT=GPIOB -DRCC_INTERNAL_LED=RCC_GPIOB
else
PILLFLAGS = -DINTERNAL_LED=GPIO13 -DINTERNAL_LED_PORT=GPIOC -DRCC_INTERNAL_LED=RCC_GPIOC
endif


$(info $$PILL is [${PILL}])

ifeq ($(strip $(OPENCM3_DIR)),)
$(warning Cannot find libopencm3 library in the standard search paths.)
$(error Please specify it through OPENCM3_DIR variable!)
endif

CFLAGS = -Wall -Wextra -g3 -O0 -MD $(CPUFLAGS) -DSTM32F1 -std=c99 $(PILLFLAGS) -I${OPENCM3_DIR}/include

LDLIBS = -lopencm3_stm32f1 -lc -lnosys

LIBPATHS := . ../../ ../
BLUE_DIR := $(wildcard $(LIBPATHS:=/bluepill.ld))
BLUE_DIR := $(firstword $(dir $(BLUE_DIR)))
ifeq ($(strip $(BLUE_DIR)),)
$(warning Cannot find bluepill.ld in the standard search paths.)
$(error Please specify it through BLUE_DIR variable!)
endif


LDFLAGS = $(CPUFLAGS) -nostartfiles -L${OPENCM3_DIR}/lib -Wl,-T,${BLUE_DIR}/bluepill.ld

.PHONY: libopencm3
libopencm3:
	if [ ! -f ${OPENCM3_DIR}/Makefile ]; then \
		git submodule init; \
		git submodule update; \
	fi
	$(MAKE) -C ${OPENCM3_DIR} lib/stm32/f1
