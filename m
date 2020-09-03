Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6068125C36A
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgICOvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:51:11 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:36560 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729236AbgICOP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:15:27 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 083EFDV8129237;
        Thu, 3 Sep 2020 09:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599142513;
        bh=EjJKmXElYtJ5D9C1igabu2ue27HZb83HX5r1+ADUS2c=;
        h=From:To:CC:Subject:Date;
        b=OeQXI5eMshK1RgUrLhMVPU54HFCSArOBmdMjenUETAtv4uUSXtHbFXpAa1N5uC1L0
         pjiASOBrbdaYhG+E0n+73IoewXp+5lYyrTDbrfYOE9AvD++20SXysNu36AY5bqIy9X
         ubAMQBaCpQIUDK1I4tTA1wYcYQb5RLgsYTOA3FII=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 083EFDcN017298
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 3 Sep 2020 09:15:13 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 3 Sep
 2020 09:15:12 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 3 Sep 2020 09:15:13 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 083EFBs2105722;
        Thu, 3 Sep 2020 09:15:12 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net] net: phy: dp83867: Fix various styling and space issues
Date:   Thu, 3 Sep 2020 09:15:10 -0500
Message-ID: <20200903141510.20212-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix spacing issues reported for misaligned switch..case and extra new
lines.

Also updated the file header to comply with networking commet style.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83867.c | 47 ++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index cd7032628a28..f182a8d767c6 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/*
- * Driver for the Texas Instruments DP83867 PHY
+/* Driver for the Texas Instruments DP83867 PHY
  *
  * Copyright (C) 2015 Texas Instruments Inc.
  */
@@ -35,7 +34,7 @@
 #define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
 #define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
 #define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
-#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    BIT(5)
 #define DP83867_CFG4_SGMII_ANEG_TIMER_16MS   (0 << 5)
 
 #define DP83867_RGMIICTL	0x0032
@@ -113,7 +112,6 @@
 #define DP83867_RGMII_RX_CLK_DELAY_SHIFT	0
 #define DP83867_RGMII_RX_CLK_DELAY_INV	(DP83867_RGMII_RX_CLK_DELAY_MAX + 1)
 
-
 /* IO_MUX_CFG bits */
 #define DP83867_IO_MUX_CFG_IO_IMPEDANCE_MASK	0x1f
 #define DP83867_IO_MUX_CFG_IO_IMPEDANCE_MAX	0x0
@@ -384,22 +382,22 @@ static int dp83867_set_downshift(struct phy_device *phydev, u8 cnt)
 				      DP83867_DOWNSHIFT_EN);
 
 	switch (cnt) {
-		case DP83867_DOWNSHIFT_1_COUNT:
-			count = DP83867_DOWNSHIFT_1_COUNT_VAL;
-			break;
-		case DP83867_DOWNSHIFT_2_COUNT:
-			count = DP83867_DOWNSHIFT_2_COUNT_VAL;
-			break;
-		case DP83867_DOWNSHIFT_4_COUNT:
-			count = DP83867_DOWNSHIFT_4_COUNT_VAL;
-			break;
-		case DP83867_DOWNSHIFT_8_COUNT:
-			count = DP83867_DOWNSHIFT_8_COUNT_VAL;
-			break;
-		default:
-			phydev_err(phydev,
-				   "Downshift count must be 1, 2, 4 or 8\n");
-			return -EINVAL;
+	case DP83867_DOWNSHIFT_1_COUNT:
+		count = DP83867_DOWNSHIFT_1_COUNT_VAL;
+		break;
+	case DP83867_DOWNSHIFT_2_COUNT:
+		count = DP83867_DOWNSHIFT_2_COUNT_VAL;
+		break;
+	case DP83867_DOWNSHIFT_4_COUNT:
+		count = DP83867_DOWNSHIFT_4_COUNT_VAL;
+		break;
+	case DP83867_DOWNSHIFT_8_COUNT:
+		count = DP83867_DOWNSHIFT_8_COUNT_VAL;
+		break;
+	default:
+		phydev_err(phydev,
+			   "Downshift count must be 1, 2, 4 or 8\n");
+		return -EINVAL;
 	}
 
 	val = DP83867_DOWNSHIFT_EN;
@@ -411,7 +409,7 @@ static int dp83867_set_downshift(struct phy_device *phydev, u8 cnt)
 }
 
 static int dp83867_get_tunable(struct phy_device *phydev,
-				struct ethtool_tunable *tuna, void *data)
+			       struct ethtool_tunable *tuna, void *data)
 {
 	switch (tuna->id) {
 	case ETHTOOL_PHY_DOWNSHIFT:
@@ -422,7 +420,7 @@ static int dp83867_get_tunable(struct phy_device *phydev,
 }
 
 static int dp83867_set_tunable(struct phy_device *phydev,
-				struct ethtool_tunable *tuna, const void *data)
+			       struct ethtool_tunable *tuna, const void *data)
 {
 	switch (tuna->id) {
 	case ETHTOOL_PHY_DOWNSHIFT:
@@ -524,11 +522,10 @@ static int dp83867_of_init(struct phy_device *phydev)
 		dp83867->io_impedance = -1; /* leave at default */
 
 	dp83867->rxctrl_strap_quirk = of_property_read_bool(of_node,
-					"ti,dp83867-rxctrl-strap-quirk");
+							    "ti,dp83867-rxctrl-strap-quirk");
 
 	dp83867->sgmii_ref_clk_en = of_property_read_bool(of_node,
-					"ti,sgmii-ref-clock-output-enable");
-
+							  "ti,sgmii-ref-clock-output-enable");
 
 	dp83867->rx_id_delay = DP83867_RGMII_RX_CLK_DELAY_INV;
 	ret = of_property_read_u32(of_node, "ti,rx-internal-delay",
-- 
2.28.0

