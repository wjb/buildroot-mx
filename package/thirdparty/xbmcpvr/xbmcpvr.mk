XBMCPVR_VERSION = 82dd3c498624006b82e33d1b3036188b912b4d84
XBMCPVR_SITE = $(call github,opdenkamp,xbmc-pvr-addons,$(XBMCPVR_VERSION))
XBMCPVR_AUTORECONF = YES
XBMCPVR_INSTALL_STAGING = YES
XBMCPVR_INSTALL_TARGET = YES

XBMCPVR_CONF_ENV += MYSQL_CONFIG=$(TARGET_DIR)/usr/bin/mysql_config
XBMCPVR_CONF_OPT += --enable-addons-with-dependencies

$(eval $(call autotools-package,package/thirdparty,xbmcpvr))

