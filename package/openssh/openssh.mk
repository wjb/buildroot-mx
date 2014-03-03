################################################################################
#
# openssh
#
################################################################################

OPENSSH_VERSION = 6.5p1
OPENSSH_SITE = http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
OPENSSH_CONF_ENV = LD="$(TARGET_CC)" LDFLAGS="$(TARGET_CFLAGS)"
OPENSSH_CONF_OPT = --disable-lastlog --disable-utmp \
		--disable-utmpx --disable-wtmp --disable-wtmpx --disable-strip

OPENSSH_DEPENDENCIES = zlib openssl

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
OPENSSH_DEPENDENCIES += linux-pam
OPENSSH_CONF_OPT += --with-pam
endif

define OPENSSH_INSTALL_INIT_SYSTEMD
	$(call install_systemd_files)
	$(call enable_service, sshd.service)
	$(call enable_service, sshd-keygen.service)
	cp $(OPENSSH_PKGDIR)/config/ssh_config	$(TARGET_DIR)/etc/
	cp $(OPENSSH_PKGDIR)/config/sshd_config	$(TARGET_DIR)/etc/
endef

define OPENSSH_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/openssh/S50sshd \
		$(TARGET_DIR)/etc/init.d/S50sshd
endef

# Replace deprecated bcopy/bzero with memset/memcpy
define OPENSSH_REPLACE_SUSV3_DEPRECATED
	for src in `find $(@D) -name \*.c`; do \
		$(SED) "s/bzero(\(.*,\)/memset(\1 0, /" $${src} ;\
		$(SED) "s/bcopy(\(.*,\) \(.*,\)/memcpy(\2 \1/" $${src} ;\
	done
endef

OPENSSH_POST_PATCH_HOOKS += OPENSSH_REPLACE_SUSV3_DEPRECATED

$(eval $(autotools-package))
