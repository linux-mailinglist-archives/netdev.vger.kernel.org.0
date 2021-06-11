Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BF33A3C15
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhFKGmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:42:16 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:6265 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhFKGmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:42:14 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G1WLJ5pLtz1BLNX;
        Fri, 11 Jun 2021 14:35:20 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [PATCH net-next 4/8] net: phy: fixed formatting issues with braces
Date:   Fri, 11 Jun 2021 14:36:55 +0800
Message-ID: <1623393419-2521-5-git-send-email-liweihang@huawei.com>
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

Fix following format issues:
1. open brace '{' following function definitions should go to the next line.
2. braces {} are not necessary for single line statements.
3. else should follow close brace '}'.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/phy/fixed_phy.c  | 4 ++--
 drivers/net/phy/marvell.c    | 9 ++++-----
 drivers/net/phy/phy.c        | 3 +--
 drivers/net/phy/phy_device.c | 9 ++++-----
 drivers/net/phy/phylink.c    | 5 ++---
 5 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 18d81f4..c65fb5f 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -161,8 +161,8 @@ static int fixed_phy_add_gpiod(unsigned int irq, int phy_addr,
 }
 
 int fixed_phy_add(unsigned int irq, int phy_addr,
-		  struct fixed_phy_status *status) {
-
+		  struct fixed_phy_status *status)
+{
 	return fixed_phy_add_gpiod(irq, phy_addr, status, NULL);
 }
 EXPORT_SYMBOL_GPL(fixed_phy_add);
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 23751d9..d93c27a 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -809,15 +809,14 @@ static int m88e1111_config_init_rgmii_delays(struct phy_device *phydev)
 {
 	int delay;
 
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
 		delay = MII_M1111_RGMII_RX_DELAY | MII_M1111_RGMII_TX_DELAY;
-	} else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+	else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
 		delay = MII_M1111_RGMII_RX_DELAY;
-	} else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+	else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
 		delay = MII_M1111_RGMII_TX_DELAY;
-	} else {
+	else
 		delay = 0;
-	}
 
 	return phy_modify(phydev, MII_M1111_PHY_EXT_CR,
 			  MII_M1111_RGMII_RX_DELAY | MII_M1111_RGMII_TX_DELAY,
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 1089a93..8eeb26d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -380,8 +380,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 					else if (val & BMCR_SPEED100)
 						phydev->speed = SPEED_100;
 					else phydev->speed = SPEED_10;
-				}
-				else {
+				} else {
 					if (phydev->autoneg == AUTONEG_DISABLE)
 						change_autoneg = true;
 					phydev->autoneg = AUTONEG_ENABLE;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1539ea0..2b78c5c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2904,15 +2904,14 @@ static int phy_probe(struct device *dev)
 	 * a controller will attach, and may modify one
 	 * or both of these values
 	 */
-	if (phydrv->features) {
+	if (phydrv->features)
 		linkmode_copy(phydev->supported, phydrv->features);
-	} else if (phydrv->get_features) {
+	else if (phydrv->get_features)
 		err = phydrv->get_features(phydev);
-	} else if (phydev->is_c45) {
+	else if (phydev->is_c45)
 		err = genphy_c45_pma_read_abilities(phydev);
-	} else {
+	else
 		err = genphy_read_abilities(phydev);
-	}
 
 	if (err)
 		goto out;
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9baaa34..4040d37 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1361,11 +1361,10 @@ int phylink_ethtool_ksettings_get(struct phylink *pl,
 
 	ASSERT_RTNL();
 
-	if (pl->phydev) {
+	if (pl->phydev)
 		phy_ethtool_ksettings_get(pl->phydev, kset);
-	} else {
+	else
 		kset->base.port = pl->link_port;
-	}
 
 	linkmode_copy(kset->link_modes.supported, pl->supported);
 
-- 
2.8.1

