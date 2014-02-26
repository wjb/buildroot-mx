define enable_service
	mkdir -p $$TARGET_DIR/lib/systemd/system/`grep '^WantedBy' $$TARGET_DIR/lib/systemd/system/$(call qstrip, $1) | cut -f2 -d=`.wants
	ln -sf ../$(call qstrip, $1) $$TARGET_DIR/lib/systemd/system/`grep '^WantedBy' $$TARGET_DIR/lib/systemd/system/$(call qstrip, $1) | cut -f2 -d=`.wants/
endef

define install_systemd_files
#	echo "BUILD_DIR: $(BUILD_DIR)"
#	echo "TARGET_DIR: $(TARGET_DIR)"
#	echo "PKG: $(PKG)";
#	echo "PKG_VERSION: $($(PKG)_VERSION)"
#	echo "PKG_DIR_PREFIX: $($(PKG)_DIR_PREFIX)"
#	echo "PKG_RAWNAME: $($(PKG)_RAWNAME)"
	if test -d $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/profile.d; then \
		mkdir -p $(TARGET_DIR)/etc/profile.d; \
		cp $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/profile.d/*.conf $(TARGET_DIR)/etc/profile.d/; \
	fi;

	if test -d $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/tmpfiles.d; then \
		mkdir -p $(TARGET_DIR)/usr/lib/tmpfiles.d; \
		cp $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/tmpfiles.d/*.conf $(TARGET_DIR)/usr/lib/tmpfiles.d/; \
	fi;

	if test -d $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/system.d; then \
		mkdir -p $(TARGET_DIR)/lib/systemd/system; \
		cp $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/system.d/*.* $(TARGET_DIR)/lib/systemd/system/; \
	fi;

	if test -d $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/udev.d; then \
		mkdir -p $(TARGET_DIR)/lib/udev/rules.d; \
		cp $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/udev.d/*.rules $(TARGET_DIR)/lib/udev/rules.d/; \
	fi;

	if test -d $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/sysctl.d; then \
		mkdir -p $(TARGET_DIR)/usr/lib/sysctl.d; \
		cp $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/sysctl.d/*.conf $(TARGET_DIR)/usr/lib/sysctl.d/; \
	fi;

	if test -d $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/modules-load.d; then \
		mkdir -p $(TARGET_DIR)/usr/lib/modules-load.d; \
		cp $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/modules-load.d/*.conf $(TARGET_DIR)/usr/lib/modules-load.d/; \
	fi;

	if test -d $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/sysconf.d; then \
		mkdir -p $(TARGET_DIR)/etc/sysconf.d; \
		cp $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/sysconf.d/*.conf $(TARGET_DIR)/etc/sysconf.d/; \
	fi;

	if test -d $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/debug.d; then \
		mkdir -p $(TARGET_DIR)/usr/share/debugconf; \
		cp $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/debug.d/*.conf $(TARGET_DIR)/usr/share/debugconf/; \
	fi;

	if test -d $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/scripts.d; then \
		mkdir -p $(TARGET_DIR)/lib/amlinux; \
		cp $($(PKG)_DIR_PREFIX)$($(PKG)_RAWNAME)/scripts.d/* $(TARGET_DIR)/lib/amlinux/; \
	fi;
endef
