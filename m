Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA73ECCB0
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 02:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfKBBOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 21:14:23 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:40413 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKBBOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 21:14:17 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B896022FC9;
        Sat,  2 Nov 2019 02:14:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572657254;
        bh=Se4SP8TUWUty8fZZvsI9WAZ/hUG7yNeGDozLgfgayyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4vg1NGhScwcc8XM+CiMbZYlHlNXf/0MHOOLoCsXdXBzVeg28/fE69yzxdRDQUXWp
         v+0FMV5AVm2k4pdPbYjMrjyYlosAz0CL+V4YCqggSZh8jtbXh+n1SAu0wjIzL/1XPd
         U+kUPXHBppur8MerY/LPHTnMr0IXaxcab5MHrXWA=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [PATCH 5/5] net: phy: at803x: fix the PHY names
Date:   Sat,  2 Nov 2019 02:13:51 +0100
Message-Id: <20191102011351.6467-6-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191102011351.6467-1-michael@walle.cc>
References: <20191102011351.6467-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix at least the displayed strings. The actual name of the chip is
AR803x.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 49a1eebc7825..4a0f0bcaac1f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -2,7 +2,7 @@
 /*
  * drivers/net/phy/at803x.c
  *
- * Driver for Atheros 803x PHY
+ * Driver for Atheros AR803x PHY
  *
  * Author: Matus Ujhelyi <ujhelyi.m@gmail.com>
  */
@@ -108,7 +108,7 @@
 #define ATH8035_PHY_ID 0x004dd072
 #define AT803X_PHY_ID_MASK			0xffffffef
 
-MODULE_DESCRIPTION("Atheros 803x PHY driver");
+MODULE_DESCRIPTION("Atheros AR803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
 
@@ -707,9 +707,9 @@ static int at803x_read_status(struct phy_device *phydev)
 
 static struct phy_driver at803x_driver[] = {
 {
-	/* ATHEROS 8035 */
+	/* Atheros AR8035 */
 	.phy_id			= ATH8035_PHY_ID,
-	.name			= "Atheros 8035 ethernet",
+	.name			= "Atheros AR8035",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
@@ -722,9 +722,9 @@ static struct phy_driver at803x_driver[] = {
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 }, {
-	/* ATHEROS 8030 */
+	/* Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
-	.name			= "Atheros 8030 ethernet",
+	.name			= "Atheros AR8030",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
@@ -737,9 +737,9 @@ static struct phy_driver at803x_driver[] = {
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 }, {
-	/* ATHEROS 8031/8033 */
+	/* Atheros AR8031/AR8033 */
 	.phy_id			= ATH8031_PHY_ID,
-	.name			= "Atheros 8031/8033 ethernet",
+	.name			= "Atheros AR8031/AR8033",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
-- 
2.20.1

