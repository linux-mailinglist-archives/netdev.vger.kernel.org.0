Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF7E3A96D9
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhFPKG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:06:59 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4950 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbhFPKGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:06:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4ggv21cyz70MK;
        Wed, 16 Jun 2021 18:01:31 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:40 +0800
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
Subject: [PATCH v2 net-next 2/8] net: phy: correct format of block comments
Date:   Wed, 16 Jun 2021 18:01:20 +0800
Message-ID: <1623837686-22569-3-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

Block comments should not use a trailing */ on a separate line and every
line of a block comment should start with an '*'.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/phy/lxt.c      | 4 ++--
 drivers/net/phy/national.c | 6 ++++--
 drivers/net/phy/phy-core.c | 3 ++-
 drivers/net/phy/phylink.c  | 9 ++++++---
 drivers/net/phy/vitesse.c  | 3 ++-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
index bde3356..e3bf827 100644
--- a/drivers/net/phy/lxt.c
+++ b/drivers/net/phy/lxt.c
@@ -242,8 +242,8 @@ static int lxt973a2_read_status(struct phy_device *phydev)
 				return lpa;
 
 			/* If both registers are equal, it is suspect but not
-			* impossible, hence a new try
-			*/
+			 * impossible, hence a new try
+			 */
 		} while (lpa == adv && retry--);
 
 		mii_lpa_to_linkmode_lpa_t(phydev->lp_advertising, lpa);
diff --git a/drivers/net/phy/national.c b/drivers/net/phy/national.c
index 46160ba..9ae9cc6b 100644
--- a/drivers/net/phy/national.c
+++ b/drivers/net/phy/national.c
@@ -68,7 +68,8 @@ static int ns_ack_interrupt(struct phy_device *phydev)
 		return ret;
 
 	/* Clear the interrupt status bit by writing a “1”
-	 * to the corresponding bit in INT_CLEAR (2:0 are reserved) */
+	 * to the corresponding bit in INT_CLEAR (2:0 are reserved)
+	 */
 	ret = phy_write(phydev, DP83865_INT_CLEAR, ret & ~0x7);
 
 	return ret;
@@ -150,7 +151,8 @@ static int ns_config_init(struct phy_device *phydev)
 {
 	ns_giga_speed_fallback(phydev, ALL_FALLBACK_ON);
 	/* In the latest MAC or switches design, the 10 Mbps loopback
-	   is desired to be turned off. */
+	 * is desired to be turned off.
+	 */
 	ns_10_base_t_hdx_loopack(phydev, hdx_loopback_off);
 	return ns_ack_interrupt(phydev);
 }
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 8d333d3..2870c33 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -76,7 +76,8 @@ EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 
 /* A mapping of all SUPPORTED settings to speed/duplex.  This table
  * must be grouped by speed and sorted in descending match priority
- * - iow, descending speed. */
+ * - iow, descending speed.
+ */
 
 #define PHY_SETTING(s, d, b) { .speed = SPEED_ ## s, .duplex = DUPLEX_ ## d, \
 			       .bit = ETHTOOL_LINK_MODE_ ## b ## _BIT}
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8ce8db4..35f22a9 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -182,7 +182,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 			pl->link_config.duplex = DUPLEX_FULL;
 
 		/* We treat the "pause" and "asym-pause" terminology as
-		 * defining the link partner's ability. */
+		 * defining the link partner's ability.
+		 */
 		if (fwnode_property_read_bool(fixed_node, "pause"))
 			__set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
 				  pl->link_config.lp_advertising);
@@ -685,7 +686,8 @@ static void phylink_resolve(struct work_struct *w)
 			phylink_mac_pcs_get_state(pl, &link_state);
 
 			/* If we have a phy, the "up" state is the union of
-			 * both the PHY and the MAC */
+			 * both the PHY and the MAC
+			 */
 			if (pl->phydev)
 				link_state.link &= pl->phy_state.link;
 
@@ -694,7 +696,8 @@ static void phylink_resolve(struct work_struct *w)
 				link_state.interface = pl->phy_state.interface;
 
 				/* If we have a PHY, we need to update with
-				 * the PHY flow control bits. */
+				 * the PHY flow control bits.
+				 */
 				link_state.pause = pl->phy_state.pause;
 				mac_config = true;
 			}
diff --git a/drivers/net/phy/vitesse.c b/drivers/net/phy/vitesse.c
index 16704e2..897b979 100644
--- a/drivers/net/phy/vitesse.c
+++ b/drivers/net/phy/vitesse.c
@@ -249,7 +249,8 @@ static int vsc73xx_config_aneg(struct phy_device *phydev)
 
 /* This adds a skew for both TX and RX clocks, so the skew should only be
  * applied to "rgmii-id" interfaces. It may not work as expected
- * on "rgmii-txid", "rgmii-rxid" or "rgmii" interfaces. */
+ * on "rgmii-txid", "rgmii-rxid" or "rgmii" interfaces.
+ */
 static int vsc8601_add_skew(struct phy_device *phydev)
 {
 	int ret;
-- 
2.8.1

