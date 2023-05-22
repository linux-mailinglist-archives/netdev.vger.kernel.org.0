Return-Path: <netdev+bounces-4223-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B8B70BBE9
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1A9E1C20A1E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA992D2F1;
	Mon, 22 May 2023 11:32:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF957D50B
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:32:52 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127D8CA;
	Mon, 22 May 2023 04:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684755166; x=1716291166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6NNAVQ4+W8BeCdTSSUfo15M1NiBo0baT+cFOGV8/Fto=;
  b=j1NfbDU5WaGSPs8tOW271N34DSm8+Zoty1/vM73sY/Uy2/fY1gvlf/jB
   /Xgkv7Gr/V7DRrhZs4TFnfG3lP5zEqOmraPVDq0Lihkdm6OTZ3AXn6DRQ
   26922PSwb1XYXECFmY6IzyIyDFj2G+ewyHzVEmn4U9Gb05j+iHcFdUSGw
   bQLwb5WgJWcFwNS/SKa6KKKoT5NqjZdz89UB6Sg/QOWBlXxkHR3XwbRbt
   29OjynOi4N28GBEcK1TYDgXAVIRFK6q3DpfEnMdUweUhKBZ4r4nxM4mff
   JN1/3T69O1XknbusN7JdozX/NIHp/rv53GOhNlGiBY7P74sSAo3wEKQoN
   w==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="214893158"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 04:32:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 04:32:43 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Mon, 22 May 2023 04:32:38 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v2 3/6] net: phy: microchip_t1s: update LAN867x PHY supported revision number
Date: Mon, 22 May 2023 17:03:28 +0530
Message-ID: <20230522113331.36872-4-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As per AN1699, the initial configuration in the driver applies to LAN867x
Rev.B1 hardware revision.

Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index 534d9faf8475..869c7f403ea1 100644
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
 	/* HW quirk: Microchip states in the application note (AN1699) for the phy
 	 * that a set of read-modify-write (rmw) operations has to be performed
@@ -71,11 +71,11 @@ static int lan867x_config_init(struct phy_device *phydev)
 	 * new_val = new_val OR value // Set bits
 	 * write_register(mmd, addr, new_val) // Write back updated register value
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
@@ -110,10 +110,10 @@ static int lan867x_read_status(struct phy_device *phydev)
 
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
@@ -124,7 +124,7 @@ static struct phy_driver microchip_t1s_driver[] = {
 module_phy_driver(microchip_t1s_driver);
 
 static struct mdio_device_id __maybe_unused tbl[] = {
-	{ PHY_ID_MATCH_MODEL(PHY_ID_LAN867X) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_LAN867X_REVB1) },
 	{ }
 };
 
-- 
2.34.1


