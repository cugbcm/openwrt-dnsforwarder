include $(TOPDIR)/rules.mk

PKG_NAME:=dnsforwarder
PKG_VERSION:=6
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/holmium/dnsforwarder.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=90c86f91f02d0e31ca32b67899d734b3072260bf
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-6



include $(INCLUDE_DIR)/package.mk

define Package/dnsforwarder
  SECTION:=net
  CATEGORY:=Network
  TITLE:=A simple DNS forwarder
  URL:=https://github.com/holmium/dnsforwarder
  DEPENDS:=+wget +ipset +dnsmasq-full
endef

define Package/dnsforwarder/description
Forwarding queries to customized domains (and their subdomains) to specified servers over a specified protocol (UDP or TCP). non-standard ports are supported.
endef


define Package/$(PKG_NAME)/postinst
#!/bin/sh
rm -rf /tmp/luci*
endef

define Package/dnsforwarder/conffiles
/etc/dnsforwarder/dnsforwarder.conf
/etc/dnsforwarder/china-banned
/etc/dnsforwarder/base-gfwlist.txt
/etc/dnsforwarder/userlist
endef

define Build/Prepare
	$(Build/Prepare/Default)
	$(foreach po,$(wildcard ${CURDIR}/i18n/zh-cn/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef


CONFIGURE_ARGS += --enable-downloader=wget


define Package/dnsforwarder/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dnsforwarder $(1)/usr/bin/dnsforwarder
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/*.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,dnsforwarder))
