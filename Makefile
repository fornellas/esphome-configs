SERIAL := $(shell cat .serial)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .serial failed: $(SERIAL))
endif

ESPHOME_VERSION = 2025.6.1
ESPHOME = docker run --rm --privileged --net=host --device=$(SERIAL) -v "${PWD}":/config -it ghcr.io/esphome/esphome:$(ESPHOME_VERSION)

DOMAIN := $(shell cat .domain)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .domain failed: $(DOMAIN))
endif

USERNAME := $(shell cat .username)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .username failed: $(USERNAME))
endif

PASSWORD := $(shell cat .password)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .password failed: $(PASSWORD))
endif

ATHOM_MINI_SWITCH_DEVICES := $(shell cat .athom-mini-switch-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .athom-mini-switch-devices failed: $(ATHOM_MINI_SWITCH_DEVICES))
endif

ATHOM_RGBCT_LIGHT_DEVICES := $(shell cat .athom-rgbct-light-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .athom-rgbct-light-devices failed: $(ATHOM_RGBCT_LIGHT_DEVICES))
endif

ATHOM_SMART_PLUG_V2_DEVICES := $(shell cat .athom-smart-plug-v2-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .athom-smart-plug-v2-devices failed: $(ATHOM_SMART_PLUG_V2_DEVICES))
endif

ENERGY_MONITOR_DEVICES := $(shell cat .energy-monitor-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .energy-monitor-devices failed: $(ENERGY_MONITOR_DEVICES))
endif

ENVIRONMENTAL_DEVICES := $(shell cat .environmental-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .environmental-devices failed: $(ENVIRONMENTAL_DEVICES))
endif

ENVIRONMENTAL_V2_DEVICES := $(shell cat .environmental-v2-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .environmental-v2-devices failed: $(ENVIRONMENTAL_V2_DEVICES))
endif

ESP32_CAM_DEVICES := $(shell cat .esp32-cam-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .esp32-cam-devices failed: $(ESP32_CAM_DEVICES))
endif

POWERED_DEVICES := $(shell cat .powered-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .powered-devices failed: $(POWERED_DEVICES))
endif

PRESENCE_DEVICES := $(shell cat .presence-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .presence-devices failed: $(PRESENCE_DEVICES))
endif

ROLLER_BLINDS_DEVICES := $(shell cat .roller-blinds-devices-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .roller-blinds-devices failed: $(ROLLER_BLINDS_DEVICES))
endif

ULTRABRITE_SMART_WIFI_PLUG_DEVICES := $(shell cat .ultrabrite-smart-wp-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .ultrabrite-smart-wp-devices failed: $(ULTRABRITE_SMART_WIFI_PLUG_DEVICES))
endif

WORD_CLOCK_DEVICES := $(shell cat .word-clock-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .word-clock-devices failed: $(WORD_CLOCK_DEVICES))
endif


all: \
	template.bin \
	athom-mini-switch.bin \
	athom-rgbct-light.bin \
	athom-smart-plug-v2.bin \
	energy-monitor.bin \
	environmental.bin \
	environmental-v2.bin \
	esp32-cam.bin \
	powered.bin \
	presence.bin \
	roller-blinds.bin \
	ultrabrite-smart-wp.uf2 \
	word-clock.bin

##
## Template
##

.PHONY: template.bin
template.bin: template.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/template/.pioenvs/template/firmware.bin $@.tmp
	mv -f $@.tmp $@

template-clean:
	rm -f template.bin.tmp template.bin
clean: template-clean

##
## Athom Mini Switch
##

.PHONY: athom-mini-switch.bin
athom-mini-switch.bin: athom-mini-switch.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/athom-mini-switch/.pioenvs/athom-mini-switch/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: athom-mini-switch-upload
athom-mini-switch-upload: athom-mini-switch.bin
	@echo Uploading athom-mini-switch:
	@for device in $(ATHOM_MINI_SWITCH_DEVICES) ; do echo -n "  athom-mini-switch-$${device}.$(DOMAIN)..." ; curl -f -X POST https://athom-mini-switch-$${device}.$(DOMAIN)/update -F upload=@athom-mini-switch.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: athom-mini-switch-upload

.PHONY: athom-mini-switch-upload-serial
athom-mini-switch-upload-serial:
	$(ESPHOME) compile athom-mini-switch.yaml
	$(ESPHOME) upload --device $(SERIAL) athom-mini-switch.yaml

athom-mini-switch-clean:
	rm -f athom-mini-switch.bin.tmp athom-mini-switch.bin
clean: athom-mini-switch-clean

##
## Athom RGBCT Light
##

.PHONY: athom-rgbct-light.bin
athom-rgbct-light.bin: athom-rgbct-light.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/athom-rgbct-light/.pioenvs/athom-rgbct-light/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: athom-rgbct-light-upload
athom-rgbct-light-upload: athom-rgbct-light.bin
	@echo Uploading athom-rgbct-light:
	@for device in $(ATHOM_RGBCT_LIGHT_DEVICES) ; do echo -n "  athom-rgbct-light-$${device}.$(DOMAIN)..." ; curl -f -X POST https://athom-rgbct-light-$${device}.$(DOMAIN)/update -F upload=@athom-rgbct-light.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: athom-rgbct-light-upload

.PHONY: athom-rgbct-light-upload-serial
athom-rgbct-light-upload-serial:
	$(ESPHOME) compile athom-rgbct-light.yaml
	$(ESPHOME) upload --device $(SERIAL) athom-rgbct-light.yaml

athom-rgbct-light-clean:
	rm -f athom-rgbct-light.bin.tmp athom-rgbct-light.bin
clean: athom-rgbct-light-clean

##
## Athom Smart Plug V2
##

.PHONY: athom-smart-plug-v2.bin
athom-smart-plug-v2.bin: athom-smart-plug-v2.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/athom-smart-plug-v2/.pioenvs/athom-smart-plug-v2/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: athom-smart-plug-v2-upload
athom-smart-plug-v2-upload: athom-smart-plug-v2.bin
	@echo Uploading athom-smart-plug-v2:
	@for device in $(ATHOM_SMART_PLUG_V2_DEVICES) ; do echo -n "  athom-smart-plug-v2-$${device}.$(DOMAIN)..." ; curl -f -X POST https://athom-smart-plug-v2-$${device}.$(DOMAIN)/update -F upload=@athom-smart-plug-v2.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: athom-smart-plug-v2-upload

.PHONY: athom-smart-plug-v2-upload-serial
athom-smart-plug-v2-upload-serial:
	$(ESPHOME) compile athom-smart-plug-v2.yaml
	$(ESPHOME) upload --device $(SERIAL) athom-smart-plug-v2.yaml

athom-smart-plug-v2-clean:
	rm -f athom-smart-plug-v2.bin.tmp athom-smart-plug-v2.bin
clean: athom-smart-plug-v2-clean

##
## Energy Monitor
##

.PHONY: energy-monitor.bin
energy-monitor.bin: energy-monitor.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/energy-monitor/.pioenvs/energy-monitor/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: energy-monitor-upload
energy-monitor-upload: energy-monitor.bin
	@echo Uploading energy-monitor:
	@for device in $(ENERGY_MONITOR_DEVICES) ; do echo -n "  energy-monitor-$${device}.$(DOMAIN)..." ; curl -f -X POST https://energy-monitor-$${device}.$(DOMAIN)/update -F upload=@energy-monitor.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: energy-monitor-upload

.PHONY: energy-monitor-upload-serial
energy-monitor-upload-serial:
	$(ESPHOME) compile energy-monitor.yaml
	$(ESPHOME) upload --device $(SERIAL) energy-monitor.yaml

energy-monitor-clean:
	rm -f energy-monitor.bin.tmp energy-monitor.bin
clean: energy-monitor-clean

##
## Environmental
##

.PHONY: environmental.bin
environmental.bin: environmental.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/environmental/.pioenvs/environmental/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: environmental-upload
environmental-upload: environmental.bin
	@echo Uploading environmental:
	@for device in $(ENVIRONMENTAL_DEVICES) ; do echo -n "  environmental-$${device}.$(DOMAIN)..." ; curl -f -X POST https://environmental-$${device}.$(DOMAIN)/update -F upload=@environmental.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: environmental-upload

.PHONY: environmental-upload-serial
environmental-upload-serial:
	$(ESPHOME) compile environmental.yaml
	$(ESPHOME) upload --device $(SERIAL) environmental.yaml

environmental-clean:
	rm -f environmental.bin.tmp environmental.bin
clean: environmental-clean

##
## Environmental v2
##

.PHONY: environmental-v2.bin
environmental-v2.bin: environmental-v2.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/environmental-v2/.pioenvs/environmental-v2/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: environmental-v2-upload
environmental-v2-upload: environmental-v2.bin
	@echo Uploading environmental-v2:
	@for device in $(ENVIRONMENTAL_V2_DEVICES) ; do echo -n "  environmental-v2-$${device}.$(DOMAIN)..." ; curl -f -X POST https://environmental-v2-$${device}.$(DOMAIN)/update -F upload=@environmental-v2.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: environmental-v2-upload

.PHONY: environmental-v2-upload-serial
environmental-v2-upload-serial:
	$(ESPHOME) compile environmental-v2.yaml
	$(ESPHOME) upload --device $(SERIAL) environmental-v2.yaml

environmental-v2-clean:
	rm -f environmental-v2.bin.tmp environmental-v2.bin
clean: environmental-v2-clean

##
## ESP32 Cam
##

.PHONY: esp32-cam.bin
esp32-cam.bin: esp32-cam.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/esp32-cam/.pioenvs/esp32-cam/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: esp32-cam-upload
esp32-cam-upload: esp32-cam.bin
	@echo Uploaing esp32-cam:
	@for device in $(ESP32_CAM_DEVICES) ; do echo -n "  esp32-cam-$${device}.$(DOMAIN)..." ; curl -f -X POST https://esp32-cam-$${device}.$(DOMAIN)/update -F upload=@esp32-cam.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: esp32-cam-upload

.PHONY: esp32-cam-upload-serial
esp32-cam-upload-serial:
	$(ESPHOME) compile esp32-cam.yaml
	$(ESPHOME) upload --device $(SERIAL) esp32-cam.yaml

esp32-cam-clean:
	rm -f esp32-cam.bin.tmp esp32-cam.bin
clean: esp32-cam-clean

##
## Powered
##

.PHONY: powered.bin
powered.bin: powered.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/powered/.pioenvs/powered/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: powered-upload
powered-upload: powered.bin
	@echo Uploaing powered:
	@for device in $(POWERED_DEVICES) ; do echo -n "  powered-$${device}.$(DOMAIN)..." ; curl -f -X POST https://powered-$${device}.$(DOMAIN)/update -F upload=@powered.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: powered-upload

.PHONY: powered-upload-serial
powered-upload-serial:
	$(ESPHOME) compile powered.yaml
	$(ESPHOME) upload --device $(SERIAL) powered.yaml

powered-clean:
	rm -f powered.bin.tmp powered.bin
clean: powered-clean

##
## Presence
##

.PHONY: presence.bin
presence.bin: presence.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/presence/.pioenvs/presence/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: presence-upload
presence-upload: presence.bin
	@echo Uploaing presence:
	@for device in $(PRESENCE_DEVICES) ; do echo -n "  presence-$${device}.$(DOMAIN)..." ; curl -f -X POST https://presence-$${device}.$(DOMAIN)/update -F upload=@presence.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: presence-upload

.PHONY: presence-upload-serial
presence-upload-serial:
	$(ESPHOME) compile presence.yaml
	$(ESPHOME) upload --device $(SERIAL) presence.yaml

presence-clean:
	rm -f presence.bin.tmp presence.bin
clean: presence-clean

##
## Roller Blinds
##

.PHONY: roller-blinds.bin
roller-blinds.bin: roller-blinds.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/roller-blinds/.pioenvs/roller-blinds/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: roller-blinds-upload
roller-blinds-upload: roller-blinds.bin
	@echo Uploading roller-blinds:
	@for device in $(ROLLER_BLINDS_DEVICES) ; do echo -n "  roller-blinds-$${device}.$(DOMAIN)..." ; curl -f -X POST https://roller-blinds-$${device}.$(DOMAIN)/update -F upload=@roller-blinds.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: roller-blinds-upload

.PHONY: roller-blinds-upload-serial
roller-blinds-upload-serial:
	$(ESPHOME) compile roller-blinds.yaml
	$(ESPHOME) upload --device $(SERIAL) roller-blinds.yaml

roller-blinds-clean:
	rm -f roller-blinds.bin.tmp roller-blinds.bin
clean: roller-blinds-clean

##
## Ultrabrite Plug
##

ultrabrite-smart-wp.uf2: ultrabrite-smart-wp.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/ultrabrite-smart-wp/.pioenvs/ultrabrite-smart-wp/firmware.uf2 $@.tmp
	mv -f $@.tmp $@

.PHONY: ultrabrite-smart-wp-upload
ultrabrite-smart-wp-upload: ultrabrite-smart-wp.uf2
	@echo Uploading ultrabrite-smart-wp:
	@for device in $(ULTRABRITE_SMART_WIFI_PLUG_DEVICES) ; do echo -n "  ultrabrite-smart-wp-$${device}.$(DOMAIN)..." ; curl -f -X POST https://ultrabrite-smart-wp-$${device}.$(DOMAIN)/update -F upload=@ultrabrite-smart-wp.uf2 -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: ultrabrite-smart-wp-upload

.PHONY: ultrabrite-smart-wp-upload-serial
ultrabrite-smart-wp-upload-serial:
	$(ESPHOME) compile ultrabrite-smart-wp.yaml
	$(ESPHOME) upload --device $(SERIAL) ultrabrite-smart-wp.yaml

ultrabrite-smart-wp-clean:
	rm -f ultrabrite-smart-wp.uf2.tmp ultrabrite-smart-wp.uf2
clean: ultrabrite-smart-wp-clean

##
## Word Clock
##

.PHONY: word-clock.bin
word-clock.bin: word-clock.yaml word-clock.cpp word-clock.h
	$(ESPHOME) compile $<
	cp .esphome/build/word-clock/.pioenvs/word-clock/firmware.bin $@.tmp
	mv -f $@.tmp $@

.PHONY: word-clock-upload
word-clock-upload: word-clock.bin
	@echo Uploaing word-clock:
	@for device in $(WORD_CLOCK_DEVICES) ; do echo -n "  word-clock-$${device}.$(DOMAIN)..." ; curl -f -X POST https://word-clock-$${device}.$(DOMAIN)/update -F upload=@word-clock.bin -u "$(USERNAME):$(PASSWORD)" ; done
	@echo
upload: word-clock-upload

.PHONY: word-clock-upload-serial
word-clock-upload-serial:
	$(ESPHOME) compile word-clock.yaml
	$(ESPHOME) upload --device $(SERIAL) word-clock.yaml

word-clock-clean:
	rm -f word-clock.bin.tmp word-clock.bin
clean: word-clock-clean

##
## Upload
#

upload:

##
## Clean
##

clean:
