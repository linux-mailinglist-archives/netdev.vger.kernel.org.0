Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB914216382
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 03:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgGGBuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 21:50:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgGGBt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 21:49:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsck6-003wBx-Ld; Tue, 07 Jul 2020 03:49:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>
Subject: [PATCH net-next v2 2/7] net: phy: Fixup parameters in kerneldoc
Date:   Tue,  7 Jul 2020 03:49:34 +0200
Message-Id: <20200707014939.938621-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707014939.938621-1-andrew@lunn.ch>
References: <20200707014939.938621-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct the kerneldoc for a few structure and function calls,
as reported by C=1 W=1.

Cc: Alexandru Ardelean <alexaundru.ardelean@analog.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/adin.c           | 12 ++++++------
 drivers/net/phy/mdio-boardinfo.c |  3 ++-
 drivers/net/phy/mdio_device.c    |  2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index c7eabe4382fb..7471a8b90873 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -106,8 +106,8 @@
 
 /**
  * struct adin_cfg_reg_map - map a config value to aregister value
- * @cfg		value in device configuration
- * @reg		value in the register
+ * @cfg:	value in device configuration
+ * @reg:	value in the register
  */
 struct adin_cfg_reg_map {
 	int cfg;
@@ -135,9 +135,9 @@ static const struct adin_cfg_reg_map adin_rmii_fifo_depths[] = {
 
 /**
  * struct adin_clause45_mmd_map - map to convert Clause 45 regs to Clause 22
- * @devad		device address used in Clause 45 access
- * @cl45_regnum		register address defined by Clause 45
- * @adin_regnum		equivalent register address accessible via Clause 22
+ * @devad:		device address used in Clause 45 access
+ * @cl45_regnum:	register address defined by Clause 45
+ * @adin_regnum:	equivalent register address accessible via Clause 22
  */
 struct adin_clause45_mmd_map {
 	int devad;
@@ -174,7 +174,7 @@ static const struct adin_hw_stat adin_hw_stats[] = {
 
 /**
  * struct adin_priv - ADIN PHY driver private data
- * stats		statistic counters for the PHY
+ * @stats:		statistic counters for the PHY
  */
 struct adin_priv {
 	u64			stats[ARRAY_SIZE(adin_hw_stats)];
diff --git a/drivers/net/phy/mdio-boardinfo.c b/drivers/net/phy/mdio-boardinfo.c
index d9b54c67ef9f..033df435f76c 100644
--- a/drivers/net/phy/mdio-boardinfo.c
+++ b/drivers/net/phy/mdio-boardinfo.c
@@ -17,7 +17,8 @@ static DEFINE_MUTEX(mdio_board_lock);
 /**
  * mdiobus_setup_mdiodev_from_board_info - create and setup MDIO devices
  * from pre-collected board specific MDIO information
- * @mdiodev: MDIO device pointer
+ * @bus: Bus the board_info belongs to
+ * @cb: Callback to create device on bus
  * Context: can sleep
  */
 void mdiobus_setup_mdiodev_from_board_info(struct mii_bus *bus,
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index be615504b829..0f625a1b1644 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -181,7 +181,7 @@ static int mdio_remove(struct device *dev)
 
 /**
  * mdio_driver_register - register an mdio_driver with the MDIO layer
- * @new_driver: new mdio_driver to register
+ * @drv: new mdio_driver to register
  */
 int mdio_driver_register(struct mdio_driver *drv)
 {
-- 
2.27.0.rc2

