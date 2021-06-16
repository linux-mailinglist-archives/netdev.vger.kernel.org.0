Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E253A96D8
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhFPKGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:06:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4811 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbhFPKGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:06:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4gdn0DJWzWqSL;
        Wed, 16 Jun 2021 17:59:41 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:41 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH v2 net-next 5/8] net: phy: fix formatting issues with braces
Date:   Wed, 16 Jun 2021 18:01:23 +0800
Message-ID: <1623837686-22569-6-git-send-email-liweihang@huawei.com>
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

Fix following format issues:
1. open brace '{' following function definitions should go to the next
   line.
2. braces {} are not necessary for single line statements.
3. else should follow close brace '}'.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/phy/fixed_phy.c  | 4 ++--
 drivers/net/phy/phy.c        | 3 +--
 drivers/net/phy/phy_device.c | 9 ++++-----
 drivers/net/phy/phylink.c    | 5 ++---
 4 files changed, 9 insertions(+), 12 deletions(-)

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
index 8573430..5d5f9a9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3021,15 +3021,14 @@ static int phy_probe(struct device *dev)
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
index 35f22a9..eb29ef5 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1383,11 +1383,10 @@ int phylink_ethtool_ksettings_get(struct phylink *pl,
 
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

