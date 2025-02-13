include $(TOPDIR)/rules.mk

PKG_NAME:=neko-status
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/JohnsonRan/neko-status.git
PKG_SOURCE_VERSION:=ea0b95a308866f8fbf4e0638a2fa3e64bc204090
PKG_MIRROR_HASH:=7006e0efa85eb6d81540856ff40c7e74e955778971aaa4ab2845789b538a41bf

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
/etc/neko-status
endef

define Package/neko-status/install
	$(call GoPackage/Package/Install/Bin,$(1))

	$(INSTALL_DIR) $(1)/etc/neko-status
	$(INSTALL_CONF) $(CURDIR)/files/config.yaml $(1)/etc/neko-status

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(CURDIR)/files/neko-status.init $(1)/etc/init.d/neko-status
endef

define Build/Prepare
	$(Build/Prepare/Default)
	$(RM) -r $(PKG_BUILD_DIR)/rules/logic_test
endef

$(eval $(call GoBinPackage,neko-status))
$(eval $(call BuildPackage,neko-status))
