CUSTOM_MONGODB_VERSION_BASE = $(VERSION)
CUSTOM_MONGODB_VERSION = r$(CUSTOM_MONGODB_VERSION_BASE)
CUSTOM_MONGODB_SITE = $(call github,mongodb,mongo,$(CUSTOM_MONGODB_VERSION))
CUSTOM_MONGODB_SOURCE = mongo-$(CUSTOM_MONGODB_VERSION).tar.gz

CUSTOM_MONGODB_LICENSE = AGPLv3, Apache-2.0
CUSTOM_MONGODB_LICENSE_FILES = GNU-AGPL-3.0.txt APACHE-2.0.txt

CUSTOM_MONGODB_DEPENDENCIES += host-custom-scons host-python host-ncurses
CUSTOM_MONGODB_BUILD_OPTS += --wiredtiger=on
CUSTOM_MONGODB_BUILD_VARS += CC=$(TARGET_CC)
CUSTOM_MONGODB_BUILD_VARS += CXX=$(TARGET_CXX)
CUSTOM_MONGODB_BUILD_VARS += LIBPATH=$(STAGING_DIR)/lib64:$(STAGING_DIR)/usr/lib64
CUSTOM_MONGODB_BUILD_VARS += MONGO_VERSION=$(CUSTOM_MONGODB_VERSION_BASE)
CUSTOM_MONGODB_BUILD_VARS += MONGO_DISTNAME=$(CUSTOM_MONGODB_VERSION)
CUSTOM_MONGODB_BUILD_VARS += VARIANT_DIR=$(CUSTOM_MONGODB_VERSION_BASE)
CUSTOM_MONGODB_BUILD_VARS += TARGET_ARCH=x86_64
CUSTOM_MONGODB_BUILD_VARS += TARGET_OS=linux

ifeq ($(BR2_PACKAGE_CUSTOM_MONGODB_SSL),y)
CUSTOM_MONGODB_BUILD_OPTS += --ssl
CUSTOM_MONGODB_DEPENDENCIES += host-openssl openssl
endif

ifeq ($(BR2_PACKAGE_CUSTOM_MONGODB_MONGO),y)
CUSTOM_MONGODB_TARGETS += build/install/bin/mongo
endif

ifeq ($(BR2_PACKAGE_CUSTOM_MONGODB_MONGOD),y)
CUSTOM_MONGODB_TARGETS += build/install/bin/mongod
endif

ifeq ($(BR2_PACKAGE_CUSTOM_MONGODB_MONGOS),y)
CUSTOM_MONGODB_TARGETS += build/install/bin/mongos
endif

define CUSTOM_MONGODB_BUILD_CMDS
			 $(SCONS) $(CUSTOM_MONGODB_BUILD_OPTS) $(CUSTOM_MONGODB_TARGETS) -C $(@D) $(CUSTOM_MONGODB_BUILD_VARS)
endef

define CUSTOM_MONGODB_INSTALL_TARGET_CMDS
				mkdir -p $(TARGET_DIR)/usr/local/bin; \
				cd $(@D)/build/install; \
				cp -R bin/ $(TARGET_DIR)/usr/local
endef

$(eval $(generic-package))
