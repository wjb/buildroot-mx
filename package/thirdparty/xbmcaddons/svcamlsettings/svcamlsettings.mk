SVCAMLSETTINGS_VERSION = 6dea23c
SVCAMLSETTINGS_SITE = $(call github,wjb,service.amlinux.settings,$(SVCAMLSETTINGS_VERSION))
SVCAMLSETTINGS_INSTALL_STAGING = YES
SVCAMLSETTINGS_INSTALL_TARGET = YES
SVCAMLSETTINGS_DEPENDENCIES = xbmc
SVCAMLSETTINGS_PATH = service.amlinux.settings

define SVCAMLSETTINGS_INSTALL_STAGING_CMDS
        if [ -d $(STAGING_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH) ]; then rm -rf $(STAGING_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/.*; rm -rf $(STAGING_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/*; rmdir $(STAGING_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH); fi;
        mkdir -p $(STAGING_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)
        cp -rf $(@D)/* $(STAGING_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/
endef

define SVCAMLSETTINGS_INSTALL_TARGET_CMDS
	if [ -d $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH) ]; then rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/.*; rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/*; rmdir $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH); fi;
	mkdir -p $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/resources
	cp -rf $(@D)/resources/* $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/resources/
	cp -f $(@D)/addon.xml $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/
	cp -f $(@D)/default.py $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/
	cp -f $(@D)/defaults.py $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/
	cp -f $(@D)/oe.py $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/
	cp -f $(@D)/service.py $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/
	cp -f $(@D)/icon.png $(TARGET_DIR)/usr/share/xbmc/addons/$(SVCAMLSETTINGS_PATH)/
endef

$(eval $(call xbmc-addon,package/thirdparty/xbmcaddons,svcamlsettings))

