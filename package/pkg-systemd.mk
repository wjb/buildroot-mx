define enable_service
	mkdir -p $$TARGET_DIR/lib/systemd/system/`grep '^WantedBy' $$TARGET_DIR/lib/systemd/system/$(call qstrip, $1) | cut -f2 -d=`.wants
	ln -sf ../$(call qstrip, $1) $$TARGET_DIR/lib/systemd/system/`grep '^WantedBy' $$TARGET_DIR/lib/systemd/system/$(call qstrip, $1) | cut -f2 -d=`.wants/
endef

define install_systemd_files
#	echo "PKGDIR = $(TOPDIR)/$($(PKG)_PKGDIR)"
	if test -d $(TOPDIR)/$($(PKG)_PKGDIR)/profile.d; then \
		mkdir -p $(TARGET_DIR)/etc/profile.d; \
		cp $(TOPDIR)/$($(PKG)_PKGDIR)/profile.d/*.conf $(TARGET_DIR)/etc/profile.d/; \
	fi;

	if test -d $(TOPDIR)/$($(PKG)_PKGDIR)/tmpfiles.d; then \
		mkdir -p $(TARGET_DIR)/usr/lib/tmpfiles.d; \
		cp $(TOPDIR)/$($(PKG)_PKGDIR)/tmpfiles.d/*.conf $(TARGET_DIR)/usr/lib/tmpfiles.d/; \
	fi;

	if test -d $(TOPDIR)/$($(PKG)_PKGDIR)/system.d; then \
		mkdir -p $(TARGET_DIR)/lib/systemd/system; \
		cp $(TOPDIR)/$($(PKG)_PKGDIR)/system.d/*.* $(TARGET_DIR)/lib/systemd/system/; \
	fi;

	if test -d $(TOPDIR)/$($(PKG)_PKGDIR)/udev.d; then \
		mkdir -p $(TARGET_DIR)/lib/udev/rules.d; \
		cp $(TOPDIR)/$($(PKG)_PKGDIR)/udev.d/*.rules $(TARGET_DIR)/lib/udev/rules.d/; \
	fi;

	if test -d $(TOPDIR)/$($(PKG)_PKGDIR)/sysctl.d; then \
		mkdir -p $(TARGET_DIR)/usr/lib/sysctl.d; \
		cp $(TOPDIR)/$($(PKG)_PKGDIR)/sysctl.d/*.conf $(TARGET_DIR)/usr/lib/sysctl.d/; \
	fi;

	if test -d $(TOPDIR)/$($(PKG)_PKGDIR)/modules-load.d; then \
		mkdir -p $(TARGET_DIR)/usr/lib/modules-load.d; \
		cp $(TOPDIR)/$($(PKG)_PKGDIR)/modules-load.d/*.conf $(TARGET_DIR)/usr/lib/modules-load.d/; \
	fi;

	if test -d $(TOPDIR)/$($(PKG)_PKGDIR)/sysconf.d; then \
		mkdir -p $(TARGET_DIR)/etc/sysconf.d; \
		cp $(TOPDIR)/$($(PKG)_PKGDIR)/sysconf.d/*.conf $(TARGET_DIR)/etc/sysconf.d/; \
	fi;

	if test -d $(TOPDIR)/$($(PKG)_PKGDIR)/debug.d; then \
		mkdir -p $(TARGET_DIR)/usr/share/debugconf; \
		cp $(TOPDIR)/$($(PKG)_PKGDIR)/debug.d/*.conf $(TARGET_DIR)/usr/share/debugconf/; \
	fi;

	if test -d $(TOPDIR)/$($(PKG)_PKGDIR)/scripts.d; then \
		mkdir -p $(TARGET_DIR)/lib/amlinux; \
		cp $(TOPDIR)/$($(PKG)_PKGDIR)/scripts.d/* $(TARGET_DIR)/lib/amlinux/; \
	fi;
endef
