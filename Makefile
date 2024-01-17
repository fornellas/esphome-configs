SERIAL := $(shell cat .serial)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .serial failed: $(SERIAL))
endif

ESPHOME_VERSION = 2023.12.5
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

PRESENCE_DEVICES := $(shell cat .presence-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .presence-devices failed: $(PRESENCE_DEVICES))
endif

ULTRABRITE_SMART_WIFI_PLUG_DEVICES := $(shell cat .ultrabrite-smart-wp-devices)
ifneq ($(.SHELLSTATUS),0)
  $(error cat .ultrabrite-smart-wp-devices failed: $(ULTRABRITE_SMART_WIFI_PLUG_DEVICES))
endif

all: \
	template.bin \
	athom-rgbct-light.bin \
	athom-smart-plug-v2.bin \
	energy-monitor.bin \
	presence.bin \
	ultrabrite-smart-wp.uf2

##
## Template
##

template.bin: template.yaml
	$(ESPHOME) compile $<
	cp .esphome/build/template/.pioenvs/template/firmware.bin $@.tmp
	mv -f $@.tmp $@

template-clean:
	rm -f template.bin.tmp template.bin
clean: template-clean

##
## Athom RGBCT Light
##

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
## Presence
##

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
## Upload
#

upload:

##
## Clean
##

clean: