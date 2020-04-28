Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621981BB394
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgD1Bsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:48:51 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45346 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbgD1Bsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 21:48:50 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7CD90498ED7D8EB6A524;
        Tue, 28 Apr 2020 09:48:48 +0800 (CST)
Received: from huawei.com (10.67.174.156) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 28 Apr 2020
 09:48:41 +0800
From:   ChenTao <chentao107@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chentao107@huawei.com>
Subject: [PATCH-next] net: phy: bcm54140: Make a bunch of functions static
Date:   Tue, 28 Apr 2020 09:48:04 +0800
Message-ID: <20200428014804.54944-1-chentao107@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.156]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following warning:

drivers/net/phy/bcm54140.c:663:5: warning:
symbol 'bcm54140_did_interrupt' was not declared. Should it be static?
drivers/net/phy/bcm54140.c:672:5: warning:
symbol 'bcm54140_ack_intr' was not declared. Should it be static?
drivers/net/phy/bcm54140.c:684:5: warning:
symbol 'bcm54140_config_intr' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: ChenTao <chentao107@huawei.com>
---
 drivers/net/phy/bcm54140.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index 7341f0126cc4..c009ac2856a5 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -660,7 +660,7 @@ static int bcm54140_config_init(struct phy_device *phydev)
 				  BCM54140_RDB_C_PWR_ISOLATE, 0);
 }
 
-int bcm54140_did_interrupt(struct phy_device *phydev)
+static int bcm54140_did_interrupt(struct phy_device *phydev)
 {
 	int ret;
 
@@ -669,7 +669,7 @@ int bcm54140_did_interrupt(struct phy_device *phydev)
 	return (ret < 0) ? 0 : ret;
 }
 
-int bcm54140_ack_intr(struct phy_device *phydev)
+static int bcm54140_ack_intr(struct phy_device *phydev)
 {
 	int reg;
 
@@ -681,7 +681,7 @@ int bcm54140_ack_intr(struct phy_device *phydev)
 	return 0;
 }
 
-int bcm54140_config_intr(struct phy_device *phydev)
+static int bcm54140_config_intr(struct phy_device *phydev)
 {
 	struct bcm54140_priv *priv = phydev->priv;
 	static const u16 port_to_imr_bit[] = {
-- 
2.22.0

