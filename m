Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76753A3C16
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhFKGmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:42:17 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9072 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFKGmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:42:14 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1WNg1dMczYrCH;
        Fri, 11 Jun 2021 14:37:23 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:14 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 1/8] net: phy: add a blank line after declarations
Date:   Fri, 11 Jun 2021 14:36:52 +0800
Message-ID: <1623393419-2521-2-git-send-email-liweihang@huawei.com>
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

There should be a blank line after declarations.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/phy/bcm87xx.c  | 4 ++--
 drivers/net/phy/dp83640.c  | 1 +
 drivers/net/phy/et1011c.c  | 6 ++++--
 drivers/net/phy/mdio_bus.c | 1 +
 drivers/net/phy/qsemi.c    | 1 +
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
index 4ac8fd1..3135634 100644
--- a/drivers/net/phy/bcm87xx.c
+++ b/drivers/net/phy/bcm87xx.c
@@ -54,9 +54,9 @@ static int bcm87xx_of_reg_init(struct phy_device *phydev)
 		u16 reg		= be32_to_cpup(paddr++);
 		u16 mask	= be32_to_cpup(paddr++);
 		u16 val_bits	= be32_to_cpup(paddr++);
-		int val;
 		u32 regnum = mdiobus_c45_addr(devid, reg);
-		val = 0;
+		int val = 0;
+
 		if (mask) {
 			val = phy_read(phydev, regnum);
 			if (val < 0) {
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 0d79f68..10769bf 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -615,6 +615,7 @@ static void prune_rx_ts(struct dp83640_private *dp83640)
 static void enable_broadcast(struct phy_device *phydev, int init_page, int on)
 {
 	int val;
+
 	phy_write(phydev, PAGESEL, 0);
 	val = phy_read(phydev, PHYCR2);
 	if (on)
diff --git a/drivers/net/phy/et1011c.c b/drivers/net/phy/et1011c.c
index 09e07b9..4b3d035 100644
--- a/drivers/net/phy/et1011c.c
+++ b/drivers/net/phy/et1011c.c
@@ -46,7 +46,8 @@ MODULE_LICENSE("GPL");
 
 static int et1011c_config_aneg(struct phy_device *phydev)
 {
-	int ctl = 0;
+	int ctl;
+
 	ctl = phy_read(phydev, MII_BMCR);
 	if (ctl < 0)
 		return ctl;
@@ -60,9 +61,10 @@ static int et1011c_config_aneg(struct phy_device *phydev)
 
 static int et1011c_read_status(struct phy_device *phydev)
 {
+	static int speed;
 	int ret;
 	u32 val;
-	static int speed;
+
 	ret = genphy_read_status(phydev);
 
 	if (speed != phydev->speed) {
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6045ad3..2466567 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -175,6 +175,7 @@ EXPORT_SYMBOL(mdiobus_alloc_size);
 static void mdiobus_release(struct device *d)
 {
 	struct mii_bus *bus = to_mii_bus(d);
+
 	BUG_ON(bus->state != MDIOBUS_RELEASED &&
 	       /* for compatibility with error handling in drivers */
 	       bus->state != MDIOBUS_ALLOCATED);
diff --git a/drivers/net/phy/qsemi.c b/drivers/net/phy/qsemi.c
index d5c1aaa..30d15f7 100644
--- a/drivers/net/phy/qsemi.c
+++ b/drivers/net/phy/qsemi.c
@@ -100,6 +100,7 @@ static int qs6612_ack_interrupt(struct phy_device *phydev)
 static int qs6612_config_intr(struct phy_device *phydev)
 {
 	int err;
+
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
 		/* clear any interrupts before enabling them */
 		err = qs6612_ack_interrupt(phydev);
-- 
2.8.1

