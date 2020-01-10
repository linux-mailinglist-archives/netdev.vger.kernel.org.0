Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77AD313766B
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgAJSu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:50:26 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:56392 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbgAJSuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:50:03 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00AInvXS079460;
        Fri, 10 Jan 2020 12:49:57 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578682197;
        bh=xyBkbLSjFv5+FCftdlNPlstRVGPWsjSvGtcajIt7PLU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=rzOQewp0xdVGprzxSlWJNAZZhvlsMNF7u6BgGPUWeQLtMSPbwubJzK3qO5TqB+jCq
         TJa4krZ9VRBhbF3uyB81NnP59CR35Wi9OOUA+xDDyasSzBs8sfq+D0E4XQI8FI+3vS
         4eeezwGQMQ/U8f5CSilpf808dvAZ+piK2Lzqs4ao=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AInvtu049477;
        Fri, 10 Jan 2020 12:49:57 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 10
 Jan 2020 12:49:57 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 10 Jan 2020 12:49:57 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AInvXK126371;
        Fri, 10 Jan 2020 12:49:57 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 3/4] phy: dp83826: Add phy IDs for DP83826N and 826NC
Date:   Fri, 10 Jan 2020 12:47:01 -0600
Message-ID: <20200110184702.14330-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200110184702.14330-1-dmurphy@ti.com>
References: <20200110184702.14330-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add phy IDs to the DP83822 phy driver for the DP83826N
and the DP83826NC devices.  The register map and features
are the same for basic enablement.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/Kconfig   | 4 ++--
 drivers/net/phy/dp83822.c | 6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 8dc461f7574b..90c9297280d2 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -340,9 +340,9 @@ config DAVICOM_PHY
 	  Currently supports dm9161e and dm9131
 
 config DP83822_PHY
-	tristate "Texas Instruments DP83822/825 PHYs"
+	tristate "Texas Instruments DP83822/825/826 PHYs"
 	---help---
-	  Supports the DP83822 and DP83825I PHYs.
+	  Supports the DP83822, DP83825I, DP83826C and DP83826NC PHYs.
 
 config DP83TC811_PHY
 	tristate "Texas Instruments DP83TC811 PHY"
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 8a4b1d167ce2..5159b28baa0f 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -16,6 +16,8 @@
 
 #define DP83822_PHY_ID	        0x2000a240
 #define DP83825I_PHY_ID		0x2000a150
+#define DP83826C_PHY_ID		0x2000a130
+#define DP83826NC_PHY_ID	0x2000a110
 
 #define DP83822_DEVADDR		0x1f
 
@@ -319,12 +321,16 @@ static int dp83822_resume(struct phy_device *phydev)
 static struct phy_driver dp83822_driver[] = {
 	DP83822_PHY_DRIVER(DP83822_PHY_ID, "TI DP83822"),
 	DP83822_PHY_DRIVER(DP83825I_PHY_ID, "TI DP83825I"),
+	DP83822_PHY_DRIVER(DP83826C_PHY_ID, "TI DP83826C"),
+	DP83822_PHY_DRIVER(DP83826NC_PHY_ID, "TI DP83826NC"),
 };
 module_phy_driver(dp83822_driver);
 
 static struct mdio_device_id __maybe_unused dp83822_tbl[] = {
 	{ DP83822_PHY_ID, 0xfffffff0 },
 	{ DP83825I_PHY_ID, 0xfffffff0 },
+	{ DP83826C_PHY_ID, 0xfffffff0 },
+	{ DP83826NC_PHY_ID, 0xfffffff0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(mdio, dp83822_tbl);
-- 
2.23.0

