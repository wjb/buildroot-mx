################################################################################
#
# connman
#
################################################################################

CONNMAN_VERSION = 1.21
CONNMAN_SOURCE = connman-$(CONNMAN_VERSION).tar.xz
CONNMAN_SITE = $(BR2_KERNEL_MIRROR)/linux/network/connman/
CONNMAN_DEPENDENCIES = libglib2 dbus iptables gnutls
CONNMAN_INSTALL_STAGING = YES
CONNMAN_LICENSE = GPLv2
CONNMAN_LICENSE_FILES = COPYING
CONNMAN_CONF_OPT += --localstatedir=/root/.cache \
	$(if $(BR2_PACKAGE_CONNMAN_DEBUG),--enable-debug,--disable-debug)		\
	$(if $(BR2_PACKAGE_CONNMAN_ETHERNET),--enable-ethernet,--disable-ethernet)	\
	$(if $(BR2_PACKAGE_CONNMAN_WIFI),--enable-wifi,--disable-wifi)			\
	$(if $(BR2_PACKAGE_CONNMAN_BLUETOOTH),--enable-bluetooth,--disable-bluetooth)	\
	$(if $(BR2_PACKAGE_CONNMAN_LOOPBACK),--enable-loopback,--disable-loopback)	\
	$(if $(BR2_PACKAGE_CONNMAN_NEARD),--enable-neard,--disable-neard) \
	$(if $(BR2_PACKAGE_CONNMAN_OFONO),--enable-ofono,--disable-ofono) \
	$(if $(BR2_INIT_SYSTEMD),--with-systemdunitdir=/lib/systemd/system)

CONNMAN_DEPENDENCIES += \
	$(if $(BR2_PACKAGE_CONNMAN_NEARD),neard) \
	$(if $(BR2_PACKAGE_CONNMAN_OFONO),ofono)

ifeq ($(BR2_PACKAGE_OPENVPN),y)
CONNMAN_CONF_OPT += --enable-openvpn --with-openvpn=/usr/sbin/openvpn
else
CONNMAN_CONF_OPT += --disable-openvpn
endif

ifeq ($(BR2_PACKAGE_PPTP_LINUX),y)
CONNMAN_CONF_OPT += --enable-pptp PPPD=/usr/sbin/pppd PPTP=/usr/sbin/pptp
CONNMAN_DEPENDENCIES += pppd pptp-linux
else
CONNMAN_CONF_OPT += --disable-pptp
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT),y)
CONNMAN_CONF_OPT += WPASUPPLICANT=/usr/sbin/wpa_supplicant
endif

CONNMAN_MAKE_OPT = storagedir=/root/.cache/connman \
                   vpn_storagedir=/root/.config/vpn-config

define CONNMAN_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/connman/S45connman $(TARGET_DIR)/etc/init.d/S45connman
endef


ifeq ($(BR2_PACKAGE_CONNMAN_CLIENT),y)
CONNMAN_CONF_OPT += --enable-client
CONNMAN_DEPENDENCIES += readline

define CONNMAN_INSTALL_CM
	$(INSTALL) -m 0755 -D $(@D)/client/connmanctl $(TARGET_DIR)/usr/bin/connmanctl
endef

CONNMAN_POST_INSTALL_TARGET_HOOKS += CONNMAN_INSTALL_CM
else
CONNMAN_CONF_OPT += --disable-client
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
define CONNMAN_SYSTEMD_INSTALL
	$(call install_systemd_files)
	$(call enable_service, connman.service)
	$(call enable_service, connman-vpn.service)
	$(call enable_service, hostname.service)
endef

CONNMAN_POST_INSTALL_TARGET_HOOKS += CONNMAN_SYSTEMD_INSTALL
endif

$(eval $(autotools-package))
