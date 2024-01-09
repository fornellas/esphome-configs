ESPHOME_VERSION = dev
ESPHOME = docker run --rm --privileged -v "${PWD}":/config -it ghcr.io/esphome/esphome:$(ESPHOME_VERSION)

all: presence.bin ultrabrite-plug.uf2

presence.bin: presence.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/presence/.pioenvs/presence/firmware.bin $@.tmp
	mv -f $@.tmp $@

presence-clean:
	rm -f presence.bin.tmp presence.bin
clean: presence-clean

ultrabrite-plug.uf2: ultrabrite-plug.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/ultrabrite-plug/.pioenvs/ultrabrite-plug/firmware.uf2 $@.tmp
	mv -f $@.tmp $@

ultrabrite-plug-clean:
	rm -f ultrabrite-plug.uf2.tmp ultrabrite-plug.uf2
clean: ultrabrite-plug-clean

clean: