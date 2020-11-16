Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F25E2B40AC
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgKPKSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbgKPKS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 05:18:29 -0500
Received: from mail.kernel.org (ip5f5ad5de.dynamic.kabel-deutschland.de [95.90.213.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 346E5216C4;
        Mon, 16 Nov 2020 10:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605521908;
        bh=L53XGoifM5dA8LlGI5Y6uRxs/Ht8R3dvC8m6g7On9oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXn4D0qe3mlMwzoqYawWm3zOYcgPH1qODjDowOu6Ps5I5RiCvQdaj7A6WGGeVZkEi
         Whk16wZSG5pkCb7pk48cST41NWF8Vu7DzkY490TQ8w9sc76BG8mN6ywqG9zQg/Rhxh
         ABQCf1kCpkb/TcwI48iftKOF5rxIfhH3rVjwnW1E=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kebab-00FwDq-RR; Mon, 16 Nov 2020 11:18:25 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Linux Doc Mailing List" <linux-doc@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 01/27] net: phy: fix kernel-doc markups
Date:   Mon, 16 Nov 2020 11:17:57 +0100
Message-Id: <87d259eb3931fcac418b60a6c5c863bded0cd5c8.1605521731.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605521731.git.mchehab+huawei@kernel.org>
References: <cover.1605521731.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some functions have different names between their prototypes
and the kernel-doc markup.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/net/phy/mdio_bus.c   | 2 +-
 drivers/net/phy/phy-c45.c    | 2 +-
 drivers/net/phy/phy.c        | 2 +-
 drivers/net/phy/phy_device.c | 2 +-
 drivers/net/phy/phylink.c    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 757e950fb745..e59067c64e97 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -455,41 +455,41 @@ static void of_mdiobus_link_mdiodev(struct mii_bus *bus,
 
 		addr = of_mdio_parse_addr(dev, child);
 		if (addr < 0)
 			continue;
 
 		if (addr == mdiodev->addr) {
 			dev->of_node = child;
 			dev->fwnode = of_fwnode_handle(child);
 			return;
 		}
 	}
 }
 #else /* !IS_ENABLED(CONFIG_OF_MDIO) */
 static inline void of_mdiobus_link_mdiodev(struct mii_bus *mdio,
 					   struct mdio_device *mdiodev)
 {
 }
 #endif
 
 /**
- * mdiobus_create_device_from_board_info - create a full MDIO device given
+ * mdiobus_create_device - create a full MDIO device given
  * a mdio_board_info structure
  * @bus: MDIO bus to create the devices on
  * @bi: mdio_board_info structure describing the devices
  *
  * Returns 0 on success or < 0 on error.
  */
 static int mdiobus_create_device(struct mii_bus *bus,
 				 struct mdio_board_info *bi)
 {
 	struct mdio_device *mdiodev;
 	int ret = 0;
 
 	mdiodev = mdio_device_create(bus, bi->mdio_addr);
 	if (IS_ERR(mdiodev))
 		return -ENODEV;
 
 	strncpy(mdiodev->modalias, bi->modalias,
 		sizeof(mdiodev->modalias));
 	mdiodev->bus_match = mdio_device_bus_match;
 	mdiodev->dev.platform_data = (void *)bi->platform_data;
diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index bd11e62bfdfe..077f2929c45e 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -1,32 +1,32 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Clause 45 PHY support
  */
 #include <linux/ethtool.h>
 #include <linux/export.h>
 #include <linux/mdio.h>
 #include <linux/mii.h>
 #include <linux/phy.h>
 
 /**
- * genphy_c45_setup_forced - configures a forced speed
+ * genphy_c45_pma_setup_forced - configures a forced speed
  * @phydev: target phy_device struct
  */
 int genphy_c45_pma_setup_forced(struct phy_device *phydev)
 {
 	int ctrl1, ctrl2, ret;
 
 	/* Half duplex is not supported */
 	if (phydev->duplex != DUPLEX_FULL)
 		return -EINVAL;
 
 	ctrl1 = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
 	if (ctrl1 < 0)
 		return ctrl1;
 
 	ctrl2 = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL2);
 	if (ctrl2 < 0)
 		return ctrl2;
 
 	ctrl1 &= ~MDIO_CTRL1_SPEEDSEL;
 	/*
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 477bdf2f94df..dce86bad8231 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -472,41 +472,41 @@ int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return -ENODEV;
 
 	return phy_do_ioctl(dev, ifr, cmd);
 }
 EXPORT_SYMBOL(phy_do_ioctl_running);
 
 /**
  * phy_queue_state_machine - Trigger the state machine to run soon
  *
  * @phydev: the phy_device struct
  * @jiffies: Run the state machine after these jiffies
  */
 void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies)
 {
 	mod_delayed_work(system_power_efficient_wq, &phydev->state_queue,
 			 jiffies);
 }
 EXPORT_SYMBOL(phy_queue_state_machine);
 
 /**
- * phy_queue_state_machine - Trigger the state machine to run now
+ * phy_trigger_machine - Trigger the state machine to run now
  *
  * @phydev: the phy_device struct
  */
 void phy_trigger_machine(struct phy_device *phydev)
 {
 	phy_queue_state_machine(phydev, 0);
 }
 EXPORT_SYMBOL(phy_trigger_machine);
 
 static void phy_abort_cable_test(struct phy_device *phydev)
 {
 	int err;
 
 	ethnl_cable_test_finished(phydev);
 
 	err = phy_init_hw(phydev);
 	if (err)
 		phydev_err(phydev, "Error while aborting cable test");
 }
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e13a46c25437..8f34bedceadc 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2731,41 +2731,41 @@ EXPORT_SYMBOL(phy_get_pause);
 #if IS_ENABLED(CONFIG_OF_MDIO)
 static int phy_get_int_delay_property(struct device *dev, const char *name)
 {
 	s32 int_delay;
 	int ret;
 
 	ret = device_property_read_u32(dev, name, &int_delay);
 	if (ret)
 		return ret;
 
 	return int_delay;
 }
 #else
 static int phy_get_int_delay_property(struct device *dev, const char *name)
 {
 	return -EINVAL;
 }
 #endif
 
 /**
- * phy_get_delay_index - returns the index of the internal delay
+ * phy_get_internal_delay - returns the index of the internal delay
  * @phydev: phy_device struct
  * @dev: pointer to the devices device struct
  * @delay_values: array of delays the PHY supports
  * @size: the size of the delay array
  * @is_rx: boolean to indicate to get the rx internal delay
  *
  * Returns the index within the array of internal delay passed in.
  * If the device property is not present then the interface type is checked
  * if the interface defines use of internal delay then a 1 is returned otherwise
  * a 0 is returned.
  * The array must be in ascending order. If PHY does not have an ascending order
  * array then size = 0 and the value of the delay property is returned.
  * Return -EINVAL if the delay is invalid or cannot be found.
  */
 s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 			   const int *delay_values, int size, bool is_rx)
 {
 	s32 delay;
 	int i;
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5d8c015bc9f2..84f6e197f965 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1632,41 +1632,41 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	 * we can't hold our state mutex while calling phy_set_asym_pause().
 	 */
 	if (pl->phydev)
 		phy_set_asym_pause(pl->phydev, pause->rx_pause,
 				   pause->tx_pause);
 
 	/* If the manual pause settings changed, make sure we trigger a
 	 * resolve to update their state; we can not guarantee that the
 	 * link will cycle.
 	 */
 	if (manual_changed) {
 		pl->mac_link_dropped = true;
 		phylink_run_resolve(pl);
 	}
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(phylink_ethtool_set_pauseparam);
 
 /**
- * phylink_ethtool_get_eee_err() - read the energy efficient ethernet error
+ * phylink_get_eee_err() - read the energy efficient ethernet error
  *   counter
  * @pl: a pointer to a &struct phylink returned from phylink_create().
  *
  * Read the Energy Efficient Ethernet error counter from the PHY associated
  * with the phylink instance specified by @pl.
  *
  * Returns positive error counter value, or negative error code.
  */
 int phylink_get_eee_err(struct phylink *pl)
 {
 	int ret = 0;
 
 	ASSERT_RTNL();
 
 	if (pl->phydev)
 		ret = phy_get_eee_err(pl->phydev);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(phylink_get_eee_err);
-- 
2.28.0

