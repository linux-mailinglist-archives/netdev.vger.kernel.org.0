Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF5D3A3C17
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhFKGmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:42:20 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9073 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhFKGmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:42:14 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1WNh5mlkzYrk9;
        Fri, 11 Jun 2021 14:37:24 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:14 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 5/8] net: phy: fixed space alignment issues
Date:   Fri, 11 Jun 2021 14:36:56 +0800
Message-ID: <1623393419-2521-6-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

There are some space related issues, including spaces at the start of the
line, before tabs, after open parenthesis and before close parenthesis.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/phy/davicom.c    |   4 +-
 drivers/net/phy/phy-core.c   | 158 +++++++++++++++++++++----------------------
 drivers/net/phy/sfp-bus.c    |  28 ++++----
 drivers/net/phy/spi_ks8995.c |  10 +--
 drivers/net/phy/ste10Xp.c    |   6 +-
 5 files changed, 103 insertions(+), 103 deletions(-)

diff --git a/drivers/net/phy/davicom.c b/drivers/net/phy/davicom.c
index a3b3842c6..23aed41 100644
--- a/drivers/net/phy/davicom.c
+++ b/drivers/net/phy/davicom.c
@@ -43,10 +43,10 @@
 #define MII_DM9161_INTR_DPLX_CHANGE	0x0010
 #define MII_DM9161_INTR_SPD_CHANGE	0x0008
 #define MII_DM9161_INTR_LINK_CHANGE	0x0004
-#define MII_DM9161_INTR_INIT 		0x0000
+#define MII_DM9161_INTR_INIT		0x0000
 #define MII_DM9161_INTR_STOP	\
 (MII_DM9161_INTR_DPLX_MASK | MII_DM9161_INTR_SPD_MASK \
- | MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)
+	| MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)
 #define MII_DM9161_INTR_CHANGE	\
 	(MII_DM9161_INTR_DPLX_CHANGE | \
 	 MII_DM9161_INTR_SPD_CHANGE | \
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 2870c33..c8d8ef8 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -84,98 +84,98 @@ EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 
 static const struct phy_setting settings[] = {
 	/* 400G */
-	PHY_SETTING( 400000, FULL, 400000baseCR8_Full		),
-	PHY_SETTING( 400000, FULL, 400000baseKR8_Full		),
-	PHY_SETTING( 400000, FULL, 400000baseLR8_ER8_FR8_Full	),
-	PHY_SETTING( 400000, FULL, 400000baseDR8_Full		),
-	PHY_SETTING( 400000, FULL, 400000baseSR8_Full		),
-	PHY_SETTING( 400000, FULL, 400000baseCR4_Full		),
-	PHY_SETTING( 400000, FULL, 400000baseKR4_Full		),
-	PHY_SETTING( 400000, FULL, 400000baseLR4_ER4_FR4_Full	),
-	PHY_SETTING( 400000, FULL, 400000baseDR4_Full		),
-	PHY_SETTING( 400000, FULL, 400000baseSR4_Full		),
+	PHY_SETTING(400000, FULL, 400000baseCR8_Full),
+	PHY_SETTING(400000, FULL, 400000baseKR8_Full),
+	PHY_SETTING(400000, FULL, 400000baseLR8_ER8_FR8_Full),
+	PHY_SETTING(400000, FULL, 400000baseDR8_Full),
+	PHY_SETTING(400000, FULL, 400000baseSR8_Full),
+	PHY_SETTING(400000, FULL, 400000baseCR4_Full),
+	PHY_SETTING(400000, FULL, 400000baseKR4_Full),
+	PHY_SETTING(400000, FULL, 400000baseLR4_ER4_FR4_Full),
+	PHY_SETTING(400000, FULL, 400000baseDR4_Full),
+	PHY_SETTING(400000, FULL, 400000baseSR4_Full),
 	/* 200G */
-	PHY_SETTING( 200000, FULL, 200000baseCR4_Full		),
-	PHY_SETTING( 200000, FULL, 200000baseKR4_Full		),
-	PHY_SETTING( 200000, FULL, 200000baseLR4_ER4_FR4_Full	),
-	PHY_SETTING( 200000, FULL, 200000baseDR4_Full		),
-	PHY_SETTING( 200000, FULL, 200000baseSR4_Full		),
-	PHY_SETTING( 200000, FULL, 200000baseCR2_Full		),
-	PHY_SETTING( 200000, FULL, 200000baseKR2_Full		),
-	PHY_SETTING( 200000, FULL, 200000baseLR2_ER2_FR2_Full	),
-	PHY_SETTING( 200000, FULL, 200000baseDR2_Full		),
-	PHY_SETTING( 200000, FULL, 200000baseSR2_Full		),
+	PHY_SETTING(200000, FULL, 200000baseCR4_Full),
+	PHY_SETTING(200000, FULL, 200000baseKR4_Full),
+	PHY_SETTING(200000, FULL, 200000baseLR4_ER4_FR4_Full),
+	PHY_SETTING(200000, FULL, 200000baseDR4_Full),
+	PHY_SETTING(200000, FULL, 200000baseSR4_Full),
+	PHY_SETTING(200000, FULL, 200000baseCR2_Full),
+	PHY_SETTING(200000, FULL, 200000baseKR2_Full),
+	PHY_SETTING(200000, FULL, 200000baseLR2_ER2_FR2_Full),
+	PHY_SETTING(200000, FULL, 200000baseDR2_Full),
+	PHY_SETTING(200000, FULL, 200000baseSR2_Full),
 	/* 100G */
-	PHY_SETTING( 100000, FULL, 100000baseCR4_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseKR4_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseLR4_ER4_Full	),
-	PHY_SETTING( 100000, FULL, 100000baseSR4_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseCR2_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseKR2_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseLR2_ER2_FR2_Full	),
-	PHY_SETTING( 100000, FULL, 100000baseDR2_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseSR2_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseCR_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseKR_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseLR_ER_FR_Full	),
-	PHY_SETTING( 100000, FULL, 100000baseDR_Full		),
-	PHY_SETTING( 100000, FULL, 100000baseSR_Full		),
+	PHY_SETTING(100000, FULL, 100000baseCR4_Full),
+	PHY_SETTING(100000, FULL, 100000baseKR4_Full),
+	PHY_SETTING(100000, FULL, 100000baseLR4_ER4_Full),
+	PHY_SETTING(100000, FULL, 100000baseSR4_Full),
+	PHY_SETTING(100000, FULL, 100000baseCR2_Full),
+	PHY_SETTING(100000, FULL, 100000baseKR2_Full),
+	PHY_SETTING(100000, FULL, 100000baseLR2_ER2_FR2_Full),
+	PHY_SETTING(100000, FULL, 100000baseDR2_Full),
+	PHY_SETTING(100000, FULL, 100000baseSR2_Full),
+	PHY_SETTING(100000, FULL, 100000baseCR_Full),
+	PHY_SETTING(100000, FULL, 100000baseKR_Full),
+	PHY_SETTING(100000, FULL, 100000baseLR_ER_FR_Full),
+	PHY_SETTING(100000, FULL, 100000baseDR_Full),
+	PHY_SETTING(100000, FULL, 100000baseSR_Full),
 	/* 56G */
-	PHY_SETTING(  56000, FULL,  56000baseCR4_Full	  	),
-	PHY_SETTING(  56000, FULL,  56000baseKR4_Full	  	),
-	PHY_SETTING(  56000, FULL,  56000baseLR4_Full	  	),
-	PHY_SETTING(  56000, FULL,  56000baseSR4_Full	  	),
+	PHY_SETTING(56000, FULL, 56000baseCR4_Full),
+	PHY_SETTING(56000, FULL, 56000baseKR4_Full),
+	PHY_SETTING(56000, FULL, 56000baseLR4_Full),
+	PHY_SETTING(56000, FULL, 56000baseSR4_Full),
 	/* 50G */
-	PHY_SETTING(  50000, FULL,  50000baseCR2_Full		),
-	PHY_SETTING(  50000, FULL,  50000baseKR2_Full		),
-	PHY_SETTING(  50000, FULL,  50000baseSR2_Full		),
-	PHY_SETTING(  50000, FULL,  50000baseCR_Full		),
-	PHY_SETTING(  50000, FULL,  50000baseKR_Full		),
-	PHY_SETTING(  50000, FULL,  50000baseLR_ER_FR_Full	),
-	PHY_SETTING(  50000, FULL,  50000baseDR_Full		),
-	PHY_SETTING(  50000, FULL,  50000baseSR_Full		),
+	PHY_SETTING(50000, FULL, 50000baseCR2_Full),
+	PHY_SETTING(50000, FULL, 50000baseKR2_Full),
+	PHY_SETTING(50000, FULL, 50000baseSR2_Full),
+	PHY_SETTING(50000, FULL, 50000baseCR_Full),
+	PHY_SETTING(50000, FULL, 50000baseKR_Full),
+	PHY_SETTING(50000, FULL, 50000baseLR_ER_FR_Full),
+	PHY_SETTING(50000, FULL, 50000baseDR_Full),
+	PHY_SETTING(50000, FULL, 50000baseSR_Full),
 	/* 40G */
-	PHY_SETTING(  40000, FULL,  40000baseCR4_Full		),
-	PHY_SETTING(  40000, FULL,  40000baseKR4_Full		),
-	PHY_SETTING(  40000, FULL,  40000baseLR4_Full		),
-	PHY_SETTING(  40000, FULL,  40000baseSR4_Full		),
+	PHY_SETTING(40000, FULL, 40000baseCR4_Full),
+	PHY_SETTING(40000, FULL, 40000baseKR4_Full),
+	PHY_SETTING(40000, FULL, 40000baseLR4_Full),
+	PHY_SETTING(40000, FULL, 40000baseSR4_Full),
 	/* 25G */
-	PHY_SETTING(  25000, FULL,  25000baseCR_Full		),
-	PHY_SETTING(  25000, FULL,  25000baseKR_Full		),
-	PHY_SETTING(  25000, FULL,  25000baseSR_Full		),
+	PHY_SETTING(25000, FULL, 25000baseCR_Full),
+	PHY_SETTING(25000, FULL, 25000baseKR_Full),
+	PHY_SETTING(25000, FULL, 25000baseSR_Full),
 	/* 20G */
-	PHY_SETTING(  20000, FULL,  20000baseKR2_Full		),
-	PHY_SETTING(  20000, FULL,  20000baseMLD2_Full		),
+	PHY_SETTING(20000, FULL, 20000baseKR2_Full),
+	PHY_SETTING(20000, FULL, 20000baseMLD2_Full),
 	/* 10G */
-	PHY_SETTING(  10000, FULL,  10000baseCR_Full		),
-	PHY_SETTING(  10000, FULL,  10000baseER_Full		),
-	PHY_SETTING(  10000, FULL,  10000baseKR_Full		),
-	PHY_SETTING(  10000, FULL,  10000baseKX4_Full		),
-	PHY_SETTING(  10000, FULL,  10000baseLR_Full		),
-	PHY_SETTING(  10000, FULL,  10000baseLRM_Full		),
-	PHY_SETTING(  10000, FULL,  10000baseR_FEC		),
-	PHY_SETTING(  10000, FULL,  10000baseSR_Full		),
-	PHY_SETTING(  10000, FULL,  10000baseT_Full		),
+	PHY_SETTING(10000, FULL, 10000baseCR_Full),
+	PHY_SETTING(10000, FULL, 10000baseER_Full),
+	PHY_SETTING(10000, FULL, 10000baseKR_Full),
+	PHY_SETTING(10000, FULL, 10000baseKX4_Full),
+	PHY_SETTING(10000, FULL, 10000baseLR_Full),
+	PHY_SETTING(10000, FULL, 10000baseLRM_Full),
+	PHY_SETTING(10000, FULL, 10000baseR_FEC),
+	PHY_SETTING(10000, FULL, 10000baseSR_Full),
+	PHY_SETTING(10000, FULL, 10000baseT_Full),
 	/* 5G */
-	PHY_SETTING(   5000, FULL,   5000baseT_Full		),
+	PHY_SETTING(5000, FULL, 5000baseT_Full),
 	/* 2.5G */
-	PHY_SETTING(   2500, FULL,   2500baseT_Full		),
-	PHY_SETTING(   2500, FULL,   2500baseX_Full		),
+	PHY_SETTING(2500, FULL, 2500baseT_Full),
+	PHY_SETTING(2500, FULL, 2500baseX_Full),
 	/* 1G */
-	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
-	PHY_SETTING(   1000, FULL,   1000baseT_Full		),
-	PHY_SETTING(   1000, HALF,   1000baseT_Half		),
-	PHY_SETTING(   1000, FULL,   1000baseT1_Full		),
-	PHY_SETTING(   1000, FULL,   1000baseX_Full		),
+	PHY_SETTING(1000, FULL, 1000baseKX_Full),
+	PHY_SETTING(1000, FULL, 1000baseT_Full),
+	PHY_SETTING(1000, HALF, 1000baseT_Half),
+	PHY_SETTING(1000, FULL, 1000baseT1_Full),
+	PHY_SETTING(1000, FULL, 1000baseX_Full),
 	/* 100M */
-	PHY_SETTING(    100, FULL,    100baseT_Full		),
-	PHY_SETTING(    100, FULL,    100baseT1_Full		),
-	PHY_SETTING(    100, HALF,    100baseT_Half		),
-	PHY_SETTING(    100, HALF,    100baseFX_Half		),
-	PHY_SETTING(    100, FULL,    100baseFX_Full		),
+	PHY_SETTING(100, FULL, 100baseT_Full),
+	PHY_SETTING(100, FULL, 100baseT1_Full),
+	PHY_SETTING(100, HALF, 100baseT_Half),
+	PHY_SETTING(100, HALF, 100baseFX_Half),
+	PHY_SETTING(100, FULL, 100baseFX_Full),
 	/* 10M */
-	PHY_SETTING(     10, FULL,     10baseT_Full		),
-	PHY_SETTING(     10, HALF,     10baseT_Half		),
+	PHY_SETTING(10, FULL, 10baseT_Full),
+	PHY_SETTING(10, HALF, 10baseT_Half),
 };
 #undef PHY_SETTING
 
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index e61de66..fe23fd3 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -624,14 +624,14 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
  * be put via sfp_bus_put() when done.
  *
  * Returns:
- * 	    - on success, a pointer to the sfp_bus structure,
- *	    - %NULL if no SFP is specified,
- * 	    - on failure, an error pointer value:
+ *	- on success, a pointer to the sfp_bus structure,
+ *	- %NULL if no SFP is specified,
+ *	- on failure, an error pointer value:
  *
- * 	      - corresponding to the errors detailed for
- * 	        fwnode_property_get_reference_args().
- * 	      - %-ENOMEM if we failed to allocate the bus.
- *	      - an error from the upstream's connect_phy() method.
+ *	- corresponding to the errors detailed for
+ *	  fwnode_property_get_reference_args().
+ *	- %-ENOMEM if we failed to allocate the bus.
+ *	- an error from the upstream's connect_phy() method.
  */
 struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
 {
@@ -666,14 +666,14 @@ EXPORT_SYMBOL_GPL(sfp_bus_find_fwnode);
  * bus, so it is safe to put the bus after this call.
  *
  * Returns:
- * 	    - on success, a pointer to the sfp_bus structure,
- *	    - %NULL if no SFP is specified,
- * 	    - on failure, an error pointer value:
+ *	- on success, a pointer to the sfp_bus structure,
+ *	- %NULL if no SFP is specified,
+ *	- on failure, an error pointer value:
  *
- * 	      - corresponding to the errors detailed for
- * 	        fwnode_property_get_reference_args().
- * 	      - %-ENOMEM if we failed to allocate the bus.
- *	      - an error from the upstream's connect_phy() method.
+ *	- corresponding to the errors detailed for
+ *	  fwnode_property_get_reference_args().
+ *	- %-ENOMEM if we failed to allocate the bus.
+ *	- an error from the upstream's connect_phy() method.
  */
 int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
 			 const struct sfp_upstream_ops *ops)
diff --git a/drivers/net/phy/spi_ks8995.c b/drivers/net/phy/spi_ks8995.c
index ca49c1a..8b5445a 100644
--- a/drivers/net/phy/spi_ks8995.c
+++ b/drivers/net/phy/spi_ks8995.c
@@ -160,11 +160,11 @@ static const struct spi_device_id ks8995_id[] = {
 MODULE_DEVICE_TABLE(spi, ks8995_id);
 
 static const struct of_device_id ks8895_spi_of_match[] = {
-        { .compatible = "micrel,ks8995" },
-        { .compatible = "micrel,ksz8864" },
-        { .compatible = "micrel,ksz8795" },
-        { },
- };
+	{ .compatible = "micrel,ks8995" },
+	{ .compatible = "micrel,ksz8864" },
+	{ .compatible = "micrel,ksz8795" },
+	{ },
+};
 MODULE_DEVICE_TABLE(of, ks8895_spi_of_match);
 
 static inline u8 get_chip_id(u8 val)
diff --git a/drivers/net/phy/ste10Xp.c b/drivers/net/phy/ste10Xp.c
index 431fe5e..309e4c3 100644
--- a/drivers/net/phy/ste10Xp.c
+++ b/drivers/net/phy/ste10Xp.c
@@ -20,12 +20,12 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 
-#define MII_XCIIS   	0x11	/* Configuration Info IRQ & Status Reg */
-#define MII_XIE     	0x12	/* Interrupt Enable Register */
+#define MII_XCIIS	0x11	/* Configuration Info IRQ & Status Reg */
+#define MII_XIE		0x12	/* Interrupt Enable Register */
 #define MII_XIE_DEFAULT_MASK 0x0070 /* ANE complete, Remote Fault, Link Down */
 
 #define STE101P_PHY_ID		0x00061c50
-#define STE100P_PHY_ID       	0x1c040011
+#define STE100P_PHY_ID		0x1c040011
 
 static int ste10Xp_config_init(struct phy_device *phydev)
 {
-- 
2.8.1

