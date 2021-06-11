Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5153A3C1A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhFKGmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:42:25 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:6266 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhFKGmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:42:15 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G1WLL2NzQz1BLNg;
        Fri, 11 Jun 2021 14:35:22 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:40:15 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 7/8] net: phy: remove unnecessary line continuation
Date:   Fri, 11 Jun 2021 14:36:58 +0800
Message-ID: <1623393419-2521-8-git-send-email-liweihang@huawei.com>
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

Avoid unnecessary line continuations.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/phy/dp83640.c | 4 ++--
 drivers/net/phy/et1011c.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 10769bf..705c166 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -170,9 +170,9 @@ static ushort gpio_tab[GPIO_TABLE_SIZE] = {
 module_param(chosen_phy, int, 0444);
 module_param_array(gpio_tab, ushort, NULL, 0444);
 
-MODULE_PARM_DESC(chosen_phy, \
+MODULE_PARM_DESC(chosen_phy,
 	"The address of the PHY to use for the ancillary clock features");
-MODULE_PARM_DESC(gpio_tab, \
+MODULE_PARM_DESC(gpio_tab,
 	"Which GPIO line to use for which purpose: cal,perout,extts1,...,extts6");
 
 static void dp83640_gpio_defaults(struct ptp_pin_desc *pd)
diff --git a/drivers/net/phy/et1011c.c b/drivers/net/phy/et1011c.c
index 4b3d035..72f51b7 100644
--- a/drivers/net/phy/et1011c.c
+++ b/drivers/net/phy/et1011c.c
@@ -74,9 +74,9 @@ static int et1011c_read_status(struct phy_device *phydev)
 					ET1011C_GIGABIT_SPEED) {
 			val = phy_read(phydev, ET1011C_CONFIG_REG);
 			val &= ~ET1011C_TX_FIFO_MASK;
-			phy_write(phydev, ET1011C_CONFIG_REG, val\
-					| ET1011C_GMII_INTERFACE\
-					| ET1011C_SYS_CLK_EN\
+			phy_write(phydev, ET1011C_CONFIG_REG, val
+					| ET1011C_GMII_INTERFACE
+					| ET1011C_SYS_CLK_EN
 					| ET1011C_TX_FIFO_DEPTH_16);
 
 		}
-- 
2.8.1

