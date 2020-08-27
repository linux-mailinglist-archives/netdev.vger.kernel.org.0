Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A6B253BC2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 04:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgH0CAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 22:00:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54362 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgH0CAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 22:00:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kB7Dc-00C1gX-Pa; Thu, 27 Aug 2020 04:00:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 5/5] net: phy: Sort Kconfig and Makefile
Date:   Thu, 27 Aug 2020 04:00:32 +0200
Message-Id: <20200827020032.2866339-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200827020032.2866339-1-andrew@lunn.ch>
References: <20200827020032.2866339-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sort the Kconfig based on the text shown in make menuconfig and sort
the Makefile by CONFIG symbol.

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/Kconfig  | 164 +++++++++++++++++++--------------------
 drivers/net/phy/Makefile |  10 +--
 2 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 20252d7487db..698bea312adc 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -45,7 +45,15 @@ config LED_TRIGGER_PHY
 		for any speed known to the PHY.
 
 
-comment "MII PHY device drivers"
+config FIXED_PHY
+	tristate "MDIO Bus/PHY emulation with fixed speed/link PHYs"
+	depends on PHYLIB
+	select SWPHY
+	help
+	  Adds the platform "fixed" MDIO Bus to cover the boards that use
+	  PHYs that are not connected to the real MDIO bus.
+
+	  Currently tested with mpc866ads and mpc8349e-mitx.
 
 config SFP
 	tristate "SFP cage support"
@@ -53,6 +61,19 @@ config SFP
 	depends on HWMON || HWMON=n
 	select MDIO_I2C
 
+comment "MII PHY device drivers"
+
+config AMD_PHY
+	tristate "AMD PHYs"
+	help
+	  Currently supports the am79c874
+
+config MESON_GXL_PHY
+	tristate "Amlogic Meson GXL Internal PHY"
+	depends on ARCH_MESON || COMPILE_TEST
+	help
+	  Currently has a driver for the Amlogic Meson GXL Internal PHY
+
 config ADIN_PHY
 	tristate "Analog Devices Industrial Ethernet PHYs"
 	help
@@ -62,11 +83,6 @@ config ADIN_PHY
 	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
 	    Ethernet PHY
 
-config AMD_PHY
-	tristate "AMD PHYs"
-	help
-	  Currently supports the am79c874
-
 config AQUANTIA_PHY
 	tristate "Aquantia PHYs"
 	help
@@ -78,6 +94,24 @@ config AX88796B_PHY
 	  Currently supports the Asix Electronics PHY found in the X-Surf 100
 	  AX88796B package.
 
+config BROADCOM_PHY
+	tristate "Broadcom 54XX PHYs"
+	select BCM_NET_PHYLIB
+	help
+	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
+	  BCM5481, BCM54810 and BCM5482 PHYs.
+
+config BCM54140_PHY
+	tristate "Broadcom BCM54140 PHY"
+	depends on PHYLIB
+	depends on HWMON || HWMON=n
+	select BCM_NET_PHYLIB
+	help
+	  Support the Broadcom BCM54140 Quad SGMII/QSGMII PHY.
+
+	  This driver also supports the hardware monitoring of this PHY and
+	  exposes voltage and temperature sensors.
+
 config BCM63XX_PHY
 	tristate "Broadcom 63xx SOCs internal PHY"
 	depends on BCM63XX || COMPILE_TEST
@@ -92,6 +126,12 @@ config BCM7XXX_PHY
 	  Currently supports the BCM7366, BCM7439, BCM7445, and
 	  40nm and 65nm generation of BCM7xxx Set Top Box SoCs.
 
+config BCM84881_PHY
+	tristate "Broadcom BCM84881 PHY"
+	depends on PHYLIB
+	help
+	  Support the Broadcom BCM84881 PHY.
+
 config BCM87XX_PHY
 	tristate "Broadcom BCM8706 and BCM8727 PHYs"
 	help
@@ -113,30 +153,6 @@ config BCM_CYGNUS_PHY
 config BCM_NET_PHYLIB
 	tristate
 
-config BROADCOM_PHY
-	tristate "Broadcom PHYs"
-	select BCM_NET_PHYLIB
-	help
-	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
-	  BCM5481, BCM54810 and BCM5482 PHYs.
-
-config BCM54140_PHY
-	tristate "Broadcom BCM54140 PHY"
-	depends on PHYLIB
-	depends on HWMON || HWMON=n
-	select BCM_NET_PHYLIB
-	help
-	  Support the Broadcom BCM54140 Quad SGMII/QSGMII PHY.
-
-	  This driver also supports the hardware monitoring of this PHY and
-	  exposes voltage and temperature sensors.
-
-config BCM84881_PHY
-	tristate "Broadcom BCM84881 PHY"
-	depends on PHYLIB
-	help
-	  Support the Broadcom BCM84881 PHY.
-
 config CICADA_PHY
 	tristate "Cicada PHYs"
 	help
@@ -152,48 +168,16 @@ config DAVICOM_PHY
 	help
 	  Currently supports dm9161e and dm9131
 
-config DP83822_PHY
-	tristate "Texas Instruments DP83822/825/826 PHYs"
-	help
-	  Supports the DP83822, DP83825I, DP83825CM, DP83825CS, DP83825S,
-	  DP83826C and DP83826NC PHYs.
-
-config DP83TC811_PHY
-	tristate "Texas Instruments DP83TC811 PHY"
-	help
-	  Supports the DP83TC811 PHY.
-
-config DP83848_PHY
-	tristate "Texas Instruments DP83848 PHY"
-	help
-	  Supports the DP83848 PHY.
-
-config DP83867_PHY
-	tristate "Texas Instruments DP83867 Gigabit PHY"
-	help
-	  Currently supports the DP83867 PHY.
-
-config DP83869_PHY
-	tristate "Texas Instruments DP83869 Gigabit PHY"
-	help
-	  Currently supports the DP83869 PHY.  This PHY supports copper and
-	  fiber connections.
-
-config FIXED_PHY
-	tristate "MDIO Bus/PHY emulation with fixed speed/link PHYs"
-	depends on PHYLIB
-	select SWPHY
-	help
-	  Adds the platform "fixed" MDIO Bus to cover the boards that use
-	  PHYs that are not connected to the real MDIO bus.
-
-	  Currently tested with mpc866ads and mpc8349e-mitx.
-
 config ICPLUS_PHY
 	tristate "ICPlus PHYs"
 	help
 	  Currently supports the IP175C and IP1001 PHYs.
 
+config LXT_PHY
+	tristate "Intel LXT PHYs"
+	help
+	  Currently supports the lxt970, lxt971
+
 config INTEL_XWAY_PHY
 	tristate "Intel XWAY PHYs"
 	help
@@ -207,27 +191,16 @@ config LSI_ET1011C_PHY
 	help
 	  Supports the LSI ET1011C PHY.
 
-config LXT_PHY
-	tristate "Intel LXT PHYs"
-	help
-	  Currently supports the lxt970, lxt971
-
 config MARVELL_PHY
-	tristate "Marvell PHYs"
+	tristate "Marvell Alaska PHYs"
 	help
-	  Currently has a driver for the 88E1011S
+	  Currently has a driver for the 88E1XXX
 
 config MARVELL_10G_PHY
 	tristate "Marvell Alaska 10Gbit PHYs"
 	help
 	  Support for the Marvell Alaska MV88X3310 and compatible PHYs.
 
-config MESON_GXL_PHY
-	tristate "Amlogic Meson GXL Internal PHY"
-	depends on ARCH_MESON || COMPILE_TEST
-	help
-	  Currently has a driver for the Amlogic Meson GXL Internal PHY
-
 config MICREL_PHY
 	tristate "Micrel PHYs"
 	help
@@ -278,12 +251,12 @@ config REALTEK_PHY
 	  Supports the Realtek 821x PHY.
 
 config RENESAS_PHY
-	tristate "Driver for Renesas PHYs"
+	tristate "Renesas PHYs"
 	help
 	  Supports the Renesas PHYs uPD60620 and uPD60620A.
 
 config ROCKCHIP_PHY
-	tristate "Driver for Rockchip Ethernet PHYs"
+	tristate "Rockchip Ethernet PHYs"
 	help
 	  Currently supports the integrated Ethernet PHY.
 
@@ -302,6 +275,33 @@ config TERANETICS_PHY
 	help
 	  Currently supports the Teranetics TN2020
 
+config DP83822_PHY
+	tristate "Texas Instruments DP83822/825/826 PHYs"
+	help
+	  Supports the DP83822, DP83825I, DP83825CM, DP83825CS, DP83825S,
+	  DP83826C and DP83826NC PHYs.
+
+config DP83TC811_PHY
+	tristate "Texas Instruments DP83TC811 PHY"
+	help
+	  Supports the DP83TC811 PHY.
+
+config DP83848_PHY
+	tristate "Texas Instruments DP83848 PHY"
+	help
+	  Supports the DP83848 PHY.
+
+config DP83867_PHY
+	tristate "Texas Instruments DP83867 Gigabit PHY"
+	help
+	  Currently supports the DP83867 PHY.
+
+config DP83869_PHY
+	tristate "Texas Instruments DP83869 Gigabit PHY"
+	help
+	  Currently supports the DP83869 PHY.  This PHY supports copper and
+	  fiber connections.
+
 config VITESSE_PHY
 	tristate "Vitesse PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 3d83b648e3f0..a13e402074cf 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -37,32 +37,32 @@ ifdef CONFIG_HWMON
 aquantia-objs			+= aquantia_hwmon.o
 endif
 obj-$(CONFIG_AQUANTIA_PHY)	+= aquantia.o
-obj-$(CONFIG_AX88796B_PHY)	+= ax88796b.o
 obj-$(CONFIG_AT803X_PHY)	+= at803x.o
+obj-$(CONFIG_AX88796B_PHY)	+= ax88796b.o
+obj-$(CONFIG_BCM54140_PHY)	+= bcm54140.o
 obj-$(CONFIG_BCM63XX_PHY)	+= bcm63xx.o
 obj-$(CONFIG_BCM7XXX_PHY)	+= bcm7xxx.o
+obj-$(CONFIG_BCM84881_PHY)	+= bcm84881.o
 obj-$(CONFIG_BCM87XX_PHY)	+= bcm87xx.o
 obj-$(CONFIG_BCM_CYGNUS_PHY)	+= bcm-cygnus.o
 obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o
 obj-$(CONFIG_BROADCOM_PHY)	+= broadcom.o
-obj-$(CONFIG_BCM54140_PHY)	+= bcm54140.o
-obj-$(CONFIG_BCM84881_PHY)	+= bcm84881.o
 obj-$(CONFIG_CICADA_PHY)	+= cicada.o
 obj-$(CONFIG_CORTINA_PHY)	+= cortina.o
 obj-$(CONFIG_DAVICOM_PHY)	+= davicom.o
 obj-$(CONFIG_DP83640_PHY)	+= dp83640.o
 obj-$(CONFIG_DP83822_PHY)	+= dp83822.o
-obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
 obj-$(CONFIG_DP83848_PHY)	+= dp83848.o
 obj-$(CONFIG_DP83867_PHY)	+= dp83867.o
 obj-$(CONFIG_DP83869_PHY)	+= dp83869.o
+obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
 obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
 obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
 obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
 obj-$(CONFIG_LSI_ET1011C_PHY)	+= et1011c.o
 obj-$(CONFIG_LXT_PHY)		+= lxt.o
-obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
 obj-$(CONFIG_MARVELL_10G_PHY)	+= marvell10g.o
+obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
 obj-$(CONFIG_MESON_GXL_PHY)	+= meson-gxl.o
 obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
 obj-$(CONFIG_MICREL_PHY)	+= micrel.o
-- 
2.28.0

