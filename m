Return-Path: <netdev+bounces-5730-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF8D712950
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B00542818D6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA66B261ED;
	Fri, 26 May 2023 15:23:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC92848B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:23:08 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5984D1A8;
	Fri, 26 May 2023 08:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685114586; x=1716650586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Ugy8OVBN/ZCydELAwyoI7h6o66NHCvsC41AaXEB37w=;
  b=d3O7jOyfUdO4OMGZVRS2yCS3pnnvq+4s8j+czZK5lZDWBOzhKxCVlwzs
   f+zvEGMBBq4Mi80/8e0Jal2q1MxpF4clStRXdhMNPSBRev1mgx5hEbN2Y
   wjZdjSaCJPR5tDdOF/SQKmvuUnG/HfPOxdRvyKCdezGuFeRn3VwHPbMZ0
   bh6dH32bNDPL24KpSQVzRVOX1X5B0sEvJwtu0KcTILpqkjECspFpHUrUg
   dlnXRouIjSwbit/n1NFiMHsfHKNtnbEvQqx98SG4NkoRnouCgZBA7Rt48
   D1NucMLzUKJQL98znMBxF8nTDDU3HgF+x+kkDttOYKXFnrOaCqKkMH/vI
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="154119457"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2023 08:23:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 26 May 2023 08:22:57 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 26 May 2023 08:22:52 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v4 3/6] net: phy: microchip_t1s: update LAN867x PHY supported revision number
Date: Fri, 26 May 2023 20:53:45 +0530
Message-ID: <20230526152348.70781-4-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
References: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As per AN1699, the initial configuration in the driver applies to LAN867x
Rev.B1 hardware revision. 0x0007C160 (Rev.A0) and 0x0007C161 (Rev.B0)
never released to production and hence they don't need to be supported.

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/Kconfig         |  2 +-
 drivers/net/phy/microchip_t1s.c | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index f6829d1bcf42..47596ada3183 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -245,7 +245,7 @@ config MICREL_PHY
 config MICROCHIP_T1S_PHY
 	tristate "Microchip 10BASE-T1S Ethernet PHYs"
 	help
-	  Currently supports the LAN8670, LAN8671, LAN8672
+	  Currently supports the LAN8670/1/2 Rev.B1
 
 config MICROCHIP_PHY
 	tristate "Microchip PHYs"
diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index fd27e94c9ee5..7abecad28bf1 100644
--- a/drivers/net/phy/microchip_t1s.c
+++ b/drivers/net/phy/microchip_t1s.c
@@ -3,14 +3,14 @@
  * Driver for Microchip 10BASE-T1S PHYs
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
 
-static const u32 lan867x_fixup_registers[12] = {
+static const u32 lan867x_revb1_fixup_registers[12] = {
 	0x00D0, 0x00D1, 0x0084, 0x0085,
 	0x008A, 0x0087, 0x0088, 0x008B,
 	0x0080, 0x00F1, 0x0096, 0x0099,
 };
 
-static const u16 lan867x_fixup_values[12] = {
+static const u16 lan867x_revb1_fixup_values[12] = {
 	0x0002, 0x0000, 0x3380, 0x0006,
 	0xC000, 0x801C, 0x033F, 0x0404,
 	0x0600, 0x2400, 0x2000, 0x7F80,
 };
 
-static const u16 lan867x_fixup_masks[12] = {
+static const u16 lan867x_revb1_fixup_masks[12] = {
 	0x0E03, 0x0300, 0xFFC0, 0x000F,
 	0xF800, 0x801C, 0x1FFF, 0xFFFF,
 	0x0600, 0x7F00, 0x2000, 0xFFFF,
 };
 
-static int lan867x_config_init(struct phy_device *phydev)
+static int lan867x_revb1_config_init(struct phy_device *phydev)
 {
 	int err;
 
@@ -59,11 +59,11 @@ static int lan867x_config_init(struct phy_device *phydev)
 	 * register already has the required value. So it is safe to use
 	 * phy_modify_mmd here.
 	 */
-	for (int i = 0; i < ARRAY_SIZE(lan867x_fixup_registers); i++) {
+	for (int i = 0; i < ARRAY_SIZE(lan867x_revb1_fixup_registers); i++) {
 		err = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
-				     lan867x_fixup_registers[i],
-				     lan867x_fixup_masks[i],
-				     lan867x_fixup_values[i]);
+				     lan867x_revb1_fixup_registers[i],
+				     lan867x_revb1_fixup_masks[i],
+				     lan867x_revb1_fixup_values[i]);
 		if (err)
 			return err;
 	}
@@ -98,10 +98,10 @@ static int lan867x_read_status(struct phy_device *phydev)
 
 static struct phy_driver microchip_t1s_driver[] = {
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
@@ -112,7 +112,7 @@ static struct phy_driver microchip_t1s_driver[] = {
 module_phy_driver(microchip_t1s_driver);
 
 static struct mdio_device_id __maybe_unused tbl[] = {
-	{ PHY_ID_MATCH_MODEL(PHY_ID_LAN867X) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_LAN867X_REVB1) },
 	{ }
 };
 
-- 
2.34.1


