Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8164CD18A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiCDJpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238328AbiCDJpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:45:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2237F198D13;
        Fri,  4 Mar 2022 01:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646387091; x=1677923091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h5xPi0D+TgB2oYfmyCW+jXtALSd2HPs9kSGxVMrZrh4=;
  b=nEgvWKAWIv4Vqx2j+sB2GX+AGn5Qjz3bh1zpfJpRKlt6avq2nEHpe/Rj
   hoaWMWjX+nv39wJeYlzBbl8c2J4FwQs26IJzM5uOumu/cXIaWS6tNZ9bI
   gyN+wrr1iAo+8XoEcS+PIxKYHAStmUEK3uDenGfHVVK6umkz5q/v4HuxK
   5ajeVXrjpjVmGu5h/GmsPiSVnNcHfPTc4VwFrCouYMyz+izUd33rL9Oxa
   +pICDljkiuvyUqeD679PoGhW5enYDtwsdAhg0m4Uwbl7RgdJ4kurriHYy
   b2KRD2Ybv7xn6qjc01lqis/svQVbV8igTvq5yDQ92hju5KkzEswWNlkeu
   w==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="87816375"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:44:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:44:51 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:44:46 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 3/6] net: phy: removed empty lines in LAN87XX
Date:   Fri, 4 Mar 2022 15:13:58 +0530
Message-ID: <20220304094401.31375-4-arun.ramadoss@microchip.com>
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

Removed the empty lines in struct phy_drivers.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index e4801d5ea793..f247892902f7 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -501,14 +501,10 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		PHY_ID_MATCH_MODEL(PHY_ID_LAN87XX),
 		.name           = "Microchip LAN87xx T1",
 		.flags          = PHY_POLL_CABLE_TEST,
-
 		.features       = PHY_BASIC_T1_FEATURES,
-
 		.config_init	= lan87xx_config_init,
-
 		.config_intr    = lan87xx_phy_config_intr,
 		.handle_interrupt = lan87xx_handle_interrupt,
-
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 		.cable_test_start = lan87xx_cable_test_start,
-- 
2.33.0

