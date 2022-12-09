Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85B0648AD8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiLIWrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLIWrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:47:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EC21C433;
        Fri,  9 Dec 2022 14:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670626037; x=1702162037;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=br/M5WmvwdwxFySfGnmU52+djJ0iOGc1/k2tY+9cOwU=;
  b=d2fDZWAQSDLvSzlpy2YM37lyqnwnrz9UDT3tAaQgBJkOf8h7mtsahMdv
   khd3cNX9hwNq4dpxyDjVu8U0aVWPtoRh7VE9AOxFGFkMYUCt9LMr169d/
   RcT4DOLX8PtQx10Qy8ngPVqy0wvkw2AfIO07mFF7gV35TeE+Dy0XthHmA
   lTPAh7dLatzd/I/bSf+5zaOUkmYmQrBx9tzDLTv2K5hQ+SO00PfeerJbg
   AGHRNSJ2rXP20hIfwAF61bmOLkfFMIbz9dTR9qEwwa5OmAhtAAMR4pIS6
   D5l9o7FqJrWqeeP48Dwh+0XSeaSnqtFXHpAwFUz65cUPOqnkRVAD+hzhM
   w==;
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="192458900"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 15:47:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 15:47:16 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 15:47:15 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v5 1/6] dsa: lan9303: align dsa_switch_ops members
Date:   Fri, 9 Dec 2022 16:47:08 -0600
Message-ID: <20221209224713.19980-2-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221209224713.19980-1-jerry.ray@microchip.com>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whitespace preparatory patch, making the dsa_switch_ops table consistent.
No code is added or removed.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
v4->v5:
 changed patch title to be less generic
 Addressed space-tab issue missed in the initial patch.
---
 drivers/net/dsa/lan9303-core.c | 38 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 80f07bd20593..5a21fc96d479 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1280,25 +1280,25 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
 }
 
 static const struct dsa_switch_ops lan9303_switch_ops = {
-	.get_tag_protocol = lan9303_get_tag_protocol,
-	.setup = lan9303_setup,
-	.get_strings = lan9303_get_strings,
-	.phy_read = lan9303_phy_read,
-	.phy_write = lan9303_phy_write,
-	.adjust_link = lan9303_adjust_link,
-	.get_ethtool_stats = lan9303_get_ethtool_stats,
-	.get_sset_count = lan9303_get_sset_count,
-	.port_enable = lan9303_port_enable,
-	.port_disable = lan9303_port_disable,
-	.port_bridge_join       = lan9303_port_bridge_join,
-	.port_bridge_leave      = lan9303_port_bridge_leave,
-	.port_stp_state_set     = lan9303_port_stp_state_set,
-	.port_fast_age          = lan9303_port_fast_age,
-	.port_fdb_add           = lan9303_port_fdb_add,
-	.port_fdb_del           = lan9303_port_fdb_del,
-	.port_fdb_dump          = lan9303_port_fdb_dump,
-	.port_mdb_add           = lan9303_port_mdb_add,
-	.port_mdb_del           = lan9303_port_mdb_del,
+	.get_tag_protocol	= lan9303_get_tag_protocol,
+	.setup			= lan9303_setup,
+	.get_strings		= lan9303_get_strings,
+	.phy_read		= lan9303_phy_read,
+	.phy_write		= lan9303_phy_write,
+	.adjust_link		= lan9303_adjust_link,
+	.get_ethtool_stats	= lan9303_get_ethtool_stats,
+	.get_sset_count		= lan9303_get_sset_count,
+	.port_enable		= lan9303_port_enable,
+	.port_disable		= lan9303_port_disable,
+	.port_bridge_join	= lan9303_port_bridge_join,
+	.port_bridge_leave	= lan9303_port_bridge_leave,
+	.port_stp_state_set	= lan9303_port_stp_state_set,
+	.port_fast_age		= lan9303_port_fast_age,
+	.port_fdb_add		= lan9303_port_fdb_add,
+	.port_fdb_del		= lan9303_port_fdb_del,
+	.port_fdb_dump		= lan9303_port_fdb_dump,
+	.port_mdb_add		= lan9303_port_mdb_add,
+	.port_mdb_del		= lan9303_port_mdb_del,
 };
 
 static int lan9303_register_switch(struct lan9303 *chip)
-- 
2.17.1

