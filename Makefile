include $(TOPDIR)/rules.mk

PKG_NAME:=neko-status
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/JohnsonRan/neko-status.git
PKG_SOURCE_VERSION:=f1ac09848211157f5990a82ca55f1bbeafc6db73
PKG_MIRROR_HASH:=2486f4d6d2fd452cf05da45b28562da67ab264aedb4b7925c3524a24db7eaaff

PKG_MAINTAINER:=JohnsonRan <me@ihtw.moe>
PKG_LICENSE:=MIT

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=$(PKG_NAME)
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
  URL:=https://github.com/nkeonkeo/nekonekostatus
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/neko-status/description
  Server TZ
endef

define Package/neko-status/conffiles
/etc/neko-status/config.yaml
endef

define Package/neko-status/install
	$(call GoPackage/Package/Install/Bin,$(1))
	
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

define Build/Prepare
	$(Build/Prepare/Default)
	$(RM) -r $(PKG_BUILD_DIR)/rules/logic_test
endef

$(eval $(call GoBinPackage,neko-status))
$(eval $(call BuildPackage,neko-status))