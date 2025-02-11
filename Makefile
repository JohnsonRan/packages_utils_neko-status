include $(TOPDIR)/rules.mk

PKG_NAME:=neko-status
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/nkeonkeo/nekonekostatus/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=4e233ccb88f5c669c0e0804e1820b1bf618b94c411485f65f7f592f0f375d27d

PKG_MAINTAINER:=JohnsonRan <me@ihtw.moe>
PKG_LICENSE:=MIT
PKG_LICENSE_FILE:=LICENSE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=neko-status
GO_PKG_BUILD_PKG:=$(GO_PKG)
CGO_ENABLED:=0
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:=main.version=v$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/neko-status
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Server TZ
  DEPENDS:=$(GO_ARCH_DEPENDS)
  MAINTAINER:=$(PKG_MAINTAINER)
endef

define Package/neko-status/description
  Server TZ
endef

define Package/neko-status/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/neko-status $(1)/usr/bin/neko-status
	
	$(INSTALL_DIR) $(1)/etc/neko-status
	$(INSTALL_CONF) $(CURDIR)/files/config.yaml $(1)/etc/neko-status
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(CURDIR)/files/neko-status.init $(1)/etc/init.d/neko-status
endef

define Package/neko-status/postrm
#!/bin/sh
if [ -z $${IPKG_INSTROOT} ]; then
	service neko-status stop > /dev/null 2>&1
	rm /etc/init.d/neko-status > /dev/null 2>&1
	EOF
fi
endef

$(eval $(call GoBinPackage,neko-status))
$(eval $(call BuildPackage,neko-status))