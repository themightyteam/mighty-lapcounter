sinclude ../rules.mk

NAME = lapcounter

CSRC = $(wildcard *.c)
OBJ = $(CSRC:.c=.o)

$(NAME).elf: $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $(OBJ) $(LDLIBS)

.PHONY: clean
clean:
	-rm -rf *.o *.bin *.elf *.map *.d

clean_all:
	-rm -rf *.o *.bin *.elf *.map *.d
	-$(MAKE) -C libopencm3 clean


%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

bin: $(NAME).bin

all: libopencm3 $(NAME).bin

