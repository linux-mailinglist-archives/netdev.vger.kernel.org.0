Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C58E3A96DB
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhFPKHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:07:03 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7334 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbhFPKGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:06:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G4gfz0ZQ0z6vH3;
        Wed, 16 Jun 2021 18:00:43 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:40 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH v2 net-next 4/8] net: phy: fix space alignment issues
Date:   Wed, 16 Jun 2021 18:01:22 +0800
Message-ID: <1623837686-22569-5-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
 drivers/net/phy/davicom.c    |  6 +++---
 drivers/net/phy/sfp-bus.c    | 28 ++++++++++++++--------------
 drivers/net/phy/spi_ks8995.c | 10 +++++-----
 drivers/net/phy/ste10Xp.c    |  6 +++---
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/phy/davicom.c b/drivers/net/phy/davicom.c
index a3b3842c6..4ac4bce 100644
--- a/drivers/net/phy/davicom.c
+++ b/drivers/net/phy/davicom.c
@@ -43,10 +43,10 @@
 #define MII_DM9161_INTR_DPLX_CHANGE	0x0010
 #define MII_DM9161_INTR_SPD_CHANGE	0x0008
 #define MII_DM9161_INTR_LINK_CHANGE	0x0004
-#define MII_DM9161_INTR_INIT 		0x0000
+#define MII_DM9161_INTR_INIT		0x0000
 #define MII_DM9161_INTR_STOP	\
-(MII_DM9161_INTR_DPLX_MASK | MII_DM9161_INTR_SPD_MASK \
- | MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)
+	(MII_DM9161_INTR_DPLX_MASK | MII_DM9161_INTR_SPD_MASK |	\
+	 MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)
 #define MII_DM9161_INTR_CHANGE	\
 	(MII_DM9161_INTR_DPLX_CHANGE | \
 	 MII_DM9161_INTR_SPD_CHANGE | \
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 1db9cea..7362f8c 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -629,14 +629,14 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
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
@@ -671,14 +671,14 @@ EXPORT_SYMBOL_GPL(sfp_bus_find_fwnode);
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

