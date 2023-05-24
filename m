Return-Path: <netdev+bounces-5052-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCFCF70F8F5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75799280DAD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43C31800A;
	Wed, 24 May 2023 14:44:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68C3C2CB
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:44:41 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9FFC1;
	Wed, 24 May 2023 07:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684939480; x=1716475480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tZFjIUb+L2bMlXyUgqiG9dtxrlUOvNQpShB8nsI+oUU=;
  b=Z497JXtqwAcuoE2IHR3xFWL3DUQT7uHzqGs6w4dp8cBnqoccpJOimjoN
   qtNh//NWtLKca+VK+u1rW0uZXq52kk7jRN72/Dkhsq5szVaL0QQ8th8U4
   XEnIkKYwRchY/MEhAFODw+czbrQqiXNTkSYTvyV/ubJbMm+zgANYcsKCw
   IZ9QupWvsXVj5i1JhCrHjzVxaWTnsdIVDY9WVw3gMWHJ33cS0YbIyXCvf
   ogch3OruHw9sYnxz1ueaqxYJDUYxq7fXgb1sKSLUQTQsXRX0ReZxjQqF2
   h9H86NvQ5+gCW22o5j27JmQq5qHgakTWTmXO1so8++S4xBp7oJT663mEQ
   w==;
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="212864706"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 07:44:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 07:44:38 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 24 May 2023 07:44:34 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v3 1/6] net: phy: microchip_t1s: modify driver description to be more generic
Date: Wed, 24 May 2023 20:15:34 +0530
Message-ID: <20230524144539.62618-2-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Remove LAN867X from the driver description as this driver is common for
all the Microchip 10BASE-T1S PHYs.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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


