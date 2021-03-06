DEVICE = atmega168
AVRDUDE_DEVICE = m168
DEVICE ?= atmega168
AVRDUDE_DEVICE ?= m168

CFLAGS=-g -Wall -mcall-prologues -mmcu=$(DEVICE) -Os
CPP=avr-g++
CC=avr-gcc
OBJ2HEX=avr-objcopy 
LDFLAGS=-Wl,-gc-sections -lpololu_$(DEVICE) -Wl,-relax

PORT ?= /dev/ttyUSB0
AVRDUDE=avrdude
TARGET=linefollowerlog

all: $(TARGET).hex

clean:
	rm -f *.o *.hex *.obj *.hex

%.hex: %.obj
	$(OBJ2HEX) -R .eeprom -O ihex $< $@

%.obj: %.o
	$(CC) $(CFLAGS) $< $(LDFLAGS) -o $@
	gcc -o logdata logdataxbee.c 

program: $(TARGET).hex
	$(AVRDUDE) -p $(AVRDUDE_DEVICE) -c avrisp2 -P $(PORT) -U flash:w:$(TARGET).hex
