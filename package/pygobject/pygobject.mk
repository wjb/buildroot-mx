#############################################################
#
# pygobject
#
#############################################################
PYGOBJECT_VERSION = 2.28.6
PYGOBJECT_SOURCE = pygobject-$(PYGOBJECT_VERSION).tar.bz2
PYGOBJECT_SITE = http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.28
PYGOBJECT_INSTALL_STAGING = YES
PYGOBJECT_INSTALL_TARGET = YES
PYGOBJECT_BUILD_OPKG = YES
PYGOBJECT_SECTION = python
PYGOBJECT_DESCRIPTION = The Python bindings for GObject
PYGOBJECT_OPKG_DEPENDENCIES = python,libglib2,libffi
PYGOBJECT_DEPENDENCIES = host-python python libglib2 libffi
PYGOBJECT_CONF_ENV = am_cv_pathless_PYTHON=python \
		ac_cv_path_PYTHON=$(HOST_DIR)/usr/bin/python \
		am_cv_python_version=$(PYTHON_VERSION) \
		am_cv_python_platform=linux2 \
		am_cv_python_pythondir=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
		am_cv_python_pyexecdir=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
		am_cv_python_includes=-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)
PYGOBJECT_CONF_OPT = \
    --enable-thread \
    --disable-introspection

$(eval $(autotools-package))
