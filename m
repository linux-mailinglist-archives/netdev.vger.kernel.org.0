Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A176EF39E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 13:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbjDZLqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 07:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjDZLqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 07:46:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CB14C3F
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 04:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682509574; x=1714045574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1wM2kRnIjH9BdvdOB48z2XOM86d5TfK6AvMIhDQ0OVM=;
  b=QWosCzOuC7lGuDDWqYZxOJQiQx9Wn98mx08ar7pftljNc+1E6QB7WUKA
   HfSeyUDwQrObzWu1NNG8v53YuNdjqVFXU/XYObft4otYQUvpp07wut/De
   Qv2hyjT4fW/OWuyBEBYPOecDeZqQEDayKR9RmpV+f5Klj04MrICFIKZ7+
   aGCHLBxuecXq0g9hbg4dMLD2JM7fnjPacBymmuwGnqRsxl+G4DGoBTFjn
   kFUHmxYImJiS5styBE5Wc30kYLz5DNRz23F2UAFSX2rjI141VGsxFufzn
   HXxFE6pJ6uLRrf7lTDbkvcu60L5Lpsvuaxm+J0AvYsj7xj4aYMEqAiImY
   w==;
X-IronPort-AV: E=Sophos;i="5.99,227,1677567600"; 
   d="scan'208";a="149009024"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2023 04:46:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 26 Apr 2023 04:46:13 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 26 Apr 2023 04:46:11 -0700
From:   Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>, <davem@davemloft.net>
CC:     <jan.huber@microchip.com>, <thorsten.kummermehr@microchip.com>,
        <ramon.nordin.rodriguez@ferroamp.se>,
        Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 1/2] net: phy: microchip_t1s: update LAN867x PHY supported revision number
Date:   Wed, 26 Apr 2023 17:16:54 +0530
Message-ID: <20230426114655.93672-2-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per AN1699, the initial configuration in the driver applies to LAN867x
Rev.B1 hardware revision.

Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 36 ++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index 094967b3c111..793fb0210605 100644
--- a/drivers/net/phy/microchip_t1s.c
+++ b/drivers/net/phy/microchip_t1s.c
@@ -1,16 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * Driver for Microchip 10BASE-T1S LAN867X PHY
+ * Driver for Microchip 10BASE-T1S PHY family
  *
  * Support: Microchip Phys:
- *  lan8670, lan8671, lan8672
+ *  lan8670/1/2 Rev.B1
  */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 
-#define PHY_ID_LAN867X 0x0007C160
+#define PHY_ID_LAN867X_REVB1 0x0007C162
 
 #define LAN867X_REG_IRQ_1_CTL 0x001C
 #define LAN867X_REG_IRQ_2_CTL 0x001D
@@ -31,25 +31,25 @@
  * W   0x1F 0x0099 0x7F80 ------
  */
 
-static const int lan867x_fixup_registers[12] = {
+static const int lan867x_revb1_fixup_registers[12] = {
 	0x00D0, 0x00D1, 0x0084, 0x0085,
 	0x008A, 0x0087, 0x0088, 0x008B,
 	0x0080, 0x00F1, 0x0096, 0x0099,
 };
 
-static const int lan867x_fixup_values[12] = {
+static const int lan867x_revb1_fixup_values[12] = {
 	0x0002, 0x0000, 0x3380, 0x0006,
 	0xC000, 0x801C, 0x033F, 0x0404,
 	0x0600, 0x2400, 0x2000, 0x7F80,
 };
 
-static const int lan867x_fixup_masks[12] = {
+static const int lan867x_revb1_fixup_masks[12] = {
 	0x0E03, 0x0300, 0xFFC0, 0x000F,
 	0xF800, 0x801C, 0x1FFF, 0xFFFF,
 	0x0600, 0x7F00, 0x2000, 0xFFFF,
 };
 
-static int lan867x_config_init(struct phy_device *phydev)
+static int lan867x_revb1_config_init(struct phy_device *phydev)
 {
 	/* HW quirk: Microchip states in the application note (AN1699) for the phy
 	 * that a set of read-modify-write (rmw) operations has to be performed
@@ -73,11 +73,11 @@ static int lan867x_config_init(struct phy_device *phydev)
 	 * new_val = new_val OR value // Set bits
 	 * write_register(mmd, addr, new_val) // Write back updated register value
 	 */
-	for (int i = 0; i < ARRAY_SIZE(lan867x_fixup_registers); i++) {
-		reg = lan867x_fixup_registers[i];
+	for (int i = 0; i < ARRAY_SIZE(lan867x_revb1_fixup_registers); i++) {
+		reg = lan867x_revb1_fixup_registers[i];
 		reg_value = phy_read_mmd(phydev, MDIO_MMD_VEND2, reg);
-		reg_value &= ~lan867x_fixup_masks[i];
-		reg_value |= lan867x_fixup_values[i];
+		reg_value &= ~lan867x_revb1_fixup_masks[i];
+		reg_value |= lan867x_revb1_fixup_values[i];
 		err = phy_write_mmd(phydev, MDIO_MMD_VEND2, reg, reg_value);
 		if (err != 0)
 			return err;
@@ -111,12 +111,12 @@ static int lan867x_read_status(struct phy_device *phydev)
 	return 0;
 }
 
-static struct phy_driver lan867x_driver[] = {
+static struct phy_driver lan867x_revb1_driver[] = {
 	{
-		PHY_ID_MATCH_MODEL(PHY_ID_LAN867X),
-		.name               = "LAN867X",
+		PHY_ID_MATCH_EXACT(PHY_ID_LAN867X_REVB1),
+		.name               = "LAN867X Rev.B1",
 		.features           = PHY_BASIC_T1S_P2MP_FEATURES,
-		.config_init        = lan867x_config_init,
+		.config_init        = lan867x_revb1_config_init,
 		.read_status        = lan867x_read_status,
 		.get_plca_cfg	    = genphy_c45_plca_get_cfg,
 		.set_plca_cfg	    = genphy_c45_plca_set_cfg,
@@ -124,15 +124,15 @@ static struct phy_driver lan867x_driver[] = {
 	}
 };
 
-module_phy_driver(lan867x_driver);
+module_phy_driver(lan867x_revb1_driver);
 
 static struct mdio_device_id __maybe_unused tbl[] = {
-	{ PHY_ID_MATCH_MODEL(PHY_ID_LAN867X) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_LAN867X_REVB1) },
 	{ }
 };
 
 MODULE_DEVICE_TABLE(mdio, tbl);
 
-MODULE_DESCRIPTION("Microchip 10BASE-T1S lan867x Phy driver");
+MODULE_DESCRIPTION("Microchip 10BASE-T1S Phy driver");
 MODULE_AUTHOR("Ramón Nordin Rodriguez");
 MODULE_LICENSE("GPL");
-- 
2.34.1

