Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BECB25C9B2
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgICTv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:51:26 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35518 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgICTvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:51:25 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 083JpJcZ027525;
        Thu, 3 Sep 2020 14:51:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599162679;
        bh=VY4y6pKM0zD2i2DSBknAWDMhJZ1BGlyUBh7Kj5LzBHI=;
        h=From:To:CC:Subject:Date;
        b=NSoQszJNHq1/vdEhmurPVoX9ylotd7D2XQdWtt9KXt8jzSff04Lky6V4//m+eYCmW
         TmCqehxlO6zdjRWKKWZUa4MmjYY1Rifkhy65Ig5sCL0ZEaQJywinMzUUD1ge5ygi23
         nBDkDhu3U3sQ19NVZC91Gsnv4DDlkAr0eOfdtzIU=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 083JpJLF059269
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 3 Sep 2020 14:51:19 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 3 Sep
 2020 14:51:18 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 3 Sep 2020 14:51:18 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 083JpIMV106935;
        Thu, 3 Sep 2020 14:51:18 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2] net: phy: dp83867: Fix various styling and space issues
Date:   Thu, 3 Sep 2020 14:51:12 -0500
Message-ID: <20200903195112.18868-1-dmurphy@ti.com>
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

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83867.c | 45 ++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index f3c04981b8da..ca26ccc6dfa4 100644
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

