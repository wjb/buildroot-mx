################################################################################
#
# systemd
#
################################################################################

SYSTEMD_VERSION = 211
SYSTEMD_SITE = http://www.freedesktop.org/software/systemd/
SYSTEMD_SOURCE = systemd-$(SYSTEMD_VERSION).tar.xz
SYSTEMD_LICENSE = GPLv2+
SYSTEMD_LICENSE_FILES = LICENSE.GPLV2 LICENSE.LGPL2.1 LICENSE.MIT
SYSTEMD_INSTALL_STAGING = YES
SYSTEMD_DEPENDENCIES = \
	host-intltool \
	host-coreutils \
	libcap \
	dbus \
	util-linux \
	kmod

# Make sure that systemd will always be built after busybox so that we have
# a consistent init setup between two builds
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
SYSTEMD_DEPENDENCIES += busybox
endif

SYSTEMD_CONF_OPT += \
	--with-rootprefix= \
	--with-rootlibdir=/lib \
	--localstatedir=/var \
	--enable-static=no \
	--disable-manpages \
	--disable-selinux \
	--disable-pam \
	--disable-libcryptsetup \
	--with-dbuspolicydir=/etc/dbus-1/system.d \
	--with-dbussessionservicedir=/usr/share/dbus-1/services \
	--with-dbussystemservicedir=/usr/share/dbus-1/system-services \
	--with-dbusinterfacedir=/usr/share/dbus-1/interfaces \
	--with-firmware-path=/lib/firmware \
	--enable-split-usr \
	--enable-introspection=no \
	--disable-multi-seat-x \
	--disable-networkd \
	--disable-efi \
	--disable-myhostname \
	--disable-tcpwrap \
	--disable-tests \
	--enable-logind \
	--enable-tmpfiles \
	--disable-machined \
	--disable-hostnamed \
	--disable-timedated \
	--disable-localed \
	--disable-backlight \
	--disable-binfmt \
	--disable-vconsole \
	--disable-readahead \
	--disable-quotacheck \
	--disable-randomseed \
	--without-python

ifeq ($(BR2_PACKAGE_ACL),y)
SYSTEMD_CONF_OPT += --enable-acl
SYSTEMD_DEPENDENCIES += acl
else
SYSTEMD_CONF_OPT += --disable-acl
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
SYSTEMD_CONF_OPT += --enable-gudev
SYSTEMD_DEPENDENCIES += libglib2
else
SYSTEMD_CONF_OPT += --disable-gudev
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_ALL_EXTRAS),y)
SYSTEMD_DEPENDENCIES += \
	xz 		\
	libgcrypt
SYSTEMD_CONF_OPT += 	\
	--enable-xz 	\
	--enable-gcrypt	\
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
SYSTEMD_CONF_OPT += 	\
	--disable-xz 	\
	--disable-gcrypt
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_JOURNAL_GATEWAY),y)
SYSTEMD_DEPENDENCIES += libmicrohttpd
else
SYSTEMD_CONF_OPT += --disable-microhttpd
endif

# mq_getattr needs -lrt
SYSTEMD_MAKE_OPT += LIBS=-lrt
SYSTEMD_MAKE_OPT += LDFLAGS+=-ldl

define SYSTEMD_INSTALL_INIT_HOOK
	ln -fs ../lib/systemd/systemd $(TARGET_DIR)/sbin/init
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/halt
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/poweroff
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/reboot
endef

define SYSTEMD_INSTALL_TTY_HOOK
	rm -f $(TARGET_DIR)/etc/systemd/system/getty.target.wants/getty@tty1.service
	ln -fs ../../../../lib/systemd/system/serial-getty@.service $(TARGET_DIR)/etc/systemd/system/getty.target.wants/serial-getty@$(BR2_TARGET_GENERIC_GETTY_PORT).service
endef

define SYSTEMD_INSTALL_MACHINEID_HOOK
	touch $(TARGET_DIR)/etc/machine-id
endef

define SYSTEMD_SANITIZE_PATH_IN_UNITS
	find $(TARGET_DIR)/lib/systemd/system -name '*.service' \
		-exec $(SED) 's,$(HOST_DIR),,g' {} \;
endef

define SYSTEMD_CLEANUP_UNITS
	rm -f $(TARGET_DIR)/lib/systemd/system-update-utmp
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-update-utmp-runlevel.service
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-update-utmp.service
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/systemd-update-utmp.service

	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-ask-password-wall.service
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-ask-password-wall.path
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-ask-password-console.service
	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-ask-password-console.path
	rm -f $(TARGET_DIR)/bin/systemd-ask-password
	rm -f $(TARGET_DIR)/bin/systemd-tty-ask-password-agent
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/systemd-ask-password-console.path
	rm -f $(TARGET_DIR)/lib/systemd/system/multi-user.target.wants/systemd-ask-password-wall.path

	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-fsck-root.service
	rm -f $(TARGET_DIR)/lib/systemd/system/local-fs.target.wants/systemd-fsck-root.service

	rm -f $(TARGET_DIR)/lib/systemd/system/systemd-binfmt.service
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/systemd-binfmt.service
	rm -f $(TARGET_DIR)/lib/systemd/system/proc-sys-fs-binfmt_misc.mount
	rm -f $(TARGET_DIR)/lib/systemd/system/proc-sys-fs-binfmt_misc.automount
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/proc-sys-fs-binfmt_misc.automount

	rm -f $(TARGET_DIR)/lib/systemd/system/autovt@.service
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/systemd-vconsole-setup.service

	rm -f $(TARGET_DIR)/lib/systemd/system/getty.target
	rm -f $(TARGET_DIR)/lib/systemd/system/getty@.service
	rm -f $(TARGET_DIR)/lib/systemd/system/getty.target.wants
	rm -f $(TARGET_DIR)/lib/systemd/system/console-getty.service

	rm -f $(TARGET_DIR)/usr/lib/tmpfiles.d/legacy.conf

	ln -sf /lib/systemd/system/console-debug.service $(TARGET_DIR)/lib/systemd/system/multi-user.target.wants/console-debug.service
endef

SYSTEMD_POST_INSTALL_TARGET_HOOKS += \
	SYSTEMD_INSTALL_INIT_HOOK \
	SYSTEMD_INSTALL_TTY_HOOK \
	SYSTEMD_INSTALL_MACHINEID_HOOK \
	SYSTEMD_SANITIZE_PATH_IN_UNITS \
	SYSTEMD_CLEANUP_UNITS

define SYSTEMD_USERS
	systemd-journal -1 systemd-journal -1 * /var/log/journal - - Journal
	systemd-journal-gateway -1 systemd-journal-gateway -1 * /var/log/journal - - Journal Gateway
endef

ifeq ($(BR2_INIT_SYSTEMD),y)
define SYSTEMD_SYSTEMD_INSTALL
	$(call install_systemd_files)
endef

SYSTEMD_POST_INSTALL_TARGET_HOOKS += SYSTEMD_SYSTEMD_INSTALL
endif

$(eval $(autotools-package))
