#docker run --rm --privileged --net=host -v "${PWD}":/config --device=/dev/serial/by-id/usb-Silicon_Labs_CP2102N_USB_to_UART_Bridge_Controller_cc1ecdf97ea0eb119c16cdacdf749906-if00-port0 -it ghcr.io/esphome/esphome:dev run esphome_presence.yaml /dev/ttyUSB0

ESPHOME_VERSION = dev
ESPHOME = docker run --rm --privileged -v "${PWD}":/config -it ghcr.io/esphome/esphome:$(ESPHOME_VERSION)

all: \
	template.bin \
	athom-rgbct-light.bin \
	athom-smart-plug-v2.bin \
	presence.bin \
	ultrabrite-plug.uf2

# Template

template.bin: template.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/template/.pioenvs/template/firmware.bin $@.tmp
	mv -f $@.tmp $@

# Athom RGBCT Light
athom-rgbct-light.bin: athom-rgbct-light.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/athom-rgbct-light/.pioenvs/athom-rgbct-light/firmware.bin $@.tmp
	mv -f $@.tmp $@

athom-rgbct-light-clean:
	rm -f athom-rgbct-light.bin.tmp athom-rgbct-light.bin
clean: athom-rgbct-light-clean

# Athom Smart Plug V2

athom-smart-plug-v2.bin: athom-smart-plug-v2.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/athom-smart-plug-v2/.pioenvs/athom-smart-plug-v2/firmware.bin $@.tmp
	mv -f $@.tmp $@

athom-smart-plug-v2-clean:
	rm -f athom-smart-plug-v2.bin.tmp athom-smart-plug-v2.bin
clean: athom-smart-plug-v2-clean

# Presence

presence.bin: presence.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/presence/.pioenvs/presence/firmware.bin $@.tmp
	mv -f $@.tmp $@

presence-clean:
	rm -f presence.bin.tmp presence.bin
clean: presence-clean

# Ultrabrite Plug

ultrabrite-plug.uf2: ultrabrite-plug.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/ultrabrite-plug/.pioenvs/ultrabrite-plug/firmware.uf2 $@.tmp
	mv -f $@.tmp $@

ultrabrite-plug-clean:
	rm -f ultrabrite-plug.uf2.tmp ultrabrite-plug.uf2
clean: ultrabrite-plug-clean

# Clean

clean: