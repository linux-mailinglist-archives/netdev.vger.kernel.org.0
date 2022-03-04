Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E784CD189
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiCDJp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239288AbiCDJp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:45:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9348C198D08;
        Fri,  4 Mar 2022 01:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646387081; x=1677923081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i70m50+Q4/95ZDivY2MDXc7mSKlWsnrpxG2EOCbBrw4=;
  b=CvhUl08e0Su0U03UkIzShZdh7Jn/ORLQTt+GgI42Lma404S/F2GX0JNP
   pdvLa89WgwR//6BAfYf/telk7LaJDV7MqZ34UvJeUXz+KzEAd8BrUuPza
   2/yF56llj++vk82gAadNQ7ilIiUPlUoMgfBM11mpU7DnGV0ByQlUxFLvJ
   RkyEE95EoXx2zFYiARjTS1NSwMj4gb1K045m5zQSH/G2qcLM6prrat86+
   Lkq5d/tUnMyeBSz6SWQz8ZzqZHHPdVCyvXBCfmg+5V/q0VyN3pHdw6XED
   BZpufBIzWE265eNJmah5dw7eQXj7VYKxDgtJ7s5KOKR9xF0uECzpoKyO9
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="150847645"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:44:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:44:40 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:44:36 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 2/6] net: phy: used the PHY_ID_MATCH_MODEL macro for LAN87XX
Date:   Fri, 4 Mar 2022 15:13:57 +0530
Message-ID: <20220304094401.31375-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304094401.31375-1-arun.ramadoss@microchip.com>
References: <20220304094401.31375-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used the PHY_ID_MATCH_MODEL MACRO for describing the phy_id and
phy_id_mask.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index c6a8c22efcce..e4801d5ea793 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -9,6 +9,8 @@
 #include <linux/ethtool.h>
 #include <linux/ethtool_netlink.h>
 
+#define PHY_ID_LAN87XX				0x0007c150
+
 /* External Register Control Register */
 #define LAN87XX_EXT_REG_CTL                     (0x14)
 #define LAN87XX_EXT_REG_CTL_RD_CTL              (0x1000)
@@ -496,8 +498,7 @@ static int lan87xx_cable_test_get_status(struct phy_device *phydev,
 
 static struct phy_driver microchip_t1_phy_driver[] = {
 	{
-		.phy_id         = 0x0007c150,
-		.phy_id_mask    = 0xfffffff0,
+		PHY_ID_MATCH_MODEL(PHY_ID_LAN87XX),
 		.name           = "Microchip LAN87xx T1",
 		.flags          = PHY_POLL_CABLE_TEST,
 
@@ -518,7 +519,7 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 module_phy_driver(microchip_t1_phy_driver);
 
 static struct mdio_device_id __maybe_unused microchip_t1_tbl[] = {
-	{ 0x0007c150, 0xfffffff0 },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_LAN87XX) },
 	{ }
 };
 
-- 
2.33.0

