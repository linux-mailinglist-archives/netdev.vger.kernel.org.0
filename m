Return-Path: <netdev+bounces-5729-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5240271294A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93B811C20FD8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEFC0261EC;
	Fri, 26 May 2023 15:23:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FDD848B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:23:02 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5750F19A;
	Fri, 26 May 2023 08:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685114580; x=1716650580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T1C/ODYKcUiSrom7jupGvTPzB9H0X69WhLJpj6CJScw=;
  b=FMwj0c+4kQtzdpUfSlUvzpJ7KI0be2Vx3dnh5ZDuoUCXPnn1BHjepzi6
   gVz7EUb4Q0kp6ThItso3nUTBOb0h2HHghxZmG6RWAohAUyKJLHLJr6zpb
   /ER2BzIDMI3qlBWAl5/kSgN2l44SwT+LNiuUIyo/vNF9+U2iQ/NB+BFLo
   H/lco4nuYHILDqnrlk0AEG0P/xMvdUR0dR3a0ZXgVSfeycuK5s17QrwUm
   yqzMxXga/fhja6367drEDSMovuAbB8jZmRoalWRxTSzf1EKEWtvSEVL4C
   4j/+H+wETFniQ6PDNwwdE7X9HNJJ3RMq0kV1x+v2V1xKhAA7ymaVS9UD6
   A==;
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="154119389"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2023 08:22:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 26 May 2023 08:22:46 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 26 May 2023 08:22:42 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v4 1/6] net: phy: microchip_t1s: modify driver description to be more generic
Date: Fri, 26 May 2023 20:53:43 +0530
Message-ID: <20230526152348.70781-2-Parthiban.Veerasooran@microchip.com>
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

Remove LAN867X from the driver description as this driver is common for
all the Microchip 10BASE-T1S PHYs.

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/Kconfig         | 2 +-
 drivers/net/phy/microchip_t1s.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 93b8efc79227..f6829d1bcf42 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -243,7 +243,7 @@ config MICREL_PHY
 	  Supports the KSZ9021, VSC8201, KS8001 PHYs.
 
 config MICROCHIP_T1S_PHY
-	tristate "Microchip 10BASE-T1S Ethernet PHY"
+	tristate "Microchip 10BASE-T1S Ethernet PHYs"
 	help
 	  Currently supports the LAN8670, LAN8671, LAN8672
 
diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index 094967b3c111..a42a6bb6e3bd 100644
--- a/drivers/net/phy/microchip_t1s.c
+++ b/drivers/net/phy/microchip_t1s.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * Driver for Microchip 10BASE-T1S LAN867X PHY
+ * Driver for Microchip 10BASE-T1S PHYs
  *
  * Support: Microchip Phys:
  *  lan8670, lan8671, lan8672
@@ -111,7 +111,7 @@ static int lan867x_read_status(struct phy_device *phydev)
 	return 0;
 }
 
-static struct phy_driver lan867x_driver[] = {
+static struct phy_driver microchip_t1s_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_LAN867X),
 		.name               = "LAN867X",
@@ -124,7 +124,7 @@ static struct phy_driver lan867x_driver[] = {
 	}
 };
 
-module_phy_driver(lan867x_driver);
+module_phy_driver(microchip_t1s_driver);
 
 static struct mdio_device_id __maybe_unused tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_LAN867X) },
@@ -133,6 +133,6 @@ static struct mdio_device_id __maybe_unused tbl[] = {
 
 MODULE_DEVICE_TABLE(mdio, tbl);
 
-MODULE_DESCRIPTION("Microchip 10BASE-T1S lan867x Phy driver");
+MODULE_DESCRIPTION("Microchip 10BASE-T1S PHYs driver");
 MODULE_AUTHOR("Ramón Nordin Rodriguez");
 MODULE_LICENSE("GPL");
-- 
2.34.1


