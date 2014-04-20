UDEVIL_VERSION = 0.4.3
UDEVIL_SITE = $(call github,IgnorantGuru,udevil,$(UDEVIL_VERSION))
UDEVIL_INSTALL_TARGET = YES
UDEVIL_AUTORECONF=YES

UDEVIL_DEPENDENCIES = 

UDEVIL_CONF_OPT+= --with-mount-prog=/bin/mount \
	--with-umount-prog=/bin/umount \
	--with-losetup-prog=/sbin/losetup \
	--with-setfacl-prog=/usr/bin/setfacl

define UDEVIL_SYSTEMD_INSTALL
	$(call install_systemd_files)
endef

UDEVIL_POST_INSTALL_TARGET_HOOKS += UDEVIL_SYSTEMD_INSTALL

$(eval $(autotools-package))
